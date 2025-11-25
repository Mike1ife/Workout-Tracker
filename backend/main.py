from fastapi import FastAPI, HTTPException

from db import *
from shcema import *

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "hello world"}


@app.post("/add/")
async def add(user: User):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.callproc(
            "register_new_user", (user.name, user.email, user.age, user.gender)
        )
        conn.commit()
    except Exception as err:
        raise HTTPException(status_code=400, detail=str(err))


@app.get("/users/")
async def users():
    conn = get_connection()
    cur = conn.cursor()
    cur.callproc("get_all_user")
    return {
        "message": "\n".join(
            [f"{row[0]} {row[1]} {row[2]} {row[3]}" for row in cur.fetchall()]
        )
    }
