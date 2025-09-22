-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db-capstore-booking
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db-capstore-booking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db-capstore-booking` DEFAULT CHARACTER SET utf8mb3 ;
USE `db-capstore-booking` ;

-- -----------------------------------------------------
-- Table `db-capstore-booking`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db-capstore-booking`.`customer` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Phone` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerEmail_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `db-capstore-booking`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db-capstore-booking`.`booking` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL,
  `BookingDate` DATETIME NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_customer_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `db-capstore-booking`.`customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb3;

USE `db-capstore-booking` ;

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `db-capstore-booking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking`(IN inBookingID INT,IN inBookingDate DATETIME,IN inTableNumber INT,IN inCustomerID INT)
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE isAvailable INT DEFAULT 0;

    SELECT COUNT(BookingID) INTO isAvailable
    FROM Booking
    WHERE TableNumber = inTableNumber AND BookingDate = inBookingDate;
    
    IF isAvailable > 0 THEN 
        SET msg = CONCAT('Booking wasnt added'); 
	ELSE
        INSERT INTO Booking (BookingID,BookingDate, TableNumber, CustomerID)
        VALUES (inBookingID,inBookingDate, inTableNumber, inCustomerID);

        IF ROW_COUNT() > 0 THEN
            SET msg = CONCAT('New booking added'); 
        ELSE
            SET msg = CONCAT('Booking wasnt added'); 
        END IF;
	END IF;
    SELECT msg AS 'Corfimation';

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

DELIMITER $$
USE `db-capstore-booking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddValidBooking`(IN inBookingDate DATETIME,IN inTableNumber INT)
BEGIN

    DECLARE msg VARCHAR(50);
    
    DECLARE isAvailable INT DEFAULT 0;
    SELECT COUNT(BookingID) INTO isAvailable
    FROM Booking
    WHERE TableNumber = inTableNumber AND BookingDate = inBookingDate;
    
    IF isAvailable > 0 THEN 
		SET msg = CONCAT('Table ', inTableNumber, ' is already booked - booking cancelled.');
	ELSE
		START TRANSACTION;
		INSERT INTO Booking (BookingDate, TableNumber, CustomerID)
		VALUES 
		(inBookingDate, inTableNumber, 1);

		IF ROW_COUNT() > 0 THEN
			COMMIT;
			SET msg = CONCAT('Table ', inTableNumber, ' was booked.'); 
		ELSE 
			ROLLBACK;
			SET msg = CONCAT('Table ', inTableNumber, ' is already booked - booking cancelled.');
		END IF;
	END IF;
    SELECT msg AS 'Booking status';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

DELIMITER $$
USE `db-capstore-booking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN inBookingID INT)
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE isExist INT DEFAULT 0;

    SELECT COUNT(BookingID) INTO isExist
    FROM Booking
    WHERE BookingID = inBookingID;
    
    IF isExist = 0 THEN 
        SET msg = CONCAT('Booking wasnt founded'); 
	ELSE
        DELETE FROM Booking 
        WHERE BookingID = inBookingID;
        IF ROW_COUNT() > 0 THEN
            SET msg = CONCAT('Booking ',inBookingID,' deleted'); 
        ELSE
            SET msg = CONCAT('Booking wasnt deleted'); 
        END IF;
	END IF;
    SELECT msg AS 'Corfimation';

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `db-capstore-booking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(IN inBookingDate DATETIME,IN inTableNumber INT)
BEGIN
    DECLARE isBooked INT DEFAULT 0;
    DECLARE msg VARCHAR(50);

    SELECT COUNT(BookingID) INTO isBooked 
    FROM Booking 
    WHERE TableNumber = inTableNumber AND BookingDate = inBookingDate;

    IF isBooked >0  THEN 
        SET msg = CONCAT('Table ', inTableNumber, ' is already booked.');
    ELSE 
        SET msg = CONCAT('Table ', inTableNumber, ' is available.');
    END IF;
    SELECT msg AS 'Booking Status';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `db-capstore-booking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(IN inBookingID INT,IN inBookingDate DATETIME)
BEGIN
    DECLARE msg VARCHAR(50);
    DECLARE isExist INT DEFAULT 0;

    SELECT COUNT(BookingID) INTO isExist
    FROM Booking
    WHERE BookingID = inBookingID;
    
    IF isExist = 0 THEN 
        SET msg = CONCAT('Booking wasnt founded'); 
	ELSE
        UPDATE Booking SET BookingDate = inBookingDate
        WHERE BookingID = inBookingID;
        IF ROW_COUNT() > 0 THEN
            SET msg = CONCAT('Booking ',inBookingID,' updated'); 
        ELSE
            SET msg = CONCAT('Booking wasnt updated'); 
        END IF;
	END IF;
    SELECT msg AS 'Corfimation';

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
