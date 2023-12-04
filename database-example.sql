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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_sequences`
--

LOCK TABLES `moderation_sequences` WRITE;
/*!40000 ALTER TABLE `moderation_sequences` DISABLE KEYS */;
INSERT INTO `moderation_sequences` VALUES (1,1,2,200,1,NULL,NULL,NULL,0,'582f2f55-b874-40af-b401-02fbdbff1105','2023-11-29 05:49:19','2023-11-29 05:49:19'),(2,1,2,100,2,NULL,NULL,NULL,0,'6b092f6d-c630-42f6-8008-77fb8be3c4f0','2023-11-29 05:49:19','2023-11-29 05:49:19'),(3,1,2,100,3,NULL,NULL,NULL,0,'060614af-aceb-4de2-b9b1-581c0373ed8b','2023-11-29 05:49:19','2023-11-29 05:49:19');
/*!40000 ALTER TABLE `moderation_sequences` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_sequence_users`
--

LOCK TABLES `moderation_sequence_users` WRITE;
/*!40000 ALTER TABLE `moderation_sequence_users` DISABLE KEYS */;
INSERT INTO `moderation_sequence_users` VALUES (1,2),(2,3),(2,4),(2,5),(3,3),(3,4),(3,5);
/*!40000 ALTER TABLE `moderation_sequence_users` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderations`
--

LOCK TABLES `moderations` WRITE;
/*!40000 ALTER TABLE `moderations` DISABLE KEYS */;
INSERT INTO `moderations` VALUES (1,'71c1a391-ae32-43b6-a730-7b82c173bcb3',NULL,2,1,2,3,NULL,NULL,1,NULL,100,'2023-11-29 05:49:19','2023-11-29 05:49:19');
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_moderations`
--

LOCK TABLES `expense_moderations` WRITE;
/*!40000 ALTER TABLE `expense_moderations` DISABLE KEYS */;
INSERT INTO `expense_moderations` VALUES (1,1,1,NULL,'2023-11-29 05:49:19','2023-11-29 05:49:19');
/*!40000 ALTER TABLE `expense_moderations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-29 12:50:45
