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
-- Table structure for table `countryregioncurrency`
--

DROP TABLE IF EXISTS `countryregioncurrency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countryregioncurrency` (
  `CountryRegionCode` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ISO code for countries and regions. Foreign key to CountryRegion.CountryRegionCode.',
  `CurrencyCode` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ISO standard currency code. Foreign key to Currency.CurrencyCode.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`CountryRegionCode`,`CurrencyCode`),
  KEY `IX_CountryRegionCurrency_CurrencyCode` (`CurrencyCode`),
  CONSTRAINT `FK_CountryRegionCurrency_CountryRegion_CountryRegionCode` FOREIGN KEY (`CountryRegionCode`) REFERENCES `countryregion` (`CountryRegionCode`),
  CONSTRAINT `FK_CountryRegionCurrency_Currency_CurrencyCode` FOREIGN KEY (`CurrencyCode`) REFERENCES `currency` (`CurrencyCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cross-reference table mapping ISO currency codes to a country or region.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countryregioncurrency`
--

LOCK TABLES `countryregioncurrency` WRITE;
/*!40000 ALTER TABLE `countryregioncurrency` DISABLE KEYS */;
INSERT INTO `countryregioncurrency` VALUES ('AE','AED','2008-03-11 13:17:22'),('AR','ARS','2008-03-11 13:17:22'),('AT','ATS','2008-03-11 13:17:22'),('AT','EUR','2002-06-01 04:00:00'),('AU','AUD','2008-03-11 13:17:22'),('BB','BBD','2008-03-11 13:17:22'),('BD','BDT','2008-03-11 13:17:22'),('BE','BEF','2008-03-11 13:17:22'),('BE','EUR','2002-06-01 04:00:00'),('BG','BGN','2008-03-11 13:17:22'),('BH','BHD','2008-03-11 13:17:22'),('BN','BND','2008-03-11 13:17:22'),('BO','BOB','2008-03-11 13:17:22'),('BR','BRL','2008-03-11 13:17:22'),('BS','BSD','2008-03-11 13:17:22'),('BT','BTN','2008-03-11 13:17:22'),('CA','CAD','2008-03-11 13:17:22'),('CH','CHF','2008-03-11 13:17:22'),('CL','CLP','2008-03-11 13:17:22'),('CN','CNY','2008-03-11 13:17:22'),('CO','COP','2008-03-11 13:17:22'),('CR','CRC','2008-03-11 13:17:22'),('CY','CYP','2008-03-11 13:17:22'),('CZ','CZK','2008-03-11 13:17:22'),('DE','DEM','2008-03-11 13:17:22'),('DE','EUR','2008-03-11 13:17:22'),('DK','DKK','2008-03-11 13:17:22'),('DO','DOP','2008-03-11 13:17:22'),('DZ','DZD','2008-03-11 13:17:22'),('EC','USD','2008-03-11 13:17:22'),('EE','EEK','2008-03-11 13:17:22'),('EG','EGP','2008-03-11 13:17:22'),('ES','ESP','2008-03-11 13:17:22'),('ES','EUR','2002-06-01 04:00:00'),('FI','EUR','2002-06-01 04:00:00'),('FI','FIM','2008-03-11 13:17:22'),('FJ','FJD','2008-03-11 13:17:22'),('FR','EUR','2008-03-11 13:17:22'),('FR','FRF','2008-03-11 13:17:22'),('GB','GBP','2008-03-11 13:17:22'),('GH','GHC','2008-03-11 13:17:22'),('GR','EUR','2002-06-01 04:00:00'),('GR','GRD','2008-03-11 13:17:22'),('GT','GTQ','2008-03-11 13:17:22'),('HK','HKD','2008-03-11 13:17:22'),('HR','HRK','2008-03-11 13:17:22'),('HU','HUF','2008-03-11 13:17:22'),('ID','IDR','2008-03-11 13:17:22'),('IE','EUR','2002-06-01 04:00:00'),('IE','IEP','2008-03-11 13:17:22'),('IL','ILS','2008-03-11 13:17:22'),('IN','INR','2008-03-11 13:17:22'),('IS','ISK','2008-03-11 13:17:22'),('IT','EUR','2002-06-01 04:00:00'),('IT','ITL','2008-03-11 13:17:22'),('JM','JMD','2008-03-11 13:17:22'),('JO','JOD','2008-03-11 13:17:22'),('JP','JPY','2008-03-11 13:17:22'),('KE','KES','2008-03-11 13:17:22'),('KR','KRW','2008-03-11 13:17:22'),('KW','KWD','2008-03-11 13:17:22'),('LB','LBP','2008-03-11 13:17:22'),('LK','LKR','2008-03-11 13:17:22'),('LT','LTL','2008-03-11 13:17:22'),('LU','EUR','2002-06-01 04:00:00'),('LV','LVL','2008-03-11 13:17:22'),('MA','MAD','2008-03-11 13:17:22'),('MT','MTL','2008-03-11 13:17:22'),('MU','MUR','2008-03-11 13:17:22'),('MV','MVR','2008-03-11 13:17:22'),('MX','MXN','2008-03-11 13:17:22'),('MY','MYR','2008-03-11 13:17:22'),('NA','NAD','2008-03-11 13:17:22'),('NG','NGN','2008-03-11 13:17:22'),('NL','EUR','2002-06-01 04:00:00'),('NL','NLG','2008-03-11 13:17:22'),('NO','NOK','2008-03-11 13:17:22'),('NP','NPR','2008-03-11 13:17:22'),('NZ','NZD','2008-03-11 13:17:22'),('OM','OMR','2008-03-11 13:17:22'),('PA','PAB','2008-03-11 13:17:22'),('PE','PEN','2008-03-11 13:17:22'),('PH','PHP','2008-03-11 13:17:22'),('PK','PKR','2008-03-11 13:17:22'),('PL','PLN','2008-03-11 13:17:22'),('PL','PLZ','2008-03-11 13:17:22'),('PT','EUR','2002-06-01 04:00:00'),('PT','PTE','2008-03-11 13:17:22'),('PY','PYG','2008-03-11 13:17:22'),('RO','ROL','2008-03-11 13:17:22'),('RU','RUB','2008-03-11 13:17:22'),('RU','RUR','2008-03-11 13:17:22'),('SA','SAR','2008-03-11 13:17:22'),('SE','SEK','2008-03-11 13:17:22'),('SG','SGD','2008-03-11 13:17:22'),('SI','SIT','2008-03-11 13:17:22'),('SK','SKK','2008-03-11 13:17:22'),('SV','SVC','2008-03-11 13:17:22'),('TH','THB','2008-03-11 13:17:22'),('TN','TND','2008-03-11 13:17:22'),('TR','TRL','2008-03-11 13:17:22'),('TT','TTD','2008-03-11 13:17:22'),('TW','TWD','2008-03-11 13:17:22'),('US','USD','2008-03-11 13:17:22'),('UY','UYU','2008-03-11 13:17:22'),('VE','VEB','2008-03-11 13:17:22'),('VN','VND','2008-03-11 13:17:22'),('ZA','ZAR','2008-03-11 13:17:22'),('ZW','ZWD','2008-03-11 13:17:22');
/*!40000 ALTER TABLE `countryregioncurrency` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:07
