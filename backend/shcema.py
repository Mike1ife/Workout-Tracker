from pydantic import BaseModel
from typing import Optional, Literal


class User(BaseModel):
    first_name: str
    last_name: str
    email: str
    age: Optional[int]
    gender: Literal["Male", "Female", "Other"]


class Food(BaseModel):
    foodName: str
    calories: Optional[float]
    carbohydrate: float
    protein: float
    fat: float


class UserFoodLog(BaseModel):
    userId: int
    foodName: str


class HealthCondition(BaseModel):
    createdAt: str
    weight: float
    body_fat_percent: float


class Session(BaseModel):
    startTime: str
    endTime: str
    note: Optional[str]


class Exercise(BaseModel):
    exerciseName: str
    description: Optional[str]


class SessionExercise(BaseModel):
    sessionId: int
    exerciseName: str


class Equipment(BaseModel):
    equipmentName: str
    description: Optional[str]


class MuscleGroup(BaseModel):
    groupName: str
    type: str


class Muscle(BaseModel):
    muscleName: str


class Set(BaseModel):
    setNum: int
    weight: float
    reps: int


class Metric(BaseModel):
    duration: str
    distance: float
