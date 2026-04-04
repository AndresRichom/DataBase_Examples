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
-- Table structure for table `addresstype`
--

DROP TABLE IF EXISTS `addresstype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresstype` (
  `AddressTypeID` int NOT NULL COMMENT 'Primary key for AddressType records.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Address type description. For example, Billing, Home, or Shipping.',
  `rowguid` varchar(64) NOT NULL COMMENT 'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`AddressTypeID`),
  UNIQUE KEY `AK_AddressType_rowguid` (`rowguid`),
  UNIQUE KEY `AK_AddressType_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Types of addresses stored in the Address table. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresstype`
--

LOCK TABLES `addresstype` WRITE;
/*!40000 ALTER TABLE `addresstype` DISABLE KEYS */;
INSERT INTO `addresstype` VALUES (1,'Billing','B84F78B1-4EFE-4A0E-8CB7-70E9F112F886','2002-06-01 04:00:00'),(2,'Home','41BC2FF6-F0FC-475F-8EB9-CEC0805AA0F2','2002-06-01 04:00:00'),(3,'Main Office','8EEEC28C-07A2-4FB9-AD0A-42D4A0BBC575','2002-06-01 04:00:00'),(4,'Primary','24CB3088-4345-47C4-86C5-17B535133D1E','2002-06-01 04:00:00'),(5,'Shipping','B29DA3F8-19A3-47DA-9DAA-15C84F4A83A5','2002-06-01 04:00:00'),(6,'Archive','A67F238A-5BA2-444B-966C-0467ED9C427F','2002-06-01 04:00:00');
/*!40000 ALTER TABLE `addresstype` ENABLE KEYS */;
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
