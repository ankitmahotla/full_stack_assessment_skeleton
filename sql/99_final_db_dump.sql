USE home_db;
SET PERSIST local_infile = 1;

CREATE TABLE `user` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) UNIQUE NOT NULL,
  `email` VARCHAR(100) UNIQUE NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `home` (
  `home_id` INT AUTO_INCREMENT PRIMARY KEY,
  `street_address` VARCHAR(255) UNIQUE NOT NULL,
  `state` VARCHAR(50) NOT NULL,
  `zip` VARCHAR(10) NOT NULL,
  `sqft` FLOAT NOT NULL,
  `beds` INT NOT NULL,
  `baths` INT NOT NULL,
  `list_price` FLOAT NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `user_home_interest` (
  `user_id` INT,
  `home_id` INT,
  PRIMARY KEY (`user_id`, `home_id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  FOREIGN KEY (`home_id`) REFERENCES `home` (`home_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Migrate data to the new structure

INSERT IGNORE INTO `user` (username, email)
SELECT DISTINCT username, email
FROM user_home;

INSERT IGNORE INTO `home` (street_address, state, zip, sqft, beds, baths, list_price)
SELECT DISTINCT street_address, state, zip, sqft, beds, baths, list_price
FROM user_home;

INSERT INTO user_home_interest (user_id, home_id)
SELECT DISTINCT u.user_id, h.home_id
FROM user_home uh
JOIN `user` u ON uh.username = u.username
JOIN home h ON uh.street_address = h.street_address;

-- Drop the original user_home table
DROP TABLE IF EXISTS user_home;