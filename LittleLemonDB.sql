-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8mb3 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`staff` (
  `StaffID` INT NOT NULL,
  `StaffName` VARCHAR(45) NOT NULL,
  `StaffRole` VARCHAR(45) NOT NULL,
  `StaffAge` VARCHAR(45) NOT NULL,
  `StaffSalary` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`booking` (
  `BookingID` INT NOT NULL,
  `BookingDate` VARCHAR(45) NOT NULL,
  `TableNumber` VARCHAR(45) NOT NULL,
  `StaffID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_staff_id` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `fk_staff_id`
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`customer` (
  `CustomerID` INT NOT NULL,
  `CustomerName` VARCHAR(45) NOT NULL,
  `CustomerPhone` VARCHAR(45) NOT NULL,
  `CustomerEmail` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerEmail_UNIQUE` (`CustomerEmail` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`menuitem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menuitem` (
  `MenuItemID` INT NOT NULL,
  `CourseName` VARCHAR(45) NOT NULL,
  `StarterName` VARCHAR(45) NOT NULL,
  `DesertName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MenuItemID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menu` (
  `MenuID` INT NOT NULL,
  `MenuName` VARCHAR(45) NOT NULL,
  `MenuPrice` DECIMAL(10,0) NOT NULL,
  `MenuDescription` VARCHAR(45) NOT NULL,
  `MenuItemID` INT NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `fk_menuitem_id_idx` (`MenuItemID` ASC) VISIBLE,
  CONSTRAINT `fk_menuitem_id`
    FOREIGN KEY (`MenuItemID`)
    REFERENCES `littlelemondb`.`menuitem` (`MenuItemID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`order` (
  `OrderID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  `Quantity` VARCHAR(45) NOT NULL,
  `MenuID` INT NOT NULL,
  `TotalCost` DECIMAL(10,0) NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_staff_id_idx` (`StaffID` ASC) VISIBLE,
  INDEX `fk_menu_id_idx` (`MenuID` ASC) VISIBLE,
  INDEX `fk_booking_id_idx` (`BookingID` ASC) VISIBLE,
  INDEX `fk_order_customer_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_booking_id`
    FOREIGN KEY (`BookingID`)
    REFERENCES `littlelemondb`.`booking` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_id`
    FOREIGN KEY (`MenuID`)
    REFERENCES `littlelemondb`.`menu` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_staff_id`
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`delivery` (
  `DeliveryID` INT NOT NULL,
  `DeliveryDate` VARCHAR(45) NOT NULL,
  `DeliveryStatus` VARCHAR(45) NOT NULL,
  `OrderID` INT NOT NULL,
  PRIMARY KEY (`DeliveryID`),
  INDEX `fk_order_id_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondb`.`order` (`OrderID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `littlelemondb` ;

-- -----------------------------------------------------
-- Placeholder table for view `littlelemondb`.`ordersview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`ordersview` (`OrderID` INT, `Quantity` INT, `TotalCost` INT);

-- -----------------------------------------------------
-- View `littlelemondb`.`ordersview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `littlelemondb`.`ordersview`;
USE `littlelemondb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `littlelemondb`.`ordersview` AS select `littlelemondb`.`order`.`OrderID` AS `OrderID`,`littlelemondb`.`order`.`Quantity` AS `Quantity`,`littlelemondb`.`order`.`TotalCost` AS `TotalCost` from `littlelemondb`.`order` where (`littlelemondb`.`order`.`Quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
