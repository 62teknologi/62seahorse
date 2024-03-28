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
-- royal_medika.ai_expense_moderations definition
CREATE TABLE `ai_expense_moderations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `deleted_by` bigint(20) unsigned DEFAULT NULL,
  `moderation_id` bigint(20) unsigned DEFAULT NULL,
  `expense_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_expense_moderations`
--

LOCK TABLES `ai_expense_moderations` WRITE;
/*!40000 ALTER TABLE `ai_expense_moderations` DISABLE KEYS */;
INSERT INTO `ai_expense_moderations` VALUES (1,1,1,NULL,'2023-12-11 02:52:33','2023-12-11 02:52:33');
/*!40000 ALTER TABLE `ai_expense_moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderation_users`
--

DROP TABLE IF EXISTS `mod_moderation_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderation_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `deleted_by` bigint(20) unsigned DEFAULT NULL,
  `item_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `moderation_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=487 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_users`
--

LOCK TABLES `mod_moderation_users` WRITE;
/*!40000 ALTER TABLE `mod_moderation_users` DISABLE KEYS */;
INSERT INTO `mod_moderation_users` VALUES (1,2,1),(2,3,1),(2,4,1),(2,5,1),(3,4,1),(3,2,1),(3,3,1);
/*!40000 ALTER TABLE `mod_moderation_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mod_moderation_items`
--

DROP TABLE IF EXISTS `mod_moderation_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mod_moderation_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `deleted_by` bigint(20) unsigned DEFAULT NULL,
  `moderation_id` bigint(20) unsigned DEFAULT NULL,
  `moderator_id` bigint(20) unsigned DEFAULT NULL,
  `result` tinyint(4) DEFAULT NULL COMMENT 'approve, pending, revise, reject',
  `step` tinyint(4) DEFAULT NULL,
  `set` tinyint(4) DEFAULT NULL,
  `remarks` varchar(2000) DEFAULT NULL,
  `file_id` bigint(20) unsigned DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=487 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderation_items`
--

LOCK TABLES `mod_moderation_items` WRITE;
/*!40000 ALTER TABLE `mod_moderation_items` DISABLE KEYS */;
INSERT INTO `mod_moderation_items` VALUES (1,1,2,4,1,NULL,'okay',NULL,0,'2023-12-11 02:52:33','2023-12-11 02:52:33','9aed45af-93d6-4310-8d1e-6662f178eb4f'),(2,1,NULL,1,NULL,NULL,NULL,NULL,0,'2023-12-11 02:52:33','2023-12-11 02:52:33','fe25dfee-d43c-4be7-8a89-c4bffc03e795'),(3,1,NULL,1,NULL,NULL,NULL,NULL,0,'2023-12-11 02:52:33','2023-12-11 02:52:33','9ef8c7c9-c9a1-4eff-956a-1b9cc159bdcd');
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
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `deleted_by` bigint(20) unsigned DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `requested_by` bigint(20) unsigned DEFAULT NULL,
  `last_item_id` bigint(20) unsigned DEFAULT NULL,
  `step_current` tinyint(4) DEFAULT NULL COMMENT 'step = moderation step, accumulative across set',
  `step_total` tinyint(4) DEFAULT NULL,
  `set_current` tinyint(4) DEFAULT NULL COMMENT 'set = moderation loop, for revise purposes',
  `set_total` tinyint(4) DEFAULT NULL,
  `is_ordered_items` tinyint(1) NOT NULL DEFAULT 0,
  `is_extendable` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(4) DEFAULT 0 COMMENT 'approve, pending, revise, reject',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mod_moderations`
--

LOCK TABLES `mod_moderations` WRITE;
/*!40000 ALTER TABLE `mod_moderations` DISABLE KEYS */;
INSERT INTO `mod_moderations` VALUES (1,NULL,1,1,1,3,NULL,NULL,0,NULL,4,'2023-12-11 02:52:33','2023-12-11 02:52:33','f6477254-33c8-4577-b309-8e4a06fb04a3');
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

-- Dump completed on 2023-12-11  9:54:00
