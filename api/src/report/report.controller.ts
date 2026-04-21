import { Controller, Get, Header, Param } from '@nestjs/common';
import { ReportService } from './report.service';

@Controller('report')
export class ReportController {
  constructor(private readonly reportService: ReportService) {}

  @Get('site/:id')
  getSiteReport(@Param('id') id: string) {
    return this.reportService.getSiteReport(id);
  }

  @Get('alerts')
  @Header('Content-Type', 'application/xml')
  getAlertsXml() {
    return this.reportService.getAlertsXml();
  }
}
