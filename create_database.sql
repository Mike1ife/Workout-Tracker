DROP DATABASE IF EXISTS workout_tracker;
CREATE DATABASE workout_tracker;
USE workout_tracker;

-- User
CREATE TABLE users (
   user_id INT AUTO_INCREMENT,
   first_name VARCHAR(64) NOT NULL,
   last_name VARCHAR(64) NOT NULL,
   email VARCHAR(128) UNIQUE NOT NULL,
   age INT,
   gender ENUM('Male', 'Female', 'Other'),
   CONSTRAINT users_age_chk CHECK (age > 0 AND age < 100),
   CONSTRAINT user_pk PRIMARY KEY(user_id)
);

-- Food
CREATE TABLE food (
  food_name VARCHAR(64) NOT NULL,
  calories DECIMAL(7,2) AS (carbohydrate * 4 + protein * 4 + fat * 9) STORED,
  carbohydrate DEC(5,2) NOT NULL,
  protein DEC(5,2) NOT NULL,
  fat DEC(5,2) NOT NULL,
  CONSTRAINT food_carbohydrate_chk CHECK (carbohydrate >= 0),
  CONSTRAINT food_protein_chk CHECK (protein >= 0),
  CONSTRAINT food_fat_chk CHECK (fat >= 0),
  CONSTRAINT food_pk PRIMARY KEY (food_name)
);

-- User Food
CREATE TABLE user_food (
  user_id INT NOT NULL,
  food_name VARCHAR(64) NOT NULL,
  CONSTRAINT user_food_pk PRIMARY KEY (user_id, food_name),
  CONSTRAINT user_food_user_fk FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT user_food_food_fk FOREIGN KEY (food_name) REFERENCES food(food_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Health Condition
CREATE TABLE health_condition(
  user_id INT NOT NULL,
  create_at DATETIME NOT NULL,
  weight DEC(5,2) NOT NULL,
  body_fat_percent DEC(5,2) NOT NULL,
  CONSTRAINT health_weight_chk CHECK (weight > 0),
  CONSTRAINT health_body_fat_chk CHECK (body_fat_percent >= 0 AND body_fat_percent <= 100),
  CONSTRAINT health_condition_pk PRIMARY KEY(user_id, create_at),
  CONSTRAINT health_condition_fk FOREIGN KEY(user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Session
CREATE TABLE user_session(
  session_id INT AUTO_INCREMENT,
  user_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  note VARCHAR(256),
  CONSTRAINT session_time_chk CHECK (end_time > start_time),
  CONSTRAINT session_pk PRIMARY KEY(session_id),
  CONSTRAINT session_ak UNIQUE(user_id, start_time, end_time),
  CONSTRAINT session_fk FOREIGN KEY(user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Exercise
CREATE TABLE exercise(
  exercise_name VARCHAR(64) NOT NULL,
  description VARCHAR(256),
  CONSTRAINT exercise_pk PRIMARY KEY(exercise_name)
);

-- Session Exercise
CREATE TABLE session_exercise(
	session_id INT NOT NULL,
    exercise_name VARCHAR(64) NOT NULL,
    CONSTRAINT session_exercise_pk PRIMARY KEY(session_id, exercise_name),
    CONSTRAINT session_exercise_session_fk FOREIGN KEY(session_id) REFERENCES user_session(session_id)
	  ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT session_exercise_exercise_fk FOREIGN KEY(exercise_name) REFERENCES exercise(exercise_name)
	  ON UPDATE CASCADE ON DELETE CASCADE
);

-- Lifting
CREATE TABLE lifting(
  exercise_name VARCHAR(64) NOT NULL,
  CONSTRAINT lifting_pk PRIMARY KEY(exercise_name),
  CONSTRAINT lifting_fk FOREIGN KEY(exercise_name) REFERENCES exercise(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Equipment
CREATE TABLE equipment(
  equipment_name VARCHAR(64) NOT NULL,
  description VARCHAR(256),
  CONSTRAINT equipment_pk PRIMARY KEY(equipment_name)
);

-- Lifting Equipment
CREATE TABLE lifting_equipment (
  exercise_name  VARCHAR(64) NOT NULL,
  equipment_name VARCHAR(64) NOT NULL,
  CONSTRAINT lifting_equipment_pk PRIMARY KEY (exercise_name, equipment_name),
  CONSTRAINT lifting_equipment_lifting_fk FOREIGN KEY (exercise_name) REFERENCES lifting(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT lifting_equipment_equipment_fk FOREIGN KEY (equipment_name) REFERENCES equipment(equipment_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Muscle Group
CREATE TABLE muscle_group(
  group_name VARCHAR(64) NOT NULL,
  type VARCHAR(64) NOT NULL,
  CONSTRAINT muscle_group_pk PRIMARY KEY(group_name)
);

-- Muscle
CREATE TABLE muscle(
  muscle_name VARCHAR(64) NOT NULL,
  group_name VARCHAR(64) NOT NULL,
  CONSTRAINT muscle_pk PRIMARY KEY(muscle_name),
  CONSTRAINT muscle_group_fk FOREIGN KEY (group_name) REFERENCES muscle_group(group_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Lifting Muscle
CREATE TABLE lifting_muscle (
  exercise_name VARCHAR(64) NOT NULL,
  muscle_name   VARCHAR(64) NOT NULL,
  CONSTRAINT lifting_muscle_pk PRIMARY KEY (exercise_name, muscle_name),
  CONSTRAINT lifting_muscle_lifting_fk FOREIGN KEY (exercise_name) REFERENCES lifting(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT lifting_muscle_muscle_fk FOREIGN KEY (muscle_name) REFERENCES muscle(muscle_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Lifting Set
CREATE TABLE lifting_set (
  session_id INT NOT NULL,
  exercise_name VARCHAR(64) NOT NULL,
  set_num INT NOT NULL,
  weight DECIMAL(5,2) NOT NULL,
  reps INT NOT NULL,
  CONSTRAINT lifting_set_num_chk CHECK (set_num >= 1),
  CONSTRAINT lifting_weight_chk CHECK (weight >= 0),
  CONSTRAINT lifting_reps_chk CHECK (reps > 0),
  CONSTRAINT lifting_set_pk PRIMARY KEY (session_id, exercise_name, set_num),
  CONSTRAINT lifting_set_session_fk FOREIGN KEY (session_id) REFERENCES user_session(session_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT lifting_set_lifting_fk FOREIGN KEY (exercise_name) REFERENCES lifting(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Aerobics
CREATE TABLE aerobics (
  exercise_name VARCHAR(64) NOT NULL,
  CONSTRAINT aerobics_pk PRIMARY KEY(exercise_name),
  CONSTRAINT aerobics_fk FOREIGN KEY(exercise_name) REFERENCES exercise(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Aerobics Metric
CREATE TABLE aerobics_metric (
  session_id INT NOT NULL,
  exercise_name VARCHAR(64) NOT NULL,
  duration TIME NOT NULL,
  distance DEC(6,2) NOT NULL,
  CONSTRAINT aerobics_distance_chk CHECK (distance > 0),
  CONSTRAINT aerobics_metric_pk PRIMARY KEY (session_id, exercise_name),
  CONSTRAINT aerobics_metric_session_fk FOREIGN KEY (session_id) REFERENCES user_session(session_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT aerobics_metric_aerobics_fk FOREIGN KEY (exercise_name) REFERENCES aerobics(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);
