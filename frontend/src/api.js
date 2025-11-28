const BASE_URL = 'http://localhost:8000';

const handleResponse = async (response) => {
  if (!response.ok) {
    const error = await response.json().catch(() => ({ detail: 'Unknown error' }));
    throw new Error(error.detail || 'Request failed');
  }
  return response.json();
};

export const userAPI = {
  getAllUsers: async () => {
    const response = await fetch(`${BASE_URL}/users`);
    const data = await handleResponse(response);
    return data.all_users;
  },

  getUserById: async (userId) => {
    const response = await fetch(`${BASE_URL}/users/${userId}`);
    const data = await handleResponse(response);
    return data.user;
  },

  createUser: async (userData) => {
    const response = await fetch(`${BASE_URL}/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        first_name: userData.firstName,
        last_name: userData.lastName,
        email: userData.email,
        age: userData.age,
        gender: userData.gender
      })
    });
    return handleResponse(response);
  },

  updateUser: async (userId, userData) => {
    const response = await fetch(`${BASE_URL}/users/${userId}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        first_name: userData.firstName,
        last_name: userData.lastName,
        email: userData.email,
        age: userData.age,
        gender: userData.gender
      })
    });
    return handleResponse(response);
  },

  deleteUser: async (userId) => {
    const response = await fetch(`${BASE_URL}/users/${userId}`, {
      method: 'DELETE'
    });
    return handleResponse(response);
  }
};

export const sessionAPI = {
  getUserSessions: async (userId) => {
    const response = await fetch(`${BASE_URL}/sessions/${userId}`);
    const data = await handleResponse(response);
    return data.sessions;
  },

  createSession: async (userId, sessionData) => {
    const response = await fetch(`${BASE_URL}/sessions/${userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        startTime: sessionData.start_time,
        endTime: sessionData.end_time,
        note: sessionData.note || ''
      })
    });
    return handleResponse(response);
  },

  updateSession: async (userId, sessionId, sessionData) => {
    const response = await fetch(`${BASE_URL}/sessions/${userId}/${sessionId}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        startTime: sessionData.start_time,
        endTime: sessionData.end_time,
        note: sessionData.note || ''
      })
    });
    return handleResponse(response);
  },

  deleteSession: async (userId, sessionId) => {
    const response = await fetch(`${BASE_URL}/sessions/${userId}/${sessionId}`, {
      method: 'DELETE'
    });
    return handleResponse(response);
  }
};

