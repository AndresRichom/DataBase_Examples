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
-- Table structure for table `titles`
--

DROP TABLE IF EXISTS `titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `titles` (
  `title_id` varchar(6) NOT NULL,
  `title` varchar(80) NOT NULL,
  `type` char(12) NOT NULL DEFAULT 'UNDECIDED',
  `pub_id` char(4) DEFAULT NULL,
  `price` decimal(19,4) DEFAULT NULL,
  `advance` decimal(19,4) DEFAULT NULL,
  `royalty` int DEFAULT NULL,
  `ytd_sales` int DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  `pubdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`title_id`),
  KEY `titleind` (`title`),
  KEY `FK__titles__pub_id__014935CB` (`pub_id`),
  CONSTRAINT `FK__titles__pub_id__014935CB` FOREIGN KEY (`pub_id`) REFERENCES `publishers` (`pub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `titles`
--

LOCK TABLES `titles` WRITE;
/*!40000 ALTER TABLE `titles` DISABLE KEYS */;
INSERT INTO `titles` VALUES ('BU1032','The Busy Executive\'s Database Guide','business','1389',19.9900,5000.0000,10,4095,'An overview of available database systems with emphasis on common business applications. Illustrated.','1991-06-12 04:00:00'),('BU1111','Cooking with Computers: Surreptitious Balance Sheets','business','1389',11.9500,5000.0000,10,3876,'Helpful hints on how to use your electronic resources to the best advantage.','1991-06-09 04:00:00'),('BU2075','You Can Combat Computer Stress!','business','0736',2.9900,10125.0000,24,18722,'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.','1991-06-30 04:00:00'),('BU7832','Straight Talk About Computers','business','1389',19.9900,5000.0000,10,4095,'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.','1991-06-22 04:00:00'),('MC2222','Silicon Valley Gastronomic Treats','mod_cook','0877',19.9900,0.0000,12,2032,'Favorite recipes for quick, easy, and elegant meals.','1991-06-09 04:00:00'),('MC3021','The Gourmet Microwave','mod_cook','0877',2.9900,15000.0000,24,22246,'Traditional French gourmet recipes adapted for modern microwave cooking.','1991-06-18 04:00:00'),('MC3026','The Psychology of Computer Cooking','UNDECIDED','0877',NULL,NULL,NULL,NULL,NULL,'2004-12-13 19:11:37'),('PC1035','But Is It User Friendly?','popular_comp','1389',22.9500,7000.0000,16,8780,'A survey of software for the naive user, focusing on the \'friendliness\' of each.','1991-06-30 04:00:00'),('PC8888','Secrets of Silicon Valley','popular_comp','1389',20.0000,8000.0000,10,4095,'Muckraking reporting on the world\'s largest computer hardware and software manufacturers.','1994-06-12 04:00:00'),('PC9999','Net Etiquette','popular_comp','1389',NULL,NULL,NULL,NULL,'A must-read for computer conferencing.','2004-12-13 19:11:37'),('PS1372','Computer Phobic AND Non-Phobic Individuals: Behavior Variations','psychology','0877',21.5900,7000.0000,10,375,'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don\'t.','1991-10-21 03:00:00'),('PS2091','Is Anger the Enemy?','psychology','0736',10.9500,2275.0000,12,2045,'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.','1991-06-15 04:00:00'),('PS2106','Life Without Fear','psychology','0736',7.0000,6000.0000,10,111,'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.','1991-10-05 03:00:00'),('PS3333','Prolonged Data Deprivation: Four Case Studies','psychology','0736',19.9900,2000.0000,10,4072,'What happens when the data runs dry?  Searching evaluations of information-shortage effects.','1991-06-12 04:00:00'),('PS7777','Emotional Security: A New Algorithm','psychology','0736',7.9900,4000.0000,10,3336,'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.','1991-06-12 04:00:00'),('TC3218','Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean','trad_cook','0877',20.9500,7000.0000,10,375,'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.','1991-10-21 03:00:00'),('TC4203','Fifty Years in Buckingham Palace Kitchens','trad_cook','0877',11.9500,4000.0000,14,15096,'More anecdotes from the Queen\'s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.','1991-06-12 04:00:00'),('TC7777','Sushi, Anyone?','trad_cook','0877',14.9900,8000.0000,10,4095,'Detailed instructions on how to make authentic Japanese sushi in your spare time.','1991-06-12 04:00:00');
/*!40000 ALTER TABLE `titles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 20:20:24
