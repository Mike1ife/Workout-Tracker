# Workout Tracker

# Ken
CREATE command
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
- set_num
- weight
- reps

`metric`
- duration
- distance

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
<img width="1237" height="1101" alt="image" src="https://github.com/user-attachments/assets/3cffc645-e71b-4d7b-85ad-abfdf3dfbcbb" />

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
