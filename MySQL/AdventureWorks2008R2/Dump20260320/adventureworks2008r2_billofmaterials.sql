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
-- Table structure for table `billofmaterials`
--

DROP TABLE IF EXISTS `billofmaterials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billofmaterials` (
  `BillOfMaterialsID` int NOT NULL COMMENT 'Primary key for BillOfMaterials records.',
  `ProductAssemblyID` int DEFAULT NULL COMMENT 'Parent product identification number. Foreign key to Product.ProductID.',
  `ComponentID` int NOT NULL COMMENT 'Component identification number. Foreign key to Product.ProductID.',
  `StartDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date the component started being used in the assembly item.',
  `EndDate` datetime(6) DEFAULT NULL COMMENT 'Date the component stopped being used in the assembly item.',
  `UnitMeasureCode` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Standard code identifying the unit of measure for the quantity.',
  `BOMLevel` smallint NOT NULL COMMENT 'Indicates the depth the component is from its parent (AssemblyID).',
  `PerAssemblyQty` decimal(8,2) NOT NULL DEFAULT '1.00' COMMENT 'Quantity of the component needed to create the assembly.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`BillOfMaterialsID`),
  UNIQUE KEY `AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate` (`ProductAssemblyID`,`ComponentID`,`StartDate`),
  KEY `IX_BillOfMaterials_UnitMeasureCode` (`UnitMeasureCode`),
  KEY `FK_BillOfMaterials_Product_ComponentID` (`ComponentID`),
  CONSTRAINT `FK_BillOfMaterials_Product_ComponentID` FOREIGN KEY (`ComponentID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `FK_BillOfMaterials_Product_ProductAssemblyID` FOREIGN KEY (`ProductAssemblyID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `FK_BillOfMaterials_UnitMeasure_UnitMeasureCode` FOREIGN KEY (`UnitMeasureCode`) REFERENCES `unitmeasure` (`UnitMeasureCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Items required to make bicycles and bicycle subassemblies. It identifies the heirarchical relationship between a parent product and its components.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billofmaterials`
--

LOCK TABLES `billofmaterials` WRITE;
/*!40000 ALTER TABLE `billofmaterials` DISABLE KEYS */;
/*!40000 ALTER TABLE `billofmaterials` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:24:57
