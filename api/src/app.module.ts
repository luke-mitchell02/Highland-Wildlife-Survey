import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DbModule } from './db/db.module';
import { ReportModule } from './report/report.module';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true }), DbModule, ReportModule],
})
export class AppModule {}
