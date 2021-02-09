-- MySQL Script generated by MySQL Workbench
-- Fri Jan 15 13:37:01 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema staem
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `staem` ;

-- -----------------------------------------------------
-- Schema staem
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `staem` DEFAULT CHARACTER SET utf8 ;
USE `staem` ;

-- -----------------------------------------------------
-- Table `staem`.`Statuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Statuses` ;

CREATE TABLE IF NOT EXISTS `staem`.`Statuses` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Status_name` VARCHAR(50) NOT NULL,
  `Status_description` VARCHAR(255) NULL,
  `Status_price_multiplier` DECIMAL(5,3) NOT NULL DEFAULT 1.0,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Developers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Developers` ;

CREATE TABLE IF NOT EXISTS `staem`.`Developers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Developer_name` VARCHAR(50) NOT NULL,
  `Developer_contact` VARCHAR(50) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Games`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Games` ;

CREATE TABLE IF NOT EXISTS `staem`.`Games` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Game_name` VARCHAR(50) NULL DEFAULT 'GameName',
  `Game_description` VARCHAR(255) NULL DEFAULT 'GameDescription',
  `Game_quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `Game_price` DECIMAL(6,2) UNSIGNED NOT NULL,
  `Status_id` INT NULL,
  `Developer_id` INT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_status_id_idx` (`Status_id` ASC) VISIBLE,
  INDEX `fk_developer_id_idx` (`Developer_id` ASC) VISIBLE,
  CONSTRAINT `fk_status_id`
    FOREIGN KEY (`Status_id`)
    REFERENCES `staem`.`Statuses` (`ID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_developer_id`
    FOREIGN KEY (`Developer_id`)
    REFERENCES `staem`.`Developers` (`ID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Suppliers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Suppliers` ;

CREATE TABLE IF NOT EXISTS `staem`.`Suppliers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Supplier_name` VARCHAR(50) NOT NULL,
  `Supplier_address` VARCHAR(255) NULL,
  `Supplier_contact` VARCHAR(50) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Orders` ;

CREATE TABLE IF NOT EXISTS `staem`.`Orders` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Order_quantity` INT UNSIGNED NOT NULL,
  `Game_id` INT NOT NULL,
  `Supplier_id` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `Game_id_idx` (`Game_id` ASC) VISIBLE,
  INDEX `Supplier_id_idx` (`Supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_gamea_id`
    FOREIGN KEY (`Game_id`)
    REFERENCES `staem`.`Games` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_supplier_id`
    FOREIGN KEY (`Supplier_id`)
    REFERENCES `staem`.`Suppliers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Customers` ;

