from fastapi import FastAPI, HTTPException
from utils import *

app = FastAPI()


# =======================
#        USER
# =======================


@app.get("/", tags=["User"])
async def root():
    return {"message": "hello world"}


@app.get("/users", tags=["User"])
async def get_all_users():
    return {"all_users": fetch_all_users()}


@app.get("/users/{userId}", tags=["User"])
async def get_user_by_id(userId: int):
    return {"user": fetch_user_by_id(userId=userId)}


@app.post("/users", tags=["User"])
async def add_user(user: User):
    insert_user(user=user)
    return {"message": "Add user successfully"}


@app.put("/users/{userId}", tags=["User"])
async def update_user_by_id(userId: int, user: User):
    update_user(userId=userId, user=user)
    return {"message": "Update user successfully"}


@app.delete("/users/{userId}", tags=["User"])
async def delete_user_by_id(userId: int):
    delete_user(userId=userId)
    return {"message": "Delete user successfully"}


# =======================
#        FOOD
# =======================


@app.get("/foods", tags=["Food"])
async def get_all_foods():
    return {"all_foods": fetch_all_foods()}


@app.get("/foods/name/{foodName}", tags=["Food"])
async def get_food_by_name(foodName: str):
    return {"food": fetch_food(foodName=foodName)}


@app.get("/foods/user/{userId}", tags=["Food"])
async def get_foods_by_user_id(userId: int):
    return {"user_foods": fetch_foods_by_user_id(userId=userId)}


@app.post("/foods", tags=["Food"])
async def add_food(food: Food):
    insert_food(food=food)
    return {"message": "Add food successfully"}


@app.post("/foods/log", tags=["User Food Log"])
async def add_user_food_log(userFoodLog: UserFoodLog):
    insert_user_food_log(userFoodLog=userFoodLog)
    return {"message": "Add user's food log successfully"}


@app.put("/foods/{foodName}", tags=["Food"])
async def update_food_by_name(foodName: str, food: Food):
    update_food(foodName=foodName, food=food)
    return {"message": "Update food successfully"}


@app.delete("/foods/{foodName}", tags=["Food"])
async def delete_food_by_name(foodName: str):
    delete_food(foodName=foodName)
    return {"message": "Delete food successfully"}


# ================================
#    HEALTH CONDITION
# ================================


@app.get("/health/{userId}", tags=["Health"])
async def get_health_conditions_by_user_id(userId: int):
    return {"user_health_conditions": fetch_health_conditions_by_user_id(userId=userId)}


@app.post("/health/{userId}", tags=["Health"])
async def add_user_health_report(userId: int, healthCondition: HealthCondition):
    insert_user_health_condition(userId=userId, healthCondition=healthCondition)
    return {"message": "Add user's health condition successfully"}


@app.delete("/health/{userId}/{createdAt}", tags=["Health"])
async def delete_health_condition(userId: int, createdAt: str):
    delete_health_condition(userId=userId, createdAt=createdAt)
    return {"message": "Delete health condition successfully"}


# =======================
#        SESSION
# =======================


@app.get("/sessions/{userId}", tags=["Session"])
async def get_user_sessions(userId: int):
    return {"sessions": fetch_sessions_by_user_id(userId=userId)}


@app.post("/sessions/{userId}", tags=["Session"])
async def add_user_session(userId: int, session: Session):
    insert_session(userId=userId, session=session)
    return {"message": "Add user's session successfully"}


@app.put("/sessions/{userId}/{sessionId}", tags=["Session"])
async def update_user_session(userId: int, sessionId: int, session: Session):
    update_session(userId=userId, sessionId=sessionId, session=session)
    return {"message": "Update user's session successfully"}


@app.delete("/sessions/{userId}/{sessionId}", tags=["Session"])
async def delete_user_session(userId: int, sessionId: int):
    delete_session(userId=userId, sessionId=sessionId)
    return {"message": "Delete user's session successfully"}


# =======================
#    SESSION EXERCISE
# =======================


@app.post("/sessions/exercises", tags=["Session Exercise"])
async def add_session_exercise(sessionExercise: SessionExercise):
    insert_session_exercise(sessionExercise=sessionExercise)
    return {"message": "Add exercise to session successfully"}


@app.delete("/sessions/exercises/{sessionId}/{exerciseName}", tags=["Session Exercise"])
async def delete_session_exercise(sessionId: int, exerciseName: str):
    delete_session_exercise(sessionId=sessionId, exerciseName=exerciseName)
    return {"message": "Delete session exercise successfully"}


# =======================
#        EXERCISE
# =======================


@app.get("/exercises", tags=["Exercise"])
async def get_exercises():
    return {"exercises": fetch_exercises()}


@app.get("/exercises/{exerciseName}", tags=["Exercise"])
async def get_exercise_by_name(exerciseName: str):
    return {"exercise": fetch_exercise_by_name(exerciseName=exerciseName)}


