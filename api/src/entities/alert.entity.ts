// https://docs.nestjs.com/techniques/database#repository-pattern

import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Species } from './species.entity';

@Entity('Alerts')
export class Alert {
  @PrimaryGeneratedColumn()
  alert_id: number;

  @Column()
  trend_direction: string;

  @Column()
  population_estimate: number;

  @Column()
  change: number;

  @Column()
  generated_time: Date;

  @ManyToOne(() => Species)
  @JoinColumn({ name: 'species_id' })
  species: Species;
}
