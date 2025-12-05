from datetime import timedelta
import pymysql
from typing import List
from fastapi import HTTPException
from config import DATABASE_CONFIG

from schema import *

conn = pymysql.connect(
    host=DATABASE_CONFIG["host"],
    user=DATABASE_CONFIG["user"],
    password=DATABASE_CONFIG["password"],
    database=DATABASE_CONFIG["database"],
    cursorclass=pymysql.cursors.DictCursor,
)


def _call_proc(proc_name: str, params: tuple = ()):
    try:
        with conn.cursor() as cursor:
            cursor.callproc(proc_name, params)
            result = cursor.fetchall()
        conn.commit()
        return result

    except pymysql.err.IntegrityError as e:
        msg = str(e)
        if "FOREIGN KEY" in msg:
            raise HTTPException(status_code=400, detail="Foreign key constraint failed")
        if "Duplicate entry" in msg:
            raise HTTPException(status_code=400, detail="Duplicate entry")
        if "CHECK constraint" in msg:
            raise HTTPException(
                status_code=400, detail="Value violates CHECK constraint"
            )
        raise HTTPException(status_code=400, detail=f"Integrity error: {msg}")

    except pymysql.err.ProgrammingError as e:
        raise HTTPException(
            status_code=500, detail=f"Database programming error: {str(e)}"
        )

    except pymysql.err.InternalError as e:
        sqlstate = e.args[0]
        msg = e.args[1]
        if sqlstate == 1644:
            raise HTTPException(status_code=400, detail=msg)
        raise HTTPException(status_code=500, detail=f"Database internal error: {msg}")

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")


def fetch_all_users() -> List[User]:
    rows = _call_proc("sp_fetch_all_users")
    return [User(**row) for row in rows]


def fetch_user_by_id(userId: int) -> User:
    rows = _call_proc("sp_fetch_user_by_id", (userId,))
    return User(**rows[0])


def insert_user(user: User):
    _call_proc(
        "sp_insert_user",
        (
            user.first_name,
            user.last_name,
            user.email,
            user.password,
            user.age,
            user.gender,
        ),
    )


def update_user(userId: int, user: User):
    _call_proc(
        "sp_update_user",
        (
            userId,
            user.first_name,
            user.last_name,
            user.email,
            user.password,
            user.age,
            user.gender,
        ),
    )


def delete_user(userId: int):
    _call_proc("sp_delete_user", (userId,))


def fetch_all_foods() -> List[Food]:
    rows = _call_proc("sp_fetch_all_foods")
    return [
        Food(
            foodName=row["food_name"],
            servingSize=row.get("serving_size", "100g"),
            calories=row.get("calories"),
            carbohydrate=row["carbohydrate"],
            protein=row["protein"],
            fat=row["fat"],
        )
        for row in rows
    ]


def fetch_food(foodName: str) -> Food:
    rows = _call_proc("sp_fetch_food", (foodName,))
    row = rows[0]
    return Food(
        foodName=row["food_name"],
        servingSize=row.get("serving_size", "100g"),
        calories=row.get("calories"),
        carbohydrate=row["carbohydrate"],
        protein=row["protein"],
        fat=row["fat"],
    )


def fetch_foods_by_user_id(userId: int) -> List[dict]:
    rows = _call_proc("sp_fetch_foods_by_user_id", (userId,))
    return [
        {
            "foodName": row["food_name"],
            "servingSize": row.get("serving_size", "100g"),
            "calories": row["calories"],
            "carbohydrate": row["carbohydrate"],
            "protein": row["protein"],
            "fat": row["fat"],
            "quantity": float(row.get("quantity", 1.0)),
            "create_at": row.get("create_at"),
        }
        for row in rows
    ]


def insert_food(food: Food):
    _call_proc(
        "sp_insert_food",
        (
            food.foodName,
            food.servingSize,
            food.carbohydrate,
            food.protein,
            food.fat,
        ),
    )


def insert_user_food_log(userFoodLog: UserFoodLog):
    _call_proc(
        "sp_insert_user_food_log",
        (
            userFoodLog.userId,
            userFoodLog.foodName,
            userFoodLog.createAt,
            userFoodLog.quantity,
        ),
    )
    

def delete_user_food_log_entry(userId: int, foodName: str, createAt: str):
    _call_proc("sp_delete_user_food_log", (userId, foodName, createAt))


