-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bookstore
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bookstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bookstore` DEFAULT CHARACTER SET utf8 ;
USE `bookstore` ;

-- -----------------------------------------------------
-- Table `bookstore`.`Books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Books` (
  `ISBN` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `category` VARCHAR(45) NOT NULL,
  `author` VARCHAR(45) NOT NULL,
  `edition` INT NOT NULL DEFAULT 0,
  `publisher` VARCHAR(45) NOT NULL,
  `publishYear` INT NOT NULL,
  `quantityInStock` INT NOT NULL,
  `rating` INT NOT NULL DEFAULT 0,
  `price` INT NOT NULL,
  PRIMARY KEY (`ISBN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`User` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `verfiedEmail` TINYINT NOT NULL,
  PRIMARY KEY (`userID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Customers` (
  `cartID` INT NOT NULL,
  `status` ENUM('Active', 'Inactive', 'Suspended') NOT NULL,
  `isSubscribed` TINYINT NOT NULL,
  `userID` INT NOT NULL,
  INDEX `fk_Customers_User1_idx` (`userID` ASC),
  PRIMARY KEY (`userID`),
  CONSTRAINT `fk_Customers_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `bookstore`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`PaymentCards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`PaymentCards` (
  `cardNumber` INT NOT NULL,
  `customerID` INT NOT NULL,
  `expirationDate` VARCHAR(45) NOT NULL,
  `cardType` ENUM('AmericanExpress', 'MasterCard', 'Visa') NOT NULL,
  PRIMARY KEY (`cardNumber`, `customerID`),
  INDEX `fk_PaymentCards_Customers1_idx` (`customerID` ASC) VISIBLE,
  CONSTRAINT `fk_PaymentCards_Customers1`
    FOREIGN KEY (`customerID`)
    REFERENCES `bookstore`.`Customers` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Orders` (
  `orderID` INT NOT NULL AUTO_INCREMENT,
  `datePlaced` VARCHAR(45) NOT NULL,
  `customerID` INT NOT NULL,
  `cardUsed` INT NOT NULL,
  `orderStatus` ENUM('Revieved', 'Arrived', 'Shipped') NOT NULL,
  `confirmationNumber` INT NOT NULL,
  `total` INT NOT NULL,
  `addressID` INT NOT NULL,
  PRIMARY KEY (`orderID`),
  INDEX `fk_Orders_Customers1_idx` (`customerID` ASC) VISIBLE,
  INDEX `fk_Orders_PaymentCards1_idx` (`cardUsed` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Customers1`
    FOREIGN KEY (`customerID`)
    REFERENCES `bookstore`.`Customers` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_PaymentCards1`
    FOREIGN KEY (`cardUsed`)
    REFERENCES `bookstore`.`PaymentCards` (`cardNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`BooksForOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`BooksForOrder` (
  `orderID` INT NOT NULL,
  `ISBN` INT NOT NULL,
  PRIMARY KEY (`orderID`, `ISBN`),
  INDEX `fk_BooksForOrder_Books_idx` (`ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_BooksForOrder_Books`
    FOREIGN KEY (`ISBN`)
    REFERENCES `bookstore`.`Books` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BooksForOrder_Orders1`
    FOREIGN KEY (`orderID`)
    REFERENCES `bookstore`.`Orders` (`orderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`Addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Addresses` (
  `addressID` INT NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipCode` INT NOT NULL,
  `customerID` INT NOT NULL,
  PRIMARY KEY (`addressID`),
  INDEX `fk_Addresses_User1_idx` (`customerID` ASC) VISIBLE,
  CONSTRAINT `fk_Addresses_User1`
    FOREIGN KEY (`customerID`)
    REFERENCES `bookstore`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`BooksInCart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`BooksInCart` (
  `cartID` INT NOT NULL,
  `ISBN` INT NOT NULL,
  PRIMARY KEY (`cartID`, `ISBN`),
  INDEX `fk_BooksInCart_Books1_idx` (`ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_BooksInCart_Books1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `bookstore`.`Books` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BooksInCart_Customers1`
    FOREIGN KEY (`cartID`)
    REFERENCES `bookstore`.`Customers` (`cartID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`Admins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Admins` (
  `userID` INT NOT NULL,
  PRIMARY KEY (`userID`),
  CONSTRAINT `fk_Admins_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `bookstore`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`permissionsForAdmins`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`permissionsForAdmins` (
  `userID` INT NOT NULL,
  `permission` ENUM('manageBooks', 'manageUsers', 'managePromotions') NOT NULL,
  PRIMARY KEY (`userID`),
  CONSTRAINT `fk_permissionsForAdmins_Admins1`
    FOREIGN KEY (`userID`)
    REFERENCES `bookstore`.`Admins` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`Promotions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`Promotions` (
  `promoCode` VARCHAR(45) NOT NULL,
  `startDate` VARCHAR(45) NOT NULL,
  `expires` VARCHAR(45) NOT NULL,
  `percentage` INT NOT NULL,
  PRIMARY KEY (`promoCode`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
