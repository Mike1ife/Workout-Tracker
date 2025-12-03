DROP DATABASE IF EXISTS workout_tracker;
CREATE DATABASE workout_tracker;
USE workout_tracker;

-- User
CREATE TABLE users (
   user_id INT AUTO_INCREMENT,
   first_name VARCHAR(64) NOT NULL,
   last_name VARCHAR(64) NOT NULL,
   email VARCHAR(128) UNIQUE NOT NULL,
   password VARCHAR(255) NOT NULL,
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
  create_at DATETIME DEFAULT NOW(),
  CONSTRAINT user_food_pk PRIMARY KEY (user_id, food_name, create_at),
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

-- Equipment
CREATE TABLE equipment(
  equipment_name VARCHAR(64) NOT NULL,
  description VARCHAR(256),
  CONSTRAINT equipment_pk PRIMARY KEY(equipment_name)
);

-- Exercise Equipment
CREATE TABLE exercise_equipment (
  exercise_name  VARCHAR(64) NOT NULL,
  equipment_name VARCHAR(64) NOT NULL,
  CONSTRAINT exercise_equipment_pk PRIMARY KEY (exercise_name, equipment_name),
  CONSTRAINT exercise_equipment_exercise_fk FOREIGN KEY (exercise_name) REFERENCES exercise(exercise_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT exercise_equipment_equipment_fk FOREIGN KEY (equipment_name) REFERENCES equipment(equipment_name)
    ON UPDATE CASCADE ON DELETE CASCADE
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
  muscle_name VARCHAR(64) NOT NULL,
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
  weight DECIMAL(5,2),
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

-- Stored Procedure for Backend

DELIMITER $$

CREATE PROCEDURE sp_fetch_all_users()
BEGIN
    SELECT * FROM users;
END $$

CREATE PROCEDURE sp_fetch_user_by_id(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT * FROM users
    WHERE user_id = p_user_id;
END $$

CREATE PROCEDURE sp_insert_user(
    IN p_first_name VARCHAR(64),
    IN p_last_name VARCHAR(64),
    IN p_email VARCHAR(128),
    IN p_password VARCHAR(255),
    IN p_age INT,
    IN p_gender ENUM('Male', 'Female', 'Other')
)
BEGIN
    INSERT INTO users (first_name, last_name, email, password, age, gender)
    VALUES (p_first_name, p_last_name, p_email, p_password, p_age, p_gender);
END $$

CREATE PROCEDURE sp_update_user(
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
END $$

CREATE PROCEDURE sp_delete_user(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    DELETE FROM users
    WHERE user_id = p_user_id;
END $$

CREATE PROCEDURE sp_fetch_all_foods()
BEGIN
    SELECT * FROM food;
END $$

CREATE PROCEDURE sp_fetch_food(IN p_food_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    SELECT * FROM food
    WHERE food_name = p_food_name;
END $$

CREATE PROCEDURE sp_fetch_foods_by_user_id(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT f.*, uf.create_at
    FROM user_food AS uf
    JOIN food AS f ON uf.food_name = f.food_name
    WHERE uf.user_id = p_user_id;
END $$

CREATE PROCEDURE sp_insert_food(
    IN p_food_name VARCHAR(64),
    IN p_carbohydrate DECIMAL(5,2),
    IN p_protein DECIMAL(5,2),
    IN p_fat DECIMAL(5,2)
)
BEGIN
    INSERT INTO food (food_name, carbohydrate, protein, fat)
    VALUES (p_food_name, p_carbohydrate, p_protein, p_fat);
END $$

CREATE PROCEDURE sp_insert_user_food_log(
    IN p_user_id INT,
    IN p_food_name VARCHAR(64),
    IN p_create_at DATETIME
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

    INSERT INTO user_food (user_id, food_name, create_at)
    VALUES (p_user_id, p_food_name, p_create_at);
END $$

CREATE PROCEDURE sp_update_food(
    IN p_food_name VARCHAR(64),
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
    SET carbohydrate = p_carbohydrate,
        protein = p_protein,
        fat = p_fat
    WHERE food_name = p_food_name;
END $$

CREATE PROCEDURE sp_delete_food(IN p_food_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM food WHERE food_name = p_food_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Food does not exist';
    END IF;

    DELETE FROM food
    WHERE food_name = p_food_name;
END $$

CREATE PROCEDURE sp_fetch_health_conditions_by_user_id(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT *
    FROM health_condition
    WHERE user_id = p_user_id
    ORDER BY create_at DESC;
END $$

CREATE PROCEDURE sp_insert_user_health_condition(
    IN p_user_id INT,
    IN p_create_at DATETIME,
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
END $$

CREATE PROCEDURE sp_delete_health_condition(
    IN p_user_id INT,
    IN p_create_at DATETIME
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
END $$

CREATE PROCEDURE sp_fetch_sessions_by_user_id(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    SELECT *
    FROM user_session
    WHERE user_id = p_user_id
    ORDER BY start_time DESC;
END $$

CREATE PROCEDURE sp_insert_session(
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
END $$

CREATE PROCEDURE sp_update_session(
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
END $$

CREATE PROCEDURE sp_delete_session(
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
END $$

CREATE PROCEDURE sp_insert_session_exercise(
    IN p_session_id INT,
    IN p_exercise_name VARCHAR(64)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM exercise WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exercise does not exist';
    END IF;

    INSERT INTO session_exercise (session_id, exercise_name)
    VALUES (p_session_id, p_exercise_name);
END $$

CREATE PROCEDURE sp_delete_session_exercise(
    IN p_session_id INT,
    IN p_exercise_name VARCHAR(64)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM session_exercise
        WHERE session_id = p_session_id
          AND exercise_name = p_exercise_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session exercise record does not exist';
    END IF;

    DELETE FROM session_exercise
    WHERE session_id = p_session_id
      AND exercise_name = p_exercise_name;
END $$

CREATE PROCEDURE sp_fetch_exercises()
BEGIN
    SELECT exercise_name, description
    FROM exercise;
END $$

CREATE PROCEDURE sp_fetch_exercise_by_name(IN p_exercise_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM exercise WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exercise does not exist';
    END IF;

    SELECT * FROM exercise
    WHERE exercise_name = p_exercise_name;
END $$

CREATE PROCEDURE sp_fetch_equipments_by_exercise_name(IN p_exercise_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM exercise WHERE exercise_name = p_exercise_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exercise does not exist';
    END IF;

    SELECT e.*
    FROM exercise_equipment AS ee
    JOIN equipment AS e ON ee.equipment_name = e.equipment_name
    WHERE ee.exercise_name = p_exercise_name;
END $$

CREATE PROCEDURE sp_fetch_exercise_by_equipment_name(IN p_equipment_name VARCHAR(64))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM equipment WHERE equipment_name = p_equipment_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Equipment does not exist';
    END IF;

    SELECT ex.*
    FROM exercise_equipment AS ee
    JOIN exercise AS ex ON ee.exercise_name = ex.exercise_name
    WHERE ee.equipment_name = p_equipment_name;
END $$

CREATE PROCEDURE sp_fetch_aerobics()
BEGIN
    SELECT ex.exercise_name, ex.description
    FROM aerobics AS a
    JOIN exercise AS ex ON a.exercise_name = ex.exercise_name;
END $$

CREATE PROCEDURE sp_fetch_aerobics_by_name(IN p_aerobics_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_insert_aerobics_metric(
    IN p_session_id INT,
    IN p_aerobics_name VARCHAR(64),
    IN p_duration TIME,
    IN p_distance DECIMAL(6,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM user_session WHERE session_id = p_session_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM aerobics WHERE exercise_name = p_aerobics_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics exercise does not exist';
    END IF;

    INSERT INTO aerobics_metric (session_id, exercise_name, duration, distance)
    VALUES (p_session_id, p_aerobics_name, p_duration, p_distance);
END $$

CREATE PROCEDURE sp_fetch_metrics(
    IN p_aerobics_name VARCHAR(64),
    IN p_session_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM user_session WHERE session_id = p_session_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM aerobics WHERE exercise_name = p_aerobics_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics exercise does not exist';
    END IF;

    SELECT *
    FROM aerobics_metric
    WHERE session_id = p_session_id
      AND exercise_name = p_aerobics_name;
END $$

CREATE PROCEDURE sp_update_aerobics_metric(
    IN p_session_id INT,
    IN p_aerobics_name VARCHAR(64),
    IN p_duration TIME,
    IN p_distance DECIMAL(6,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics_metric
        WHERE session_id = p_session_id
          AND exercise_name = p_aerobics_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics metric record does not exist';
    END IF;

    UPDATE aerobics_metric
    SET duration = p_duration,
        distance = p_distance
    WHERE session_id = p_session_id
      AND exercise_name = p_aerobics_name;
END $$

CREATE PROCEDURE sp_delete_aerobics_metric(
    IN p_session_id INT,
    IN p_aerobics_name VARCHAR(64)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM aerobics_metric
        WHERE session_id = p_session_id
          AND exercise_name = p_aerobics_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Aerobics metric record does not exist';
    END IF;

    DELETE FROM aerobics_metric
    WHERE session_id = p_session_id
      AND exercise_name = p_aerobics_name;
END $$

CREATE PROCEDURE sp_fetch_liftings()
BEGIN
    SELECT ex.exercise_name, ex.description
    FROM lifting AS l
    JOIN exercise AS ex ON l.exercise_name = ex.exercise_name;
END $$

CREATE PROCEDURE sp_fetch_lifting_by_name(IN p_lifting_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_insert_lifting_set(
    IN p_session_id INT,
    IN p_lifting_name VARCHAR(64),
    IN p_set_num INT,
    IN p_weight DECIMAL(5,2),
    IN p_reps INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM lifting WHERE exercise_name = p_lifting_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting exercise does not exist';
    END IF;

    INSERT INTO lifting_set (session_id, exercise_name, set_num, weight, reps)
    VALUES (p_session_id, p_lifting_name, p_set_num, p_weight, p_reps);
END $$

CREATE PROCEDURE sp_fetch_sets(
    IN p_lifting_name VARCHAR(64),
    IN p_session_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM lifting WHERE exercise_name = p_lifting_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting exercise does not exist';
    END IF;

    SELECT *
    FROM lifting_set
    WHERE session_id = p_session_id
      AND exercise_name = p_lifting_name
    ORDER BY set_num;
END $$

CREATE PROCEDURE sp_update_lifting_set(
    IN p_session_id INT,
    IN p_lifting_name VARCHAR(64),
    IN p_set_num INT,
    IN p_weight DECIMAL(5,2),
    IN p_reps INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_set
        WHERE session_id = p_session_id
          AND exercise_name = p_lifting_name
          AND set_num = p_set_num
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting set record does not exist';
    END IF;

    UPDATE lifting_set
    SET weight = p_weight,
        reps = p_reps
    WHERE session_id = p_session_id
      AND exercise_name = p_lifting_name
      AND set_num = p_set_num;
END $$

CREATE PROCEDURE sp_delete_lifting_set(
    IN p_session_id INT,
    IN p_lifting_name VARCHAR(64),
    IN p_set_num INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM lifting_set
        WHERE session_id = p_session_id
          AND exercise_name = p_lifting_name
          AND set_num = p_set_num
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lifting set record does not exist';
    END IF;

    DELETE FROM lifting_set
    WHERE session_id = p_session_id
      AND exercise_name = p_lifting_name
      AND set_num = p_set_num;
END $$

CREATE PROCEDURE sp_fetch_muscles_by_lifting_name(IN p_lifting_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_fetch_liftings_by_muscle_name(IN p_muscle_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_fetch_muscle_group(IN p_muscle_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_fetch_group_muscle(IN p_group_name VARCHAR(64))
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
END $$

CREATE PROCEDURE sp_fetch_exercises_by_session_id(IN p_session_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_session WHERE session_id = p_session_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Session does not exist';
    END IF;

    SELECT se.exercise_name
    FROM session_exercise AS se
    WHERE se.session_id = p_session_id;
END $$

DELIMITER ;


-- insert rows into the tables
INSERT INTO exercise (exercise_name, description)
VALUES
('Bench Press', 'Barbell chest press targeting pectorals'),
('Incline Bench Press', 'Incline barbell press for upper chest'),
('Decline Bench Press', 'Decline barbell press for lower chest'),
('Dumbbell Chest Press', 'Dumbbell-based chest pressing movement'),
('Dumbbell Flyes', 'Chest isolation exercise using dumbbells'),
('Push Ups', 'Bodyweight chest push movement'),

('Lat Pulldown', 'Back exercise targeting lats'),
('Seated Row', 'Cable row for mid-back development'),
('Bent Over Barbell Row', 'Compound row movement for back'),
('Dumbbell Row', 'Single-arm dumbbell back row'),
('Pull Ups', 'Bodyweight vertical pulling exercise'),
('Chin Ups', 'Underhand grip pulling movement'),

('Barbell Squat', 'Compound leg movement targeting quads and glutes'),
('Front Squat', 'Barbell squat variation emphasizing quads'),
('Leg Press', 'Machine-based leg press'),
('Romanian Deadlift', 'Deadlift variation for hamstrings'),
('Hamstring Curl', 'Machine-based hamstring isolation'),
('Leg Extension', 'Machine-based quad isolation'),
('Calf Raise', 'Calf-targeting machine or free weight exercise'),
('Goblet Squat', 'Kettlebell squat variation'),

('Barbell Deadlift', 'Full-body compound movement targeting posterior chain'),
('Sumo Deadlift', 'Wide-stance deadlift variation'),
('Trap Bar Deadlift', 'Neutral grip deadlift variation'),

('Barbell Shoulder Press', 'Barbell overhead press for shoulders'),
('Dumbbell Shoulder Press', 'Dumbbell overhead shoulder press'),
('Lateral Raise', 'Dumbbell raise for side delts'),
('Front Raise', 'Dumbbell front shoulder isolation'),
('Rear Delt Fly', 'Rear shoulder isolation movement'),

('Barbell Bicep Curl', 'Free weight curl for biceps'),
('Dumbbell Bicep Curl', 'Dumbbell curl for biceps'),
('Hammer Curl', 'Neutral-grip dumbbell bicep curl'),
('Tricep Rope Pushdown', 'Cable pressdown targeting triceps'),
('Tricep Dips', 'Bodyweight dip movement for triceps'),
('Overhead Tricep Extension', 'Dumbbell tricep isolation exercise'),

('Cable Crunch', 'Weighted abdominal crunch exercise'),
('Plank', 'Core stability bodyweight hold'),
('Hanging Leg Raise', 'Advanced core exercise for lower abs'),
('Russian Twists', 'Rotational ab exercise using weight'),

-- Cardio / Aerobics section (goes into aerobics table too)
('Treadmill Running', 'Indoor running exercise'),
('Stationary Bike', 'Indoor cycling machine'),
('Elliptical Trainer', 'Low-impact cardio machine'),
('Rowing Machine', 'Full-body cardio rowing motion'),
('Stair Climber', 'Cardio machine simulating stair climbing'),
('Jump Rope', 'High intensity rope jumping cardio'),
('Outdoor Running', 'Outdoor jogging or running'),
('Swimming', 'Full-body aerobic swimming exercise'),
('Cycling', 'Outdoor cycling exercise'),
('Hiking', 'Outdoor uphill cardio exercise'),
('Walking', 'Low impact aerobic activity'),
('High Knees', 'Bodyweight cardio warm-up drill'),
('Mountain Climbers', 'Core + cardio bodyweight drill'),
('Burpees', 'High-intensity full-body aerobic drill'),
('Jumping Jacks', 'Full-body cardio warm-up movement'),
('Rowing Sprints', 'High-intensity interval rowing'),
('Spinning Class', 'Indoor group cycling cardio session'),
('Stair Sprint', 'High-intensity stair running interval');

INSERT INTO muscle_group (group_name, type)
VALUES
('Chest','Upper Body'),
('Back', 'Upper Body'),
('Shoulders', 'Upper Body'),
('Biceps', 'Upper Body'),
('Triceps', 'Upper Body'),
('Quadriceps', 'Lower Body'),
('Hamstrings', 'Lower Body'),
('Calves', 'Lower Body'),
('Core', 'Core');

INSERT INTO equipment (equipment_name, description)
VALUES
('Barbell', 'Standard Olympic barbell used for compound lifts'),
('Dumbbells', 'Free weight dumbbells for various exercises'),
('Bench', 'Flat bench for pressing exercises'),
('Incline Bench', 'Incline bench for upper chest exercises'),
('Decline Bench', 'Decline bench for lower chest exercises'),
('Cable Machine', 'Adjustable cable pulley machine'),
('Lat Pulldown Machine', 'Machine for vertical pulling exercises'),
('Seated Row Machine', 'Cable row machine targeting the back'),
('Smith Machine', 'Guided barbell machine for safer lifting'),
('Leg Press Machine', 'Machine used to train quads and glutes'),
('Leg Extension Machine', 'Isolation machine for quadriceps'),
('Hamstring Curl Machine', 'Machine isolating the hamstrings'),
('Calf Raise Machine', 'Machine targeting calf muscles'),
('Squat Rack', 'Rack for squats and barbell lifts'),
('Power Rack', 'Full cage structure for weightlifting'),
('Kettlebell', 'Ball-shaped weight for swings and goblet squats'),
('Pull Up Bar', 'Bar for pull-ups and chin-ups'),
('Dip Bars', 'Parallel bars for tricep dips'),
('Pec Deck Machine', 'Chest fly isolation machine'),
('Chest Press Machine', 'Machine version of chest press exercise'),
('Rowing Machine', 'Cardio machine simulating rowing motion'),
('Treadmill', 'Cardio machine for walking or running'),
('Stationary Bike', 'Indoor cycling machine'),
('Elliptical Trainer', 'Low-impact cardio machine'),
('Stair Climber', 'Cardio machine simulating stair climbing'),
('Spin Bike', 'High-intensity indoor bike'),
('Jump Rope', 'Rope used for cardio skipping exercises'),
('Ab Crunch Machine', 'Machine for abdominal crunches'),
('Medicine Ball', 'Weighted ball for core and strength exercises'),
('Resistance Bands', 'Elastic bands used for resistance training'),
('Trap Bar', 'Hex bar for trap bar deadlifts'),
('Weight Plates', 'Plates added to bars for resistance'),
('EZ Bar', 'Curved bar used for arm exercises'),
('Rowing Ergometer', 'High-performance rowing machine');

INSERT INTO lifting (exercise_name)
SELECT exercise_name
FROM exercise
WHERE exercise_name NOT IN (
  'Treadmill Running',
  'Stationary Bike',
  'Elliptical Trainer',
  'Rowing Machine',
  'Stair Climber',
  'Jump Rope',
  'Outdoor Running',
  'Swimming',
  'Cycling',
  'Hiking',
  'Walking',
  'High Knees',
  'Mountain Climbers',
  'Burpees',
  'Jumping Jacks',
  'Rowing Sprints',
  'Spinning Class',
  'Stair Sprint'
);

INSERT INTO aerobics (exercise_name)
SELECT exercise_name
FROM exercise
WHERE exercise_name IN (
  'Treadmill Running',
  'Stationary Bike',
  'Elliptical Trainer',
  'Rowing Machine',
  'Stair Climber',
  'Jump Rope',
  'Outdoor Running',
  'Swimming',
  'Cycling',
  'Hiking',
  'Walking',
  'High Knees',
  'Mountain Climbers',
  'Burpees',
  'Jumping Jacks',
  'Rowing Sprints',
  'Spinning Class',
  'Stair Sprint'
);

INSERT INTO exercise_equipment (exercise_name, equipment_name)
VALUES
  -- ==== Chest ====
  ('Bench Press',           'Barbell'),
  ('Bench Press',           'Bench'),
  ('Bench Press',           'Squat Rack'),
  ('Bench Press',           'Weight Plates'),

  ('Incline Bench Press',   'Barbell'),
  ('Incline Bench Press',   'Incline Bench'),
  ('Incline Bench Press',   'Squat Rack'),
  ('Incline Bench Press',   'Weight Plates'),

  ('Decline Bench Press',   'Barbell'),
  ('Decline Bench Press',   'Decline Bench'),
  ('Decline Bench Press',   'Squat Rack'),
  ('Decline Bench Press',   'Weight Plates'),

  ('Dumbbell Chest Press',  'Dumbbells'),
  ('Dumbbell Chest Press',  'Bench'),

  ('Dumbbell Flyes',        'Dumbbells'),
  ('Dumbbell Flyes',        'Bench'),
  ('Dumbbell Flyes',        'Pec Deck Machine'),

  ('Push Ups',              'Resistance Bands'),

  -- ==== Back ====
  ('Lat Pulldown',          'Lat Pulldown Machine'),
  ('Lat Pulldown',          'Cable Machine'),

  ('Seated Row',            'Seated Row Machine'),
  ('Seated Row',            'Cable Machine'),

  ('Bent Over Barbell Row', 'Barbell'),
  ('Bent Over Barbell Row', 'Weight Plates'),

  ('Dumbbell Row',          'Dumbbells'),
  ('Dumbbell Row',          'Bench'),

  ('Pull Ups',              'Pull Up Bar'),
  ('Chin Ups',              'Pull Up Bar'),

  -- ==== Legs ====
  ('Barbell Squat',         'Barbell'),
  ('Barbell Squat',         'Squat Rack'),
  ('Barbell Squat',         'Power Rack'),
  ('Barbell Squat',         'Weight Plates'),

  ('Front Squat',           'Barbell'),
  ('Front Squat',           'Squat Rack'),
  ('Front Squat',           'Weight Plates'),

  ('Leg Press',             'Leg Press Machine'),

  ('Romanian Deadlift',     'Barbell'),
  ('Romanian Deadlift',     'Weight Plates'),

  ('Hamstring Curl',        'Hamstring Curl Machine'),

  ('Leg Extension',         'Leg Extension Machine'),

  ('Calf Raise',            'Calf Raise Machine'),
  ('Calf Raise',            'Smith Machine'),

  ('Goblet Squat',          'Kettlebell'),

  -- ==== Deadlift family ====
  ('Barbell Deadlift',      'Barbell'),
  ('Barbell Deadlift',      'Weight Plates'),

  ('Sumo Deadlift',         'Barbell'),
  ('Sumo Deadlift',         'Weight Plates'),

  ('Trap Bar Deadlift',     'Trap Bar'),
  ('Trap Bar Deadlift',     'Weight Plates'),

  -- ==== Shoulders ====
  ('Barbell Shoulder Press','Barbell'),
  ('Barbell Shoulder Press','Bench'),
  ('Barbell Shoulder Press','Power Rack'),
  ('Barbell Shoulder Press','Weight Plates'),

  ('Dumbbell Shoulder Press','Dumbbells'),
  ('Dumbbell Shoulder Press','Bench'),

  ('Lateral Raise',         'Dumbbells'),
  ('Lateral Raise',         'Resistance Bands'),

  ('Front Raise',           'Dumbbells'),
  ('Front Raise',           'Resistance Bands'),

  ('Rear Delt Fly',         'Dumbbells'),
  ('Rear Delt Fly',         'Pec Deck Machine'),

  -- ==== Arms ====
  ('Barbell Bicep Curl',    'EZ Bar'),
  ('Barbell Bicep Curl',    'Weight Plates'),

  ('Dumbbell Bicep Curl',   'Dumbbells'),

  ('Hammer Curl',           'Dumbbells'),

  ('Tricep Rope Pushdown',  'Cable Machine'),

  ('Tricep Dips',           'Dip Bars'),

  ('Overhead Tricep Extension','Dumbbells'),

  -- ==== Core ====
  ('Cable Crunch',          'Cable Machine'),
  ('Cable Crunch',          'Ab Crunch Machine'),

  ('Plank',                 'Medicine Ball'),

  ('Hanging Leg Raise',     'Pull Up Bar'),

  ('Russian Twists',        'Medicine Ball'),

  -- ==== Cardio / Aerobics (machine based) ====
  ('Treadmill Running',     'Treadmill'),
  ('Stationary Bike',       'Stationary Bike'),
  ('Stationary Bike',       'Spin Bike'),
  ('Elliptical Trainer',    'Elliptical Trainer'),
  ('Rowing Machine',        'Rowing Machine'),
  ('Rowing Machine',        'Rowing Ergometer'),
  ('Stair Climber',         'Stair Climber'),
  ('Jump Rope',             'Jump Rope'),
  ('Walking',               'Treadmill'),
  ('Rowing Sprints',        'Rowing Ergometer'),
  ('Spinning Class',        'Spin Bike'),
  ('Stair Sprint',          'Stair Climber');

INSERT INTO muscle (muscle_name, group_name)
VALUES
 -- Chest
  ('Pectoralis Major', 'Chest'),
  ('Pectoralis Minor', 'Chest'),
  ('Serratus Anterior', 'Chest'),

  -- Back
  ('Latissimus Dorsi', 'Back'),
  ('Trapezius Upper', 'Back'),
  ('Trapezius Middle', 'Back'),
  ('Trapezius Lower', 'Back'),
  ('Rhomboid Major', 'Back'),
  ('Rhomboid Minor', 'Back'),
  ('Teres Major', 'Back'),

  -- Shoulders
  ('Anterior Deltoid', 'Shoulders'),
  ('Lateral Deltoid', 'Shoulders'),
  ('Posterior Deltoid', 'Shoulders'),
  ('Supraspinatus', 'Shoulders'),
  ('Infraspinatus', 'Shoulders'),
  ('Teres Minor', 'Shoulders'),
  ('Subscapularis', 'Shoulders'),

  -- Biceps
  ('Biceps Brachii Long Head', 'Biceps'),
  ('Biceps Brachii Short Head', 'Biceps'),
  ('Brachialis', 'Biceps'),
  ('Brachioradialis', 'Biceps'),

  -- Triceps
  ('Triceps Long Head', 'Triceps'),
  ('Triceps Lateral Head', 'Triceps'),
  ('Triceps Medial Head', 'Triceps'),

  -- Quadriceps
  ('Rectus Femoris', 'Quadriceps'),
  ('Vastus Lateralis', 'Quadriceps'),
  ('Vastus Medialis', 'Quadriceps'),
  ('Vastus Intermedius', 'Quadriceps'),

  -- Hamstrings
  ('Biceps Femoris', 'Hamstrings'),
  ('Semitendinosus', 'Hamstrings'),
  ('Semimembranosus', 'Hamstrings'),

  -- Calves
  ('Gastrocnemius Medial Head', 'Calves'),
  ('Gastrocnemius Lateral Head', 'Calves'),
  ('Soleus', 'Calves'),

  -- Core
  ('Rectus Abdominis', 'Core'),
  ('External Oblique', 'Core'),
  ('Internal Oblique', 'Core'),
  ('Transversus Abdominis', 'Core'),
  ('Erector Spinae Lumbar', 'Core');