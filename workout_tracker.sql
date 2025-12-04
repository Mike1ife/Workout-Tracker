CREATE DATABASE  IF NOT EXISTS `workout_tracker` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `workout_tracker`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: workout_tracker
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `aerobics`
--

DROP TABLE IF EXISTS `aerobics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aerobics` (
  `exercise_name` varchar(64) NOT NULL,
  PRIMARY KEY (`exercise_name`),
  CONSTRAINT `aerobics_fk` FOREIGN KEY (`exercise_name`) REFERENCES `exercise` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aerobics`
--

LOCK TABLES `aerobics` WRITE;
/*!40000 ALTER TABLE `aerobics` DISABLE KEYS */;
INSERT INTO `aerobics` VALUES ('Burpees'),('Cycling'),('Elliptical Trainer'),('High Knees'),('Hiking'),('Jump Rope'),('Jumping Jacks'),('Mountain Climbers'),('Outdoor Running'),('Rowing Machine'),('Rowing Sprints'),('Spinning Class'),('Stair Climber'),('Stair Sprint'),('Stationary Bike'),('Swimming'),('Treadmill Running'),('Walking');
/*!40000 ALTER TABLE `aerobics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aerobics_section`
--

DROP TABLE IF EXISTS `aerobics_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aerobics_section` (
  `aerobics_section_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `exercise_name` varchar(64) NOT NULL,
  PRIMARY KEY (`aerobics_section_id`),
  UNIQUE KEY `aerobics_section_ak` (`session_id`,`exercise_name`),
  KEY `aerobics_section_aerobics_fk` (`exercise_name`),
  CONSTRAINT `aerobics_section_aerobics_fk` FOREIGN KEY (`exercise_name`) REFERENCES `aerobics` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aerobics_section_session_fk` FOREIGN KEY (`session_id`) REFERENCES `user_session` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aerobics_section`
--

LOCK TABLES `aerobics_section` WRITE;
/*!40000 ALTER TABLE `aerobics_section` DISABLE KEYS */;
/*!40000 ALTER TABLE `aerobics_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `equipment_name` varchar(64) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`equipment_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES ('Ab Crunch Machine','Machine for abdominal crunches'),('Barbell','Standard Olympic barbell used for compound lifts'),('Bench','Flat bench for pressing exercises'),('Cable Machine','Adjustable cable pulley machine'),('Calf Raise Machine','Machine targeting calf muscles'),('Chest Press Machine','Machine version of chest press exercise'),('Decline Bench','Decline bench for lower chest exercises'),('Dip Bars','Parallel bars for tricep dips'),('Dumbbells','Free weight dumbbells for various exercises'),('Elliptical Trainer','Low-impact cardio machine'),('EZ Bar','Curved bar used for arm exercises'),('Hamstring Curl Machine','Machine isolating the hamstrings'),('Incline Bench','Incline bench for upper chest exercises'),('Jump Rope','Rope used for cardio skipping exercises'),('Kettlebell','Ball-shaped weight for swings and goblet squats'),('Lat Pulldown Machine','Machine for vertical pulling exercises'),('Leg Extension Machine','Isolation machine for quadriceps'),('Leg Press Machine','Machine used to train quads and glutes'),('Medicine Ball','Weighted ball for core and strength exercises'),('Pec Deck Machine','Chest fly isolation machine'),('Power Rack','Full cage structure for weightlifting'),('Pull Up Bar','Bar for pull-ups and chin-ups'),('Resistance Bands','Elastic bands used for resistance training'),('Rowing Ergometer','High-performance rowing machine'),('Rowing Machine','Cardio machine simulating rowing motion'),('Seated Row Machine','Cable row machine targeting the back'),('Smith Machine','Guided barbell machine for safer lifting'),('Spin Bike','High-intensity indoor bike'),('Squat Rack','Rack for squats and barbell lifts'),('Stair Climber','Cardio machine simulating stair climbing'),('Stationary Bike','Indoor cycling machine'),('Trap Bar','Hex bar for trap bar deadlifts'),('Treadmill','Cardio machine for walking or running'),('Weight Plates','Plates added to bars for resistance');
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercise`
--

DROP TABLE IF EXISTS `exercise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercise` (
  `exercise_name` varchar(64) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`exercise_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercise`
--

LOCK TABLES `exercise` WRITE;
/*!40000 ALTER TABLE `exercise` DISABLE KEYS */;
INSERT INTO `exercise` VALUES ('Barbell Bicep Curl','Free weight curl for biceps'),('Barbell Deadlift','Full-body compound movement targeting posterior chain'),('Barbell Shoulder Press','Barbell overhead press for shoulders'),('Barbell Squat','Compound leg movement targeting quads and glutes'),('Bench Press','Barbell chest press targeting pectorals'),('Bent Over Barbell Row','Compound row movement for back'),('Burpees','High-intensity full-body aerobic drill'),('Cable Crunch','Weighted abdominal crunch exercise'),('Calf Raise','Calf-targeting machine or free weight exercise'),('Chin Ups','Underhand grip pulling movement'),('Cycling','Outdoor cycling exercise'),('Decline Bench Press','Decline barbell press for lower chest'),('Dumbbell Bicep Curl','Dumbbell curl for biceps'),('Dumbbell Chest Press','Dumbbell-based chest pressing movement'),('Dumbbell Flies','Chest isolation exercise using dumbbells'),('Dumbbell Row','Single-arm dumbbell back row'),('Dumbbell Shoulder Press','Dumbbell overhead shoulder press'),('Elliptical Trainer','Low-impact cardio machine'),('Front Raise','Dumbbell front shoulder isolation'),('Front Squat','Barbell squat variation emphasizing quads'),('Goblet Squat','Kettlebell squat variation'),('Hammer Curl','Neutral-grip dumbbell bicep curl'),('Hamstring Curl','Machine-based hamstring isolation'),('Hanging Leg Raise','Advanced core exercise for lower abs'),('High Knees','Bodyweight cardio warm-up drill'),('Hiking','Outdoor uphill cardio exercise'),('Incline Bench Press','Incline barbell press for upper chest'),('Jump Rope','High intensity rope jumping cardio'),('Jumping Jacks','Full-body cardio warm-up movement'),('Lat Pulldown','Back exercise targeting lats'),('Lateral Raise','Dumbbell raise for side delts'),('Leg Extension','Machine-based quad isolation'),('Leg Press','Machine-based leg press'),('Mountain Climbers','Core + cardio bodyweight drill'),('Outdoor Running','Outdoor jogging or running'),('Overhead Tricep Extension','Dumbbell tricep isolation exercise'),('Plank','Core stability bodyweight hold'),('Pull Ups','Bodyweight vertical pulling exercise'),('Push Ups','Bodyweight chest push movement'),('Rear Delt Fly','Rear shoulder isolation movement'),('Romanian Deadlift','Deadlift variation for hamstrings'),('Rowing Machine','Full-body cardio rowing motion'),('Rowing Sprints','High-intensity interval rowing'),('Russian Twists','Rotational ab exercise using weight'),('Seated Row','Cable row for mid-back development'),('Spinning Class','Indoor group cycling cardio session'),('Stair Climber','Cardio machine simulating stair climbing'),('Stair Sprint','High-intensity stair running interval'),('Stationary Bike','Indoor cycling machine'),('Sumo Deadlift','Wide-stance deadlift variation'),('Swimming','Full-body aerobic swimming exercise'),('Trap Bar Deadlift','Neutral grip deadlift variation'),('Treadmill Running','Indoor running exercise'),('Tricep Dips','Bodyweight dip movement for triceps'),('Tricep Rope Pushdown','Cable pressdown targeting triceps'),('Walking','Low impact aerobic activity');
/*!40000 ALTER TABLE `exercise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercise_equipment`
--

DROP TABLE IF EXISTS `exercise_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercise_equipment` (
  `exercise_name` varchar(64) NOT NULL,
  `equipment_name` varchar(64) NOT NULL,
  PRIMARY KEY (`exercise_name`,`equipment_name`),
  KEY `exercise_equipment_equipment_fk` (`equipment_name`),
  CONSTRAINT `exercise_equipment_equipment_fk` FOREIGN KEY (`equipment_name`) REFERENCES `equipment` (`equipment_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `exercise_equipment_exercise_fk` FOREIGN KEY (`exercise_name`) REFERENCES `exercise` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercise_equipment`
--

LOCK TABLES `exercise_equipment` WRITE;
/*!40000 ALTER TABLE `exercise_equipment` DISABLE KEYS */;
INSERT INTO `exercise_equipment` VALUES ('Cable Crunch','Ab Crunch Machine'),('Barbell Deadlift','Barbell'),('Barbell Shoulder Press','Barbell'),('Barbell Squat','Barbell'),('Bench Press','Barbell'),('Bent Over Barbell Row','Barbell'),('Decline Bench Press','Barbell'),('Front Squat','Barbell'),('Incline Bench Press','Barbell'),('Romanian Deadlift','Barbell'),('Sumo Deadlift','Barbell'),('Barbell Shoulder Press','Bench'),('Bench Press','Bench'),('Dumbbell Chest Press','Bench'),('Dumbbell Flies','Bench'),('Dumbbell Row','Bench'),('Dumbbell Shoulder Press','Bench'),('Cable Crunch','Cable Machine'),('Lat Pulldown','Cable Machine'),('Seated Row','Cable Machine'),('Tricep Rope Pushdown','Cable Machine'),('Calf Raise','Calf Raise Machine'),('Decline Bench Press','Decline Bench'),('Tricep Dips','Dip Bars'),('Dumbbell Bicep Curl','Dumbbells'),('Dumbbell Chest Press','Dumbbells'),('Dumbbell Flies','Dumbbells'),('Dumbbell Row','Dumbbells'),('Dumbbell Shoulder Press','Dumbbells'),('Front Raise','Dumbbells'),('Hammer Curl','Dumbbells'),('Lateral Raise','Dumbbells'),('Overhead Tricep Extension','Dumbbells'),('Rear Delt Fly','Dumbbells'),('Elliptical Trainer','Elliptical Trainer'),('Barbell Bicep Curl','EZ Bar'),('Hamstring Curl','Hamstring Curl Machine'),('Incline Bench Press','Incline Bench'),('Jump Rope','Jump Rope'),('Goblet Squat','Kettlebell'),('Lat Pulldown','Lat Pulldown Machine'),('Leg Extension','Leg Extension Machine'),('Leg Press','Leg Press Machine'),('Plank','Medicine Ball'),('Russian Twists','Medicine Ball'),('Dumbbell Flies','Pec Deck Machine'),('Rear Delt Fly','Pec Deck Machine'),('Barbell Shoulder Press','Power Rack'),('Barbell Squat','Power Rack'),('Chin Ups','Pull Up Bar'),('Hanging Leg Raise','Pull Up Bar'),('Pull Ups','Pull Up Bar'),('Front Raise','Resistance Bands'),('Lateral Raise','Resistance Bands'),('Push Ups','Resistance Bands'),('Rowing Machine','Rowing Ergometer'),('Rowing Sprints','Rowing Ergometer'),('Rowing Machine','Rowing Machine'),('Seated Row','Seated Row Machine'),('Calf Raise','Smith Machine'),('Spinning Class','Spin Bike'),('Stationary Bike','Spin Bike'),('Barbell Squat','Squat Rack'),('Bench Press','Squat Rack'),('Decline Bench Press','Squat Rack'),('Front Squat','Squat Rack'),('Incline Bench Press','Squat Rack'),('Stair Climber','Stair Climber'),('Stair Sprint','Stair Climber'),('Stationary Bike','Stationary Bike'),('Trap Bar Deadlift','Trap Bar'),('Treadmill Running','Treadmill'),('Walking','Treadmill'),('Barbell Bicep Curl','Weight Plates'),('Barbell Deadlift','Weight Plates'),('Barbell Shoulder Press','Weight Plates'),('Barbell Squat','Weight Plates'),('Bench Press','Weight Plates'),('Bent Over Barbell Row','Weight Plates'),('Decline Bench Press','Weight Plates'),('Front Squat','Weight Plates'),('Incline Bench Press','Weight Plates'),('Romanian Deadlift','Weight Plates'),('Sumo Deadlift','Weight Plates'),('Trap Bar Deadlift','Weight Plates');
/*!40000 ALTER TABLE `exercise_equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food` (
  `food_name` varchar(64) NOT NULL,
  `serving_size` varchar(64) NOT NULL DEFAULT '100g',
  `calories` decimal(7,2) GENERATED ALWAYS AS ((((`carbohydrate` * 4) + (`protein` * 4)) + (`fat` * 9))) STORED,
  `carbohydrate` decimal(5,2) NOT NULL,
  `protein` decimal(5,2) NOT NULL,
  `fat` decimal(5,2) NOT NULL,
  PRIMARY KEY (`food_name`),
  CONSTRAINT `food_carbohydrate_chk` CHECK ((`carbohydrate` >= 0)),
  CONSTRAINT `food_fat_chk` CHECK ((`fat` >= 0)),
  CONSTRAINT `food_protein_chk` CHECK ((`protein` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food`
--

LOCK TABLES `food` WRITE;
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
INSERT INTO `food` (`food_name`, `serving_size`, `carbohydrate`, `protein`, `fat`) VALUES ('Almonds','100g',22.00,21.00,49.00),('Avocado','100g',9.00,2.00,15.00),('Banana','100g',23.00,1.10,0.30),('Broccoli','100g',7.00,2.80,0.40),('Brown Rice','100g',23.00,2.50,0.90),('Chicken Breast','100g',0.00,31.00,3.60),('Eggs','100g',0.70,13.00,9.50),('Greek Yogurt','100g',3.60,10.00,0.40),('Oatmeal','100g',12.00,2.50,1.50),('Quinoa','100g',21.00,4.40,1.90),('Salmon','100g',0.00,25.00,8.50),('Spinach','100g',3.60,2.90,0.40),('Sweet Potato','100g',20.00,2.00,0.20),('Tuna','100g',0.00,26.00,0.80),('Whole Wheat Bread','100g',41.00,13.00,3.40);
/*!40000 ALTER TABLE `food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_condition`
--

DROP TABLE IF EXISTS `health_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_condition` (
  `user_id` int NOT NULL,
  `create_at` date NOT NULL,
  `weight` decimal(5,2) NOT NULL,
  `body_fat_percent` decimal(5,2) NOT NULL,
  PRIMARY KEY (`user_id`,`create_at`),
  CONSTRAINT `health_condition_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `health_body_fat_chk` CHECK (((`body_fat_percent` >= 0) and (`body_fat_percent` <= 100))),
  CONSTRAINT `health_weight_chk` CHECK ((`weight` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_condition`
--

LOCK TABLES `health_condition` WRITE;
/*!40000 ALTER TABLE `health_condition` DISABLE KEYS */;
/*!40000 ALTER TABLE `health_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lifting`
--

DROP TABLE IF EXISTS `lifting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lifting` (
  `exercise_name` varchar(64) NOT NULL,
  PRIMARY KEY (`exercise_name`),
  CONSTRAINT `lifting_fk` FOREIGN KEY (`exercise_name`) REFERENCES `exercise` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lifting`
--

LOCK TABLES `lifting` WRITE;
/*!40000 ALTER TABLE `lifting` DISABLE KEYS */;
INSERT INTO `lifting` VALUES ('Barbell Bicep Curl'),('Barbell Deadlift'),('Barbell Shoulder Press'),('Barbell Squat'),('Bench Press'),('Bent Over Barbell Row'),('Cable Crunch'),('Calf Raise'),('Chin Ups'),('Decline Bench Press'),('Dumbbell Bicep Curl'),('Dumbbell Chest Press'),('Dumbbell Flies'),('Dumbbell Row'),('Dumbbell Shoulder Press'),('Front Raise'),('Front Squat'),('Goblet Squat'),('Hammer Curl'),('Hamstring Curl'),('Hanging Leg Raise'),('Incline Bench Press'),('Lat Pulldown'),('Lateral Raise'),('Leg Extension'),('Leg Press'),('Overhead Tricep Extension'),('Plank'),('Pull Ups'),('Push Ups'),('Rear Delt Fly'),('Romanian Deadlift'),('Russian Twists'),('Seated Row'),('Sumo Deadlift'),('Trap Bar Deadlift'),('Tricep Dips'),('Tricep Rope Pushdown');
/*!40000 ALTER TABLE `lifting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lifting_muscle`
--

DROP TABLE IF EXISTS `lifting_muscle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lifting_muscle` (
  `exercise_name` varchar(64) NOT NULL,
  `muscle_name` varchar(64) NOT NULL,
  PRIMARY KEY (`exercise_name`,`muscle_name`),
  KEY `lifting_muscle_muscle_fk` (`muscle_name`),
  CONSTRAINT `lifting_muscle_lifting_fk` FOREIGN KEY (`exercise_name`) REFERENCES `lifting` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lifting_muscle_muscle_fk` FOREIGN KEY (`muscle_name`) REFERENCES `muscle` (`muscle_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lifting_muscle`
--

LOCK TABLES `lifting_muscle` WRITE;
/*!40000 ALTER TABLE `lifting_muscle` DISABLE KEYS */;
INSERT INTO `lifting_muscle` VALUES ('Barbell Shoulder Press','Anterior Deltoid'),('Bench Press','Anterior Deltoid'),('Dumbbell Chest Press','Anterior Deltoid'),('Dumbbell Shoulder Press','Anterior Deltoid'),('Front Raise','Anterior Deltoid'),('Incline Bench Press','Anterior Deltoid'),('Push Ups','Anterior Deltoid'),('Barbell Bicep Curl','Biceps Brachii Long Head'),('Chin Ups','Biceps Brachii Long Head'),('Dumbbell Bicep Curl','Biceps Brachii Long Head'),('Lat Pulldown','Biceps Brachii Long Head'),('Pull Ups','Biceps Brachii Long Head'),('Barbell Bicep Curl','Biceps Brachii Short Head'),('Dumbbell Bicep Curl','Biceps Brachii Short Head'),('Barbell Deadlift','Biceps Femoris'),('Hamstring Curl','Biceps Femoris'),('Romanian Deadlift','Biceps Femoris'),('Sumo Deadlift','Biceps Femoris'),('Trap Bar Deadlift','Biceps Femoris'),('Hammer Curl','Brachialis'),('Hammer Curl','Brachioradialis'),('Barbell Deadlift','Erector Spinae Lumbar'),('Romanian Deadlift','Erector Spinae Lumbar'),('Sumo Deadlift','Erector Spinae Lumbar'),('Russian Twists','External Oblique'),('Calf Raise','Gastrocnemius Lateral Head'),('Calf Raise','Gastrocnemius Medial Head'),('Russian Twists','Internal Oblique'),('Barbell Shoulder Press','Lateral Deltoid'),('Dumbbell Shoulder Press','Lateral Deltoid'),('Lateral Raise','Lateral Deltoid'),('Bent Over Barbell Row','Latissimus Dorsi'),('Chin Ups','Latissimus Dorsi'),('Dumbbell Row','Latissimus Dorsi'),('Lat Pulldown','Latissimus Dorsi'),('Pull Ups','Latissimus Dorsi'),('Seated Row','Latissimus Dorsi'),('Bench Press','Pectoralis Major'),('Decline Bench Press','Pectoralis Major'),('Dumbbell Chest Press','Pectoralis Major'),('Dumbbell Flies','Pectoralis Major'),('Incline Bench Press','Pectoralis Major'),('Push Ups','Pectoralis Major'),('Rear Delt Fly','Posterior Deltoid'),('Cable Crunch','Rectus Abdominis'),('Hanging Leg Raise','Rectus Abdominis'),('Plank','Rectus Abdominis'),('Barbell Squat','Rectus Femoris'),('Front Squat','Rectus Femoris'),('Goblet Squat','Rectus Femoris'),('Leg Extension','Rectus Femoris'),('Leg Press','Rectus Femoris'),('Trap Bar Deadlift','Rectus Femoris'),('Bent Over Barbell Row','Rhomboid Major'),('Dumbbell Row','Rhomboid Major'),('Seated Row','Rhomboid Major'),('Hamstring Curl','Semitendinosus'),('Romanian Deadlift','Semitendinosus'),('Calf Raise','Soleus'),('Lat Pulldown','Teres Major'),('Plank','Transversus Abdominis'),('Bent Over Barbell Row','Trapezius Middle'),('Seated Row','Trapezius Middle'),('Barbell Deadlift','Trapezius Upper'),('Bench Press','Triceps Lateral Head'),('Tricep Dips','Triceps Lateral Head'),('Tricep Rope Pushdown','Triceps Lateral Head'),('Barbell Shoulder Press','Triceps Long Head'),('Bench Press','Triceps Long Head'),('Decline Bench Press','Triceps Long Head'),('Dumbbell Chest Press','Triceps Long Head'),('Incline Bench Press','Triceps Long Head'),('Overhead Tricep Extension','Triceps Long Head'),('Push Ups','Triceps Long Head'),('Tricep Dips','Triceps Long Head'),('Tricep Rope Pushdown','Triceps Long Head'),('Barbell Squat','Vastus Lateralis'),('Front Squat','Vastus Lateralis'),('Goblet Squat','Vastus Lateralis'),('Leg Extension','Vastus Lateralis'),('Leg Press','Vastus Lateralis'),('Barbell Squat','Vastus Medialis');
/*!40000 ALTER TABLE `lifting_muscle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lifting_section`
--

DROP TABLE IF EXISTS `lifting_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lifting_section` (
  `lifting_section_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `exercise_name` varchar(64) NOT NULL,
  PRIMARY KEY (`lifting_section_id`),
  KEY `lifting_section_fk` (`session_id`),
  KEY `lifting_section_lifting_fk` (`exercise_name`),
  CONSTRAINT `lifting_section_fk` FOREIGN KEY (`session_id`) REFERENCES `user_session` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lifting_section_lifting_fk` FOREIGN KEY (`exercise_name`) REFERENCES `lifting` (`exercise_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lifting_section`
--

LOCK TABLES `lifting_section` WRITE;
/*!40000 ALTER TABLE `lifting_section` DISABLE KEYS */;
/*!40000 ALTER TABLE `lifting_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lifting_set`
--

DROP TABLE IF EXISTS `lifting_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lifting_set` (
  `lifting_section_id` int NOT NULL,
  `set_num` int NOT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `reps` int NOT NULL,
  PRIMARY KEY (`lifting_section_id`,`set_num`),
  CONSTRAINT `lifting_set_section_fk` FOREIGN KEY (`lifting_section_id`) REFERENCES `lifting_section` (`lifting_section_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lifting_reps_chk` CHECK ((`reps` > 0)),
  CONSTRAINT `lifting_set_num_chk` CHECK ((`set_num` >= 1)),
  CONSTRAINT `lifting_weight_chk` CHECK ((`weight` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lifting_set`
--

LOCK TABLES `lifting_set` WRITE;
/*!40000 ALTER TABLE `lifting_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `lifting_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metric`
--

DROP TABLE IF EXISTS `metric`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metric` (
  `metric_id` int NOT NULL AUTO_INCREMENT,
  `aerobics_section_id` int NOT NULL,
  `duration` time DEFAULT NULL,
  `distance` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`metric_id`),
  KEY `metric_section_fk` (`aerobics_section_id`),
  CONSTRAINT `metric_section_fk` FOREIGN KEY (`aerobics_section_id`) REFERENCES `aerobics_section` (`aerobics_section_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metric_distance_chk` CHECK (((`distance` is null) or (`distance` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metric`
--

LOCK TABLES `metric` WRITE;
/*!40000 ALTER TABLE `metric` DISABLE KEYS */;
/*!40000 ALTER TABLE `metric` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `muscle`
--

DROP TABLE IF EXISTS `muscle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `muscle` (
  `muscle_name` varchar(64) NOT NULL,
  `group_name` varchar(64) NOT NULL,
  PRIMARY KEY (`muscle_name`),
  KEY `muscle_group_fk` (`group_name`),
  CONSTRAINT `muscle_group_fk` FOREIGN KEY (`group_name`) REFERENCES `muscle_group` (`group_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `muscle`
--

LOCK TABLES `muscle` WRITE;
/*!40000 ALTER TABLE `muscle` DISABLE KEYS */;
INSERT INTO `muscle` VALUES ('Latissimus Dorsi','Back'),('Rhomboid Major','Back'),('Rhomboid Minor','Back'),('Teres Major','Back'),('Trapezius Lower','Back'),('Trapezius Middle','Back'),('Trapezius Upper','Back'),('Biceps Brachii Long Head','Biceps'),('Biceps Brachii Short Head','Biceps'),('Brachialis','Biceps'),('Brachioradialis','Biceps'),('Gastrocnemius Lateral Head','Calves'),('Gastrocnemius Medial Head','Calves'),('Soleus','Calves'),('Pectoralis Major','Chest'),('Pectoralis Minor','Chest'),('Serratus Anterior','Chest'),('Erector Spinae Lumbar','Core'),('External Oblique','Core'),('Internal Oblique','Core'),('Rectus Abdominis','Core'),('Transversus Abdominis','Core'),('Biceps Femoris','Hamstrings'),('Semimembranosus','Hamstrings'),('Semitendinosus','Hamstrings'),('Rectus Femoris','Quadriceps'),('Vastus Intermedius','Quadriceps'),('Vastus Lateralis','Quadriceps'),('Vastus Medialis','Quadriceps'),('Anterior Deltoid','Shoulders'),('Infraspinatus','Shoulders'),('Lateral Deltoid','Shoulders'),('Posterior Deltoid','Shoulders'),('Subscapularis','Shoulders'),('Supraspinatus','Shoulders'),('Teres Minor','Shoulders'),('Triceps Lateral Head','Triceps'),('Triceps Long Head','Triceps'),('Triceps Medial Head','Triceps');
/*!40000 ALTER TABLE `muscle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `muscle_group`
--

DROP TABLE IF EXISTS `muscle_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `muscle_group` (
  `group_name` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  PRIMARY KEY (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `muscle_group`
--

LOCK TABLES `muscle_group` WRITE;
/*!40000 ALTER TABLE `muscle_group` DISABLE KEYS */;
INSERT INTO `muscle_group` VALUES ('Back','Upper Body'),('Biceps','Upper Body'),('Calves','Lower Body'),('Chest','Upper Body'),('Core','Core'),('Hamstrings','Lower Body'),('Quadriceps','Lower Body'),('Shoulders','Upper Body'),('Triceps','Upper Body');
/*!40000 ALTER TABLE `muscle_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_food`
--

DROP TABLE IF EXISTS `user_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_food` (
  `user_id` int NOT NULL,
  `food_name` varchar(64) NOT NULL,
  `quantity` decimal(5,2) NOT NULL DEFAULT '1.00',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`food_name`,`create_at`),
  KEY `user_food_food_fk` (`food_name`),
  CONSTRAINT `user_food_food_fk` FOREIGN KEY (`food_name`) REFERENCES `food` (`food_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_food_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_food_quantity_chk` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_food`
--

LOCK TABLES `user_food` WRITE;
/*!40000 ALTER TABLE `user_food` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_session`
--

DROP TABLE IF EXISTS `user_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_session` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `note` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `session_ak` (`user_id`,`start_time`,`end_time`),
  CONSTRAINT `session_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `session_time_chk` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_session`
--

LOCK TABLES `user_session` WRITE;
/*!40000 ALTER TABLE `user_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `password` varchar(256) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `users_age_chk` CHECK (((`age` > 0) and (`age` < 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'workout_tracker'
--

--
-- Dumping routines for database 'workout_tracker'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_aerobics_section` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_aerobics_section`(
    IN p_section_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics_section
        WHERE aerobics_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics Section does not exist';
    END IF;

    DELETE FROM aerobics_section
    WHERE aerobics_section_id = p_section_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_aerobics_section_metric` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_aerobics_section_metric`(
    IN p_metric_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM metric
        WHERE metric_id = p_metric_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics metric record does not exist';
    END IF;

    DELETE FROM metric
    WHERE metric_id = p_metric_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_food` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_food`(IN p_food_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    DELETE FROM food
    WHERE food_name = p_food_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_health_condition` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_health_condition`(
    IN p_user_id INT,
    IN p_create_at DATE
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM health_condition
        WHERE user_id = p_user_id AND create_at = p_create_at
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Health condition record does not exist';
    END IF;

    DELETE FROM health_condition
    WHERE user_id = p_user_id
      AND create_at = p_create_at;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_lifting_section` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_lifting_section`(
    IN p_section_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_section
        WHERE lifting_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting Section does not exist';
    END IF;

    DELETE FROM lifting_section
    WHERE lifting_section_id = p_section_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_lifting_section_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_lifting_section_set`(
    IN p_section_id INT,
    IN p_set_num INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_set
        WHERE lifting_section_id = p_section_id 
            AND set_num = p_set_num
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting set record does not exist';
    END IF;

    DELETE FROM lifting_set
    WHERE lifting_section_id = p_section_id 
        AND set_num = p_set_num;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_session`(
    IN p_user_id INT,
    IN p_session_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM user_session
        WHERE session_id = p_session_id
          AND user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist for this user';
    END IF;

    DELETE FROM user_session
    WHERE session_id = p_session_id
      AND user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_user`(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    DELETE FROM users
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_user_food_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_user_food_log`(
    IN p_user_id INT,
    IN p_food_name VARCHAR(64),
    IN p_create_at DATETIME
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM user_food
        WHERE user_id = p_user_id 
          AND food_name = p_food_name
          AND create_at = p_create_at
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User food log entry does not exist';
    END IF;

    DELETE FROM user_food
    WHERE user_id = p_user_id
      AND food_name = p_food_name
      AND create_at = p_create_at;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_aerobics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_aerobics`()
BEGIN
    SELECT ex.exercise_name, ex.description
    FROM aerobics AS a
    JOIN exercise AS ex ON a.exercise_name = ex.exercise_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_aerobics_by_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_aerobics_by_name`(IN p_aerobics_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics WHERE exercise_name = p_aerobics_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics exercise does not exist';
    END IF;

    SELECT ex.exercise_name, ex.description
    FROM aerobics AS a
    JOIN exercise AS ex ON a.exercise_name = ex.exercise_name
    WHERE a.exercise_name = p_aerobics_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_aerobics_section_metric` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_aerobics_section_metric`(
    IN p_section_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics_section 
        WHERE aerobics_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics Section does not exist';
    END IF;

    SELECT duration, distance
    FROM metric
    WHERE aerobics_section_id = p_section_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_all_foods` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_all_foods`()
BEGIN
    SELECT * FROM food;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_all_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_all_users`()
BEGIN
    SELECT * FROM users;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_equipments_by_exercise_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_equipments_by_exercise_name`(IN p_exercise_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM exercise WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exercise does not exist';
    END IF;

    SELECT e.*
    FROM exercise_equipment AS ee
    JOIN equipment AS e ON ee.equipment_name = e.equipment_name
    WHERE ee.exercise_name = p_exercise_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_exercises` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_exercises`()
BEGIN
    SELECT exercise_name, description
    FROM exercise;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_exercise_by_equipment_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_exercise_by_equipment_name`(IN p_equipment_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM equipment WHERE equipment_name = p_equipment_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Equipment does not exist';
    END IF;

    SELECT ex.*
    FROM exercise_equipment AS ee
    JOIN exercise AS ex ON ee.exercise_name = ex.exercise_name
    WHERE ee.equipment_name = p_equipment_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_exercise_by_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_exercise_by_name`(IN p_exercise_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM exercise WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exercise does not exist';
    END IF;

    SELECT * FROM exercise
    WHERE exercise_name = p_exercise_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_exercise_section_by_session_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_exercise_section_by_session_id`(IN p_session_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    SELECT exercise_name
    FROM lifting_section
    WHERE session_id = p_session_id
    UNION
    SELECT exercise_name
    FROM aerobics_section
    WHERE session_id = p_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_food` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_food`(IN p_food_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    SELECT * FROM food
    WHERE food_name = p_food_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_foods_by_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_foods_by_user_id`(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT f.*, uf.quantity, uf.create_at
    FROM user_food AS uf
    JOIN food AS f ON uf.food_name = f.food_name
    WHERE uf.user_id = p_user_id
    ORDER BY uf.create_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_group_muscle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_group_muscle`(IN p_group_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM muscle_group WHERE group_name = p_group_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Muscle group does not exist';
    END IF;

    SELECT *
    FROM muscle
    WHERE group_name = p_group_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_health_conditions_by_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_health_conditions_by_user_id`(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT *
    FROM health_condition
    WHERE user_id = p_user_id
    ORDER BY create_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_liftings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_liftings`()
BEGIN
    SELECT ex.exercise_name, ex.description
    FROM lifting AS l
    JOIN exercise AS ex ON l.exercise_name = ex.exercise_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_liftings_by_muscle_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_liftings_by_muscle_name`(IN p_muscle_name VARCHAR(64))
BEGIN
    -- Muscle must exist
    IF NOT EXISTS (
        SELECT 1 FROM muscle WHERE muscle_name = p_muscle_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Muscle does not exist';
    END IF;

    SELECT ex.*
    FROM lifting_muscle AS lm
    JOIN lifting AS l ON lm.exercise_name = l.exercise_name
    JOIN exercise AS ex ON l.exercise_name = ex.exercise_name
    WHERE lm.muscle_name = p_muscle_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_lifting_by_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_lifting_by_name`(IN p_lifting_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting WHERE exercise_name = p_lifting_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting exercise does not exist';
    END IF;

    SELECT ex.exercise_name, ex.description
    FROM lifting AS l
    JOIN exercise AS ex ON l.exercise_name = ex.exercise_name
    WHERE l.exercise_name = p_lifting_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_lifting_section_sets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_lifting_section_sets`(
    IN p_section_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_section
        WHERE lifting_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting Section does not exist';
    END IF;

    SELECT *
    FROM lifting_set
    WHERE lifting_section_id = p_section_id
    ORDER BY set_num;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_muscles_by_lifting_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_muscles_by_lifting_name`(IN p_lifting_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting WHERE exercise_name = p_lifting_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting exercise does not exist';
    END IF;

    SELECT m.*
    FROM lifting_muscle AS lm
    JOIN muscle AS m ON lm.muscle_name = m.muscle_name
    WHERE lm.exercise_name = p_lifting_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_muscle_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_muscle_group`(IN p_muscle_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM muscle WHERE muscle_name = p_muscle_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Muscle does not exist';
    END IF;

    SELECT mg.*
    FROM muscle AS m
    JOIN muscle_group AS mg ON m.group_name = mg.group_name
    WHERE m.muscle_name = p_muscle_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_sessions_by_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_sessions_by_user_id`(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT *
    FROM user_session
    WHERE user_id = p_user_id
    ORDER BY start_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fetch_user_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fetch_user_by_id`(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT * FROM users
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_aerobics_section` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_aerobics_section`(
    IN p_session_id INT,
    IN p_aerobics_name VARCHAR(64)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM aerobics WHERE exercise_name = p_aerobics_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics does not exist';
    END IF;

    INSERT INTO aerobics_section (session_id, exercise_name)
    VALUES (p_session_id, p_aerobics_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_aerobics_section_metric` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_aerobics_section_metric`(
    IN p_section_id INT,
    IN p_duration VARCHAR(64),
    IN p_distance DECIMAL(6,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics_section 
        WHERE aerobics_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics Section does not exist';
    END IF;

    INSERT INTO metric (aerobics_section_id, duration, distance)
    VALUES (p_section_id, p_duration, p_distance);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_food` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_food`(
    IN p_food_name VARCHAR(64),
    IN p_serving_size VARCHAR(64),
    IN p_carbohydrate DECIMAL(5,2),
    IN p_protein DECIMAL(5,2),
    IN p_fat DECIMAL(5,2)
)
BEGIN
    INSERT INTO food (food_name, serving_size, carbohydrate, protein, fat)
    VALUES (p_food_name, p_serving_size, p_carbohydrate, p_protein, p_fat);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_lifting_section` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_lifting_section`(
    IN p_session_id INT,
    IN p_exercise_name VARCHAR(64)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM lifting WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting does not exist';
    END IF;

    INSERT INTO lifting_section (session_id, exercise_name)
    VALUES (p_session_id, p_exercise_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_lifting_section_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_lifting_section_set`(
    IN p_section_id INT,
    IN p_set_num INT,
    IN p_weight DECIMAL(5,2),
    IN p_reps INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_section
        WHERE lifting_section_id = p_section_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting Section does not exist';
    END IF;

    INSERT INTO lifting_set (lifting_section_id, set_num, weight, reps)
    VALUES (p_section_id, p_set_num, p_weight, p_reps);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_session`(
    IN p_user_id INT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME,
    IN p_note VARCHAR(256)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    INSERT INTO user_session (user_id, start_time, end_time, note)
    VALUES (p_user_id, p_start_time, p_end_time, p_note);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user`(
    IN p_first_name VARCHAR(64),
    IN p_last_name VARCHAR(64),
    IN p_email VARCHAR(128),
    IN p_password VARCHAR(256),
    IN p_age INT,
    IN p_gender ENUM('Male', 'Female', 'Other')
)
BEGIN
    INSERT INTO users (first_name, last_name, email, password, age, gender)
    VALUES (p_first_name, p_last_name, p_email, p_password, p_age, p_gender);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_user_food_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user_food_log`(
    IN p_user_id INT,
    IN p_food_name VARCHAR(64),
    IN p_create_at DATETIME,
    IN p_quantity DECIMAL(5,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    INSERT INTO user_food (user_id, food_name, quantity, create_at)
    VALUES (p_user_id, p_food_name, p_quantity, p_create_at);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insert_user_health_condition` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user_health_condition`(
    IN p_user_id INT,
    IN p_create_at DATE,
    IN p_weight DECIMAL(5,2),
    IN p_body_fat_percent DECIMAL(5,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    INSERT INTO health_condition (user_id, create_at, weight, body_fat_percent)
    VALUES (p_user_id, p_create_at, p_weight, p_body_fat_percent);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_aerobics_section_metric` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_aerobics_section_metric`(
    IN p_metric_id INT,
    IN p_duration VARCHAR(64),
    IN p_distance DECIMAL(6,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM metric
        WHERE metric_id = p_metric_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics metric record does not exist';
    END IF;

    UPDATE metric
    SET duration = p_duration,
        distance = p_distance
    WHERE metric_id = p_metric_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_food` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_food`(
    IN p_food_name VARCHAR(64),
    IN p_serving_size VARCHAR(64),
    IN p_carbohydrate DECIMAL(5,2),
    IN p_protein DECIMAL(5,2),
    IN p_fat DECIMAL(5,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    UPDATE food
    SET serving_size = p_serving_size,
        carbohydrate = p_carbohydrate,
        protein = p_protein,
        fat = p_fat
    WHERE food_name = p_food_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_lifting_section_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_lifting_section_set`(
    IN p_section_id INT,
    IN p_set_num INT,
    IN p_weight DECIMAL(5,2),
    IN p_reps INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_set
        WHERE lifting_section_id = p_section_id 
            AND set_num = p_set_num
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting set record does not exist';
    END IF;

    UPDATE lifting_set
    SET weight = p_weight,
        reps = p_reps
    WHERE lifting_section_id = p_section_id 
        AND set_num = p_set_num;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_session`(
    IN p_user_id INT,
    IN p_session_id INT,
    IN p_start_time DATETIME,
    IN p_end_time DATETIME,
    IN p_note VARCHAR(256)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM user_session
        WHERE session_id = p_session_id
          AND user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist for this user';
    END IF;

    UPDATE user_session
    SET start_time = p_start_time,
        end_time   = p_end_time,
        note       = p_note
    WHERE session_id = p_session_id
      AND user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user`(
    IN p_user_id INT,
    IN p_first_name VARCHAR(64),
    IN p_last_name VARCHAR(64),
    IN p_email VARCHAR(128),
    IN p_password VARCHAR(255),
    IN p_age INT,
    IN p_gender ENUM('Male', 'Female', 'Other')
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    UPDATE users
    SET first_name = p_first_name,
        last_name = p_last_name,
        email = p_email,
        password = p_password,
        age = p_age,
        gender = p_gender
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-04 17:51:40