CREATE TABLE IF NOT EXISTS `staem`.`Customers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Customer_name` VARCHAR(50) NOT NULL,
  `Customer_surname` VARCHAR(50) NOT NULL,
  `Customer_price_multiplier` DECIMAL(6,3) UNSIGNED NULL DEFAULT 1.0,
  `Customer_games_bought` INT UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staem`.`Reservations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staem`.`Reservations` ;

CREATE TABLE IF NOT EXISTS `staem`.`Reservations` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Reservation_date` DATE NOT NULL,
  `Customer_id` INT NOT NULL,
  `Game_id` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `Game_id_idx` (`Game_id` ASC) VISIBLE,
  INDEX `Customer_id_idx` (`Customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_game_id`
    FOREIGN KEY (`Game_id`)
    REFERENCES `staem`.`Games` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_id`
    FOREIGN KEY (`Customer_id`)
    REFERENCES `staem`.`Customers` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `staem` ;

-- -----------------------------------------------------
-- procedure GET_RESERVATIONS_ORDER_BY_DATE
-- -----------------------------------------------------

USE `staem`;
DROP procedure IF EXISTS `staem`.`GET_RESERVATIONS_ORDER_BY_DATE`;

DELIMITER $$
USE `staem`$$
CREATE PROCEDURE `GET_RESERVATIONS_ORDER_BY_DATE` ()
BEGIN
	SELECT r.reservation_date, c.customer_name, c.customer_surname, g.game_name, g.game_price FROM Reservations r
    JOIN Customers c ON r.customer_id = c.id
    JOIN Games g ON r.game_id = g.id
    ORDER BY r.reservation_date ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GET_RESERVATIONS_BY_SURNAME
-- -----------------------------------------------------

USE `staem`;
DROP procedure IF EXISTS `staem`.`GET_RESERVATIONS_BY_SURNAME`;

DELIMITER $$
USE `staem`$$
CREATE PROCEDURE `GET_RESERVATIONS_BY_SURNAME` (given_surname VARCHAR(50))
BEGIN
	SELECT r.reservation_date, c.customer_name, c.customer_surname, g.game_name, g.game_price FROM Reservations r
    JOIN Customers c ON r.customer_id = c.id
    JOIN Games g ON r.game_id = g.id
    WHERE c.customer_surname = given_surname
    ORDER BY r.reservation_date ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GET_RESERVATIONS_BY_DATE
-- -----------------------------------------------------

USE `staem`;
DROP procedure IF EXISTS `staem`.`GET_RESERVATIONS_BY_DATE`;

DELIMITER $$
USE `staem`$$
CREATE PROCEDURE `GET_RESERVATIONS_BY_DATE` (given_date DATE)
BEGIN
	SELECT r.reservation_date, c.customer_name, c.customer_surname, g.game_name, g.game_price FROM Reservations r
    JOIN Customers c ON r.customer_id = c.id
    JOIN Games g ON r.game_id = g.id
    WHERE r.reservation_date = given_date
    ORDER BY r.reservation_date ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GET_ORDERS
-- -----------------------------------------------------

USE `staem`;
DROP procedure IF EXISTS `staem`.`GET_ORDERS`;

DELIMITER $$
USE `staem`$$
CREATE PROCEDURE `GET_ORDERS` ()
BEGIN
	SELECT o.order_quantity, g.game_name, s.supplier_name FROM Orders o
	JOIN games g ON o.game_id = g.id
    JOIN suppliers s ON o.supplier_id = s.id;
END$$

DELIMITER ;
USE `staem`;

DELIMITER $$

USE `staem`$$
DROP TRIGGER IF EXISTS `staem`.`Orders_BEFORE_INSERT` $$
USE `staem`$$
CREATE DEFINER = CURRENT_USER TRIGGER `staem`.`Orders_BEFORE_INSERT` BEFORE INSERT ON `Orders` FOR EACH ROW
BEGIN
 DECLARE errorMessage VARCHAR(255);
    SET errorMessage = "Nieporawna ilość!";
                        
    IF new.order_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END$$


USE `staem`$$
DROP TRIGGER IF EXISTS `staem`.`Orders_BEFORE_UPDATE` $$
USE `staem`$$
CREATE DEFINER = CURRENT_USER TRIGGER `staem`.`Orders_BEFORE_UPDATE` BEFORE UPDATE ON `Orders` FOR EACH ROW
BEGIN
 DECLARE errorMessage VARCHAR(255);
    SET errorMessage = "Nieporawna ilość!";
                        
    IF new.order_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END$$


USE `staem`$$
DROP TRIGGER IF EXISTS `staem`.`Customers_BEFORE_UPDATE` $$
USE `staem`$$
CREATE DEFINER = CURRENT_USER TRIGGER `staem`.`Customers_BEFORE_UPDATE` BEFORE UPDATE ON `Customers` FOR EACH ROW
BEGIN
    SET new.customer_price_multiplier = 1.0 - new.customer_games_bought * 0.01;
	IF new.customer_price_multiplier < 0.7 THEN
		SET new.customer_price_multiplier = 0.7;
	END IF;
END$$


USE `staem`$$
DROP TRIGGER IF EXISTS `staem`.`Reservations_BEFORE_INSERT` $$
USE `staem`$$
CREATE DEFINER = CURRENT_USER TRIGGER `staem`.`Reservations_BEFORE_INSERT` BEFORE INSERT ON `Reservations` FOR EACH ROW
BEGIN
 DECLARE errorMessage VARCHAR(255);
    SET errorMessage = "Podana data jest niepoprawana!";
                        
    IF new.reservation_date < curdate() THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END$$


USE `staem`$$
DROP TRIGGER IF EXISTS `staem`.`Reservations_BEFORE_UPDATE` $$
USE `staem`$$
CREATE DEFINER = CURRENT_USER TRIGGER `staem`.`Reservations_BEFORE_UPDATE` BEFORE UPDATE ON `Reservations` FOR EACH ROW
BEGIN
 DECLARE errorMessage VARCHAR(255);
    SET errorMessage = "Podana data jest niepoprawana!";
                        
    IF new.reservation_date < curdate() THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END$$


DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS admin;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'admin' IDENTIFIED BY 'admin';

GRANT ALL ON TABLE `staem`.`Games` TO 'admin';
GRANT ALL ON TABLE `staem`.`Orders` TO 'admin';
GRANT ALL ON TABLE `staem`.`Suppliers` TO 'admin';
GRANT ALL ON TABLE `staem`.`Statuses` TO 'admin';
GRANT ALL ON TABLE `staem`.`Reservations` TO 'admin';
GRANT ALL ON TABLE `staem`.`Customers` TO 'admin';
GRANT ALL ON TABLE `staem`.`Developers` TO 'admin';
SET SQL_MODE = '';
DROP USER IF EXISTS manager;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'manager' IDENTIFIED BY 'manager';

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE `staem`.`Games` TO 'manager';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Orders` TO 'manager';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Suppliers` TO 'manager';
GRANT SELECT, UPDATE, DELETE, INSERT ON TABLE `staem`.`Statuses` TO 'manager';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Reservations` TO 'manager';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Customers` TO 'manager';
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Developers` TO 'manager';
SET SQL_MODE = '';
DROP USER IF EXISTS worker;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'worker' IDENTIFIED BY 'worker';

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE `staem`.`Games` TO 'worker';
GRANT SELECT ON TABLE `staem`.`Orders` TO 'worker';
GRANT SELECT ON TABLE `staem`.`Suppliers` TO 'worker';
GRANT SELECT ON TABLE `staem`.`Statuses` TO 'worker';
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE `staem`.`Reservations` TO 'worker';
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE `staem`.`Customers` TO 'worker';
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE `staem`.`Developers` TO 'worker';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `staem`.`Statuses`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (1, 'Normalny', 'Nic specjalnego', 1.0);
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (2, 'Przedpremiera', 'Zakup przed premierą', 1.5);
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (3, 'Promocja50', 'Promocja 50% taniej', 0.5);
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (4, 'Promocja30', 'Promocja 30% taniej', 0.7);
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (5, 'Promocja10', 'Promocja 10% tanej', 0.9);
INSERT INTO `staem`.`Statuses` (`ID`, `Status_name`, `Status_description`, `Status_price_multiplier`) VALUES (6, 'Niedostępny', 'Brak produktu', 0.0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Developers`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Developers` (`ID`, `Developer_name`, `Developer_contact`) VALUES (1, 'Bethesda', 'devone@mail.com');
INSERT INTO `staem`.`Developers` (`ID`, `Developer_name`, `Developer_contact`) VALUES (2, 'CD Project Red', 'cdpr@cdpr.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Games`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Games` (`ID`, `Game_name`, `Game_description`, `Game_quantity`, `Game_price`, `Status_id`, `Developer_id`) VALUES (1, 'The Elder Scrolls V: Skyrim', 'Skyrim description', 10, 49.99, 1, 1);
INSERT INTO `staem`.`Games` (`ID`, `Game_name`, `Game_description`, `Game_quantity`, `Game_price`, `Status_id`, `Developer_id`) VALUES (2, 'The Witcher', 'Witcher description', 20, 69.99, 3, 2);
INSERT INTO `staem`.`Games` (`ID`, `Game_name`, `Game_description`, `Game_quantity`, `Game_price`, `Status_id`, `Developer_id`) VALUES (3, 'Fallout 3', 'Fallout3 description', 5, 29.99, 4, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Suppliers`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Suppliers` (`ID`, `Supplier_name`, `Supplier_address`, `Supplier_contact`) VALUES (1, 'YourSupplier', 'Warszawa, ul. Długa 1', 'dostawca@mail.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Orders`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Orders` (`ID`, `Order_quantity`, `Game_id`, `Supplier_id`) VALUES (1, 100, 1, 1);
INSERT INTO `staem`.`Orders` (`ID`, `Order_quantity`, `Game_id`, `Supplier_id`) VALUES (2, 200, 2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Customers`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Customers` (`ID`, `Customer_name`, `Customer_surname`, `Customer_price_multiplier`, `Customer_games_bought`) VALUES (1, 'Zniżka', 'Pracownik', 0.9, 0);
INSERT INTO `staem`.`Customers` (`ID`, `Customer_name`, `Customer_surname`, `Customer_price_multiplier`, `Customer_games_bought`) VALUES (2, 'Jan', 'Kowalski', 1.0, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `staem`.`Reservations`
-- -----------------------------------------------------
START TRANSACTION;
USE `staem`;
INSERT INTO `staem`.`Reservations` (`ID`, `Reservation_date`, `Customer_id`, `Game_id`) VALUES (1, '2021.12.30', 1, 3);

COMMIT;