export const healthAPI = {
  getHealthRecords: async (userId) => {
    const response = await fetch(`${BASE_URL}/health/${userId}`);
    const data = await handleResponse(response);
    return data.user_health_conditions;
  },

  createHealthRecord: async (userId, healthData) => {
    const response = await fetch(`${BASE_URL}/health/${userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        createdAt: healthData.createdAt || new Date().toISOString().slice(0, 19).replace('T', ' '),
        weight: healthData.weight,
        body_fat_percent: healthData.body_fat_percent
      })
    });
    return handleResponse(response);
  },

  deleteHealthRecord: async (userId, createdAt) => {
    const response = await fetch(`${BASE_URL}/health/${userId}/${createdAt}`, {
      method: 'DELETE'
    });
    return handleResponse(response);
  },

  getLatestHealthRecord: async (userId) => {
    const records = await healthAPI.getHealthRecords(userId);
    return records.length > 0 ? records[0] : null;
  }
};

export const exerciseAPI = {
  getAllExercises: async () => {
    const response = await fetch(`${BASE_URL}/exercises`);
    const data = await handleResponse(response);
    return data.exercises;
  },

  getExerciseByName: async (exerciseName) => {
    const response = await fetch(`${BASE_URL}/exercises/${exerciseName}`);
    const data = await handleResponse(response);
    return data.exercise;
  },

  getLiftingExercises: async () => {
    const response = await fetch(`${BASE_URL}/exercises/lifting`);
    const data = await handleResponse(response);
    return data.liftings;
  },

  getAerobicExercises: async () => {
    const response = await fetch(`${BASE_URL}/exercises/aerobics`);
    const data = await handleResponse(response);
    return data.aerobics;
  }
};

export const foodAPI = {
  getAllFoods: async () => {
    const response = await fetch(`${BASE_URL}/foods`);
    const data = await handleResponse(response);
    return data.all_foods;
  },

  getFoodByName: async (foodName) => {
    const response = await fetch(`${BASE_URL}/foods/name/${foodName}`);
    const data = await handleResponse(response);
    return data.food;
  },

  getUserFoods: async (userId) => {
    const response = await fetch(`${BASE_URL}/foods/user/${userId}`);
    const data = await handleResponse(response);
    return data.user_foods;
  },

  createFood: async (foodData) => {
    const response = await fetch(`${BASE_URL}/foods`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        foodName: foodData.foodName,
        calories: foodData.calories,
        carbohydrate: foodData.carbohydrate,
        protein: foodData.protein,
        fat: foodData.fat
      })
    });
    return handleResponse(response);
  },

  logFood: async (userId, foodName, createAt) => {
    const response = await fetch(`${BASE_URL}/foods/log`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        userId,
        foodName,
        createAt: createAt || new Date().toISOString().slice(0, 19).replace('T', ' ')
      })
    });
    return handleResponse(response);
  }
};

export const liftingAPI = {
  getSets: async (liftingName, sessionId) => {
    const response = await fetch(`${BASE_URL}/exercises/lifting/${liftingName}/sets/${sessionId}`);
    const data = await handleResponse(response);
    return data.sets;
  },

  addSet: async (liftingName, sessionId, setData) => {
    const response = await fetch(`${BASE_URL}/exercises/lifting/${liftingName}/sets/${sessionId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        setNum: setData.setNum,
        weight: setData.weight,
        reps: setData.reps
      })
    });
    return handleResponse(response);
  },

  updateSet: async (liftingName, sessionId, setNum, setData) => {
    const response = await fetch(`${BASE_URL}/exercises/lifting/${liftingName}/sets/${sessionId}/${setNum}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        setNum: setData.setNum,
        weight: setData.weight,
        reps: setData.reps
      })
    });
    return handleResponse(response);
  },

  deleteSet: async (liftingName, sessionId, setNum) => {
    const response = await fetch(`${BASE_URL}/exercises/lifting/${liftingName}/sets/${sessionId}/${setNum}`, {
      method: 'DELETE'
    });
    return handleResponse(response);
  }
};

export const dashboardAPI = {
  getDashboardStats: async (userId) => {
    try {
      const [sessions, healthRecords] = await Promise.all([
        sessionAPI.getUserSessions(userId),
        healthAPI.getHealthRecords(userId)
      ]);

      const totalSessions = sessions.length;

      const today = new Date();
      const weekStart = new Date(today);
      weekStart.setDate(today.getDate() - today.getDay());
      weekStart.setHours(0, 0, 0, 0);

      const sessionsThisWeek = sessions.filter(session => {
        const sessionDate = new Date(session.startTime);
        return sessionDate >= weekStart;
      }).length;

      let avgDuration = 0;
      if (sessions.length > 0) {
        const totalMinutes = sessions.reduce((sum, session) => {
          const start = new Date(session.startTime);
          const end = new Date(session.endTime);
          const duration = (end - start) / 1000 / 60;
          return sum + duration;
        }, 0);
        avgDuration = Math.round(totalMinutes / sessions.length);
      }

      const latestHealth = healthRecords.length > 0 ? healthRecords[0] : null;

      return {
        total_sessions: totalSessions,
        sessions_this_week: sessionsThisWeek,
        avg_duration_minutes: avgDuration,
        current_weight: latestHealth ? latestHealth.weight : null,
        current_body_fat: latestHealth ? latestHealth.body_fat_percent : null
      };
    } catch (error) {
      console.error('Error fetching dashboard stats:', error);
      throw error;
    }
  }
};

export default {
  user: userAPI,
  session: sessionAPI,
  health: healthAPI,
  exercise: exerciseAPI,
  food: foodAPI,
  lifting: liftingAPI,
  dashboard: dashboardAPI
};