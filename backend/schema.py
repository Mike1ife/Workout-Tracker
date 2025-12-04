from pydantic import BaseModel
from typing import Optional, Literal


class User(BaseModel):
    user_id: Optional[int] = None
    first_name: str
    last_name: str
    email: str
    password: str
    age: Optional[int]
    gender: Literal["Male", "Female", "Other"]


class Food(BaseModel):
    foodName: str
    servingSize: Optional[str] = "1 serving"
    calories: Optional[float] = None
    carbohydrate: float
    protein: float
    fat: float


class UserFoodLog(BaseModel):
    userId: int
    foodName: str
    quantity: Optional[float] = 1.0
    createAt: Optional[str]


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


class ExerciseSection(BaseModel):
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
    duration: Optional[str] = None
    distance: Optional[float] = None