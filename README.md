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

## Frontend (React + JavaScript)
