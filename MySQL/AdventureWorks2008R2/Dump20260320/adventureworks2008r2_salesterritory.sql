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
-- Table structure for table `salesterritory`
--

DROP TABLE IF EXISTS `salesterritory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesterritory` (
  `TerritoryID` int NOT NULL COMMENT 'Primary key for SalesTerritory records.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Sales territory description',
  `CountryRegionCode` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode. ',
  `Group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Geographic area to which the sales territory belong.',
  `SalesYTD` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Sales in the territory year to date.',
  `SalesLastYear` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Sales in the territory the previous year.',
  `CostYTD` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Business costs in the territory year to date.',
  `CostLastYear` decimal(19,4) NOT NULL DEFAULT '0.0000' COMMENT 'Business costs in the territory the previous year.',
  `rowguid` varchar(64) NOT NULL COMMENT 'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`TerritoryID`),
  UNIQUE KEY `AK_SalesTerritory_Name` (`Name`),
  UNIQUE KEY `AK_SalesTerritory_rowguid` (`rowguid`),
  KEY `FK_SalesTerritory_CountryRegion_CountryRegionCode` (`CountryRegionCode`),
  CONSTRAINT `FK_SalesTerritory_CountryRegion_CountryRegionCode` FOREIGN KEY (`CountryRegionCode`) REFERENCES `countryregion` (`CountryRegionCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Sales territory lookup table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesterritory`
--

LOCK TABLES `salesterritory` WRITE;
/*!40000 ALTER TABLE `salesterritory` DISABLE KEYS */;
INSERT INTO `salesterritory` VALUES (1,'Northwest','US','North America',7887186.7882,3298694.4938,0.0000,0.0000,'43689A10-E30B-497F-B0DE-11DE20267FF7','2002-06-01 04:00:00'),(2,'Northeast','US','North America',2402176.8476,3607148.9371,0.0000,0.0000,'00FB7309-96CC-49E2-8363-0A1BA72486F2','2002-06-01 04:00:00'),(3,'Central','US','North America',3072175.1180,3205014.0767,0.0000,0.0000,'DF6E7FD8-1A8D-468C-B103-ED8ADDB452C1','2002-06-01 04:00:00'),(4,'Southwest','US','North America',10510853.8739,5366575.7098,0.0000,0.0000,'DC3E9EA0-7950-4431-9428-99DBCBC33865','2002-06-01 04:00:00'),(5,'Southeast','US','North America',2538667.2515,3925071.4318,0.0000,0.0000,'6DC4165A-5E4C-42D2-809D-4344E0AC75E7','2002-06-01 04:00:00'),(6,'Canada','CA','North America',6771829.1376,5693988.8600,0.0000,0.0000,'06B4AF8A-1639-476E-9266-110461D66B00','2002-06-01 04:00:00'),(7,'France','FR','Europe',4772398.3078,2396539.7601,0.0000,0.0000,'BF806804-9B4C-4B07-9D19-706F2E689552','2002-06-01 04:00:00'),(8,'Germany','DE','Europe',3805202.3478,1307949.7917,0.0000,0.0000,'6D2450DB-8159-414F-A917-E73EE91C38A9','2002-06-01 04:00:00'),(9,'Australia','AU','Pacific',5977814.9154,2278548.9776,0.0000,0.0000,'602E612E-DFE9-41D9-B894-27E489747885','2002-06-01 04:00:00'),(10,'United Kingdom','GB','Europe',5012905.3656,1635823.3967,0.0000,0.0000,'05FC7E1F-2DEA-414E-9ECD-09D150516FB5','2002-06-01 04:00:00');
/*!40000 ALTER TABLE `salesterritory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:15
