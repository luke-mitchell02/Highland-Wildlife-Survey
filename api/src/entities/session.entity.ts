// https://docs.nestjs.com/techniques/database#repository-pattern

import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryColumn,
} from 'typeorm';
import { Sighting } from './sighting.entity';
import { Site } from './site.entity';

@Entity('Sessions')
export class Session {
  @PrimaryColumn()
  session_id: string;

  @Column()
  volunteer_id: string;

  @Column()
  date: string;

  @Column()
  start_time: string;

  @Column()
  end_time: string;

  @ManyToOne(() => Site, (site) => site.sessions)
  @JoinColumn({ name: 'site_id' })
  site: Site;

  @OneToMany(() => Sighting, (sighting) => sighting.session)
  sightings: Sighting[];
}
