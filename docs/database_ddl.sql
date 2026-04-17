CREATE TABLE `Volunteers` (
	`volunteer_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`first_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`last_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`email` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`phone` VARCHAR(16) NULL DEFAULT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`region` ENUM('Highlands','Islands','Moray','Cairngorms') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date_joined` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	`is_active` TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY (`volunteer_id`) USING BTREE,
	UNIQUE INDEX `email` (`email`) USING BTREE
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB;

CREATE TABLE `Sites` (
	`site_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`site_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`region` ENUM('Highlands','Islands','Moray','Cairngorms') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`grid_reference` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`habitat_type` ENUM('Coastal','Woodland','Moorland','Freshwater','Urban') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`access_difficulty` ENUM('Easy','Moderate','Difficult') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`is_active` TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY (`site_id`) USING BTREE
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB;

CREATE TABLE `Species` (
	`species_id` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`species_name` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`scientific_name` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`category` ENUM('Bird','Mammal','Marine','Amphibian','Insect') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`conservation_status` ENUM('Least Concern','Near Threatened','Vulnerable','Endangered','Critically Endangered') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`is_priority` TINYINT NOT NULL,
	PRIMARY KEY (`species_id`) USING BTREE,
	UNIQUE INDEX `species_name` (`species_name`) USING BTREE
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB;

CREATE TABLE `Sessions` (
	`session_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`volunteer_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`site_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`date` DATE NOT NULL,
	`start_time` TIME NOT NULL,
	`end_time` TIME NOT NULL,
	PRIMARY KEY (`session_id`) USING BTREE,
	UNIQUE INDEX `volunteer_id` (`volunteer_id`, `site_id`, `date`) USING BTREE,
	INDEX `site_idx` (`site_id`) USING BTREE,
	CONSTRAINT `site_idx` FOREIGN KEY (`site_id`) REFERENCES `Sites` (`site_id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `volunteer_idx` FOREIGN KEY (`volunteer_id`) REFERENCES `Volunteers` (`volunteer_id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB
;

CREATE TABLE `Sightings` (
	`sighting_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`session_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`species_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`individuals_count` INT NOT NULL,
	`sighting_time` TIME NOT NULL,
	`weather_conditions` ENUM('Clear','Cloudy','Light Rain','Heavy Rain','Hail','Sleet','Snow','Fog','Sunny','Overcast','Windy') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`notes` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`photo_submitted` TINYINT NOT NULL,
	PRIMARY KEY (`sighting_id`) USING BTREE,
	INDEX `volunteer_idx` (`session_id`) USING BTREE,
	INDEX `species_name` (`species_id`) USING BTREE,
	CONSTRAINT `session_idx` FOREIGN KEY (`session_id`) REFERENCES `Sessions` (`session_id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `species_idx` FOREIGN KEY (`species_id`) REFERENCES `Species` (`species_id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB;

CREATE TABLE `Alerts` (
	`alert_id` INT NOT NULL AUTO_INCREMENT,
	`species_id` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`trend_direction` ENUM('Down','Up','Down Fast','Up Fast') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`population_estimate` INT NOT NULL,
	`change` INT NOT NULL,
	`generated_time` DATETIME NOT NULL,
	PRIMARY KEY (`alert_id`) USING BTREE,
	INDEX `species_idx_1` (`species_id`) USING BTREE,
	CONSTRAINT `species_idx_1` FOREIGN KEY (`species_id`) REFERENCES `Species` (`species_id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_0900_ai_ci'
ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER before_session_insert
BEFORE INSERT ON `Sessions`
FOR EACH ROW
BEGIN
	SET NEW.session_id = CONCAT('SS_', LPAD((SELECT COUNT(*) + 1 FROM Sessions), 4, '0'));
END$$

CREATE TRIGGER before_sighting_insert
BEFORE INSERT ON `Sightings`
FOR EACH ROW
BEGIN
	SET NEW.sighting_id = CONCAT('SI_', LPAD((SELECT COUNT(*) + 1 FROM Sightings), 4, '0'));
END$$

DELIMITER ;