-- MySQL dump 10.13  Distrib 8.0.32, for macos13 (arm64)
--
-- Host: localhost    Database: sea_horse
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `moderation_sequences`
--

DROP TABLE IF EXISTS `moderation_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderation_sequences` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `moderation_id` bigint unsigned DEFAULT NULL,
  `moderator_id` bigint unsigned DEFAULT NULL,
  `result` int DEFAULT NULL,
  `step` smallint DEFAULT NULL,
  `set` smallint DEFAULT NULL,
  `remarks` varchar(225) DEFAULT NULL,
  `file_id` varchar(225) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT '0',
  `uuid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_sequences`
--

LOCK TABLES `moderation_sequences` WRITE;
/*!40000 ALTER TABLE `moderation_sequences` DISABLE KEYS */;
INSERT INTO `moderation_sequences` VALUES (1,1,2,200,1,NULL,NULL,NULL,0,'e5956aff-f9ba-43d4-a766-6876441dd43e'),(2,1,2,200,2,NULL,NULL,NULL,0,'b4b30578-c249-4bf6-a848-1519c0c3c019'),(3,1,2,200,3,NULL,NULL,NULL,0,'72931f88-cdb8-4aff-b061-1765489dd733'),(4,2,2,100,1,NULL,NULL,NULL,1,'dcc20564-bbaa-4fe4-8d9c-d86cfb7518af'),(5,2,2,100,2,NULL,NULL,NULL,0,'90068ec5-6d81-45cc-bfda-4160f245cb7e'),(6,2,2,100,3,NULL,NULL,NULL,0,'70b4bb87-2003-4f5e-8ebf-c05f1420711d'),(7,3,2,100,1,NULL,NULL,NULL,1,'4e612331-2787-4015-a809-0cf93406f452'),(8,3,2,100,2,NULL,NULL,NULL,0,'a8cdca5f-fdc6-4749-b1bf-9a4917d18710'),(9,3,2,100,3,NULL,NULL,NULL,0,'43f67495-894c-4477-b0a5-37b5b8df3ef2');
/*!40000 ALTER TABLE `moderation_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES (1,'thami'),(2,'kusuma');
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderations`
--

DROP TABLE IF EXISTS `moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(225) DEFAULT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `requested_by` bigint unsigned DEFAULT NULL,
  `last_moderation_sequence_id` bigint unsigned DEFAULT NULL,
  `step_current` int DEFAULT NULL,
  `step_total` int DEFAULT NULL,
  `set_current` bigint unsigned DEFAULT NULL,
  `set_total` int DEFAULT NULL,
  `is_in_order` tinyint(1) DEFAULT '0',
  `is_extendable` tinyint(1) DEFAULT NULL,
  `status` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderations`
--

LOCK TABLES `moderations` WRITE;
/*!40000 ALTER TABLE `moderations` DISABLE KEYS */;
INSERT INTO `moderations` VALUES (1,'b5ad89ce-1c0b-470e-bcea-d92e1a2a3812',NULL,2,1,3,3,NULL,NULL,0,NULL,200),(2,'75c07941-ec7c-4f5a-becf-4bcd9b0cbe44',NULL,2,NULL,1,3,NULL,NULL,0,NULL,100),(3,'7f358f74-3cc5-4967-86e0-8ed83a12aa10',NULL,2,NULL,1,3,NULL,NULL,0,NULL,100);
/*!40000 ALTER TABLE `moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_moderations`
--

DROP TABLE IF EXISTS `expense_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_moderations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `moderation_id` bigint unsigned DEFAULT NULL,
  `record_id` bigint unsigned DEFAULT NULL,
  `type` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_moderations`
--

LOCK TABLES `expense_moderations` WRITE;
/*!40000 ALTER TABLE `expense_moderations` DISABLE KEYS */;
INSERT INTO `expense_moderations` VALUES (1,1,1,NULL),(2,2,1,NULL),(3,3,1,NULL);
/*!40000 ALTER TABLE `expense_moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderation_sequence_users`
--

DROP TABLE IF EXISTS `moderation_sequence_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderation_sequence_users` (
  `moderation_sequence_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_sequence_users`
--

LOCK TABLES `moderation_sequence_users` WRITE;
/*!40000 ALTER TABLE `moderation_sequence_users` DISABLE KEYS */;
INSERT INTO `moderation_sequence_users` VALUES (2,3),(2,4),(2,5),(3,3),(3,4),(3,5),(1,1),(1,2),(1,3),(4,2),(5,3),(5,4),(5,5),(6,3),(6,4),(6,5),(7,2),(8,3),(8,4),(8,5),(9,3),(9,4),(9,5);
/*!40000 ALTER TABLE `moderation_sequence_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-29  9:28:52
