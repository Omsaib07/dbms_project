-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 14, 2024 at 06:56 AM
-- Server version: 8.0.35
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medical`
--
CREATE DATABASE IF NOT EXISTS `medical` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `medical`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `upsert_medicine`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `upsert_medicine` (IN `med_name` VARCHAR(500), IN `new_quantity` INT)   BEGIN
    DECLARE existing_id INT;

    -- Check if the medicine exists
    SELECT id INTO existing_id
    FROM Medicines
    WHERE name = med_name;

    -- If it exists, update the quantity; if not, insert a new row
    IF existing_id IS NOT NULL THEN
        UPDATE Medicines
        SET amount = amount + new_quantity
        WHERE id = existing_id;
    ELSE
        INSERT INTO Medicines (name, amount)
        VALUES (med_name, new_quantity);
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addmp`
--

DROP TABLE IF EXISTS `addmp`;
CREATE TABLE IF NOT EXISTS `addmp` (
  `sno` int NOT NULL AUTO_INCREMENT,
  `medicine` varchar(500) NOT NULL,
  `quantity` int DEFAULT '0',
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `addmp`
--

TRUNCATE TABLE `addmp`;
--
-- Dumping data for table `addmp`
--

INSERT DELAYED IGNORE INTO `addmp` (`sno`, `medicine`, `quantity`) VALUES
(1, 'Dolo 650', 0),
(2, 'Carpel 250 mg', 0),
(3, 'Azythromycin 500', 0),
(4, 'Azythromycin 250', 0),
(5, 'Rantac 300', 0),
(6, 'Omez', 0),
(7, 'Okacet', 0),
(8, 'Paracetomol', 0);

-- --------------------------------------------------------

--
-- Table structure for table `addpd`
--

DROP TABLE IF EXISTS `addpd`;
CREATE TABLE IF NOT EXISTS `addpd` (
  `sno` int NOT NULL AUTO_INCREMENT,
  `product` varchar(200) NOT NULL,
  `quantity` int DEFAULT '0',
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `addpd`
--

TRUNCATE TABLE `addpd`;
--
-- Dumping data for table `addpd`
--

INSERT DELAYED IGNORE INTO `addpd` (`sno`, `product`, `quantity`) VALUES
(1, 'colgate', 0),
(2, 'perfume', 0),
(3, 'garnier face wash', 0),
(4, 'garnier face wash', 0);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mid` int NOT NULL,
  `action` varchar(500) NOT NULL,
  `date` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `logs`
--

TRUNCATE TABLE `logs`;
--
-- Dumping data for table `logs`
--

INSERT DELAYED IGNORE INTO `logs` (`id`, `mid`, `action`, `date`) VALUES
(1, 1001, ' INSERTED', '2023-01-24 12:54:41'),
(2, 1001, ' DELETED', '2023-01-24 12:57:48');

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

DROP TABLE IF EXISTS `medicines`;
CREATE TABLE IF NOT EXISTS `medicines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `amount` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `medicines` varchar(500) NOT NULL,
  `products` varchar(500) NOT NULL,
  `email` varchar(50) NOT NULL,
  `mid` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'pending',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `medicines`
--

TRUNCATE TABLE `medicines`;
--
-- Triggers `medicines`
--
DROP TRIGGER IF EXISTS `Delete`;
DELIMITER $$
CREATE TRIGGER `Delete` BEFORE DELETE ON `medicines` FOR EACH ROW INSERT INTO Logs VALUES(null,OLD.mid,' DELETED',NOW())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `Insert`;
DELIMITER $$
CREATE TRIGGER `Insert` AFTER INSERT ON `medicines` FOR EACH ROW INSERT INTO Logs VALUES(null,NEW.mid,' INSERTED',NOW())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `Update`;
DELIMITER $$
CREATE TRIGGER `Update` AFTER UPDATE ON `medicines` FOR EACH ROW INSERT INTO Logs VALUES(null,NEW.mid,' UPDATED',NOW())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `check_negative_quantity`;
DELIMITER $$
CREATE TRIGGER `check_negative_quantity` BEFORE INSERT ON `medicines` FOR EACH ROW BEGIN
    IF NEW.mid < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Negative values cannot be inserted into the quantity column.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `mid` int NOT NULL AUTO_INCREMENT,
  `medical_name` varchar(100) NOT NULL,
  `owner_name` varchar(100) NOT NULL,
  `phone_no` varchar(20) NOT NULL,
  `address` varchar(50) NOT NULL,
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `posts`
--

TRUNCATE TABLE `posts`;
--
-- Dumping data for table `posts`
--

INSERT DELAYED IGNORE INTO `posts` (`mid`, `medical_name`, `owner_name`, `phone_no`, `address`) VALUES
(1001, 'ARK PROCODER MEDICAL', 'ANEES', '7896541230', 'Bangalore');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
CREATE TABLE IF NOT EXISTS `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Truncate table before insert `Users`
--

ALTER TABLE posts ADD COLUMN user_id INT NOT NULL;

-- If you want to set up a foreign key relationship with the `Users` table:
ALTER TABLE posts ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Users(id);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
