from pydantic import BaseModel


class User(BaseModel):
    name: str
    email: str
    age: int
    gender: str


class Food(BaseModel):
    name: str
    carbohydrate: float
    protein: float
    fat: float


class UserFoodLog(BaseModel):
    userId: int
    foodName: str


class HealthReport(BaseModel):
    weight: float
    body_fat: float  # 0.2 = 20%
    createdAt: str


class Session(BaseModel):
    startDate: str
    startTime: str
    endDate: str
    endTime: str
    note: str


class SessionExercise(BaseModel):
    sessionId: int
    exerciseName: str


class Exercise(BaseModel):
    name: str
    description: str


class Aerobics(Exercise):
    duration: str
    distance: str


class Lifting(Exercise):
    pass


class Set(BaseModel):
    weight: float
    numOfReps: int


class Equipment(BaseModel):
    name: str
    description: str


class Muscle(BaseModel):
    name: str


class MuscleGroup(BaseModel):
    name: str
    type: str
