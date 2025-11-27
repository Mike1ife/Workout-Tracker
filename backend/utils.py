import pymysql
from typing import List
from shcema import *

conn = pymysql.connect(
    host="localhost",
    user="root",
    password="daiguangyi123",
    database="workout_tracker",
)

# =======================
#        USER
# =======================


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


# =======================
#        FOOD
# =======================


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


# =======================
#    HEALTH CONDITION
# =======================


def fetch_health_conditions_by_user_id(userId: int) -> List[HealthCondition]:
    pass


def insert_user_health_condition(userId: int, healthCondition: HealthCondition):
    pass


def delete_health_condition(userId: int, createdAt: str):
    pass


# =======================
#        SESSION
# =======================


def fetch_sessions_by_user_id(userId: int) -> List[Session]:
    pass


def insert_session(userId: int, session: Session):
    pass


def update_session(userId: int, sessionId: int, session: Session):
    pass


def delete_session(userId: int, sessionId: int):
    pass


# =======================
#    SESSION EXERCISE
# =======================


def insert_session_exercise(sessionExercise: SessionExercise):
    pass


def delete_session_exercise(sessionId: int, exerciseName: str):
    pass


# =======================
#        EXERCISE
# =======================


def fetch_exercises() -> List[Exercise]:
    pass


def fetch_exercise_by_name(exerciseName: str) -> Exercise:
    pass


# =======================
#         AEROBICS
# =======================


def fetch_aerobics() -> List[Exercise]:
    pass


def fetch_aerobics_by_name(aerobicsName: str) -> Exercise:
    pass


def insert_aerobics_metric(sessionId: int, aerobicsName: str, metric: Metric):
    pass


def fetch_metrics(aerobicsName: str, sessionId: int) -> List[Metric]:
    pass


def update_aerobics_metric(sessionId: int, aerobicsName: str, metric: Metric):
    pass


def delete_aerobics_metric(sessionId: int, aerobicsName: str):
    pass


# =======================
#         LIFTING
# =======================


def fetch_liftings() -> List[Exercise]:
    pass


def fetch_lifting_by_name(liftingName: str) -> Exercise:
    pass


def insert_lifting_set(sessionId: int, liftingName: str, set: Set):
    pass


def fetch_sets(liftingName: str, sessionId: int) -> List[Set]:
    pass


def update_lifting_set(sessionId: int, liftingName: str, setNum: int, set: Set):
    pass


def delete_lifting_set(sessionId: int, liftingName: str, setNum: int):
    pass


def fetch_equipments_by_lifting_name(liftingName: str) -> List[Equipment]:
    pass


def fetch_liftings_by_equipment_name(equipmentName: str) -> List[Exercise]:
    pass


def fetch_muscles_by_lifting_name(liftingName: str) -> List[Muscle]:
    pass


def fetch_liftings_by_muscle_name(muscleName: str) -> List[Exercise]:
    pass


# =======================
#         MUSCLE
# =======================


def fetch_muscle_group(muscleName: str) -> MuscleGroup:
    pass


def fetch_group_muscle(groupName: str) -> List[Muscle]:
    pass
