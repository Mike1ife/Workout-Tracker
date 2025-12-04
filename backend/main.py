from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from utils import *

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", tags=["User"])
async def root():
    return {"message": "hello world"}


# User
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


# Food
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


# Health Condition
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


# Session
@app.get("/sessions/{userId}", tags=["Session"])
async def get_user_sessions(userId: int):
    return {"sessions": fetch_sessions_by_user_id(userId=userId)}


"""Mike's update part1 start"""


# User first select add lifting or aerobics in a session
# Then select exercise name


# Update: Add lifting to session
@app.post("/sessions/lifting_section", tags=["Lifting Section"])
async def add_lifting_section(liftingSection: ExerciseSection):
    insert_lifting_section(liftingSection=liftingSection)
    return {"message": "Add lifting section to session successfully"}


# Update: Add aerobics to session
@app.post("/sessions/aerobics_section", tags=["Aerobics Section"])
async def add_session_exercise(aerobicsSection: ExerciseSection):
    insert_aerobics_section(aerobicsSection=aerobicsSection)
    return {"message": "Add aerobics secction to session successfully"}


# Update: Delete lifting section by sectionId
@app.delete("/sessions/lifting_section/{sectionId}", tags=["Lifting Section"])
async def delete_lifting_section_endpoint(sectionId: int):
    delete_lifting_section(sectionId=sectionId)
    return {"message": "Delete lifting section successfully"}


# Update: Delete aerobics section by sectionId
@app.delete("/sessions/aerobics_section/{sectionId}", tags=["Aerobics Section"])
async def delete_aerobics_section_endpoint(sectionId: int):
    delete_aerobics_section(sectionId=sectionId)
    return {"message": "Delete aerobics section successfully"}


# Update: Fetch all lifting sections and aerobics sections in session
@app.get("/sessions/{sessionId}/exercises", tags=["Session"])
async def get_session_exercise_section(sessionId: int):
    return {"exercises": fetch_exercise_section_by_session_id(sessionId=sessionId)}


"""Mike's update part1 end"""


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


# Exercise
@app.get("/exercises", tags=["Exercise"])
async def get_exercises():
    return {"exercises": fetch_exercises()}


@app.get("/exercises/aerobics", tags=["Aerobics"])
async def get_aerobics():
    return {"aerobics": fetch_aerobics()}


@app.get("/exercises/lifting", tags=["Lifting"])
async def get_liftings():
    return {"liftings": fetch_liftings()}


@app.get("/exercises/{exerciseName}", tags=["Exercise"])
async def get_exercise_by_name(exerciseName: str):
    return {"exercise": fetch_exercise_by_name(exerciseName=exerciseName)}


@app.get("/exercises/{exerciseName}/equipment", tags=["Exercise"])
async def get_exercise_equipments(exerciseName: str):
    return {"equipments": fetch_equipments_by_exercise_name(exerciseName=exerciseName)}


@app.get("/equipment/{equipmentName}/exercise", tags=["Exercise"])
async def get_exercise_by_equipment(equipmentName: str):
    return {"exercises": fetch_exercise_by_equipment_name(equipmentName=equipmentName)}


# Aerobics
@app.get("/exercises/aerobics/{aerobicsName}", tags=["Aerobics"])
async def get_aerobics_by_name(aerobicsName: str):
    return {"aerobics": fetch_aerobics_by_name(aerobicsName=aerobicsName)}


"""Mike's update part2 start"""


# Update: Add metric to aerobics section
@app.post("/exercises/aerobics_section/{sectionId}/metrics", tags=["Aerobics Section"])
async def add_aerobics_section_metric(sectionId: int, metric: Metric):
    insert_aerobics_section_metric(sectionId=sectionId, metric=metric)
    return {"message": "Add metric successfully"}


# Update: Get metric of aerobics section
@app.get("/exercises/aerobics_section/{sectionId}/metrics", tags=["Aerobics Section"])
async def get_aerobics_section_metric(sectionId: int):
    return {"metrics": fetch_aerobics_section_metric(sectionId=sectionId)}


# Update: Update metric of aerobics section
@app.put("/exercises/aerobics_section/metrics/{metricId}", tags=["Aerobics Section"])
async def update_aerobics_section_metric_endpoint(metricId: int, metric: Metric):
    update_aerobics_section_metric(metricId=metricId, metric=metric)
    return {"message": "Update metric successfully"}


# Update: Delete metric oif aerobics section
@app.delete("/exercises/aerobics_section/metrics/{metricId}", tags=["Aerobics Section"])
async def delete_aerobics_section_metric_endpoint(metricId: int):
    delete_aerobics_section_metric(metricId=metricId)
    return {"message": "Delete metric successfully"}


"""Mike's update part2 end"""


# Lifting
@app.get("/exercises/lifting/{liftingName}", tags=["Lifting"])
async def get_lifting_by_name(liftingName: str):
    return {"lifting": fetch_lifting_by_name(liftingName=liftingName)}


"""Mike's update part3 start"""


# Update: Add set to lifting section
@app.post("/exercises/lifting_section/{sectionId}/sets", tags=["Lifting Section"])
async def add_lifting_section_set(sectionId: int, set: Set):
    insert_lifting_section_set(sectionId=sectionId, set=set)
    return {"message": "Add set successfully"}


# Update: Get sets of lifting section
@app.get("/exercises/lifting_section/{sectionId}/sets", tags=["Lifting Section"])
async def get_lifting_section_sets(sectionId: int):
    return {"sets": fetch_lifting_section_sets(sectionId=sectionId)}


# Update: Update set of lifting section
@app.put(
    "/exercises/lifting_section/sets/{sectionId}/{setNum}", tags=["Lifting Section"]
)
async def update_lifting_section_set_endpoint(sectionId: int, setNum: int, set: Set):
    update_lifting_section_set(sectionId=sectionId, setNum=setNum, set=set)
    return {"message": "Update set successfully"}


# Update: Delete set of lifting section
@app.delete(
    "/exercises/lifting_section/sets/{sectionId}/{setNum}", tags=["Lifting Section"]
)
async def delete_lifting_section_set_endpoint(sectionId: int, setNum: int):
    delete_lifting_section_set(sectionId=sectionId, setNum=setNum)
    return {"message": "Delete set successfully"}


"""Mike's update part3 end"""


@app.get("/exercises/lifting/{liftingName}/muscles", tags=["Lifting"])
async def get_lifting_muscles(liftingName: str):
    return {"muscles": fetch_muscles_by_lifting_name(liftingName=liftingName)}


@app.get("/muscles/{muscleName}/lifting", tags=["Lifting"])
async def get_muscle_liftings(muscleName: str):
    return {"liftings": fetch_liftings_by_muscle_name(muscleName=muscleName)}


# Muscle
@app.get("/muscles/{muscleName}/group", tags=["Muscle"])
async def get_muscle_group(muscleName: str):
    return {"muscle_group": fetch_muscle_group(muscleName=muscleName)}


@app.get("/muscle-groups/{groupName}/muscles", tags=["Muscle"])
async def get_group_muscles(groupName: str):
    return {"muscles": fetch_group_muscle(groupName=groupName)}
