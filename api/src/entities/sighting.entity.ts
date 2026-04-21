// https://docs.nestjs.com/techniques/database#repository-pattern

import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import { Session } from './session.entity';
import { Species } from './species.entity';

@Entity('Sightings')
export class Sighting {
  @PrimaryColumn()
  sighting_id: string;

  @Column()
  individuals_count: number;

  @Column()
  sighting_time: string;

  @Column()
  weather_conditions: string;

  @Column({ nullable: true })
  notes: string;

  @Column()
  photo_submitted: number;

  @ManyToOne(() => Session, (session) => session.sightings)
  @JoinColumn({ name: 'session_id' })
  session: Session;

  @ManyToOne(() => Species)
  @JoinColumn({ name: 'species_id' })
  species: Species;
}
