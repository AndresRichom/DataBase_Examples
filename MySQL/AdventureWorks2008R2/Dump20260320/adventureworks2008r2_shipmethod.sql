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
-- Table structure for table `shipmethod`
--

DROP TABLE IF EXISTS `shipmethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipmethod` (
  `ShipMethodID` int NOT NULL COMMENT 'Primary key for ShipMethod records.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Shipping company name.',
  `ShipBase` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Minimum shipping charge.',
  `ShipRate` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Shipping charge per pound.',
  `rowguid` varchar(64) NOT NULL COMMENT 'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`ShipMethodID`),
  UNIQUE KEY `AK_ShipMethod_Name` (`Name`),
  UNIQUE KEY `AK_ShipMethod_rowguid` (`rowguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Shipping company lookup table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipmethod`
--

LOCK TABLES `shipmethod` WRITE;
/*!40000 ALTER TABLE `shipmethod` DISABLE KEYS */;
INSERT INTO `shipmethod` VALUES (1,'XRQ - TRUCK GROUND',3.9500,0.9900,'6BE756D9-D7BE-4463-8F2C-AE60C710D606','2002-06-01 04:00:00'),(2,'ZY - EXPRESS',9.9500,1.9900,'3455079B-F773-4DC6-8F1E-2A58649C4AB8','2002-06-01 04:00:00'),(3,'OVERSEAS - DELUXE',29.9500,2.9900,'22F4E461-28CF-4ACE-A980-F686CF112EC8','2002-06-01 04:00:00'),(4,'OVERNIGHT J-FAST',21.9500,1.2900,'107E8356-E7A8-463D-B60C-079FFF467F3F','2002-06-01 04:00:00'),(5,'CARGO TRANSPORT 5',8.9900,1.4900,'B166019A-B134-4E76-B957-2B0490C610ED','2002-06-01 04:00:00');
/*!40000 ALTER TABLE `shipmethod` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:01