def update_food(foodName: str, food: Food):
    _call_proc(
        "sp_update_food",
        (
            foodName,
            food.servingSize,
            food.carbohydrate,
            food.protein,
            food.fat,
        ),
    )


def delete_food(foodName: str):
    _call_proc("sp_delete_food", (foodName,))


def fetch_health_conditions_by_user_id(userId: int) -> List[dict]:
    rows = _call_proc("sp_fetch_health_conditions_by_user_id", (userId,))
    return [
        {
            "createdAt": str(row["create_at"]),
            "weight": float(row["weight"]),
            "body_fat_percent": float(row["body_fat_percent"]),
        }
        for row in rows
    ]


def insert_user_health_condition(userId: int, healthCondition: HealthCondition):
    _call_proc(
        "sp_insert_user_health_condition",
        (
            userId,
            healthCondition.createdAt,
            healthCondition.weight,
            healthCondition.body_fat_percent,
        ),
    )


def delete_health_condition(userId: int, createdAt: str):
    _call_proc("sp_delete_health_condition", (userId, createdAt))


def fetch_sessions_by_user_id(userId: int) -> List[dict]:
    rows = _call_proc("sp_fetch_sessions_by_user_id", (userId,))
    return [
        {
            "session_id": row["session_id"],
            "startTime": str(row["start_time"]),
            "endTime": str(row["end_time"]),
            "note": row["note"],
        }
        for row in rows
    ]


def insert_session(userId: int, session: Session):
    _call_proc(
        "sp_insert_session", (userId, session.startTime, session.endTime, session.note)
    )


def update_session(userId: int, sessionId: int, session: Session):
    _call_proc(
        "sp_update_session",
        (userId, sessionId, session.startTime, session.endTime, session.note),
    )


def delete_session(userId: int, sessionId: int):
    _call_proc("sp_delete_session", (userId, sessionId))


def insert_lifting_section(liftingSection: ExerciseSection):
    _call_proc(
        "sp_insert_lifting_section",
        (liftingSection.sessionId, liftingSection.exerciseName),
    )


def insert_aerobics_section(aerobicsSection: ExerciseSection):
    _call_proc(
        "sp_insert_aerobics_section",
        (aerobicsSection.sessionId, aerobicsSection.exerciseName),
    )


def delete_lifting_section(sectionId: int):
    _call_proc("sp_delete_lifting_section", (sectionId,))


def delete_aerobics_section(sectionId: int):
    _call_proc("sp_delete_aerobics_section", (sectionId,))


def fetch_exercise_section_by_session_id(sessionId: int) -> List[str]:
    rows = _call_proc("sp_fetch_exercise_section_by_session_id", (sessionId,))
    return [row["exercise_name"] for row in rows]


def fetch_exercises() -> List[dict]:
    rows = _call_proc("sp_fetch_exercises")
    return [
        {"exerciseName": row["exercise_name"], "description": row.get("description")}
        for row in rows
    ]


def fetch_exercise_by_name(exerciseName: str) -> dict:
    rows = _call_proc("sp_fetch_exercise_by_name", (exerciseName,))
    return {
        "exerciseName": rows[0]["exercise_name"],
        "description": rows[0].get("description"),
    }


def fetch_equipments_by_exercise_name(exerciseName: str) -> List[dict]:
    rows = _call_proc("sp_fetch_equipments_by_exercise_name", (exerciseName,))
    return [
        {
            "equipmentName": row["equipment_name"],
            "description": row.get("description")
        }
        for row in rows
    ]


def fetch_exercise_by_equipment_name(equipmentName: str) -> List[dict]:
    rows = _call_proc("sp_fetch_exercise_by_equipment_name", (equipmentName,))
    return [
        {"exerciseName": row["exercise_name"], "description": row.get("description")}
        for row in rows
    ]


def fetch_aerobics() -> List[dict]:
    rows = _call_proc("sp_fetch_aerobics")
    return [
        {"exerciseName": row["exercise_name"], "description": row.get("description")}
        for row in rows
    ]


def fetch_aerobics_by_name(aerobicsName: str) -> dict:
    rows = _call_proc("sp_fetch_aerobics_by_name", (aerobicsName,))
    if not rows:
        raise HTTPException(status_code=404, detail="Aerobics exercise not found")
    return {
        "exerciseName": rows[0].get("exercise_name", ""),
        "description": rows[0].get("description", ""),
    }


