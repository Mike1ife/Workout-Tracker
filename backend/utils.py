import pymysql
from typing import List
from shcema import *

conn = pymysql.connect(
    host="localhost",
    user="root",
    password="daiguangyi123",
    database="workout_tracker",
)


def fetch_all_users() -> List[User]:
    pass


def fetch_user_by_id(userId: int) -> User:
    pass


def insert_user(user: User):
    pass


def update_user(userId: int, user: User):
    pass


def delete_user(userId: int):
    pass


def fetch_all_foods() -> List[Food]:
    pass


def fetch_food(foodName: str) -> Food:
    pass


def fetch_foods_by_user_id(userId: int) -> List[Food]:
    pass


def insert_food(food: Food):
    pass


def insert_user_food_log(userFoodLog: UserFoodLog):
    pass


def update_food(foodName: str, food: Food):
    pass


def delete_food(foodName: str):
    pass


def fetch_health_reports_by_user_id(userId: int) -> List[HealthReport]:
    pass


def insert_user_health_report(report: HealthReport):
    pass


def fetch_sessions_by_user_id(userId: int) -> List[Session]:
    pass


def insert_session(userId: int, session: Session):
    pass


def update_session(userId: int, sessionId: int, session: Session):
    pass


def insert_session_exercise(sessionExercise: SessionExercise):
    pass


def fetch_exercises() -> List[Exercise]:
    pass


def fetch_exercise_by_name(exerciseName: str) -> Exercise:
    pass


def fetch_aerobics() -> List[Aerobics]:
    pass


def fetch_aerobics_by_name(aerobicsName: str) -> Aerobics:
    pass


def fetch_liftings() -> List[Lifting]:
    pass


def fetch_lifting_by_name(liftingName: str) -> Lifting:
    pass


def fetch_sets() -> List[Set]:
    pass


def fetch_equipments_by_lifting_name(liftingName: str) -> List[Equipment]:
    pass


def fetch_liftings_by_equipment_name(equipmentName: str) -> List[Lifting]:
    pass


def fetch_muscles_by_lifting_name(liftingName: str) -> List[Muscle]:
    pass


def fetch_liftings_by_muscle_name(muscleName: str) -> List[Lifting]:
    pass


def fetch_muscle_group(muscleName: str) -> MuscleGroup:
    pass


def fetch_group_muscle(groupName: str) -> List[Muscle]:
    pass
