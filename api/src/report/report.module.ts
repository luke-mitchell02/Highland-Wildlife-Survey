import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Alert } from '../entities/alert.entity';
import { Session } from '../entities/session.entity';
import { Sighting } from '../entities/sighting.entity';
import { Site } from '../entities/site.entity';
import { Species } from '../entities/species.entity';
import { ReportController } from './report.controller';
import { ReportService } from './report.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Site, Session, Sighting, Alert, Species]),
  ],
  controllers: [ReportController],
  providers: [ReportService],
})
export class ReportModule {}
