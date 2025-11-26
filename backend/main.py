from fastapi import FastAPI, HTTPException

from utils import *

app = FastAPI()


# ==== User ====
@app.get("/", tags=["User"])
async def root():
    return {"message": "hello world"}


@app.get("/user/get", tags=["User"])
async def get_all_users():
    users = fetch_all_users()
    return {"all_users": users}


@app.get("/user/get/{userId}", tags=["User"])
async def get_user_by_id(userId: int):
    user = fetch_user_by_id(userId=userId)
    return {"user": user}


@app.post("/user/add", tags=["User"])
async def add_user(user: User):
    insert_user(user=user)
    return {"message": "Add user successfully"}


@app.post("/user/update/{userId}", tags=["User"])
async def update_user_by_id(userId: int, user: User):
    update_user(userId=userId, user=user)
    return {"message": "Update user successfully"}


@app.post("/user/delete/{userId}", tags=["User"])
async def delete_user_by_id(userId: int):
    delete_user(userId=userId)
    return {"message": "Delete user successfully"}


# ==== Food ====
@app.get("/food/get", tags=["Food"])
async def get_all_foods():
    foods = fetch_all_foods()
    return {"all_foods": foods}


@app.get("/food/get/{foodName}", tags=["Food"])
async def get_food_by_name(foodName: str):
    food = fetch_food(foodName=foodName)
    return {"food": food}


@app.get("/food/get/{userId}", tags=["Food"])
async def get_foods_by_user_id(userId: int):
    foods = fetch_foods_by_user_id(userId=userId)
    return {"user_foods": foods}


@app.post("/food/add", tags=["Food"])
async def add_food(food: Food):
    insert_food(food=food)
    return {"message": "Add food successfully"}


@app.post("/user/log_food", tags=["User Food Log"])
async def add_user_food_log(userFoodLog: UserFoodLog):
    insert_user_food_log(userFoodLog=userFoodLog)
    return {"message": "Add user's food log successfully"}


@app.post("/food/update/{foodName}", tags=["Food"])
async def update_user_by_id(foodName: str, food: Food):
    update_food(foodName=foodName, food=food)
    return {"message": "Update food successfully"}


@app.post("/food/delete/{foodName}", tags=["Food"])
async def delete_user_by_id(foodName: str):
    delete_food(foodName=foodName)
    return {"message": "Delete food successfully"}


# ==== Health Report ====
@app.get("/health_report/{userId}", tags=["Health Report"])
async def get_health_reports_by_user_id(userId: int):
    reports = fetch_health_reports_by_user_id(userId=userId)
    return {"user_health_reports": reports}


@app.post("/health_report/add/{userId}", tags=["Health Report"])
async def add_user_health_report(report: HealthReport):
    insert_user_health_report(report=report)
    return {"message": "Add user's health report successfully"}


# ==== Session ====
@app.post("/session/get/{userId}", tags=["Session"])
async def get_user_sessions(userId: int):
    sessions = fetch_sessions_by_user_id(userId=userId)
    return {"sessions": sessions}


@app.post("/session/add/{userId}", tags=["Session"])
async def add_user_session(userId: int, session: Session):
    insert_session(userId=userId, session=session)
    return {"message": "Add user's session successfully"}


@app.post("/session/update/{userId}/{sessionId}", tags=["Session"])
async def update_user_session(userId: int, sessionId: int, session: Session):
    update_session(userId=userId, sessionId=sessionId, session=session)
    return {"message": "Update user's session successfully"}


@app.post("/session/add/exercise", tags=["Session Exercise"])
async def add_session_exercise(sessionExercise: SessionExercise):
    insert_session_exercise(sessionExercise=sessionExercise)
    return {"message": "Add exercise to session successfully"}


# ==== Exercise ====
@app.get("/exercise/get", tags=["Exercise"])
async def get_exercises():
    exercises = fetch_exercises()
    return {"excercises": exercises}


@app.get("/exercise/get/{exerciseName}", tags=["Exercise"])
async def get_exercise_by_name(exerciseName: str):
    exercise = fetch_exercise_by_name(exerciseName=exerciseName)
    return {"exercise": exercise}


@app.get("/exercise/aerobics/get", tags=["Exercise"])
async def get_aerobics():
    aerobics = fetch_aerobics()
    return {"aerobics": aerobics}


@app.get("/exercise/aerobics/get/{aerobicsName}", tags=["Exercise"])
async def get_aerobics_by_name(aerobicsName: str):
    aerobics = fetch_aerobics_by_name(aerobicsName=aerobicsName)
    return {"aerobics": aerobics}


@app.get("/exercise/lifting/get", tags=["Exercise"])
async def get_liftings():
    liftings = fetch_liftings()
    return {"liftings": liftings}


@app.get("/exercise/lifting/get/{liftingName}", tags=["Exercise"])
async def get_lifting_by_name(liftingName: str):
    lifting = fetch_lifting_by_name(liftingName=liftingName)
    return {"lifting": lifting}


@app.get("/exercise/lifting/set/get", tags=["Exercise"])
async def get_lifting_sets():
    sets = fetch_sets()
    return {"sets": sets}


@app.get("/exercise/lifting/set/add/{liftingName}", tags=["Exercise"])
async def add_lifting_set(liftingName: str, set: Set):
    fetch_sets(liftingName=liftingName, set=set)
    return {"message": "Add set to exercise successfully"}


@app.get("/exercise/lifting/equipment/get/{liftingName}", tags=["Exercise"])
async def get_lifting_equipments(liftingName: str):
    equipments = fetch_equipments_by_lifting_name(liftingName=liftingName)
    return {"equipments": equipments}


@app.get("/exercise/equipment/get/{equipmentName}", tags=["Exercise"])
async def get_equipment_liftings(equipmentName: str):
    liftings = fetch_liftings_by_equipment_name(equipmentName=equipmentName)
    return {"liftings": liftings}


@app.get("/exercise/lifting/muscle/get/{liftingName}", tags=["Exercise"])
async def get_lifting_muscles(liftingName: str):
    muscles = fetch_muscles_by_lifting_name(liftingName=liftingName)
    return {"muscles": muscles}


@app.get("/exercise/muscle/get/{muscleName}", tags=["Exercise"])
async def get_muscle_liftings(muscleName: str):
    liftings = fetch_liftings_by_muscle_name(muscleName=muscleName)
    return {"liftings": liftings}


# ==== Muscle ====
@app.get("/muscle/group/get/{muscleName}", tags=["Muscle"])
async def get_muscle_group(muscleName: str):
    muscleGroup = fetch_muscle_group(muscleName=muscleName)
    return {"muscle group": muscleGroup}


@app.get("/group/get/{groupName}", tags=["Muscle"])
async def get_group_muscle(groupName: str):
    muscles = fetch_group_muscle(groupName=groupName)
    return {"muscles": muscles}
