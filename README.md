# Workout Tracker

## Database (MySQL)
```
Execute database dump file to build the workout_tracker database
```

## Backend (FastAPI + pymysql)
```
python version = 3.11
```
```cmd
cd Workout-Tracker
pip install requirements.txt
```
```python
backend/utils.py
conn = pymysql.connect(
    host="localhost",
    user="user", # Change to your MySQL username
    password="password", # Change to your MySQL password
    database="workout_tracker",
    cursorclass=pymysql.cursors.DictCursor,
)
```

## ERD
<img width="873" height="726" alt="image" src="https://github.com/user-attachments/assets/d699be45-09fe-4bb1-8c48-3d17c8631b46" />

## UML
<img width="2209" height="2589" alt="image" src="https://github.com/user-attachments/assets/2a159df3-b0c0-46fe-a0e1-d2f643a20991" />
