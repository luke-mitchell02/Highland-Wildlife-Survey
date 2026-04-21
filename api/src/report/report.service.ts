import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { readFileSync } from 'fs';
import { join } from 'path';
import { Repository } from 'typeorm';
import { create } from 'xmlbuilder2';
import * as libxmljs from 'libxmljs2';
import { Alert } from '../entities/alert.entity';
import { Site } from '../entities/site.entity';

// https://typeorm.io/working-with-repository
// https://oozcitak.github.io/xmlbuilder2/object-conversion.html
// https://github.com/marudor/libxmljs2?tab=readme-ov-file#validation
// https://www.geeksforgeeks.org/javascript/how-to-validate-xml-against-xsd-in-javascript/#using-libxmljs-for-xml-validation
// https://typeorm.io/select-query-builder

const RECOMMENDED_ACTIONS: Record<string, string> = {
  'Down Fast':
    'The population is decreasing quickly, immediate intervention is required to preserve the species',
  Down: 'The population is decreasing, increase monitoring frequency and consider habitat protection measures',
  Up: 'The population is increasing, continue current conservation efforts',
  'Up Fast':
    'The population is rapidly increasing, continue current conservation efforts',
};

@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(Site)
    private readonly siteRepository: Repository<Site>,
    @InjectRepository(Alert)
    private readonly alertRepository: Repository<Alert>,
  ) {}

  // Returns a JSON report of all sightings at a given site, nested by session and species.
  async getSiteReport(siteId: string): Promise<Site> {
    const site = await this.siteRepository.findOne({
      where: { site_id: siteId },
      relations: [
        'sessions',
        'sessions.sightings',
        'sessions.sightings.species',
      ],
    });

    // Throw a 404 if the site ID does not exist.
    if (!site) throw new NotFoundException(`Site ${siteId} not found`);

    return site;
  }

  // Return an XML report of all alerts, including species details, trend data, the sites
  // where the species has been sighted, and a recommended action based on the trend direction.
  // The XML gets validated against alerts.xsd before being returned.
  async getAlertsXml(): Promise<string> {
    const alerts = await this.alertRepository.find({ relations: ['species'] });

    // For each alert, query the distinct sites where the species has been sighted
    const alertData: { alert: Alert; sites: Site[] }[] = [];
    for (const alert of alerts) {
      const sites = await this.siteRepository
        .createQueryBuilder('site')
        .innerJoin('site.sessions', 'session')
        .innerJoin('session.sightings', 'sighting')
        .where('sighting.species_id = :id', { id: alert.species.species_id })
        .select(['site.site_id', 'site.site_name', 'site.region'])
        .distinct(true)
        .getMany();

      alertData.push({ alert, sites });
    }

    // Build XML from a JS object. Keys map to elements, @ prefix denotes attributes
    const xml = create({
      alerts: {
        '@generated': new Date().toISOString(),
        alert: alertData.map(({ alert, sites }) => ({
          '@id': alert.alert_id,
          species: {
            id: alert.species.species_id,
            name: alert.species.species_name,
            scientific_name: alert.species.scientific_name,
            conservation_status: alert.species.conservation_status,
          },
          trend: {
            direction: alert.trend_direction,
            population_estimate: alert.population_estimate,
            change: alert.change,
            generated_time: alert.generated_time.toISOString(),
          },
          sites: {
            site: sites.map((s) => ({
              id: s.site_id,
              name: s.site_name,
              region: s.region,
            })),
          },
          recommended_action: RECOMMENDED_ACTIONS[alert.trend_direction],
        })),
      },
    }).end({ prettyPrint: true });

    // Validate the generated XML against the XSD schema before returning
    const xsdPath = join(__dirname, '..', 'schemas', 'alerts.xsd');
    const xsdDoc = libxmljs.parseXml(readFileSync(xsdPath, 'utf-8'));
    const xmlDoc = libxmljs.parseXml(xml);
    if (!xmlDoc.validate(xsdDoc)) {
      throw new InternalServerErrorException(
        'Generated XML failed XSD validation',
      );
    }

    return xml;
  }
}
