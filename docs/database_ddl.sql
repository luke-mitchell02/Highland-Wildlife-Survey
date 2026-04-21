-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: localhost    Database: Highland_Wildlife_Trust
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Alerts`
--

DROP TABLE IF EXISTS `Alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alerts` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `species_id` varchar(16) NOT NULL,
  `trend_direction` enum('Down','Up','Down Fast','Up Fast') NOT NULL,
  `population_estimate` int NOT NULL,
  `change` int NOT NULL,
  `generated_time` datetime NOT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `species_idx_1` (`species_id`),
  CONSTRAINT `species_idx_1` FOREIGN KEY (`species_id`) REFERENCES `Species` (`species_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alerts`
--

LOCK TABLES `Alerts` WRITE;
/*!40000 ALTER TABLE `Alerts` DISABLE KEYS */;
INSERT INTO `Alerts` VALUES (2,'SP-0016','Down',15,-10,'2026-04-21 10:08:25');
/*!40000 ALTER TABLE `Alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sessions`
--

DROP TABLE IF EXISTS `Sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sessions` (
  `session_id` varchar(16) NOT NULL,
  `volunteer_id` varchar(16) NOT NULL,
  `site_id` varchar(16) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `volunteer_id` (`volunteer_id`,`site_id`,`date`),
  KEY `site_idx` (`site_id`),
  KEY `idx_sessions_date` (`date`),
  CONSTRAINT `site_idx` FOREIGN KEY (`site_id`) REFERENCES `Sites` (`site_id`),
  CONSTRAINT `volunteer_idx` FOREIGN KEY (`volunteer_id`) REFERENCES `Volunteers` (`volunteer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sessions`
--

LOCK TABLES `Sessions` WRITE;
/*!40000 ALTER TABLE `Sessions` DISABLE KEYS */;
INSERT INTO `Sessions` VALUES ('SS_0001','VT_0004','ST-0008','2026-04-06','13:00:00','15:30:00'),('SS_0002','VT_0005','ST-0021','2026-04-07','06:50:00','09:40:00'),('SS_0003','VT_0006','ST-0015','2026-04-08','17:15:00','19:00:00'),('SS_0004','VT_0001','ST-0001','2026-04-03','08:30:00','11:00:00'),('SS_0005','VT_0002','ST-0016','2026-04-04','10:00:00','12:30:00'),('SS_0006','VT_0003','ST-0022','2026-04-05','07:45:00','10:15:00'),('SS_0007','VT_0001','ST-0001','2026-01-05','08:30:00','11:00:00'),('SS_0008','VT_0002','ST-0016','2026-01-12','10:00:00','12:30:00'),('SS_0009','VT_0003','ST-0022','2026-01-18','07:45:00','10:15:00'),('SS_0010','VT_0005','ST-0021','2026-01-25','07:00:00','10:00:00'),('SS_0011','VT_0001','ST-0001','2026-02-02','09:00:00','11:30:00'),('SS_0012','VT_0004','ST-0008','2026-02-09','13:00:00','15:30:00'),('SS_0013','VT_0006','ST-0015','2026-02-16','17:00:00','19:00:00'),('SS_0014','VT_0002','ST-0016','2026-02-23','10:00:00','12:30:00'),('SS_0015','VT_0003','ST-0022','2026-03-02','07:45:00','10:15:00'),('SS_0016','VT_0005','ST-0021','2026-03-09','06:50:00','09:40:00'),('SS_0017','VT_0001','ST-0001','2026-03-16','08:30:00','11:00:00'),('SS_0018','VT_0004','ST-0008','2026-03-23','13:00:00','15:30:00'),('SS_0019','VT_0006','ST-0015','2026-03-30','17:00:00','19:00:00'),('SS_0020','VT_0002','ST-0016','2026-04-13','10:00:00','12:30:00'),('SS_0021','VT_0003','ST-0022','2026-04-20','07:45:00','10:15:00'),('SS_0022','VT_0005','ST-0021','2026-04-27','06:50:00','09:40:00'),('SS_0023','VT_0002','ST-0001','2026-01-08','08:30:00','11:00:00'),('SS_0024','VT_0004','ST-0001','2026-01-22','09:00:00','11:30:00'),('SS_0025','VT_0006','ST-0001','2026-02-05','08:30:00','11:00:00'),('SS_0026','VT_0005','ST-0001','2026-02-19','09:00:00','11:30:00'),('SS_0027','VT_0002','ST-0001','2026-03-10','08:30:00','11:00:00'),('SS_0028','VT_0005','ST-0001','2026-04-21','09:00:00','11:30:00');
/*!40000 ALTER TABLE `Sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`superuser`@`10.10.10.50`*/ /*!50003 TRIGGER `before_session_insert` BEFORE INSERT ON `Sessions` FOR EACH ROW SET NEW.session_id = CONCAT('SS_', LPAD(COALESCE((SELECT MAX(CAST(SUBSTRING(session_id, 4) AS UNSIGNED)) FROM Sessions), 0) + 1, 4, '0')) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Sightings`
--

DROP TABLE IF EXISTS `Sightings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sightings` (
  `sighting_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `species_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `individuals_count` int NOT NULL,
  `sighting_time` time NOT NULL,
  `weather_conditions` enum('Clear','Cloudy','Light Rain','Heavy Rain','Hail','Sleet','Snow','Fog','Sunny','Overcast','Windy') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `notes` longtext,
  `photo_submitted` tinyint NOT NULL,
  PRIMARY KEY (`sighting_id`),
  KEY `volunteer_idx` (`session_id`) USING BTREE,
  KEY `species_name` (`species_id`) USING BTREE,
  CONSTRAINT `session_idx` FOREIGN KEY (`session_id`) REFERENCES `Sessions` (`session_id`),
  CONSTRAINT `species_idx` FOREIGN KEY (`species_id`) REFERENCES `Species` (`species_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sightings`
--

LOCK TABLES `Sightings` WRITE;
/*!40000 ALTER TABLE `Sightings` DISABLE KEYS */;
INSERT INTO `Sightings` VALUES ('SI_0001','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0002','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0003','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0004','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0005','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0006','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0007','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0008','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0009','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0010','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0011','SS_0001','SP-0030',14,'13:27:00','Windy','Group clustered on lower ledges',1),('SI_0012','SS_0001','SP-0062',9,'13:27:00','Windy','Mixed flock with puffins',0),('SI_0013','SS_0001','SP-0013',21,'14:05:00','Windy','Continuous movement around nesting area',0),('SI_0014','SS_0002','SP-0015',3,'07:10:00','Overcast','Three together on upper slope',1),('SI_0015','SS_0002','SP-0020',6,'07:10:00','Overcast','Small group flushed from heather',0),('SI_0016','SS_0002','SP-0008',1,'08:22:00','Overcast','Single bird soaring high above ridge',1),('SI_0017','SS_0003','SP-0077',4,'18:02:00','Clear','Visible offshore for several minutes',1),('SI_0018','SS_0003','SP-0064',11,'18:02:00','Clear','Feeding quickly along tideline',0),('SI_0019','SS_0003','SP-0044',5,'18:19:00','Clear','Five resting near dunes',0),('SI_0020','SS_0003','SP-0018',2,'18:44:00','Clear','Seen on flowering plants behind beach',1),('SI_0021','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0022','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0023','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0024','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0025','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0026','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0027','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0028','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0029','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0030','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0031','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0032','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0033','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0034','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0035','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0036','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0037','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0038','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0039','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0040','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0041','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0042','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0043','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0044','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0045','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0046','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0047','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0048','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0049','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0050','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0051','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0052','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0053','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0054','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0055','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0056','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0057','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0058','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0059','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0060','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0061','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0062','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0063','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0064','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0065','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0066','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0067','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0068','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0069','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0070','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0071','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0072','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0073','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0074','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0075','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0076','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0077','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0078','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0079','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0080','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0081','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0082','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0083','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0084','SS_0004','SP-0004',7,'09:45:00','Sunny','Several adults visible in reeds',0),('SI_0085','SS_0004','SP-0007',3,'10:05:00','Sunny','Three seen together over pond',1),('SI_0086','SS_0005','SP-0013',12,'10:41:00','Cloudy','Large noisy group on shoreline',0),('SI_0087','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0088','SS_0005','SP-0002',5,'11:18:00','Cloudy','Pod moving east across bay',1),('SI_0089','SS_0006','SP-0023',2,'08:03:00','Light Rain','Two adults chasing through pines',1),('SI_0090','SS_0006','SP-0019',1,'08:52:00','Light Rain','Brief sighting crossing path',0),('SI_0091','SS_0006','SP-0029',18,'09:34:00','Light Rain','Active mound beside trail',0),('SI_0092','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0093','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0094','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0095','SS_0004','SP-0016',1,'09:12:00','Sunny','Adult circling over loch',1),('SI_0096','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0097','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0098','SS_0004','SP-0009',4,'09:12:00','Sunny','Small group feeding near water edge',0),('SI_0099','SS_0005','SP-0010',2,'10:41:00','Cloudy','Pair hauled out on sandbank',1),('SI_0100','SS_0004','SP-0009',4,'09:12:00','Sunny','Count has trailing space',0),('SI_0101','SS_0006','SP-0023',2,'08:03:00','Light Rain','End time before start time',1),('SI_0102','SS_0002','SP-0015',3,'07:10:00','Overcast','Boolean variant to normalise',1),('SI_0103','SS_0007','SP-0016',2,'09:00:00','Overcast','Two adults perched near loch edge',1),('SI_0104','SS_0007','SP-0009',8,'09:30:00','Overcast','Small group feeding on grassland',0),('SI_0105','SS_0007','SP-0004',3,'10:00:00','Overcast','Found near reed bed margin',0),('SI_0106','SS_0008','SP-0010',4,'10:30:00','Cloudy','Four hauled out on sandbank',1),('SI_0107','SS_0008','SP-0013',18,'11:00:00','Cloudy','Large group resting on shoreline',0),('SI_0108','SS_0008','SP-0002',2,'11:30:00','Cloudy','Pair moving slowly westward',1),('SI_0109','SS_0009','SP-0023',1,'08:10:00','Snow','Single adult foraging near feeder',1),('SI_0110','SS_0009','SP-0019',1,'08:50:00','Snow','Brief sighting at forest edge',0),('SI_0111','SS_0009','SP-0029',5,'09:30:00','Snow','Small cluster near base of pine',0),('SI_0112','SS_0010','SP-0015',5,'07:30:00','Overcast','Five in winter coat on upper slope',1),('SI_0113','SS_0010','SP-0020',4,'08:00:00','Overcast','Group flushed from heather',0),('SI_0114','SS_0010','SP-0008',1,'09:00:00','Overcast','Single bird soaring over ridge',1),('SI_0115','SS_0011','SP-0016',1,'09:30:00','Cloudy','Single bird hunting over loch',0),('SI_0116','SS_0011','SP-0009',12,'10:00:00','Cloudy','Flock moving across open ground',0),('SI_0117','SS_0011','SP-0004',6,'10:30:00','Cloudy','Several adults visible in shallows',1),('SI_0118','SS_0011','SP-0007',2,'11:00:00','Cloudy','Two seen near reed bed',0),('SI_0119','SS_0012','SP-0030',8,'13:30:00','Windy','Group on lower ledges',1),('SI_0120','SS_0012','SP-0062',5,'14:00:00','Windy','Mixed with puffin group',0),('SI_0121','SS_0012','SP-0013',14,'14:30:00','Windy','Continuous movement around cliffs',0),('SI_0122','SS_0012','SP-0008',1,'15:00:00','Windy','Single bird circling above headland',1),('SI_0123','SS_0013','SP-0077',3,'17:30:00','Clear','Three visible offshore',1),('SI_0124','SS_0013','SP-0064',9,'18:00:00','Clear','Feeding along tideline',0),('SI_0125','SS_0013','SP-0044',7,'18:30:00','Clear','Seven resting near dunes',0),('SI_0126','SS_0014','SP-0010',3,'10:30:00','Overcast','Three resting on exposed rock',0),('SI_0127','SS_0014','SP-0002',4,'11:00:00','Overcast','Pod moving through bay',1),('SI_0128','SS_0014','SP-0013',22,'11:30:00','Overcast','Large flock on shoreline',0),('SI_0129','SS_0014','SP-0064',6,'12:00:00','Overcast','Feeding at water\'s edge',0),('SI_0130','SS_0015','SP-0023',3,'08:00:00','Light Rain','Three adults active in canopy',1),('SI_0131','SS_0015','SP-0019',1,'08:50:00','Light Rain','Crossing path near trail marker',0),('SI_0132','SS_0015','SP-0029',14,'09:30:00','Light Rain','Active mound beside trail',0),('SI_0133','SS_0015','SP-0007',4,'10:00:00','Light Rain','Several near stream crossing',0),('SI_0134','SS_0016','SP-0015',7,'07:15:00','Clear','Seven on upper moorland',1),('SI_0135','SS_0016','SP-0020',9,'07:45:00','Clear','Flock on open hillside',0),('SI_0136','SS_0016','SP-0008',2,'08:30:00','Clear','Pair soaring together',1),('SI_0137','SS_0016','SP-0023',2,'09:00:00','Clear','Two seen near lower treeline',0),('SI_0138','SS_0017','SP-0016',3,'09:00:00','Sunny','Three adults active over loch',1),('SI_0139','SS_0017','SP-0009',15,'09:30:00','Sunny','Large flock on grassland',0),('SI_0140','SS_0017','SP-0004',11,'10:00:00','Sunny','Many adults visible in breeding pond',1),('SI_0141','SS_0017','SP-0007',7,'10:30:00','Sunny','Several species active near reeds',0),('SI_0142','SS_0018','SP-0030',19,'13:20:00','Windy','Large group on nesting ledges',1),('SI_0143','SS_0018','SP-0062',12,'13:50:00','Windy','Dozen seen on cliff face',0),('SI_0144','SS_0018','SP-0013',28,'14:20:00','Windy','Very active around nesting area',0),('SI_0145','SS_0018','SP-0008',1,'15:00:00','Windy','Single bird hunting over headland',1),('SI_0146','SS_0019','SP-0077',6,'17:30:00','Clear','Six offshore moving east',1),('SI_0147','SS_0019','SP-0064',15,'18:00:00','Clear','Large group feeding at tideline',0),('SI_0148','SS_0019','SP-0044',8,'18:30:00','Clear','Eight resting on dunes',0),('SI_0149','SS_0019','SP-0018',3,'18:50:00','Clear','Three on flowering plants',1),('SI_0150','SS_0020','SP-0010',5,'10:30:00','Cloudy','Five on sandbank',1),('SI_0151','SS_0020','SP-0002',7,'11:00:00','Cloudy','Pod of seven in bay',1),('SI_0152','SS_0020','SP-0013',31,'11:30:00','Cloudy','Very large group on shore',0),('SI_0153','SS_0020','SP-0064',10,'12:00:00','Cloudy','Ten feeding at water\'s edge',0),('SI_0154','SS_0021','SP-0023',4,'08:10:00','Light Rain','Four active near feeder station',1),('SI_0155','SS_0021','SP-0019',2,'09:00:00','Light Rain','Two seen together near den site',1),('SI_0156','SS_0021','SP-0029',22,'09:40:00','Light Rain','Very active mound',0),('SI_0157','SS_0021','SP-0007',8,'10:00:00','Light Rain','Many active along stream',0),('SI_0158','SS_0022','SP-0015',9,'07:10:00','Sunny','Nine on upper slope',1),('SI_0159','SS_0022','SP-0020',11,'07:45:00','Sunny','Flock of eleven on open ground',0),('SI_0160','SS_0022','SP-0008',2,'08:30:00','Sunny','Pair hunting over plateau',1),('SI_0161','SS_0022','SP-0023',3,'09:00:00','Sunny','Three seen near lower forest edge',0),('SI_0162','SS_0007','SP-0016',2,'09:00:00','Overcast','Two adults perched near loch edge',1),('SI_0163','SS_0007','SP-0009',8,'09:30:00','Overcast','Small group feeding on grassland',0),('SI_0164','SS_0007','SP-0004',3,'10:00:00','Overcast','Found near reed bed margin',0),('SI_0165','SS_0008','SP-0010',4,'10:30:00','Cloudy','Four hauled out on sandbank',1),('SI_0166','SS_0008','SP-0013',18,'11:00:00','Cloudy','Large group resting on shoreline',0),('SI_0167','SS_0008','SP-0002',2,'11:30:00','Cloudy','Pair moving slowly westward',1),('SI_0168','SS_0009','SP-0023',1,'08:10:00','Snow','Single adult foraging near feeder',1),('SI_0169','SS_0009','SP-0019',1,'08:50:00','Snow','Brief sighting at forest edge',0),('SI_0170','SS_0009','SP-0029',5,'09:30:00','Snow','Small cluster near base of pine',0),('SI_0171','SS_0010','SP-0015',5,'07:30:00','Overcast','Five in winter coat on upper slope',1),('SI_0172','SS_0010','SP-0020',4,'08:00:00','Overcast','Group flushed from heather',0),('SI_0173','SS_0010','SP-0008',1,'09:00:00','Overcast','Single bird soaring over ridge',1),('SI_0174','SS_0011','SP-0016',1,'09:30:00','Cloudy','Single bird hunting over loch',0),('SI_0175','SS_0011','SP-0009',12,'10:00:00','Cloudy','Flock moving across open ground',0),('SI_0176','SS_0011','SP-0004',6,'10:30:00','Cloudy','Several adults visible in shallows',1),('SI_0177','SS_0011','SP-0007',2,'11:00:00','Cloudy','Two seen near reed bed',0),('SI_0178','SS_0012','SP-0030',8,'13:30:00','Windy','Group on lower ledges',1),('SI_0179','SS_0012','SP-0062',5,'14:00:00','Windy','Mixed with puffin group',0),('SI_0180','SS_0012','SP-0013',14,'14:30:00','Windy','Continuous movement around cliffs',0),('SI_0181','SS_0012','SP-0008',1,'15:00:00','Windy','Single bird circling above headland',1),('SI_0182','SS_0013','SP-0077',3,'17:30:00','Clear','Three visible offshore',1),('SI_0183','SS_0013','SP-0064',9,'18:00:00','Clear','Feeding along tideline',0),('SI_0184','SS_0013','SP-0044',7,'18:30:00','Clear','Seven resting near dunes',0),('SI_0185','SS_0014','SP-0010',3,'10:30:00','Overcast','Three resting on exposed rock',0),('SI_0186','SS_0014','SP-0002',4,'11:00:00','Overcast','Pod moving through bay',1),('SI_0187','SS_0014','SP-0013',22,'11:30:00','Overcast','Large flock on shoreline',0),('SI_0188','SS_0014','SP-0064',6,'12:00:00','Overcast','Feeding at water\'s edge',0),('SI_0189','SS_0015','SP-0023',3,'08:00:00','Light Rain','Three adults active in canopy',1),('SI_0190','SS_0015','SP-0019',1,'08:50:00','Light Rain','Crossing path near trail marker',0),('SI_0191','SS_0015','SP-0029',14,'09:30:00','Light Rain','Active mound beside trail',0),('SI_0192','SS_0015','SP-0007',4,'10:00:00','Light Rain','Several near stream crossing',0),('SI_0193','SS_0016','SP-0015',7,'07:15:00','Clear','Seven on upper moorland',1),('SI_0194','SS_0016','SP-0020',9,'07:45:00','Clear','Flock on open hillside',0),('SI_0195','SS_0016','SP-0008',2,'08:30:00','Clear','Pair soaring together',1),('SI_0196','SS_0016','SP-0023',2,'09:00:00','Clear','Two seen near lower treeline',0),('SI_0197','SS_0017','SP-0016',3,'09:00:00','Sunny','Three adults active over loch',1),('SI_0198','SS_0017','SP-0009',15,'09:30:00','Sunny','Large flock on grassland',0),('SI_0199','SS_0017','SP-0004',11,'10:00:00','Sunny','Many adults visible in breeding pond',1),('SI_0200','SS_0017','SP-0007',7,'10:30:00','Sunny','Several species active near reeds',0),('SI_0201','SS_0018','SP-0030',19,'13:20:00','Windy','Large group on nesting ledges',1),('SI_0202','SS_0018','SP-0062',12,'13:50:00','Windy','Dozen seen on cliff face',0),('SI_0203','SS_0018','SP-0013',28,'14:20:00','Windy','Very active around nesting area',0),('SI_0204','SS_0018','SP-0008',1,'15:00:00','Windy','Single bird hunting over headland',1),('SI_0205','SS_0019','SP-0077',6,'17:30:00','Clear','Six offshore moving east',1),('SI_0206','SS_0019','SP-0064',15,'18:00:00','Clear','Large group feeding at tideline',0),('SI_0207','SS_0019','SP-0044',8,'18:30:00','Clear','Eight resting on dunes',0),('SI_0208','SS_0019','SP-0018',3,'18:50:00','Clear','Three on flowering plants',1),('SI_0209','SS_0020','SP-0010',5,'10:30:00','Cloudy','Five on sandbank',1),('SI_0210','SS_0020','SP-0002',7,'11:00:00','Cloudy','Pod of seven in bay',1),('SI_0211','SS_0020','SP-0013',31,'11:30:00','Cloudy','Very large group on shore',0),('SI_0212','SS_0020','SP-0064',10,'12:00:00','Cloudy','Ten feeding at water\'s edge',0),('SI_0213','SS_0021','SP-0023',4,'08:10:00','Light Rain','Four active near feeder station',1),('SI_0214','SS_0021','SP-0019',2,'09:00:00','Light Rain','Two seen together near den site',1),('SI_0215','SS_0021','SP-0029',22,'09:40:00','Light Rain','Very active mound',0),('SI_0216','SS_0021','SP-0007',8,'10:00:00','Light Rain','Many active along stream',0),('SI_0217','SS_0022','SP-0015',9,'07:10:00','Sunny','Nine on upper slope',1),('SI_0218','SS_0022','SP-0020',11,'07:45:00','Sunny','Flock of eleven on open ground',0),('SI_0219','SS_0022','SP-0008',2,'08:30:00','Sunny','Pair hunting over plateau',1),('SI_0220','SS_0022','SP-0023',3,'09:00:00','Sunny','Three seen near lower forest edge',0),('SI_0221','SS_0023','SP-0016',6,'09:15:00','Overcast','Six adults active over loch',1),('SI_0222','SS_0024','SP-0016',5,'09:45:00','Cloudy','Five birds visible from hide',1),('SI_0223','SS_0025','SP-0016',4,'09:30:00','Overcast','Four adults perched near water',0),('SI_0224','SS_0026','SP-0016',4,'10:00:00','Cloudy','Four seen circling together',1),('SI_0225','SS_0027','SP-0016',1,'09:30:00','Light Rain','Single bird briefly visible',0),('SI_0226','SS_0028','SP-0016',1,'10:30:00','Cloudy','One seen briefly near reeds',0);
/*!40000 ALTER TABLE `Sightings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`superuser`@`10.10.10.50`*/ /*!50003 TRIGGER `before_sighting_insert` BEFORE INSERT ON `Sightings` FOR EACH ROW SET NEW.sighting_id = CONCAT('SI_', LPAD(COALESCE((SELECT MAX(CAST(SUBSTRING(sighting_id, 4) AS UNSIGNED)) FROM Sightings), 0) + 1, 4, '0')) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Sites`
--

DROP TABLE IF EXISTS `Sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sites` (
  `site_id` varchar(16) NOT NULL,
  `site_name` varchar(255) NOT NULL,
  `region` enum('Highlands','Islands','Moray','Cairngorms') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `grid_reference` varchar(16) NOT NULL,
  `habitat_type` enum('Coastal','Woodland','Moorland','Freshwater','Urban') NOT NULL,
  `access_difficulty` enum('Easy','Moderate','Difficult') NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `site_name` (`site_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sites`
--

LOCK TABLES `Sites` WRITE;
/*!40000 ALTER TABLE `Sites` DISABLE KEYS */;
INSERT INTO `Sites` VALUES ('ST-0001','Speyside Wetland Centre','Highlands','NH294837','Freshwater','Easy',1),('ST-0002','Loch Maree Shore','Highlands','NG894705','Freshwater','Moderate',1),('ST-0003','Black Isle Woodland Trail','Highlands','NH655575','Woodland','Easy',1),('ST-0004','Assynt Moor Edge','Highlands','NC210276','Moorland','Difficult',1),('ST-0005','Inverness Riverside Park','Highlands','NH665449','Urban','Easy',0),('ST-0006','Glen Affric Pinewoods','Highlands','NH203233','Woodland','Moderate',1),('ST-0007','Dornoch Coastal Point','Highlands','NH798898','Coastal','Easy',1),('ST-0008','Skye Cliff Watch','Islands','NG412468','Coastal','Moderate',1),('ST-0009','Harris Moor Reserve','Islands','NB218098','Moorland','Difficult',1),('ST-0010','Orkney Tidal Bay','Islands','HY451128','Coastal','Easy',1),('ST-0011','Mull Woodland Track','Islands','NM525376','Woodland','Moderate',0),('ST-0012','Lewis Loch Margin','Islands','NB301327','Freshwater','Moderate',1),('ST-0013','South Uist Machair Edge','Islands','NF787225','Coastal','Easy',1),('ST-0014','Shetland Harbour View','Islands','HU511401','Urban','Easy',0),('ST-0015','Lossiemouth Dune Path','Moray','NJ216702','Coastal','Easy',1),('ST-0016','Findhorn Bay Watchpoint','Moray','NJ042642','Coastal','Easy',1),('ST-0017','Elgin Nature Green','Moray','NJ216631','Urban','Easy',0),('ST-0018','Spey Forest Fringe','Moray','NJ351514','Woodland','Moderate',1),('ST-0019','Keith Mossland Site','Moray','NJ428506','Moorland','Moderate',1),('ST-0020','Cullen Burn Corridor','Moray','NJ512673','Freshwater','Easy',1),('ST-0021','Cairngorm Lochan Trail','Cairngorms','NH982060','Freshwater','Moderate',1),('ST-0022','Rothiemurchus Forest Gate','Cairngorms','NH896093','Woodland','Easy',1),('ST-0023','Braemar Heather Slopes','Cairngorms','NO151915','Moorland','Difficult',1),('ST-0024','Aviemore Park Edge','Cairngorms','NH898123','Urban','Easy',0),('ST-0025','Glenmore Upland Track','Cairngorms','NH971098','Moorland','Moderate',1);
/*!40000 ALTER TABLE `Sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Species`
--

DROP TABLE IF EXISTS `Species`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Species` (
  `species_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `species_name` varchar(64) NOT NULL,
  `scientific_name` varchar(64) NOT NULL,
  `category` enum('Bird','Mammal','Marine','Amphibian','Insect') NOT NULL,
  `conservation_status` enum('Least Concern','Near Threatened','Vulnerable','Endangered','Critically Endangered') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_priority` tinyint NOT NULL,
  PRIMARY KEY (`species_id`),
  UNIQUE KEY `species_name` (`species_name`),
  KEY `idx_species_conservation` (`conservation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Species`
--

LOCK TABLES `Species` WRITE;
/*!40000 ALTER TABLE `Species` DISABLE KEYS */;
INSERT INTO `Species` VALUES ('SP-0001','Badger','Meles meles','Mammal','Least Concern',0),('SP-0002','Bottlenose Dolphin','Tursiops truncatus','Marine','Least Concern',1),('SP-0003','Buzzard','Buteo buteo','Bird','Least Concern',0),('SP-0004','Common Frog','Rana temporaria','Amphibian','Least Concern',0),('SP-0005','Common Lizard','Zootoca vivipara','Amphibian','Least Concern',0),('SP-0006','Common Toad','Bufo bufo','Amphibian','Least Concern',0),('SP-0007','Dragonfly','Anisoptera spp.','Insect','Least Concern',0),('SP-0008','Golden Eagle','Aquila chrysaetos','Bird','Least Concern',1),('SP-0009','Golden Plover','Pluvialis apricaria','Bird','Near Threatened',1),('SP-0010','Grey Seal','Halichoerus grypus','Marine','Least Concern',0),('SP-0011','Harbour Seal','Phoca vitulina','Marine','Least Concern',0),('SP-0012','Hedgehog','Erinaceus europaeus','Mammal','Vulnerable',1),('SP-0013','Kittiwake','Rissa tridactyla','Bird','Vulnerable',1),('SP-0014','Minke Whale','Balaenoptera acutorostrata','Marine','Least Concern',0),('SP-0015','Mountain Hare','Lepus timidus','Mammal','Near Threatened',0),('SP-0016','Osprey','Pandion haliaetus','Bird','Critically Endangered',1),('SP-0017','Otter','Lutra lutra','Mammal','Least Concern',1),('SP-0018','Peacock Butterfly','Aglais io','Insect','Least Concern',0),('SP-0019','Pine Marten','Martes martes','Mammal','Least Concern',0),('SP-0020','Ptarmigan','Lagopus muta','Bird','Least Concern',0),('SP-0021','Red Deer','Cervus elaphus','Mammal','Least Concern',0),('SP-0022','Red Kite','Milvus milvus','Bird','Least Concern',1),('SP-0023','Red Squirrel','Sciurus vulgaris','Mammal','Endangered',1),('SP-0024','Roe Deer','Capreolus capreolus','Mammal','Least Concern',0),('SP-0025','Scottish Wildcat','Felis silvestris','Mammal','Critically Endangered',1),('SP-0026','Small Heath Butterfly','Coenonympha pamphilus','Insect','Least Concern',0),('SP-0027','Smooth Newt','Lissotriton vulgaris','Amphibian','Least Concern',0),('SP-0028','Tawny Owl','Strix aluco','Bird','Least Concern',0),('SP-0029','Wood Ant','Formica rufa','Insect','Least Concern',0),('SP-0030','Atlantic Puffin','Fratercula arctica','Bird','Vulnerable',1),('SP-0031','Barn Owl','Tyto alba','Bird','Least Concern',0),('SP-0032','Black Grouse','Lyrurus tetrix','Bird','Least Concern',1),('SP-0033','Curlew','Numenius arquata','Bird','Near Threatened',1),('SP-0034','Lapwing','Vanellus vanellus','Bird','Near Threatened',1),('SP-0035','Peregrine Falcon','Falco peregrinus','Bird','Least Concern',1),('SP-0036','Puffin','Fratercula arctica','Bird','Vulnerable',1),('SP-0037','Whooper Swan','Cygnus cygnus','Bird','Least Concern',0),('SP-0038','Daubentons Bat','Myotis daubentonii','Mammal','Least Concern',0),('SP-0039','Harbour Porpoise','Phocoena phocoena','Marine','Least Concern',1),('SP-0040','Orca','Orcinus orca','Marine','Least Concern',1),('SP-0041','Water Vole','Arvicola amphibius','Mammal','Endangered',1),('SP-0042','Rabbits','Oryctolagus cuniculus','Mammal','Near Threatened',0),('SP-0043','Stoat','Mustela erminea','Mammal','Least Concern',0),('SP-0044','Common Gull','Larus canus','Bird','Least Concern',0),('SP-0045','Common Starfish','Asterias rubens','Marine','Least Concern',0),('SP-0046','Leatherback Turtle','Dermochelys coriacea','Marine','Vulnerable',1),('SP-0047','Basking Shark','Cetorhinus maximus','Marine','Endangered',1),('SP-0048','Great Crested Newt','Triturus cristatus','Amphibian','Least Concern',1),('SP-0049','Palmate Newt','Lissotriton helveticus','Amphibian','Least Concern',0),('SP-0050','Natterjack Toad','Epidalea calamita','Amphibian','Least Concern',1),('SP-0051','Common Blue Butterfly','Polyommatus icarus','Insect','Least Concern',0),('SP-0052','Elephant Hawk-moth','Deilephila elpenor','Insect','Least Concern',0),('SP-0053','Great Yellow Bumblebee','Bombus distinguendus','Insect','Vulnerable',1),('SP-0054','Northern Damselfly','Coenagrion hastulatum','Insect','Least Concern',0),('SP-0055','Small Tortoiseshell','Aglais urticae','Insect','Least Concern',0),('SP-0056','Arctic Tern','Sterna paradisaea','Bird','Least Concern',1),('SP-0057','Barnacle Goose','Branta leucopsis','Bird','Least Concern',0),('SP-0058','Chough','Pyrrhocorax pyrrhocorax','Bird','Least Concern',1),('SP-0059','Corncrake','Crex crex','Bird','Least Concern',1),('SP-0060','Gannet','Morus bassanus','Bird','Least Concern',0),('SP-0061','Hen Harrier','Circus cyaneus','Bird','Least Concern',1),('SP-0062','Razorbill','Alca torda','Bird','Least Concern',0),('SP-0063','Ring Ouzel','Turdus torquatus','Bird','Least Concern',1),('SP-0064','Sanderling','Calidris alba','Bird','Least Concern',0),('SP-0065','White-tailed Eagle','Haliaeetus albicilla','Bird','Least Concern',1),('SP-0066','Bank Vole','Myodes glareolus','Mammal','Least Concern',0),('SP-0067','Common Pipistrelle','Pipistrellus pipistrellus','Mammal','Least Concern',0),('SP-0068','European Mole','Talpa europaea','Mammal','Least Concern',0),('SP-0069','Fallow Deer','Dama dama','Mammal','Least Concern',0),('SP-0070','Field Vole','Microtus agrestis','Mammal','Least Concern',0),('SP-0071','Common Shrew','Sorex araneus','Mammal','Least Concern',0),('SP-0072','Red Fox','Vulpes vulpes','Mammal','Least Concern',0),('SP-0073','Sika Deer','Cervus nippon','Mammal','Least Concern',0),('SP-0074','Weasel','Mustela nivalis','Mammal','Least Concern',0),('SP-0075','Brown Hare','Lepus europaeus','Mammal','Near Threatened',1),('SP-0076','Atlantic Salmon','Salmo salar','Marine','Near Threatened',1),('SP-0077','Common Dolphin','Delphinus delphis','Marine','Least Concern',1),('SP-0078','European Eel','Anguilla anguilla','Marine','Critically Endangered',1),('SP-0079','Edible Crab','Cancer pagurus','Marine','Least Concern',0),('SP-0080','Humpback Whale','Megaptera novaeangliae','Marine','Least Concern',1),('SP-0081','Moon Jellyfish','Aurelia aurita','Marine','Least Concern',0),('SP-0082','European Lobster','Homarus gammarus','Marine','Least Concern',0),('SP-0083','Rissos Dolphin','Grampus griseus','Marine','Least Concern',1),('SP-0084','Sand Eel','Ammodytes marinus','Marine','Least Concern',0),('SP-0085','Short-snouted Seahorse','Hippocampus hippocampus','Marine','Near Threatened',1),('SP-0086','Alpine Newt','Ichthyosaura alpestris','Amphibian','Least Concern',0),('SP-0087','Edible Frog','Pelophylax kl. esculentus','Amphibian','Least Concern',0),('SP-0088','Fire Salamander','Salamandra salamandra','Amphibian','Least Concern',0),('SP-0089','Iberian Midwife Toad','Alytes cisternasii','Amphibian','Least Concern',0),('SP-0090','Marsh Frog','Pelophylax ridibundus','Amphibian','Least Concern',0),('SP-0091','Northern Leopard Frog','Lithobates pipiens','Amphibian','Least Concern',0),('SP-0092','Pool Frog','Pelophylax lessonae','Amphibian','Least Concern',1),('SP-0093','7-Spot Ladybird','Coccinella septempunctata','Insect','Least Concern',0),('SP-0094','Buff-tailed Bumblebee','Bombus terrestris','Insect','Least Concern',0),('SP-0095','Green Tiger Beetle','Cicindela campestris','Insect','Least Concern',0),('SP-0096','Marsh Fritillary','Euphydryas aurinia','Insect','Near Threatened',1),('SP-0097','Meadow Brown','Maniola jurtina','Insect','Least Concern',0),('SP-0098','Painted Lady','Vanessa cardui','Insect','Least Concern',0),('SP-0099','Pearl-bordered Fritillary','Boloria euphrosyne','Insect','Near Threatened',1),('SP-0100','Red Admiral','Vanessa atalanta','Insect','Least Concern',0);
/*!40000 ALTER TABLE `Species` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Volunteers`
--

DROP TABLE IF EXISTS `Volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Volunteers` (
  `volunteer_id` varchar(16) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `region` enum('Highlands','Islands','Moray','Cairngorms') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date_joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`volunteer_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Volunteers`
--

LOCK TABLES `Volunteers` WRITE;
/*!40000 ALTER TABLE `Volunteers` DISABLE KEYS */;
INSERT INTO `Volunteers` VALUES ('VT_0001','Eilidh','MacLeod','eilidh.m@email.com',NULL,'Highlands','2024-03-28 00:00:00',1),('VT_0002','Calum','Ross','c.ross@email.com',NULL,'Moray','2024-04-15 00:00:00',1),('VT_0003','Fiona','Munro','fiona.munro@email.com','07700111223','Highlands','2024-06-01 00:00:00',1),('VT_0004','Mairi','Fraser','mairi.fraser@email.com',NULL,'Islands','2024-07-12 00:00:00',1),('VT_0005','Lewis','Grant','lewis.grant@email.com','07700222334','Cairngorms','2024-08-20 00:00:00',1),('VT_0006','Anna','Stewart','anna.stewart@email.com',NULL,'Moray','2024-09-05 00:00:00',1),('VT_0007','Alasdair','Campbell','a.campbell@email.com','07700333445','Highlands','2024-10-14 00:00:00',1),('VT_0008','Kirsty','Murray','kirsty.murray@email.com',NULL,'Cairngorms','2024-11-03 00:00:00',1),('VT_0009','Ruaridh','Mackay','r.mackay@email.com','07700444556','Islands','2024-11-19 00:00:00',1),('VT_0010','Catriona','Henderson','cat.henderson@email.com',NULL,'Moray','2025-01-07 00:00:00',1),('VT_0011','Hamish','Gillies','h.gillies@email.com','07700555667','Highlands','2025-02-14 00:00:00',1),('VT_0012','Isla','Sinclair','isla.sinclair@email.com',NULL,'Cairngorms','2025-03-01 00:00:00',0),('VT_0013','Tormod','Morrison','tormod.morrison@email.com','07700666778','Islands','2025-03-10 00:00:00',1),('VT_0014','Siobhan','Kerr','siobhan.kerr@email.com',NULL,'Highlands','2025-03-15 00:00:00',1),('VT_0015','Angus','Dunbar','angus.dunbar@email.com','07700777889','Cairngorms','2025-03-22 00:00:00',1),('VT_0016','Morag','Paterson','morag.paterson@email.com',NULL,'Moray','2025-03-28 00:00:00',1),('VT_0017','Euan','Buchanan','euan.buchanan@email.com','07700888990','Islands','2025-04-02 00:00:00',1),('VT_0018','Rhona','Dougall','rhona.dougall@email.com',NULL,'Highlands','2025-04-08 00:00:00',1),('VT_0019','Finlay','Lawson','finlay.lawson@email.com','07700999001','Cairngorms','2025-04-14 00:00:00',1),('VT_0020','Seonaid','Mclean','seonaid.mclean@email.com',NULL,'Moray','2025-04-20 00:00:00',1),('VT_0021','Donnchadh','Forbes','d.forbes@email.com','07701111223','Highlands','2025-05-01 00:00:00',1),('VT_0022','Marsaili','Drummond','m.drummond@email.com',NULL,'Islands','2025-05-07 00:00:00',1),('VT_0023','Coinneach','Sutherland','c.sutherland@email.com','07701222334','Cairngorms','2025-05-13 00:00:00',1),('VT_0024','Grainne','Reid','grainne.reid@email.com',NULL,'Moray','2025-05-19 00:00:00',1),('VT_0025','Struan','Black','struan.black@email.com','07701333445','Highlands','2025-05-25 00:00:00',1),('VT_0026','Deirdre','Allan','deirdre.allan@email.com',NULL,'Islands','2025-06-01 00:00:00',1),('VT_0027','Seumas','Whyte','seumas.whyte@email.com','07701444556','Cairngorms','2025-06-07 00:00:00',0),('VT_0028','Beathag','Ingram','beathag.ingram@email.com',NULL,'Moray','2025-06-13 00:00:00',1),('VT_0029','Iain','Galbraith','iain.galbraith@email.com','07701555667','Highlands','2025-06-19 00:00:00',1),('VT_0030','Niamh','Cochrane','niamh.cochrane@email.com',NULL,'Islands','2025-06-25 00:00:00',1),('VT_0031','Oisean','Beveridge','oisean.beveridge@email.com','07701666778','Cairngorms','2025-07-01 00:00:00',1),('VT_0032','Peggy','Aitken','peggy.aitken@email.com',NULL,'Moray','2025-07-07 00:00:00',1),('VT_0033','Tearlach','Menzies','tearlach.menzies@email.com','07701777889','Highlands','2025-07-13 00:00:00',1),('VT_0034','Una','Crichton','una.crichton@email.com',NULL,'Islands','2025-07-19 00:00:00',0),('VT_0035','Brennan','Nairn','brennan.nairn@email.com','07701888990','Cairngorms','2025-07-25 00:00:00',1),('VT_0036','Caoimhe','Lochhead','caoimhe.lochhead@email.com',NULL,'Moray','2025-08-01 00:00:00',1),('VT_0037','Fearghas','Paton','fearghas.paton@email.com','07701999001','Highlands','2025-08-07 00:00:00',1),('VT_0038','Sorcha','Rennie','sorcha.rennie@email.com',NULL,'Islands','2025-08-13 00:00:00',1),('VT_0039','Dugald','Mair','dugald.mair@email.com','07702111223','Cairngorms','2025-08-19 00:00:00',1),('VT_0040','Fionnuala','Yuill','fionnuala.yuill@email.com',NULL,'Moray','2025-08-25 00:00:00',1),('VT_0041','Murdo','Skinner','murdo.skinner@email.com','07702222334','Highlands','2025-09-01 00:00:00',1),('VT_0042','Ailsa','Tough','ailsa.tough@email.com',NULL,'Islands','2025-09-07 00:00:00',1),('VT_0043','Pàdraig','Milne','padraig.milne@email.com','07702333445','Cairngorms','2025-09-13 00:00:00',1),('VT_0044','Rona','Urquhart','rona.urquhart@email.com',NULL,'Moray','2025-09-19 00:00:00',0),('VT_0045','Lachlann','Waddell','lachlann.waddell@email.com','07702444556','Highlands','2025-09-25 00:00:00',1),('VT_0046','Brighid','Fyfe','brighid.fyfe@email.com',NULL,'Islands','2025-10-01 00:00:00',1),('VT_0047','Cormac','Spence','cormac.spence@email.com','07702555667','Cairngorms','2025-10-07 00:00:00',1),('VT_0048','Teasag','Ogilvie','teasag.ogilvie@email.com',NULL,'Moray','2025-10-13 00:00:00',1),('VT_0049','Artair','Pringle','artair.pringle@email.com','07702666778','Highlands','2025-10-19 00:00:00',1),('VT_0050','Sile','Quigley','sile.quigley@email.com',NULL,'Islands','2025-10-25 00:00:00',1);
/*!40000 ALTER TABLE `Volunteers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'Highland_Wildlife_Trust'
--
/*!50003 DROP PROCEDURE IF EXISTS `identify_population_trend` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`superuser`@`10.10.10.50` PROCEDURE `identify_population_trend`(
	IN `param_species_name` VARCHAR(64),
	IN `param_start_date` DATE,
	IN `param_end_date` DATE
)
BEGIN
    DECLARE var_species_id VARCHAR(64);
    DECLARE var_conservation_status VARCHAR(32);
    DECLARE var_midpoint DATE;
    DECLARE var_first_half INT DEFAULT 0;
    DECLARE var_second_half INT DEFAULT 0;
    DECLARE var_change INT DEFAULT 0;
    DECLARE var_trend VARCHAR(16);

    SELECT species_id, conservation_status
    INTO var_species_id, var_conservation_status
    FROM Species
    WHERE species_name = param_species_name;

    IF var_species_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Species not found';
    END IF;

    SET var_midpoint = DATE_ADD(param_start_date, INTERVAL DATEDIFF(param_end_date, param_start_date) / 2 DAY);

    SELECT COALESCE(SUM(sg.individuals_count), 0) INTO var_first_half
    FROM Sightings sg
    JOIN Sessions se ON sg.session_id = se.session_id
    WHERE sg.species_id = var_species_id
      AND se.date >= param_start_date
      AND se.date < var_midpoint;

    SELECT COALESCE(SUM(sg.individuals_count), 0) INTO var_second_half
    FROM Sightings sg
    JOIN Sessions se ON sg.session_id = se.session_id
    WHERE sg.species_id = var_species_id
      AND se.date >= var_midpoint
      AND se.date <= param_end_date;

    SET var_change = var_second_half - var_first_half;

    IF var_change > 0 THEN
        SET var_trend = 'Increasing';
    ELSEIF var_change < 0 THEN
        SET var_trend = 'Decreasing';
    ELSE
        SET var_trend = 'Stable';
    END IF;

    IF var_conservation_status IN ('Endangered', 'Critically Endangered') AND var_trend = 'Decreasing' THEN
        INSERT INTO Alerts (species_id, trend_direction, population_estimate, `change`, generated_time)
        VALUES (var_species_id, 'Down', var_second_half, var_change, NOW());
        SELECT param_species_name AS species, var_trend AS trend, var_first_half AS first_half, var_second_half AS second_half, 'Alert created' AS alert_status;                            
    ELSE                                                                                                                                                                                     
        SELECT param_species_name AS species, var_trend AS trend, var_first_half AS first_half, var_second_half AS second_half, 'No alert created' AS alert_status;  
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-21 10:27:05
