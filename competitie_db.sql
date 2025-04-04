-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: competitie_db
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.24.04.1

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
-- Table structure for table `achizitii`
--

DROP TABLE IF EXISTS `achizitii`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `achizitii` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `bilet_id` int NOT NULL,
  `cantitate` int NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `data_achizitie` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `bilet_id` (`bilet_id`),
  CONSTRAINT `achizitii_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `achizitii_ibfk_2` FOREIGN KEY (`bilet_id`) REFERENCES `bilete` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achizitii`
--

LOCK TABLES `achizitii` WRITE;
/*!40000 ALTER TABLE `achizitii` DISABLE KEYS */;
/*!40000 ALTER TABLE `achizitii` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `achizitii_magazin`
--

DROP TABLE IF EXISTS `achizitii_magazin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `achizitii_magazin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `produs_id` int NOT NULL,
  `cantitate` int NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `data_achizitie` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `produs_id` (`produs_id`),
  CONSTRAINT `achizitii_magazin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `achizitii_magazin_ibfk_2` FOREIGN KEY (`produs_id`) REFERENCES `magazin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achizitii_magazin`
--

LOCK TABLES `achizitii_magazin` WRITE;
/*!40000 ALTER TABLE `achizitii_magazin` DISABLE KEYS */;
/*!40000 ALTER TABLE `achizitii_magazin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bilete`
--

DROP TABLE IF EXISTS `bilete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bilete` (
  `id` int NOT NULL AUTO_INCREMENT,
  `denumire` varchar(100) NOT NULL,
  `pret` decimal(10,2) NOT NULL,
  `descriere` text,
  `disponibilitate` int DEFAULT '0',
  `data_eveniment` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bilete`
--

LOCK TABLES `bilete` WRITE;
/*!40000 ALTER TABLE `bilete` DISABLE KEYS */;
/*!40000 ALTER TABLE `bilete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `magazin`
--

DROP TABLE IF EXISTS `magazin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `magazin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nume_produs` varchar(100) NOT NULL,
  `descriere` text,
  `pret` decimal(10,2) NOT NULL,
  `stoc` int DEFAULT '0',
  `imagine` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `magazin`
--

LOCK TABLES `magazin` WRITE;
/*!40000 ALTER TABLE `magazin` DISABLE KEYS */;
/*!40000 ALTER TABLE `magazin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `organizer` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'cristi','popageorgecristian10@gmail.com','$2b$10$R3AXIZhJAH3dZPC5DZw9NeUuq0qWvwLE/bVBnUlzz1aEyAjzxUlIO','2025-04-03 20:58:16',1),(2,'florin','idk@gmail.com','$2b$10$PBN1Rub6ZU2HxbQVqF8in.pfEZoW936w1WUGKv8rQwzAZMazUlXpu','2025-04-04 05:23:46',0),(4,'test','test@gmail.com','$2b$10$isXTeg8Sk.GDX9bTee.sGOIYe2fvkUI2K38pAFZrhcrCtdaBACpwS','2025-04-04 05:44:30',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04  7:08:36
