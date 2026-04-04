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
-- Table structure for table `salestaxrate`
--

DROP TABLE IF EXISTS `salestaxrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salestaxrate` (
  `SalesTaxRateID` int NOT NULL COMMENT 'Primary key for SalesTaxRate records.',
  `StateProvinceID` int NOT NULL COMMENT 'State, province, or country/region the sales tax applies to.',
  `TaxType` tinyint unsigned NOT NULL COMMENT '1 = Tax applied to retail transactions, 2 = Tax applied to wholesale transactions, 3 = Tax applied to all sales (retail and wholesale) transactions.',
  `TaxRate` decimal(10,4) NOT NULL DEFAULT '0.0000' COMMENT 'Tax rate amount.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Tax rate description.',
  `rowguid` varchar(64) NOT NULL COMMENT 'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`SalesTaxRateID`),
  UNIQUE KEY `AK_SalesTaxRate_StateProvinceID_TaxType` (`StateProvinceID`,`TaxType`),
  UNIQUE KEY `AK_SalesTaxRate_rowguid` (`rowguid`),
  CONSTRAINT `FK_SalesTaxRate_StateProvince_StateProvinceID` FOREIGN KEY (`StateProvinceID`) REFERENCES `stateprovince` (`StateProvinceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tax rate lookup table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salestaxrate`
--

LOCK TABLES `salestaxrate` WRITE;
/*!40000 ALTER TABLE `salestaxrate` DISABLE KEYS */;
INSERT INTO `salestaxrate` VALUES (1,1,1,14.0000,'Canadian GST + Alberta Provincial Tax','683DE5DD-521A-47D4-A573-06A3CDB1BC5D','2002-06-01 04:00:00'),(2,57,1,14.2500,'Canadian GST + Ontario Provincial Tax','05C4FFDB-4F84-4CDF-ABE5-FDF3216EA74E','2002-06-01 04:00:00'),(3,63,1,14.2500,'Canadian GST + Quebec Provincial Tax','D4EDB557-56D7-403C-B538-4DF5E7302588','2002-06-01 04:00:00'),(4,1,2,7.0000,'Canadian GST','F0D76907-B433-453F-B95E-16FCE73B807A','2002-06-01 04:00:00'),(5,57,2,7.0000,'Canadian GST','7E0E97A2-878B-476F-A648-05A3DD4450ED','2002-06-01 04:00:00'),(6,63,2,7.0000,'Canadian GST','1E285D2C-8AF7-47AA-B06A-762CF4D93ACD','2002-06-01 04:00:00'),(7,7,3,7.0000,'Canadian GST','590CCB14-CB20-49BF-8FEE-E0C3ABC4C2B1','2002-06-01 04:00:00'),(8,29,3,7.0000,'Canadian GST','A8365F30-78B7-4DBE-8985-F8260560126B','2002-06-01 04:00:00'),(9,31,3,7.0000,'Canadian GST','F4FDE24B-7A53-4340-9D10-173E9424864A','2002-06-01 04:00:00'),(10,41,3,7.0000,'Canadian GST','383D465B-E1D1-492A-83F3-AB3E9CBF3282','2002-06-01 04:00:00'),(11,45,3,7.0000,'Canadian GST','8451909F-8A8D-4789-9F87-16A335D28053','2002-06-01 04:00:00'),(12,49,3,7.0000,'Canadian GST','FB7607EE-8F12-41EA-B461-10885C6F1533','2002-06-01 04:00:00'),(13,51,3,7.0000,'Canadian GST','06DF529D-EB11-446F-9570-9EE97B8EA1BF','2002-06-01 04:00:00'),(16,69,3,7.0000,'Canadian GST','89D447A8-239A-4F31-A529-478821E8F714','2002-06-01 04:00:00'),(17,83,3,7.0000,'Canadian GST','3847B431-F939-4E89-83FC-864912E3CFD2','2002-06-01 04:00:00'),(18,6,1,7.7500,'Arizona State Sales Tax','89DD0E3A-C018-449E-A86B-885ADF684C5C','2002-06-01 04:00:00'),(19,9,1,8.7500,'California State Sales Tax','90E3090E-DF71-407A-8059-04C3104523AF','2002-06-01 04:00:00'),(20,15,1,8.0000,'Florida State Sales Tax','630AE36F-6E76-4A1F-AB25-6342159C80D2','2002-06-01 04:00:00'),(21,30,1,7.0000,'Massachusetts State Sales Tax','207C7024-85FE-42CB-BF74-9FE88E2F4E1B','2002-06-01 04:00:00'),(22,35,1,7.2500,'Michigan State Sales Tax','F9D1A85D-6474-43B5-A7EA-BED59E00439A','2002-06-01 04:00:00'),(23,36,1,6.7500,'Minnesota State Sales Tax','1753D75F-8357-4497-BC92-543F17BBF514','2002-06-01 04:00:00'),(24,72,1,7.2500,'Tennessese State Sales Tax','ECBA1BAB-A7A6-4CC2-8D0F-C094A38E5C0E','2002-06-01 04:00:00'),(25,73,1,7.5000,'Texas State Sales Tax','D50102E1-0150-43F3-93AD-12AB6C1DEB06','2002-06-01 04:00:00'),(26,74,1,5.0000,'Utah State Sales Tax','5E6D8621-36AF-40CE-972B-61AAEF0556D8','2002-06-01 04:00:00'),(27,79,1,8.8000,'Washington State Sales Tax','9C84C0AF-41CD-4670-98BC-5026E188541F','2002-06-01 04:00:00'),(28,77,3,10.0000,'Taxable Supply','F53B6A7E-7DA4-49E8-AC09-D57FEFAC64D3','2002-06-01 04:00:00'),(29,20,3,16.0000,'Germany Output Tax','78C8A559-4D0F-45B6-B7A3-E11FF9A702F4','2002-06-01 04:00:00'),(30,84,3,19.6000,'France Output Tax','5446EA04-FA7C-4B02-A157-A05F44BF47B6','2002-06-01 04:00:00'),(31,14,3,17.5000,'United Kingdom Output Tax','ABD185A9-5367-44E1-8A6E-71D083943F3C','2002-06-01 04:00:00');
/*!40000 ALTER TABLE `salestaxrate` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:14
