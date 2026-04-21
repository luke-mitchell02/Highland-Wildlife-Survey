// https://docs.nestjs.com/techniques/database#repository-pattern

import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity('Species')
export class Species {
  @PrimaryColumn()
  species_id: string;

  @Column()
  species_name: string;

  @Column()
  scientific_name: string;

  @Column()
  category: string;

  @Column()
  conservation_status: string;

  @Column()
  is_priority: number;
}
