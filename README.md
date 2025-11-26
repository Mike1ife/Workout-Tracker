# Workout Tracker

The database stores detailed information about users’ workout activities, nutritional intake, and physical condition, allowing comprehensive tracking of fitness behavior and long-term health trends. Each user has a unique identifier along with personal attributes such as name, email, age, and gender. A user can create multiple workout sessions, record periodic health measurements, and log the foods they consume. Each health record captures the user’s body weight and body fat percentage at a specific point in time, enabling progress monitoring over extended periods.

Workout activity is organized around sessions, each representing a single exercise event. A session includes a unique session ID, start and end date/time, and optional notes that describe the user’s workout experience. A user may have many sessions, and each session can contain multiple exercises performed during that workout.

Exercises in the system are defined in a central exercise catalog, where each exercise has a unique name and description. Every exercise is classified into one—and only one—of two categories: lifting or aerobics. Lifting exercises represent strength-training movements and may involve multiple sets, targeted muscles, and required equipment. Aerobic exercises represent endurance-based activities such as running or cycling, and are measured using attributes such as duration and distance.

Strength-training exercises may consist of one or more sets, where each set records the weight lifted, number of repetitions, and set number within the exercise. Lifting exercises also train specific muscles, and each muscle belongs to exactly one defined muscle group. Muscle groups categorize body regions such as upper body, core, or lower body, allowing exercises to be analyzed based on which part of the body they target.

Lifting exercises may also involve equipment, each of which has a unique name and description. The relationship between lifting exercises and equipment is many-to-many, since a single exercise may require multiple pieces of equipment, and a single piece of equipment may be used across many exercises.

The database additionally supports nutritional tracking through a collection of foods. Each food item is uniquely identified by name and includes its macronutrient breakdown, such as carbohydrate, protein, and fat content. Users can log the foods they consume, enabling the system to correlate dietary habits with workout performance and health changes.

Together, this database design provides an integrated framework for users to monitor their fitness journey holistically—capturing detailed workout structure, equipment usage, muscle engagement, nutritional intake, and ongoing health metrics. It allows meaningful insights into exercise performance and overall physical progression over time.

# Ken
Modify `create_database.sql`

## Modifiable Table

`user`
- user_id {PK}
- name
- email
- age
- gender

`session`
- session_id {PK}
- start_date
- start_time
- end_date
- end_time
- note

`set`
- set_id {PK}
- set_num
- weight
- reps

`food`
- food_name {PK}
- carbohydrate
- protein
- fat

`health condition`
- created_at
- weight
- body_fat

## Predefined Table

`exercise`
- exercise_name {PK}
- description

`aerobics`
- exercise_name {PK}
- duration
- distance

`lifting`
- exercise_name {PK}

`equipment`
- equipment_name {PK}
- description

`muscle`
- muscle_name {PK}

`muscle group`
- group_name {PK}
- type

## ERD
<img width="1135" height="1123" alt="image" src="https://github.com/user-attachments/assets/326c24a4-fa9b-4d5f-a861-20c22b62b66c" />


# Tony
Frontend (React)

# Mike
Backend (FastAPI + pymysql)

SELECT command should be packed as procedure in MySQL

```
cd backend
uvicorn main:app --reload
go to /docs to see API document
```