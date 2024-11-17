CREATE DATABASE  IF NOT EXISTS `dreamhome`;
USE `dreamhome`;


-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
-- 
-- Host: localhost    Database: dreamhome
-- ------------------------------------------------------ 
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
-- 
-- Table structure for table `Branch`
-- 

DROP TABLE IF EXISTS `Branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Branch` (
  `branchNo` char(4) NOT NULL,
  `street` varchar(25) NOT NULL,
  `city` varchar(15) NOT NULL,
  `postcode` varchar(8) NOT NULL,
  PRIMARY KEY (`branchNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `Branch`
-- 

LOCK TABLES `Branch` WRITE;
/*!40000 ALTER TABLE `Branch` DISABLE KEYS */;
INSERT INTO `Branch` VALUES ('B002','56 Clover Dr','London','NW10 6EU'),('B003','163 Main St','Glasgow','G11 9QX'),('B004','32 Manse Rd','Bristol','BS99 1NZ'),('B005','22 Deer Rd','London','SW1 4EH'),('B007','16 Argyll St','Aberdeen','AB2 3SU');
/*!40000 ALTER TABLE `Branch` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `Client`
-- 

DROP TABLE IF EXISTS `Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Client` (
  `clientNo` varchar(7) NOT NULL,
  `fName` varchar(15) NOT NULL,
  `lName` varchar(15) NOT NULL,
  `telNo` varchar(13) NOT NULL,
  `prefType` varchar(10) NOT NULL,
  `maxRent` decimal(5,1) NOT NULL,
  PRIMARY KEY (`clientNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `Client`
-- 

LOCK TABLES `Client` WRITE;
/*!40000 ALTER TABLE `Client` DISABLE KEYS */;
INSERT INTO `Client` VALUES ('CR56','Aline','Stewart','0141-848-1825','Flat',350.0),('CR62','Mary','Tregar','01224-196720','Flat',600.0),('CR74','Mike','Ritchie','01475-392178','House',750.0),('CR76','John','Kay','0207-774-5632','Flat',425.0);
/*!40000 ALTER TABLE `Client` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `PrivateOwner`
-- 

DROP TABLE IF EXISTS `PrivateOwner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PrivateOwner` (
  `ownerNo` varchar(7) NOT NULL,
  `fName` varchar(15) NOT NULL,
  `lName` varchar(15) NOT NULL,
  `address` varchar(50) NOT NULL,
  `telNo` varchar(13) NOT NULL,
  PRIMARY KEY (`ownerNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `PrivateOwner`
-- 

LOCK TABLES `PrivateOwner` WRITE;
/*!40000 ALTER TABLE `PrivateOwner` DISABLE KEYS */;
INSERT INTO `PrivateOwner` VALUES ('CO40','Tina','Murphy','63 Well St, Glasgow G42','0141-943-1728'),('CO46','Joe','Keogh','2 Fergus Dr, Aberdeen AB2 7SX','01224-861212'),('CO87','Carol','Farrel','6 Achray St, Glasgow G32 9DX','0141-357-7419'),('CO93','Tony','Shaw','12 Park Pl, Glasgow G4 0QR','0141-225-7025');
/*!40000 ALTER TABLE `PrivateOwner` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `PropertyForRent`
-- 

DROP TABLE IF EXISTS `PropertyForRent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PropertyForRent` (
  `propertyNo` varchar(8) NOT NULL,
  `street` varchar(25) NOT NULL,
  `city` varchar(15) NOT NULL,
  `postcode` varchar(8) NOT NULL,
  `type` varchar(10) NOT NULL,
  `rooms` smallint(6) NOT NULL,
  `rent` decimal(5,1) NOT NULL,
  `ownerNo` varchar(7) NOT NULL,
  `staffNo` varchar(5) DEFAULT NULL,
  `branchNo` char(4) NOT NULL,
  PRIMARY KEY (`propertyNo`),
  KEY `Property_Owner_FK` (`ownerNo`),
  KEY `Property_Staff_FK` (`staffNo`),
  KEY `Property_Branch_FK` (`branchNo`),
  CONSTRAINT `Property_Branch_FK` FOREIGN KEY (`branchNo`) REFERENCES `Branch` (`branchNo`),
  CONSTRAINT `Property_Owner_FK` FOREIGN KEY (`ownerNo`) REFERENCES `PrivateOwner` (`ownerNo`),
  CONSTRAINT `Property_Staff_FK` FOREIGN KEY (`staffNo`) REFERENCES `Staff` (`staffNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `PropertyForRent`
-- 

LOCK TABLES `PropertyForRent` WRITE;
/*!40000 ALTER TABLE `PropertyForRent` DISABLE KEYS */;
INSERT INTO `PropertyForRent` VALUES ('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650.0,'CO46','SA9','B007'),('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450.0,'CO93','SG14','B003'),('PG21','18 Dale Rd','Glasgow','G12','House',5,600.0,'CO87','SG37','B003'),('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375.0,'CO93','SG37','B003'),('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350.0,'CO40',NULL,'B003'),('PL94','6 Argyll St','London','NW2','Flat',4,400.0,'CO87','SL41','B005');
/*!40000 ALTER TABLE `PropertyForRent` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `Registration`
-- 

DROP TABLE IF EXISTS `Registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Registration` (
  `clientNo` varchar(7) NOT NULL,
  `branchNo` char(4) NOT NULL,
  `staffNo` varchar(5) NOT NULL,
  `dateJoined` date NOT NULL,
  PRIMARY KEY (`clientNo`,`branchNo`),
  KEY `Regist_Branch_FK` (`branchNo`),
  KEY `Regist_Staff_FK` (`staffNo`),
  CONSTRAINT `Regist_Branch_FK` FOREIGN KEY (`branchNo`) REFERENCES `Branch` (`branchNo`),
  CONSTRAINT `Regist_Client_FK` FOREIGN KEY (`clientNo`) REFERENCES `Client` (`clientNo`),
  CONSTRAINT `Regist_Staff_FK` FOREIGN KEY (`staffNo`) REFERENCES `Staff` (`staffNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `Registration`
-- 

LOCK TABLES `Registration` WRITE;
/*!40000 ALTER TABLE `Registration` DISABLE KEYS */;
INSERT INTO `Registration` VALUES ('CR56','B003','SG37','2000-04-11'),('CR62','B007','SA9','2000-03-07'),('CR74','B003','SG37','1999-11-16'),('CR76','B005','SL41','2001-01-02');
/*!40000 ALTER TABLE `Registration` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `Staff`
-- 

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Staff` (
  `staffNo` varchar(5) NOT NULL,
  `fName` varchar(15) NOT NULL,
  `lName` varchar(15) NOT NULL,
  `position` varchar(10) NOT NULL,
  `sex` char(4) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `salary` decimal(9,2) NOT NULL,
  `branchNo` char(4) NOT NULL,
  PRIMARY KEY (`staffNo`),
  KEY `Staff_Branch_FK` (`branchNo`),
  CONSTRAINT `Staff_Branch_FK` FOREIGN KEY (`branchNo`) REFERENCES `Branch` (`branchNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `Staff`
-- 

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES ('SA9','Mary','Howe','Assistant','F','1970-02-19',9000.00,'B007'),('SG14','David','Ford','Supervisor','M','1958-11-24',18000.00,'B003'),('SG37','Ann','Beech','Assistant','F','1960-10-11',12000.00,'B003'),('SG5','Susan','Brand','Manager','F','1940-06-03',24000.00,'B003'),('SL21','John','White','Manager','M','1945-10-01',30000.00,'B005'),('SL41','Julie','Lee','Assistant','F','1965-06-13',9000.00,'B005');
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;

-- 
-- Table structure for table `Viewing`
-- 

DROP TABLE IF EXISTS `Viewing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Viewing` (
  `clientNo` varchar(7) NOT NULL,
  `propertyNo` varchar(8) NOT NULL,
  `viewDate` date NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`propertyNo`,`clientNo`),
  KEY `Viewing_Client_FK` (`clientNo`),
  CONSTRAINT `Viewing_Client_FK` FOREIGN KEY (`clientNo`) REFERENCES `Client` (`clientNo`),
  CONSTRAINT `Viewing_Propty_FK` FOREIGN KEY (`propertyNo`) REFERENCES `PropertyForRent` (`propertyNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- 
-- Dumping data for table `Viewing`
-- 

LOCK TABLES `Viewing` WRITE;
/*!40000 ALTER TABLE `Viewing` DISABLE KEYS */;
INSERT INTO `Viewing` VALUES ('CR56','PA14','2001-05-24','too small'),('CR62','PA14','2001-05-14','no dining room'),('CR56','PG36','2001-04-28',NULL),('CR56','PG4','2001-05-26',NULL),('CR76','PG4','2001-04-20','too --ote');
/*!40000 ALTER TABLE `Viewing` ENABLE KEYS */;

UNLOCK TABLES;

-- 
-- Dumping events for database 'dreamhome'
-- 

-- 
-- Dumping routines for database 'dreamhome'
-- 
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-23 17:45:28
