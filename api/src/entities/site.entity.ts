// https://docs.nestjs.com/techniques/database#repository-pattern

import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import { Session } from './session.entity';

@Entity('Sites')
export class Site {
  @PrimaryColumn()
  site_id: string;

  @Column()
  site_name: string;

  @Column()
  region: string;

  @Column()
  grid_reference: string;

  @Column()
  habitat_type: string;

  @Column()
  access_difficulty: string;

  @Column()
  is_active: number;

  @OneToMany(() => Session, (session) => session.site)
  sessions: Session[];
}