def insert_aerobics_section_metric(sectionId: int, metric: Metric):
    _call_proc(
        "sp_insert_aerobics_section_metric",
        (sectionId, metric.metricNum, metric.duration, metric.distance), 
    )


def fetch_aerobics_section_metric(sectionId: int) -> List[Metric]:
    rows = _call_proc("sp_fetch_aerobics_section_metrics", (sectionId,)) 
    result = []

    for row in rows:
        duration_str = None
        if row.get("duration") is not None:
            duration = row["duration"]
            if isinstance(duration, timedelta):
                total_seconds = int(duration.total_seconds())
                hours = total_seconds // 3600
                minutes = (total_seconds % 3600) // 60
                seconds = total_seconds % 60
                duration_str = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
            else:
                duration_str = str(duration)

        result.append(Metric(
            metricNum=row["metric_num"],  
            duration=duration_str, 
            distance=row.get("distance")
        ))
    
    return result


def update_aerobics_section_metric(sectionId: int, metricNum: int, metric: Metric):
    _call_proc(
        "sp_update_aerobics_section_metric",
        (sectionId, metricNum, metric.duration, metric.distance), 
    )


def delete_aerobics_section_metric(sectionId: int, metricNum: int):
    _call_proc("sp_delete_aerobics_section_metric", (sectionId, metricNum))


def fetch_liftings() -> List[dict]:
    rows = _call_proc("sp_fetch_liftings")
    return [
        {
            "exerciseName": row.get("exercise_name", ""),
            "description": row.get("description", ""),
        }
        for row in rows
    ]


def fetch_lifting_by_name(liftingName: str) -> dict:
    rows = _call_proc("sp_fetch_lifting_by_name", (liftingName,))
    if not rows:
        raise HTTPException(status_code=404, detail="Lifting exercise not found")
    return {
        "exerciseName": rows[0].get("exercise_name", ""),
        "description": rows[0].get("description", ""),
    }


def insert_lifting_section_set(sectionId: int, set: Set):
    _call_proc(
        "sp_insert_lifting_section_set",
        (sectionId, set.setNum, set.weight, set.reps),
    )


def fetch_lifting_section_sets(sectionId: int) -> List[Set]:
    rows = _call_proc("sp_fetch_lifting_section_sets", (sectionId,))
    return [
        Set(setNum=row["set_num"], weight=row["weight"], reps=row["reps"])
        for row in rows
    ]


def update_lifting_section_set(sectionId: int, setNum: int, set: Set):
    _call_proc(
        "sp_update_lifting_section_set", (sectionId, setNum, set.weight, set.reps)
    )


def delete_lifting_section_set(sectionId: int, setNum: int):
    _call_proc("sp_delete_lifting_section_set", (sectionId, setNum))


def fetch_muscles_by_lifting_name(liftingName: str) -> List[dict]:
    rows = _call_proc("sp_fetch_muscles_by_lifting_name", (liftingName,))
    return [
        {
            "muscleName": row["muscle_name"]
        }
        for row in rows
    ]


def fetch_liftings_by_muscle_name(muscleName: str) -> List[dict]:
    rows = _call_proc("sp_fetch_liftings_by_muscle_name", (muscleName,))
    return [
        {"exerciseName": row["exercise_name"], "description": row.get("description")}
        for row in rows
    ]


def fetch_muscle_group(muscleName: str) -> MuscleGroup:
    rows = _call_proc("sp_fetch_muscle_group", (muscleName,))
    return MuscleGroup(**rows[0])


def fetch_group_muscle(groupName: str) -> List[Muscle]:
    rows = _call_proc("sp_fetch_group_muscle", (groupName,))
    return [Muscle(**row) for row in rows]


def get_lifting_section_id(sessionId: int, exerciseName: str) -> int:
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT lifting_section_id FROM lifting_section WHERE session_id = %s AND exercise_name = %s",
                (sessionId, exerciseName)
            )
            result = cursor.fetchone()
            if not result:
                raise HTTPException(status_code=404, detail="Lifting section not found")
            return result['lifting_section_id']
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


def get_aerobics_section_id(sessionId: int, exerciseName: str) -> int:
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT aerobics_section_id FROM aerobics_section WHERE session_id = %s AND exercise_name = %s",
                (sessionId, exerciseName)
            )
            result = cursor.fetchone()
            if not result:
                raise HTTPException(status_code=404, detail="Aerobics section not found")
            return result['aerobics_section_id']
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")

