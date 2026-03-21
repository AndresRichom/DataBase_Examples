-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: pubs
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
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `emp_id` char(9) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `minit` char(1) DEFAULT NULL,
  `lname` varchar(30) NOT NULL,
  `job_id` smallint NOT NULL DEFAULT '1',
  `job_lvl` tinyint unsigned DEFAULT '10',
  `pub_id` char(4) NOT NULL DEFAULT '9952',
  `hire_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`emp_id`),
  KEY `employee_ind` (`fname`,`minit`,`lname`),
  KEY `FK__employee__job_id__1BFD2C07` (`job_id`),
  KEY `FK__employee__pub_id__1ED998B2` (`pub_id`),
  CONSTRAINT `FK__employee__job_id__1BFD2C07` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
  CONSTRAINT `FK__employee__pub_id__1ED998B2` FOREIGN KEY (`pub_id`) REFERENCES `publishers` (`pub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('A-C71970F','Aria','','Cruz',10,87,'1389','1991-10-26 03:00:00'),('A-R89858F','Annette','','Roulet',6,152,'9999','1990-02-21 03:00:00'),('AMD15433F','Ann','M','Devon',3,200,'9952','1991-07-16 04:00:00'),('ARD36773F','Anabela','R','Domingues',8,100,'0877','1993-01-27 03:00:00'),('CFH28514M','Carlos','F','Hernadez',5,211,'9999','1989-04-21 04:00:00'),('CGS88322F','Carine','G','Schmitt',13,64,'1389','1992-07-07 04:00:00'),('DBT39435M','Daniel','B','Tonini',11,75,'0877','1990-01-01 03:00:00'),('DWR65030M','Diego','W','Roel',6,192,'1389','1991-12-16 03:00:00'),('ENL44273F','Elizabeth','N','Lincoln',14,35,'0877','1990-07-24 04:00:00'),('F-C16315M','Francisco','','Chang',4,227,'9952','1990-11-03 03:00:00'),('GHT50241M','Gary','H','Thomas',9,170,'0736','1988-08-09 04:00:00'),('H-B39728F','Helen','','Bennett',12,35,'0877','1989-09-21 03:00:00'),('HAN90777M','Helvetius','A','Nagy',7,120,'9999','1993-03-19 03:00:00'),('HAS54740M','Howard','A','Snyder',12,100,'0736','1988-11-19 03:00:00'),('JYL26161F','Janine','Y','Labrune',5,172,'9901','1991-05-26 04:00:00'),('KFJ64308F','Karin','F','Josephs',14,100,'0736','1992-10-17 03:00:00'),('KJJ92907F','Karla','J','Jablonski',9,170,'9999','1994-03-11 03:00:00'),('L-B31947F','Lesley','','Brown',7,120,'0877','1991-02-13 03:00:00'),('LAL21447M','Laurence','A','Lebihan',5,175,'0736','1990-06-03 04:00:00'),('M-L67958F','Maria','','Larsson',7,135,'1389','1992-03-27 03:00:00'),('M-P91209M','Manuel','','Pereira',8,101,'9999','1989-01-09 03:00:00'),('M-R38834F','Martine','','Rance',9,75,'0877','1992-02-05 03:00:00'),('MAP77183M','Miguel','A','Paolino',11,112,'1389','1992-12-07 03:00:00'),('MAS70474F','Margaret','A','Smith',9,78,'1389','1988-09-29 03:00:00'),('MFS52347M','Martin','F','Sommer',10,165,'0736','1990-04-13 04:00:00'),('MGK44605M','Matti','G','Karttunen',6,220,'0736','1994-05-01 04:00:00'),('MJP25939M','Maria','J','Pontes',5,246,'1756','1989-03-01 03:00:00'),('MMS49649F','Mary','M','Saveley',8,175,'0736','1993-06-29 04:00:00'),('PCM98509F','Patricia','C','McKenna',11,150,'9999','1989-08-01 04:00:00'),('PDI47470M','Palle','D','Ibsen',7,195,'0736','1993-05-09 04:00:00'),('PHF38899M','Peter','H','Franken',10,75,'0877','1992-05-17 04:00:00'),('PMA42628M','Paolo','M','Accorti',13,35,'0877','1992-08-27 04:00:00'),('POK93028M','Pirkko','O','Koskitalo',10,80,'9999','1993-11-29 03:00:00'),('PSA89086M','Pedro','S','Afonso',14,89,'1389','1990-12-24 03:00:00'),('PSP68661F','Paula','S','Parente',8,125,'1389','1994-01-19 03:00:00'),('PTC11962M','Philip','T','Cramer',2,215,'9952','1989-11-11 03:00:00'),('PXH22250M','Paul','X','Henriot',5,159,'0877','1993-08-19 04:00:00'),('R-M53550M','Roland','','Mendel',11,150,'0736','1991-09-05 04:00:00'),('RBM23061F','Rita','B','Muller',5,198,'1622','1993-10-09 03:00:00'),('SKO22412M','Sven','K','Ottlieb',5,150,'1389','1991-04-05 03:00:00'),('TPO55093M','Timothy','P','O\'Rourke',13,100,'0736','1988-06-19 04:00:00'),('VPA30890F','Victoria','P','Ashworth',6,140,'0877','1990-09-13 03:00:00'),('Y-L77953M','Yoshi','','Latimer',12,32,'1389','1989-06-11 04:00:00');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:20:23
