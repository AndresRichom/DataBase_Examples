-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: adventureworks2008r2
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `LocationID` smallint NOT NULL COMMENT 'Primary key for Location records.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Location description.',
  `CostRate` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT 'Standard hourly cost of the manufacturing location.',
  `Availability` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Work capacity (in hours) of the manufacturing location.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`LocationID`),
  UNIQUE KEY `AK_Location_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Product inventory and manufacturing locations.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'Tool Crib',0.0000,0.00,'2002-06-01 04:00:00'),(2,'Sheet Metal Racks',0.0000,0.00,'2002-06-01 04:00:00'),(3,'Paint Shop',0.0000,0.00,'2002-06-01 04:00:00'),(4,'Paint Storage',0.0000,0.00,'2002-06-01 04:00:00'),(5,'Metal Storage',0.0000,0.00,'2002-06-01 04:00:00'),(6,'Miscellaneous Storage',0.0000,0.00,'2002-06-01 04:00:00'),(7,'Finished Goods Storage',0.0000,0.00,'2002-06-01 04:00:00'),(10,'Frame Forming',22.5000,96.00,'2002-06-01 04:00:00'),(20,'Frame Welding',25.0000,108.00,'2002-06-01 04:00:00'),(30,'Debur and Polish',14.5000,120.00,'2002-06-01 04:00:00'),(40,'Paint',15.7500,120.00,'2002-06-01 04:00:00'),(45,'Specialized Paint',18.0000,80.00,'2002-06-01 04:00:00'),(50,'Subassembly',12.2500,120.00,'2002-06-01 04:00:00'),(60,'Final Assembly',12.2500,120.00,'2002-06-01 04:00:00');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:06
