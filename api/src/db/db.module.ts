import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigService } from "@nestjs/config";

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService) => {
        return {
          type: 'mysql',
          host: configService.get('DB_HOST'),
          port: configService.get('DB_PORT'),
          username: configService.get('DB_USER'),
          password: configService.get('DB_PASSWORD'),
          database: configService.get('DB_NAME'),
          synchronize: false,
          autoLoadEntities: true,
          poolSize: 10,
          connectTimeout: 10000,
          extra: {
            connectionLimit: 10,
            waitForConnections: true,
          }
        }
      }
    }),
  ],
  exports: [TypeOrmModule],
})
export class DbModule {}