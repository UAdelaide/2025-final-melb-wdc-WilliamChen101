-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: dogwalkservice
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `dogs`
--

DROP TABLE IF EXISTS `dogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dogs` (
  `dog_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `size` enum('small','medium','large') NOT NULL,
  PRIMARY KEY (`dog_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `dogs_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dogs`
--

LOCK TABLES `dogs` WRITE;
/*!40000 ALTER TABLE `dogs` DISABLE KEYS */;
INSERT INTO `dogs` VALUES (1,1,'Max','medium'),(2,3,'Bella','small'),(3,4,'Rocky','large'),(4,1,'Luna','medium'),(5,4,'Coco','small');
/*!40000 ALTER TABLE `dogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('owner','walker') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'alice123','alice@example.com','hashed123','owner','2025-06-20 13:16:52'),(2,'bobwalker','bob@example.com','hashed456','walker','2025-06-20 13:16:52'),(3,'carol123','carol@example.com','hashed789','owner','2025-06-20 13:16:52'),(4,'daviddog','david@example.com','hashed000','owner','2025-06-20 13:16:52'),(5,'elliewalk','ellie@example.com','hashed111','walker','2025-06-20 13:16:52');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `walkapplications`
--

DROP TABLE IF EXISTS `walkapplications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `walkapplications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `unique_application` (`request_id`,`walker_id`),
  KEY `walker_id` (`walker_id`),
  CONSTRAINT `walkapplications_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `walkrequests` (`request_id`),
  CONSTRAINT `walkapplications_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `walkapplications`
--

LOCK TABLES `walkapplications` WRITE;
/*!40000 ALTER TABLE `walkapplications` DISABLE KEYS */;
/*!40000 ALTER TABLE `walkapplications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `walkratings`
--

DROP TABLE IF EXISTS `walkratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `walkratings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `rating` int DEFAULT NULL,
  `comments` text,
  `rated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `unique_rating_per_walk` (`request_id`),
  KEY `walker_id` (`walker_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `walkratings_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `walkrequests` (`request_id`),
  CONSTRAINT `walkratings_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `walkratings_ibfk_3` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `walkratings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `walkratings`
--

LOCK TABLES `walkratings` WRITE;
/*!40000 ALTER TABLE `walkratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `walkratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `walkrequests`
--

DROP TABLE IF EXISTS `walkrequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `walkrequests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `dog_id` int NOT NULL,
  `requested_time` datetime NOT NULL,
  `duration_minutes` int NOT NULL,
  `location` varchar(255) NOT NULL,
  `status` enum('open','accepted','completed','cancelled') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `dog_id` (`dog_id`),
  CONSTRAINT `walkrequests_ibfk_1` FOREIGN KEY (`dog_id`) REFERENCES `dogs` (`dog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `walkrequests`
--

LOCK TABLES `walkrequests` WRITE;
/*!40000 ALTER TABLE `walkrequests` DISABLE KEYS */;
INSERT INTO `walkrequests` VALUES (1,1,'2025-06-10 08:00:00',30,'Parklands','open','2025-06-20 13:16:52'),(2,2,'2025-06-10 09:30:00',45,'Beachside Ave','accepted','2025-06-20 13:16:52'),(3,3,'2025-06-11 10:00:00',60,'Hill Park','open','2025-06-20 13:16:52'),(4,4,'2025-06-12 11:00:00',40,'River Street','open','2025-06-20 13:16:52'),(5,5,'2025-06-12 13:30:00',50,'City Garden','open','2025-06-20 13:16:52'),(8,1,'2025-06-01 11:47:00',11,'bundoora','open','2025-06-21 01:48:34');
/*!40000 ALTER TABLE `walkrequests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-21 12:56:07
