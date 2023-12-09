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
-- Table structure for table `ai_expense_moderations`
--

DROP TABLE IF EXISTS `ai_expense_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_expense_moderations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `moderation_id` bigint unsigned DEFAULT NULL,
  `expense_id` bigint unsigned DEFAULT NULL,
  `type` varchar(225) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_expense_moderations`
--

LOCK TABLES `ai_expense_moderations` WRITE;
/*!40000 ALTER TABLE `ai_expense_moderations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_expense_moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderation_users`
--

DROP TABLE IF EXISTS `mod_moderation_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderation_users` (
  `item_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `moderation_id` bigint unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_users`
--

LOCK TABLES `mod_moderation_users` WRITE;
/*!40000 ALTER TABLE `mod_moderation_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `mod_moderation_users` ENABLE KEYS */;
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uuid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_items`
--

LOCK TABLES `mod_moderation_items` WRITE;
/*!40000 ALTER TABLE `mod_moderation_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mod_moderation_items` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
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
-- Table structure for table `mod_moderations`
--

DROP TABLE IF EXISTS `mod_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint unsigned DEFAULT NULL,
  `requested_by` bigint unsigned DEFAULT NULL,
  `last_moderation_sequence_id` bigint unsigned DEFAULT NULL,
  `step_current` int DEFAULT NULL,
  `step_total` int DEFAULT NULL,
  `set_current` bigint unsigned DEFAULT NULL,
  `set_total` int DEFAULT NULL,
  `is_ordered_items` tinyint(1) DEFAULT '0',
  `is_extendable` tinyint(1) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uuid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderations`
--

LOCK TABLES `mod_moderations` WRITE;
/*!40000 ALTER TABLE `mod_moderations` DISABLE KEYS */;
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

-- Dump completed on 2023-12-09 11:36:43
