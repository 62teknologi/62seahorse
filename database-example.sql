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
-- Table structure for table `ai_expenses`
--

DROP TABLE IF EXISTS `ai_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_expenses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_expenses`
--

LOCK TABLES `ai_expenses` WRITE;
/*!40000 ALTER TABLE `ai_expenses` DISABLE KEYS */;
INSERT INTO `ai_expenses` VALUES (1,'thami'),(2,'kusuma');
/*!40000 ALTER TABLE `ai_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderation_users`
--

DROP TABLE IF EXISTS `mod_moderation_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderation_users` (
  `moderation_sequence_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_users`
--

LOCK TABLES `mod_moderation_users` WRITE;
/*!40000 ALTER TABLE `mod_moderation_users` DISABLE KEYS */;
INSERT INTO `mod_moderation_users` VALUES (1,2),(2,3),(2,4),(2,5),(3,3),(3,4),(3,5);
/*!40000 ALTER TABLE `mod_moderation_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_expense_moderations`
--

DROP TABLE IF EXISTS `ai_expense_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_expense_moderations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `moderation_id` bigint unsigned DEFAULT NULL,
  `record_id` bigint unsigned DEFAULT NULL,
  `type` varchar(225) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_expense_moderations`
--

LOCK TABLES `ai_expense_moderations` WRITE;
/*!40000 ALTER TABLE `ai_expense_moderations` DISABLE KEYS */;
INSERT INTO `ai_expense_moderations` VALUES (1,1,1,NULL,'2023-12-05 09:24:22','2023-12-05 09:24:22');
/*!40000 ALTER TABLE `ai_expense_moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderation_items`
--

DROP TABLE IF EXISTS `mod_moderation_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderation_items` (
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_items`
--

LOCK TABLES `mod_moderation_items` WRITE;
/*!40000 ALTER TABLE `mod_moderation_items` DISABLE KEYS */;
INSERT INTO `mod_moderation_items` VALUES (1,1,2,200,1,NULL,'ok','10',0,'b99afac6-a1bf-41be-8888-3eb718a3547e','2023-12-05 09:24:22','2023-12-05 09:24:22'),(2,1,NULL,100,2,NULL,NULL,NULL,1,'f584c406-1a9e-4603-a010-2f1fd7ea4c9a','2023-12-05 09:24:22','2023-12-05 09:24:22'),(3,1,NULL,100,3,NULL,NULL,NULL,0,'243d33ad-04f5-4b0a-90f6-34e1a078e8eb','2023-12-05 09:24:22','2023-12-05 09:24:22');
/*!40000 ALTER TABLE `mod_moderation_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderations`
--

DROP TABLE IF EXISTS `mod_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderations` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderations`
--

LOCK TABLES `mod_moderations` WRITE;
/*!40000 ALTER TABLE `mod_moderations` DISABLE KEYS */;
INSERT INTO `mod_moderations` VALUES (1,'8d16aaf7-2f07-44b0-bff1-8fb65018c53d',NULL,1,1,1,3,NULL,NULL,1,NULL,100,'2023-12-05 09:24:22','2023-12-05 09:24:22');
/*!40000 ALTER TABLE `mod_moderations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-05 16:30:47