# =======================
#        AEROBICS
# =======================


@app.get("/exercises/aerobics", tags=["Exercise"])
async def get_aerobics():
    return {"aerobics": fetch_aerobics()}


@app.get("/exercises/aerobics/{aerobicsName}", tags=["Aerobics"])
async def get_aerobics_by_name(aerobicsName: str):
    return {"aerobics": fetch_aerobics_by_name(aerobicsName=aerobicsName)}


@app.post("/exercises/aerobics/{aerobicsName}/metrics/{sessionId}", tags=["Aerobics"])
async def add_aerobics_metric(aerobicsName: str, sessionId: int, metric: Metric):
    insert_aerobics_metric(
        sessionId=sessionId, aerobicsName=aerobicsName, metric=metric
    )
    return {"message": "Add metric successfully"}


@app.get("/exercises/aerobics/{aerobicsName}/metrics/{sessionId}", tags=["Aerobics"])
async def get_aerobics_metrics(aerobicsName: str, sessionId: int):
    return {"metrics": fetch_metrics(aerobicsName=aerobicsName, sessionId=sessionId)}


@app.put("/exercises/aerobics/{aerobicsName}/metrics/{sessionId}", tags=["Aerobics"])
async def update_aerobics_metric(aerobicsName: str, sessionId: int, metric: Metric):
    update_aerobics_metric(
        sessionId=sessionId, aerobicsName=aerobicsName, metric=metric
    )
    return {"message": "Update metric successfully"}


@app.delete("/exercises/aerobics/{aerobicsName}/metrics/{sessionId}", tags=["Aerobics"])
async def delete_aerobics_metric(aerobicsName: str, sessionId: int):
    delete_aerobics_metric(sessionId=sessionId, aerobicsName=aerobicsName)
    return {"message": "Delete metric successfully"}


# =======================
#         LIFTING
# =======================


@app.get("/exercises/lifting", tags=["Lifting"])
async def get_liftings():
    return {"liftings": fetch_liftings()}


@app.get("/exercises/lifting/{liftingName}", tags=["Lifting"])
async def get_lifting_by_name(liftingName: str):
    return {"lifting": fetch_lifting_by_name(liftingName=liftingName)}


@app.post("/exercises/lifting/{liftingName}/sets/{sessionId}", tags=["Lifting"])
async def add_lifting_set(liftingName: str, sessionId: int, set: Set):
    insert_lifting_set(sessionId=sessionId, liftingName=liftingName, set=set)
    return {"message": "Add set successfully"}


@app.get("/exercises/lifting/{liftingName}/sets/{sessionId}", tags=["Lifting"])
async def get_lifting_sets(liftingName: str, sessionId: int):
    return {"sets": fetch_sets(liftingName=liftingName, sessionId=sessionId)}


@app.put("/exercises/lifting/{liftingName}/sets/{sessionId}/{setNum}", tags=["Lifting"])
async def update_lifting_set(liftingName: str, sessionId: int, setNum: int, set: Set):
    update_lifting_set(
        sessionId=sessionId, liftingName=liftingName, setNum=setNum, set=set
    )
    return {"message": "Update set successfully"}


@app.delete(
    "/exercises/lifting/{liftingName}/sets/{sessionId}/{setNum}", tags=["Lifting"]
)
async def delete_lifting_set(liftingName: str, sessionId: int, setNum: int):
    delete_lifting_set(sessionId=sessionId, liftingName=liftingName, setNum=setNum)
    return {"message": "Delete set successfully"}


@app.get("/exercises/lifting/{liftingName}/equipment", tags=["Lifting"])
async def get_lifting_equipments(liftingName: str):
    return {"equipments": fetch_equipments_by_lifting_name(liftingName=liftingName)}


@app.get("/equipment/{equipmentName}/lifting", tags=["Lifting"])
async def get_liftings_by_equipment(equipmentName: str):
    return {"liftings": fetch_liftings_by_equipment_name(equipmentName=equipmentName)}


@app.get("/exercises/lifting/{liftingName}/muscles", tags=["Lifting"])
async def get_lifting_muscles(liftingName: str):
    return {"muscles": fetch_muscles_by_lifting_name(liftingName=liftingName)}


@app.get("/muscles/{muscleName}/lifting", tags=["Lifting"])
async def get_muscle_liftings(muscleName: str):
    return {"liftings": fetch_liftings_by_muscle_name(muscleName=muscleName)}


# =======================
#         MUSCLES
# =======================


@app.get("/muscles/{muscleName}/group", tags=["Muscle"])
async def get_muscle_group(muscleName: str):
    return {"muscle_group": fetch_muscle_group(muscleName=muscleName)}


@app.get("/muscle-groups/{groupName}/muscles", tags=["Muscle"])
async def get_group_muscles(groupName: str):
    return {"muscles": fetch_group_muscle(groupName=groupName)}
