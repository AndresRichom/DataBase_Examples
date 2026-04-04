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
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `CurrencyCode` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'The ISO code for the Currency.',
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Currency name.',
  `ModifiedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date and time the record was last updated.',
  PRIMARY KEY (`CurrencyCode`),
  UNIQUE KEY `AK_Currency_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Lookup table containing standard ISO currencies.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES ('AED','Emirati Dirham','2002-06-01 04:00:00'),('AFA','Afghani','2002-06-01 04:00:00'),('ALL','Lek','2002-06-01 04:00:00'),('AMD','Armenian Dram','2002-06-01 04:00:00'),('ANG','Netherlands Antillian Guilder','2002-06-01 04:00:00'),('AOA','Kwanza','2002-06-01 04:00:00'),('ARS','Argentine Peso','2002-06-01 04:00:00'),('ATS','Shilling','2002-06-01 04:00:00'),('AUD','Australian Dollar','2002-06-01 04:00:00'),('AWG','Aruban Guilder','2002-06-01 04:00:00'),('AZM','Azerbaijanian Manat','2002-06-01 04:00:00'),('BBD','Barbados Dollar','2002-06-01 04:00:00'),('BDT','Taka','2002-06-01 04:00:00'),('BEF','Belgian Franc','2002-06-01 04:00:00'),('BGN','Bulgarian Lev','2002-06-01 04:00:00'),('BHD','Bahraini Dinar','2002-06-01 04:00:00'),('BND','Brunei Dollar','2002-06-01 04:00:00'),('BOB','Boliviano','2002-06-01 04:00:00'),('BRL','Brazilian Real','2002-06-01 04:00:00'),('BSD','Bahamian Dollar','2002-06-01 04:00:00'),('BTN','Ngultrum','2002-06-01 04:00:00'),('CAD','Canadian Dollar','2002-06-01 04:00:00'),('CHF','Swiss Franc','2002-06-01 04:00:00'),('CLP','Chilean Peso','2002-06-01 04:00:00'),('CNY','Yuan Renminbi','2002-06-01 04:00:00'),('COP','Colombian Peso','2002-06-01 04:00:00'),('CRC','Costa Rican Colon','2002-06-01 04:00:00'),('CYP','Cyprus Pound','2002-06-01 04:00:00'),('CZK','Czech Koruna','2002-06-01 04:00:00'),('DEM','Deutsche Mark','2002-06-01 04:00:00'),('DKK','Danish Krone','2002-06-01 04:00:00'),('DOP','Dominican Peso','2002-06-01 04:00:00'),('DZD','Algerian Dinar','2002-06-01 04:00:00'),('EEK','Kroon','2002-06-01 04:00:00'),('EGP','Egyptian Pound','2002-06-01 04:00:00'),('ESP','Spanish Peseta','2002-06-01 04:00:00'),('EUR','EURO','2002-06-01 04:00:00'),('FIM','Markka','2002-06-01 04:00:00'),('FJD','Fiji Dollar','2002-06-01 04:00:00'),('FRF','French Franc','2002-06-01 04:00:00'),('GBP','United Kingdom Pound','2002-06-01 04:00:00'),('GHC','Cedi','2002-06-01 04:00:00'),('GRD','Drachma','2002-06-01 04:00:00'),('GTQ','Quetzal','2002-06-01 04:00:00'),('HKD','Hong Kong Dollar','2002-06-01 04:00:00'),('HRK','Croatian Kuna','2002-06-01 04:00:00'),('HUF','Forint','2002-06-01 04:00:00'),('IDR','Rupiah','2002-06-01 04:00:00'),('IEP','Irish Pound','2002-06-01 04:00:00'),('ILS','New Israeli Shekel','2002-06-01 04:00:00'),('INR','Indian Rupee','2002-06-01 04:00:00'),('ISK','Iceland Krona','2002-06-01 04:00:00'),('ITL','Italian Lira','2002-06-01 04:00:00'),('JMD','Jamaican Dollar','2002-06-01 04:00:00'),('JOD','Jordanian Dinar','2002-06-01 04:00:00'),('JPY','Yen','2002-06-01 04:00:00'),('KES','Kenyan Shilling','2002-06-01 04:00:00'),('KRW','Won','2002-06-01 04:00:00'),('KWD','Kuwaiti Dinar','2002-06-01 04:00:00'),('LBP','Lebanese Pound','2002-06-01 04:00:00'),('LKR','Sri Lankan Rupee','2002-06-01 04:00:00'),('LTL','Lithuanian Litas','2002-06-01 04:00:00'),('LVL','Latvian Lats','2002-06-01 04:00:00'),('MAD','Moroccan Dirham','2002-06-01 04:00:00'),('MTL','Maltese Lira','2002-06-01 04:00:00'),('MUR','Mauritius Rupee','2002-06-01 04:00:00'),('MVR','Rufiyaa','2002-06-01 04:00:00'),('MXN','Mexican Peso','2002-06-01 04:00:00'),('MYR','Malaysian Ringgit','2002-06-01 04:00:00'),('NAD','Namibia Dollar','2002-06-01 04:00:00'),('NGN','Naira','2002-06-01 04:00:00'),('NLG','Netherlands Guilder','2002-06-01 04:00:00'),('NOK','Norwegian Krone','2002-06-01 04:00:00'),('NPR','Nepalese Rupee','2002-06-01 04:00:00'),('NZD','New Zealand Dollar','2002-06-01 04:00:00'),('OMR','Omani Rial','2002-06-01 04:00:00'),('PAB','Balboa','2002-06-01 04:00:00'),('PEN','Nuevo Sol','2002-06-01 04:00:00'),('PHP','Philippine Peso','2002-06-01 04:00:00'),('PKR','Pakistan Rupee','2002-06-01 04:00:00'),('PLN','Zloty','2002-06-01 04:00:00'),('PLZ','Polish Zloty(old)','2002-06-01 04:00:00'),('PTE','Portuguese Escudo','2002-06-01 04:00:00'),('PYG','Guarani','2002-06-01 04:00:00'),('ROL','Leu','2002-06-01 04:00:00'),('RUB','Russian Ruble','2002-06-01 04:00:00'),('RUR','Russian Ruble(old)','2002-06-01 04:00:00'),('SAR','Saudi Riyal','2002-06-01 04:00:00'),('SEK','Swedish Krona','2002-06-01 04:00:00'),('SGD','Singapore Dollar','2002-06-01 04:00:00'),('SIT','Tolar','2002-06-01 04:00:00'),('SKK','Slovak Koruna','2002-06-01 04:00:00'),('SVC','El Salvador Colon','2002-06-01 04:00:00'),('THB','Baht','2002-06-01 04:00:00'),('TND','Tunisian Dinar','2002-06-01 04:00:00'),('TRL','Turkish Lira','2002-06-01 04:00:00'),('TTD','Trinidad and Tobago Dollar','2002-06-01 04:00:00'),('TWD','New Taiwan Dollar','2002-06-01 04:00:00'),('USD','US Dollar','2002-06-01 04:00:00'),('UYU','Uruguayan Peso','2002-06-01 04:00:00'),('VEB','Bolivar','2002-06-01 04:00:00'),('VND','Dong','2002-06-01 04:00:00'),('XOF','CFA Franc BCEAO','2002-06-01 04:00:00'),('ZAR','Rand','2002-06-01 04:00:00'),('ZWD','Zimbabwe Dollar','2002-06-01 04:00:00');
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:25:00
