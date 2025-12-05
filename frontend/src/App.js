import React, { useState, useEffect, useRef } from 'react';
import { Calendar, Dumbbell, Activity, Apple, Heart, Plus, Minus, ChevronRight, TrendingUp, Clock, Trash2, User, LogOut } from 'lucide-react';
import { LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import './App.css';
import api from './api';

const LoginRegister = ({ onLogin }) => {
  const [isLogin, setIsLogin] = useState(true);
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    first_name: '',
    last_name: '',
    age: '',
    gender: 'Male'
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isLogin) {
        const users = await api.user.getAllUsers();
        const user = users.find(u => u.email === formData.email && u.password === formData.password);

        if (user) {
          onLogin(user);
        } else {
          setError('Invalid email or password');
        }
      } else {
        if (!formData.first_name || !formData.last_name || !formData.email || !formData.password) {
          setError('Please fill in all required fields');
          setLoading(false);
          return;
        }

        await api.user.createUser({
          firstName: formData.first_name,
          lastName: formData.last_name,
          email: formData.email,
          password: formData.password,
          age: formData.age ? parseInt(formData.age) : null,
          gender: formData.gender
        });

        const users = await api.user.getAllUsers();
        const newUser = users.find(u => u.email === formData.email && u.password === formData.password);
        if (newUser) {
          onLogin(newUser);
        } else {
          setError('Registration successful but login failed. Please try logging in.');
        }
      }
    } catch (err) {
      setError(err.message || 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <Dumbbell size={40} className="login-icon" />
          <h1 className="login-title">Workout Tracker</h1>
        </div>

        <div className="login-tabs">
          <button
            onClick={() => setIsLogin(true)}
            className={`login-tab ${isLogin ? 'login-tab-active' : ''}`}
          >
            Login
          </button>
          <button
            onClick={() => setIsLogin(false)}
            className={`login-tab ${!isLogin ? 'login-tab-active' : ''}`}
          >
            Register
          </button>
        </div>

        <form onSubmit={handleSubmit} className="login-form">
          {!isLogin && (
            <>
              <div className="form-group">
                <label className="form-label">First Name *</label>
                <input
                  type="text"
                  value={formData.first_name}
                  onChange={(e) => setFormData({ ...formData, first_name: e.target.value })}
                  className="form-input"
                  required
                />
              </div>
              <div className="form-group">
                <label className="form-label">Last Name *</label>
                <input
                  type="text"
                  value={formData.last_name}
                  onChange={(e) => setFormData({ ...formData, last_name: e.target.value })}
                  className="form-input"
                  required
                />
              </div>
            </>
          )}

          <div className="form-group">
            <label className="form-label">Email {!isLogin && '*'}</label>
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              className="form-input"
              required
              placeholder="your.email@example.com"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Password {!isLogin && '*'}</label>
            <input
              type="password"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              className="form-input"
              required
              placeholder="••••••••"
            />
          </div>

          {!isLogin && (
            <>
              <div className="form-group">
                <label className="form-label">Age (optional)</label>
                <input
                  type="number"
                  value={formData.age}
                  onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                  className="form-input"
                  min="1"
                  max="99"
                  placeholder="25"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Gender</label>
                <select
                  value={formData.gender}
                  onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                  className="form-input"
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </>
          )}

          {error && <div className="error">{error}</div>}

          <button type="submit" className="btn-primary btn-full-width" disabled={loading}>
            {loading ? 'Loading...' : isLogin ? 'Login' : 'Register'}
          </button>
        </form>

        <p className="login-footer">
          {isLogin ? "Don't have an account? " : "Already have an account? "}
          <button
            onClick={() => {
              setIsLogin(!isLogin);
              setError('');
            }}
            className="link-button"
          >
            {isLogin ? 'Register' : 'Login'}
          </button>
        </p>
      </div>
    </div>
  );
};

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState('overview');
  const [showNewSession, setShowNewSession] = useState(false);
  const [showNewHealth, setShowNewHealth] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [currentUser, setCurrentUser] = useState({ user_id: 1, first_name: 'User' });
  const [sessions, setSessions] = useState([]);
  const [healthRecords, setHealthRecords] = useState([]);
  const [dashboardStats, setDashboardStats] = useState(null);
  const [exercises, setExercises] = useState([]);
  const [liftingExercises, setLiftingExercises] = useState([]);
  const [aerobicExercises, setAerobicExercises] = useState([]);
  const [exerciseFilter, setExerciseFilter] = useState('all');
  const [muscleGroupFilter, setMuscleGroupFilter] = useState('all');
  const [equipmentFilter, setEquipmentFilter] = useState('all');
  const [foods, setFoods] = useState([]);
  const [userFoods, setUserFoods] = useState([]);
  const [showNewFood, setShowNewFood] = useState(false);
  const [showLogFood, setShowLogFood] = useState(false);
  const [showEditFood, setShowEditFood] = useState(false);
  const [editingFood, setEditingFood] = useState(null);
  const [editingFoodLog, setEditingFoodLog] = useState(null);
  const [showEditFoodLog, setShowEditFoodLog] = useState(false);
  const [foodLogDateRange, setFoodLogDateRange] = useState('7days');
  const [customStartDate, setCustomStartDate] = useState('');
  const [customEndDate, setCustomEndDate] = useState('');
  const [selectedSession, setSelectedSession] = useState(null);
  const [showAddExercise, setShowAddExercise] = useState(false);
  const [showAddSet, setShowAddSet] = useState(false);
  const [showEditSet, setShowEditSet] = useState(false);
  const [editingSet, setEditingSet] = useState(null);
  const [editingSetExercise, setEditingSetExercise] = useState(null);
  const [selectedExercise, setSelectedExercise] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [exerciseRefreshKey, setExerciseRefreshKey] = useState(0);
  const [setRefreshTrigger, setSetRefreshTrigger] = useState(0);
  const [showEditSession, setShowEditSession] = useState(false);
  const [editingSession, setEditingSession] = useState(null);
  const [showAddAerobicMetric, setShowAddAerobicMetric] = useState(false);
  const [selectedAerobicExercise, setSelectedAerobicExercise] = useState(null);
  const [exerciseMuscles, setExerciseMuscles] = useState({});
  const [exerciseEquipment, setExerciseEquipment] = useState({});

  const uniqueMuscleGroups = ['All', 'Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core'];

  const uniqueEquipment = React.useMemo(() => {
    const equipment = new Set();
    Object.values(exerciseEquipment).forEach(items => {
      items.forEach(eq => equipment.add(eq.equipmentName));
    });
    return ['All', ...Array.from(equipment).sort()];
  }, [exerciseEquipment]);

  const getFilteredExercises = () => {
    let filtered = exerciseFilter === 'all' ? exercises :
      exerciseFilter === 'lifting' ? liftingExercises :
        aerobicExercises;

    if (muscleGroupFilter !== 'all' && muscleGroupFilter !== 'All') {
      filtered = filtered.filter(exercise => {
        const muscles = exerciseMuscles[exercise.exerciseName] || [];
        return muscles.some(muscle => {
          const muscleName = muscle.muscleName.toLowerCase();
          const filterLower = muscleGroupFilter.toLowerCase();

          if (filterLower === 'chest') return muscleName.includes('pectoral');
          if (filterLower === 'back') return muscleName.includes('lat') || muscleName.includes('trapezius') || muscleName.includes('rhomboid');
          if (filterLower === 'shoulders') return muscleName.includes('deltoid');
          if (filterLower === 'arms') return muscleName.includes('biceps') || muscleName.includes('triceps') || muscleName.includes('brachialis');
          if (filterLower === 'legs') return muscleName.includes('femoris') || muscleName.includes('vastus') || muscleName.includes('gastrocnemius') || muscleName.includes('soleus');
          if (filterLower === 'core') return muscleName.includes('abdominis') || muscleName.includes('oblique') || muscleName.includes('erector');
          return false;
        });
      });
    }

    if (equipmentFilter !== 'all' && equipmentFilter !== 'All') {
      filtered = filtered.filter(exercise => {
        const equipment = exerciseEquipment[exercise.exerciseName] || [];
        return equipment.some(eq => eq.equipmentName === equipmentFilter);
      });
    }

    return filtered;
  };

  useEffect(() => {
    const savedUser = localStorage.getItem('workout_tracker_user');
    if (savedUser) {
      const user = JSON.parse(savedUser);
      api.user.getUserById(user.user_id)
        .then(() => {
          setCurrentUser(user);
          setIsAuthenticated(true);
        })
        .catch(() => {
          localStorage.removeItem('workout_tracker_user');
          setIsAuthenticated(false);
        });
    }
  }, []);

  useEffect(() => {
    if (isAuthenticated && currentUser.user_id) {
      fetchAllData();
      fetchExercises();
      fetchFoods();
    }
  }, [isAuthenticated, currentUser.user_id]);

  const fetchFoods = async () => {
    if (!currentUser.user_id) return;

    try {
      const [allFoods, userFoodLogs] = await Promise.all([
        api.food.getAllFoods(),
        api.food.getUserFoods(currentUser.user_id)
      ]);
      setFoods(allFoods);
      setUserFoods(userFoodLogs);
    } catch (err) {
      console.error('Error fetching foods:', err);
    }
  };

  const handleLogin = (user) => {
    setCurrentUser(user);
    setIsAuthenticated(true);
    localStorage.setItem('workout_tracker_user', JSON.stringify(user));
  };

  const handleLogout = () => {
    setCurrentUser({ user_id: null, first_name: 'User' });
    setIsAuthenticated(false);
    localStorage.removeItem('workout_tracker_user');
    setActiveTab('overview');
  };

  if (!isAuthenticated) {
    return <LoginRegister onLogin={handleLogin} />;
  }

  const fetchExercises = async () => {
    try {
      const [allExercises, liftings, aerobics] = await Promise.all([
        api.exercise.getAllExercises(),
        api.exercise.getLiftingExercises(),
        api.exercise.getAerobicExercises()
      ]);
      setExercises(allExercises);
      setLiftingExercises(liftings);
      setAerobicExercises(aerobics);

      const musclePromises = liftings.map(ex =>
        fetch(`http://localhost:8000/exercises/lifting/${ex.exerciseName}/muscles`)
          .then(r => r.json())
          .then(data => ({ exerciseName: ex.exerciseName, muscles: data.muscles }))
          .catch(() => ({ exerciseName: ex.exerciseName, muscles: [] }))
      );
      const musclesData = await Promise.all(musclePromises);
      const musclesMap = {};
      musclesData.forEach(item => {
        musclesMap[item.exerciseName] = item.muscles;
      });
      setExerciseMuscles(musclesMap);

      const equipmentPromises = allExercises.map(ex =>
        fetch(`http://localhost:8000/exercises/${ex.exerciseName}/equipment`)
          .then(r => r.json())
          .then(data => ({ exerciseName: ex.exerciseName, equipment: data.equipments }))
          .catch(() => ({ exerciseName: ex.exerciseName, equipment: [] }))
      );
      const equipmentData = await Promise.all(equipmentPromises);
      const equipmentMap = {};
      equipmentData.forEach(item => {
        equipmentMap[item.exerciseName] = item.equipment;
      });
      setExerciseEquipment(equipmentMap);
    } catch (err) {
      console.error('Error fetching exercises:', err);
    }
  };

  const fetchAllData = async () => {
    if (!currentUser.user_id) return;

    try {
      setLoading(true);
      const [userData, sessionsData, healthData, statsData] = await Promise.all([
        api.user.getUserById(currentUser.user_id),
        api.session.getUserSessions(currentUser.user_id),
        api.health.getHealthRecords(currentUser.user_id),
        api.dashboard.getDashboardStats(currentUser.user_id)
      ]);

      setCurrentUser({ ...currentUser, ...userData });
      setSessions(sessionsData);
      setHealthRecords(healthData);
      setDashboardStats(statsData);
      setError(null);
    } catch (err) {
      const errorMessage = err.message || JSON.stringify(err);
      setError(errorMessage);
      console.error('Error fetching data:', err);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (date) => {
    if (!date) return 'N/A';
    const dateStr = date.split('T')[0] || date.split(' ')[0];
    const [year, month, day] = dateStr.split('-');
    return new Date(year, month - 1, day).toLocaleDateString();
  };

  const formatDateTime = (datetime) => {
    if (!datetime) return 'N/A';
    const date = new Date(datetime);
    return date.toLocaleDateString();
  };

  const formatTime = (datetime) => {
    if (!datetime) return 'N/A';
    const date = new Date(datetime);
    return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
  };

  const calculateDuration = (start, end) => {
    if (!start || !end) return '0 min';
    const startDate = new Date(start);
    const endDate = new Date(end);
    const diff = Math.abs(endDate - startDate);
    const minutes = Math.floor(diff / 1000 / 60);
    return `${minutes} min`;
  };

  const calculateDailyMacros = (foods) => {
    let totalCarbs = 0;
    let totalProtein = 0;
    let totalFat = 0;

    foods.forEach(food => {
      const qty = food.quantity || 1;
      totalCarbs += (food.carbohydrate || 0) * qty;
      totalProtein += (food.protein || 0) * qty;
      totalFat += (food.fat || 0) * qty;
    });

    return [
      { name: 'Carbs', value: Math.round(totalCarbs * 10) / 10, color: '#f59e0b' },
      { name: 'Protein', value: Math.round(totalProtein * 10) / 10, color: '#3b82f6' },
      { name: 'Fat', value: Math.round(totalFat * 10) / 10, color: '#10b981' }
    ];
  };

  const getFilteredFoodLogs = () => {
    const now = new Date();
    let startDate = new Date();

    switch (foodLogDateRange) {
      case '7days':
        startDate.setDate(now.getDate() - 7);
        break;
      case '30days':
        startDate.setDate(now.getDate() - 30);
        break;
      case 'thisMonth':
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
        break;
      case 'lastMonth':
        startDate = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        const endDate = new Date(now.getFullYear(), now.getMonth(), 0);
        return userFoods.filter(food => {
          const foodDate = new Date(food.create_at);
          return foodDate >= startDate && foodDate <= endDate;
        });
      case 'custom':
        if (!customStartDate || !customEndDate) return userFoods;
        const customStart = new Date(customStartDate);
        const customEnd = new Date(customEndDate);
        customEnd.setHours(23, 59, 59, 999);
        return userFoods.filter(food => {
          const foodDate = new Date(food.create_at);
          return foodDate >= customStart && foodDate <= customEnd;
        });
      default:
        startDate.setDate(now.getDate() - 7);
    }

    return userFoods.filter(food => {
      const foodDate = new Date(food.create_at);
      return foodDate >= startDate;
    });
  };

  const groupFoodsByDate = (foods) => {
    const grouped = {};

    foods.forEach(food => {
      const dateKey = food.create_at.split('T')[0] || food.create_at.split(' ')[0];
      if (!grouped[dateKey]) {
        grouped[dateKey] = [];
      }
      grouped[dateKey].push(food);
    });

    return grouped;
  };

  const calculateDailyTotals = (foods) => {
    let totalCals = 0;
    let totalCarbs = 0;
    let totalProtein = 0;
    let totalFat = 0;

    foods.forEach(food => {
      const qty = food.quantity || 1;
      totalCals += (food.calories || 0) * qty;
      totalCarbs += (food.carbohydrate || 0) * qty;
      totalProtein += (food.protein || 0) * qty;
      totalFat += (food.fat || 0) * qty;
    });

    return {
      calories: Math.round(totalCals),
      carbs: Math.round(totalCarbs * 10) / 10,
      protein: Math.round(totalProtein * 10) / 10,
      fat: Math.round(totalFat * 10) / 10
    };
  };

  const StatCard = ({ icon: Icon, label, value, trend }) => (
    <div className="stat-card">
      <div className="stat-card-content">
        <div className="stat-card-left">
          <div className="stat-icon-container">
            <Icon className="stat-icon" />
          </div>
          <div>
            <p className="stat-label">{label}</p>
            <p className="stat-value">{value}</p>
          </div>
        </div>
        {trend && (
          <div className="stat-trend">
            <TrendingUp className="trend-icon" />
            <span className="trend-text">{trend}</span>
          </div>
        )}
      </div>
    </div>
  );

  const SessionCard = ({ session }) => (
    <div className="session-card" onClick={() => handleSessionClick(session)}>
      <div className="session-card-content">
        <div className="session-info">
          <div className="session-header">
            <Calendar className="icon-small" />
            <span className="session-date">{formatDateTime(session.startTime)}</span>
            <Clock className="icon-small" />
            <span className="session-time">
              {formatTime(session.startTime)} - {formatTime(session.endTime)}
            </span>
            <span className="session-duration">{calculateDuration(session.startTime, session.endTime)}</span>
          </div>
          <p className="session-note">{session.note || "No notes"}</p>
        </div>
        <div className="session-actions">
          <button
            onClick={(e) => {
              e.stopPropagation();
              setEditingSession(session);
              setShowEditSession(true);
            }}
            className="btn-secondary btn-icon-only"
            title="Edit session"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
            </svg>
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleDeleteSession(session.session_id);
            }}
            className="btn-delete"
            title="Delete session"
          >
            <Trash2 size={16} />
          </button>
          <ChevronRight className="chevron-icon" />
        </div>
      </div>
    </div>
  );

  const handleSessionClick = (session) => {
    setSelectedSession(session);
    setActiveTab('session-detail');
  };

  const handleDeleteSession = async (sessionId) => {
    if (!window.confirm('Are you sure you want to delete this session? This will also delete all exercises and sets associated with it.')) {
      return;
    }

    try {
      await api.session.deleteSession(currentUser.user_id, sessionId);
      fetchAllData();
      if (selectedSession?.session_id === sessionId) {
        setSelectedSession(null);
        setActiveTab('sessions');
      }
    } catch (err) {
      alert('Error deleting session: ' + err.message);
    }
  };

  const EditSessionForm = () => {
    const parseDateTime = (datetime) => {
      if (!datetime) return { date: '', time: '' };
      const dateStr = datetime.includes('T') ? datetime.split('T')[0] : datetime.split(' ')[0];
      const timeStr = datetime.includes('T')
        ? datetime.split('T')[1]?.substring(0, 5)
        : datetime.split(' ')[1]?.substring(0, 5);
      return { date: dateStr || '', time: timeStr || '' };
    };

    const startParsed = parseDateTime(editingSession.startTime);
    const endParsed = parseDateTime(editingSession.endTime);

    const [formData, setFormData] = useState({
      start_date: startParsed.date,
      start_time: startParsed.time,
      end_date: endParsed.date,
      end_time: endParsed.time,
      note: editingSession.note || ''
    });

    const handleSubmit = async () => {
      try {
        const startDateTime = `${formData.start_date} ${formData.start_time}:00`;
        const endDateTime = `${formData.end_date} ${formData.end_time}:00`;

        await api.session.updateSession(currentUser.user_id, editingSession.session_id, {
          start_time: startDateTime,
          end_time: endDateTime,
          note: formData.note
        });

        setShowEditSession(false);
        setEditingSession(null);
        fetchAllData();
        if (selectedSession?.session_id === editingSession.session_id) {
          setSelectedSession({
            ...selectedSession,
            startTime: startDateTime,
            endTime: endDateTime,
            note: formData.note
          });
        }
      } catch (err) {
        alert('Error updating session: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Edit Workout Session</h3>

          <div className="form-container">
            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Start Date</label>
                <input
                  type="date"
                  value={formData.start_date}
                  onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Start Time</label>
                <input
                  type="time"
                  value={formData.start_time}
                  onChange={(e) => setFormData({ ...formData, start_time: e.target.value })}
                  className="form-input"
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">End Date</label>
                <input
                  type="date"
                  value={formData.end_date}
                  onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <label className="form-label">End Time</label>
                <input
                  type="time"
                  value={formData.end_time}
                  onChange={(e) => setFormData({ ...formData, end_time: e.target.value })}
                  className="form-input"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Notes</label>
              <textarea
                value={formData.note}
                onChange={(e) => setFormData({ ...formData, note: e.target.value })}
                className="form-textarea"
                rows="3"
                placeholder="How did the workout feel?"
              />
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => {
              setShowEditSession(false);
              setEditingSession(null);
            }} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Update Session
            </button>
          </div>
        </div>
      </div>
    );
  };

  const NewSessionForm = () => {
    const [formData, setFormData] = useState({
      start_date: '',
      start_time: '',
      end_date: '',
      end_time: '',
      note: ''
    });

    const handleSubmit = async () => {
      try {
        const startDateTime = `${formData.start_date} ${formData.start_time}:00`;
        const endDateTime = `${formData.end_date} ${formData.end_time}:00`;

        await api.session.createSession(currentUser.user_id, {
          start_time: startDateTime,
          end_time: endDateTime,
          note: formData.note
        });

        setShowNewSession(false);
        fetchAllData();
      } catch (err) {
        alert('Error creating session: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">New Workout Session</h3>

          <div className="form-container">
            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Start Date</label>
                <input
                  type="date"
                  value={formData.start_date}
                  onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Start Time</label>
                <input
                  type="time"
                  value={formData.start_time}
                  onChange={(e) => setFormData({ ...formData, start_time: e.target.value })}
                  className="form-input"
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">End Date</label>
                <input
                  type="date"
                  value={formData.end_date}
                  onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <label className="form-label">End Time</label>
                <input
                  type="time"
                  value={formData.end_time}
                  onChange={(e) => setFormData({ ...formData, end_time: e.target.value })}
                  className="form-input"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Notes</label>
              <textarea
                value={formData.note}
                onChange={(e) => setFormData({ ...formData, note: e.target.value })}
                className="form-textarea"
                rows="3"
                placeholder="How did the workout feel?"
              />
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => setShowNewSession(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Create Session
            </button>
          </div>
        </div>
      </div>
    );
  };

  const AddExerciseToSessionForm = () => {
    const [selectedExerciseName, setSelectedExerciseName] = useState('');

    const handleSubmit = async () => {
      if (!selectedExerciseName) {
        alert('Please select an exercise');
        return;
      }

      try {
        await api.session.addExerciseToSession(selectedSession.session_id, selectedExerciseName);
        setShowAddExercise(false);
        setExerciseRefreshKey(prev => prev + 1);
        alert('Exercise added to session!');
      } catch (err) {
        alert('Error adding exercise: ' + (err.message || 'Unknown error'));
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Add Exercise to Session</h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Select Exercise</label>
              <select
                value={selectedExerciseName}
                onChange={(e) => setSelectedExerciseName(e.target.value)}
                className="form-input"
              >
                <option value="">Choose an exercise...</option>
                <optgroup label="Lifting">
                  {liftingExercises.map((ex, i) => (
                    <option key={i} value={ex.exerciseName}>{ex.exerciseName}</option>
                  ))}
                </optgroup>
                <optgroup label="Aerobics">
                  {aerobicExercises.map((ex, i) => (
                    <option key={i} value={ex.exerciseName}>{ex.exerciseName}</option>
                  ))}
                </optgroup>
              </select>
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => setShowAddExercise(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Add Exercise
            </button>
          </div>
        </div>
      </div>
    );
  };

  const AddSetForm = () => {
    const [formData, setFormData] = useState({
      setNum: '',
      weight: '',
      reps: ''
    });

    const handleSubmit = async () => {
      if (!formData.setNum || !formData.weight || !formData.reps) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.lifting.addSet(
          selectedExercise.exerciseName,
          selectedSession.session_id,
          {
            setNum: parseInt(formData.setNum),
            weight: parseFloat(formData.weight),
            reps: parseInt(formData.reps)
          }
        );
        setShowAddSet(false);
        setSetRefreshTrigger(prev => prev + 1);
        alert('Set added successfully!');
      } catch (err) {
        alert('Error adding set: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Add Set - {selectedExercise?.exerciseName}</h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Set Number</label>
              <input
                type="number"
                value={formData.setNum}
                onChange={(e) => setFormData({ ...formData, setNum: e.target.value })}
                className="form-input"
                min="1"
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Weight (lbs)</label>
                <input
                  type="number"
                  step="2.5"
                  value={formData.weight}
                  onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
                  className="form-input"
                  placeholder="135"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Reps</label>
                <input
                  type="number"
                  value={formData.reps}
                  onChange={(e) => setFormData({ ...formData, reps: e.target.value })}
                  className="form-input"
                  placeholder="10"
                />
              </div>
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => setShowAddSet(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Add Set
            </button>
          </div>
        </div>
      </div>
    );
  };

  const EditSetForm = () => {
    const originalSetNum = useRef(editingSet?.setNum);

    const [formData, setFormData] = useState({
      setNum: editingSet?.setNum || 1,
      weight: editingSet?.weight || '',
      reps: editingSet?.reps || ''
    });

    const handleSubmit = async () => {
      if (!formData.setNum || !formData.weight || !formData.reps) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.lifting.updateSet(
          editingSetExercise.exerciseName,
          selectedSession.session_id,
          originalSetNum.current,
          {
            setNum: parseInt(formData.setNum),
            weight: parseFloat(formData.weight),
            reps: parseInt(formData.reps)
          }
        );
        setShowEditSet(false);
        setEditingSet(null);
        setEditingSetExercise(null);
        setSetRefreshTrigger(prev => prev + 1);
        alert('Set updated successfully!');
      } catch (err) {
        alert('Error updating set: ' + err.message);
      }
    };

    const handleDelete = async () => {
      if (!window.confirm('Are you sure you want to delete this set?')) {
        return;
      }

      try {
        await api.lifting.deleteSet(
          editingSetExercise.exerciseName,
          selectedSession.session_id,
          originalSetNum.current
        );
        setShowEditSet(false);
        setEditingSet(null);
        setEditingSetExercise(null);
        setSetRefreshTrigger(prev => prev + 1);
        alert('Set deleted successfully!');
      } catch (err) {
        alert('Error deleting set: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <div className="modal-title-row">
            <h3 className="modal-title">Edit Set - {editingSetExercise?.exerciseName}</h3>
            <button
              onClick={handleDelete}
              className="btn-delete"
              title="Delete set"
            >
              <Trash2 size={16} />
            </button>
          </div>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Set Number</label>
              <input
                type="number"
                value={formData.setNum}
                onChange={(e) => setFormData({ ...formData, setNum: e.target.value })}
                className="form-input"
                min="1"
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Weight (lbs)</label>
                <input
                  type="number"
                  step="2.5"
                  value={formData.weight}
                  onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
                  className="form-input"
                  placeholder="135"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Reps</label>
                <input
                  type="number"
                  value={formData.reps}
                  onChange={(e) => setFormData({ ...formData, reps: e.target.value })}
                  className="form-input"
                  placeholder="10"
                />
              </div>
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => {
              setShowEditSet(false);
              setEditingSet(null);
              setEditingSetExercise(null);
            }} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Update Set
            </button>
          </div>
        </div>
      </div>
    );
  };

  const SessionDetailView = () => {
    const [exerciseSets, setExerciseSets] = useState({});
    const [aerobicMetrics, setAerobicMetrics] = useState({});
    const [expandedExercises, setExpandedExercises] = useState({});
    const [localExercises, setLocalExercises] = useState([]);
    const isFetchingLocalRef = useRef(false);

    useEffect(() => {
      const fetchExercises = async () => {
        if (isFetchingLocalRef.current) return;

        isFetchingLocalRef.current = true;
        try {
          const exerciseNames = await api.session.getSessionExercises(selectedSession.session_id);
          const exerciseDetails = exerciseNames.map(name => ({
            exerciseName: name
          }));
          setLocalExercises(exerciseDetails);
        } catch (err) {
          console.error('Error fetching session exercises:', err);
          setLocalExercises([]);
        } finally {
          isFetchingLocalRef.current = false;
        }
      };

      if (selectedSession?.session_id) {
        fetchExercises();
      }
    }, [selectedSession?.session_id, exerciseRefreshKey]);

    useEffect(() => {
      if (selectedExercise && setRefreshTrigger > 0) {
        refreshSets(selectedExercise.exerciseName);
      }
    }, [setRefreshTrigger]);

    const toggleExercise = async (exerciseName) => {
      const isCurrentlyExpanded = expandedExercises[exerciseName];

      setExpandedExercises(prev => ({
        ...prev,
        [exerciseName]: !prev[exerciseName]
      }));

      if (!isCurrentlyExpanded) {
        const isLiftingExercise = liftingExercises.some(e => e.exerciseName === exerciseName);
        const isAerobicExercise = aerobicExercises.some(e => e.exerciseName === exerciseName);

        if (isLiftingExercise && !exerciseSets[exerciseName]) {
          try {
            const sets = await api.lifting.getSets(exerciseName, selectedSession.session_id);
            setExerciseSets(prev => ({
              ...prev,
              [exerciseName]: sets
            }));
          } catch (err) {
            console.error('Error fetching sets:', err);
            setExerciseSets(prev => ({
              ...prev,
              [exerciseName]: []
            }));
          }
        } else if (isAerobicExercise && !aerobicMetrics[exerciseName]) {
          try {
            const metrics = await api.aerobic.getMetrics(exerciseName, selectedSession.session_id);
            setAerobicMetrics(prev => ({
              ...prev,
              [exerciseName]: metrics
            }));
          } catch (err) {
            console.error('Error fetching aerobic metrics:', err);
            setAerobicMetrics(prev => ({
              ...prev,
              [exerciseName]: []
            }));
          }
        }
      }
    };

    const refreshSets = async (exerciseName) => {
      try {
        const sets = await api.lifting.getSets(exerciseName, selectedSession.session_id);
        setExerciseSets(prev => ({
          ...prev,
          [exerciseName]: sets
        }));
      } catch (err) {
        console.error('Error refreshing sets:', err);
      }
    };

    const handleDeleteSet = async (exerciseName, setNum) => {
      if (!window.confirm('Are you sure you want to delete this set?')) {
        return;
      }

      try {
        await api.lifting.deleteSet(exerciseName, selectedSession.session_id, setNum);
        await refreshSets(exerciseName);
      } catch (err) {
        alert('Error deleting set: ' + err.message);
      }
    };

    const handleRemoveExercise = async (exerciseName) => {
      if (!window.confirm(`Remove ${exerciseName} from this session? This will also delete all associated sets/metrics.`)) {
        return;
      }

      try {
        const isLiftingExercise = liftingExercises.some(e => e.exerciseName === exerciseName);
        const isAerobicExercise = aerobicExercises.some(e => e.exerciseName === exerciseName);

        if (isLiftingExercise) {
          const sets = await api.lifting.getSets(exerciseName, selectedSession.session_id);
          for (const set of sets) {
            await api.lifting.deleteSet(exerciseName, selectedSession.session_id, set.setNum);
          }
        } else if (isAerobicExercise) {
          try {
            const metrics = await api.aerobic.getMetrics(exerciseName, selectedSession.session_id);
            for (const metric of metrics) {
              await api.aerobic.deleteMetric(exerciseName, selectedSession.session_id, metric.metricNum);
            }
          } catch (err) {
            console.log('No metrics to delete or error deleting metrics:', err);
          }
        }

        await api.session.removeExerciseFromSession(selectedSession.session_id, exerciseName);

        setLocalExercises(prev => prev.filter(ex => ex.exerciseName !== exerciseName));

        setExerciseSets(prev => {
          const updated = { ...prev };
          delete updated[exerciseName];
          return updated;
        });
        setAerobicMetrics(prev => {
          const updated = { ...prev };
          delete updated[exerciseName];
          return updated;
        });
        setExpandedExercises(prev => {
          const updated = { ...prev };
          delete updated[exerciseName];
          return updated;
        });
      } catch (err) {
        alert('Error removing exercise: ' + err.message);
      }
    };

    return (
      <div>
        <div className="session-detail-header">
          <button onClick={() => {
            setSelectedSession(null);
            setActiveTab('sessions');
          }} className="btn-secondary btn-back">
            ← Back to Sessions
          </button>
          <button onClick={() => setShowAddExercise(true)} className="btn-primary">
            <Plus className="btn-icon" />
            Add Exercise
          </button>
        </div>

        <div className="session-detail-info">
          <h2 className="page-title">Session Details</h2>
          <div className="session-meta">
            <div className="meta-item">
              <Calendar className="icon-small" />
              <span>{formatDateTime(selectedSession.startTime)}</span>
            </div>
            <div className="meta-item">
              <Clock className="icon-small" />
              <span>{formatTime(selectedSession.startTime)} - {formatTime(selectedSession.endTime)}</span>
            </div>
            <div className="meta-item">
              <Activity className="icon-small" />
              <span>{calculateDuration(selectedSession.startTime, selectedSession.endTime)}</span>
            </div>
          </div>
          {selectedSession.note && (
            <div className="session-note-detail">{selectedSession.note}</div>
          )}
        </div>

        <div className="exercises-section">
          <h3 className="section-title">Exercises</h3>

          {localExercises.length === 0 ? (
            <p className="no-data">No exercises added yet. Click "Add Exercise" to get started!</p>
          ) : (
            <div className="exercise-list">
              {localExercises.map((exercise, i) => {
                const isExpanded = expandedExercises[exercise.exerciseName];
                const isAerobic = aerobicExercises.some(e => e.exerciseName === exercise.exerciseName);

                return (
                  <div key={i} className="exercise-detail-card">
                    <div
                      className="exercise-detail-header"
                      onClick={() => toggleExercise(exercise.exerciseName)}
                    >
                      <div className="exercise-detail-title">
                        {isAerobic ? <Activity size={20} /> : <Dumbbell size={20} />}
                        <span>{exercise.exerciseName}</span>
                      </div>
                      <div className="exercise-detail-actions">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleRemoveExercise(exercise.exerciseName);
                          }}
                          className="btn-delete"
                          title="Remove from session"
                        >
                          <Trash2 size={16} />
                        </button>
                        {isAerobic && (
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedAerobicExercise(exercise);
                              setShowAddAerobicMetric(true);
                            }}
                            className="btn-small"
                          >
                            <Plus size={16} />
                            Add Metrics
                          </button>
                        )}
                        {!isAerobic && (
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedExercise(exercise);
                              setShowAddSet(true);
                            }}
                            className="btn-small"
                          >
                            <Plus size={16} />
                            Add Set
                          </button>
                        )}
                        <ChevronRight
                          className={`chevron-icon ${isExpanded ? 'chevron-expanded' : ''}`}
                        />
                      </div>
                    </div>

                    {isExpanded && (
                      <div className="exercise-detail-content">
                        {isAerobic ? (
                          <div className="aerobics-metrics">
                            {aerobicMetrics[exercise.exerciseName] && aerobicMetrics[exercise.exerciseName].length > 0 ? (
                              aerobicMetrics[exercise.exerciseName].map((metric, idx) => (
                                <div key={idx} className="sets-table-row">
                                  <span>#{metric.metricNum}</span>
                                  <div className="metric-item">
                                    <span className="metric-label">Duration</span>
                                    <span className="metric-value">{metric.duration || '--:--'}</span>
                                  </div>
                                  <div className="metric-item">
                                    <span className="metric-label">Distance</span>
                                    <span className="metric-value">
                                      {metric.distance ? `${metric.distance} mi` : '-- mi'}
                                    </span>
                                  </div>
                                </div>
                              ))
                            ) : (
                              <p className="no-data">No metrics added yet</p>
                            )}
                          </div>
                        ) : (
                          <div className="sets-table">
                            <div className="sets-table-header">
                              <span>Set</span>
                              <span>Weight</span>
                              <span>Reps</span>
                              <span>Actions</span>
                            </div>
                            {exerciseSets[exercise.exerciseName] && exerciseSets[exercise.exerciseName].length > 0 ? (
                              exerciseSets[exercise.exerciseName].map((set, setIndex) => (
                                <div key={setIndex} className="sets-table-row">
                                  <span>Set {set.setNum}</span>
                                  <span>{set.weight} lbs</span>
                                  <span>{set.reps} reps</span>
                                  <div style={{ display: 'flex', gap: '0.5rem' }}>
                                    <button
                                      onClick={() => {
                                        setEditingSet(set);
                                        setEditingSetExercise(exercise);
                                        setShowEditSet(true);
                                      }}
                                      className="btn-secondary btn-icon-only"
                                      title="Edit set"
                                    >
                                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                      </svg>
                                    </button>
                                    <button
                                      onClick={() => handleDeleteSet(exercise.exerciseName, set.setNum)}
                                      className="btn-delete"
                                    >
                                      <Trash2 size={14} />
                                    </button>
                                  </div>
                                </div>
                              ))
                            ) : (
                              <p className="no-data no-data-compact">No sets added yet</p>
                            )}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    );
  };

  const NewHealthRecordForm = () => {
    const [formData, setFormData] = useState({
      date: new Date().toISOString().split('T')[0],
      weight: '',
      body_fat_percent: ''
    });

    const handleSubmit = async () => {
      if (!formData.weight || !formData.body_fat_percent) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.health.createHealthRecord(currentUser.user_id, {
          createdAt: formData.date,
          weight: parseFloat(formData.weight),
          body_fat_percent: parseFloat(formData.body_fat_percent)
        });

        setShowNewHealth(false);
        fetchAllData();
      } catch (err) {
        alert('Error creating health record: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">New Health Record</h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Date</label>
              <input
                type="date"
                value={formData.date}
                onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                className="form-input"
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Weight (lbs)</label>
                <input
                  type="number"
                  value={formData.weight}
                  onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
                  className="form-input"
                  placeholder="185.5"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Body Fat (%)</label>
                <input
                  type="number"
                  value={formData.body_fat_percent}
                  onChange={(e) => setFormData({ ...formData, body_fat_percent: e.target.value })}
                  className="form-input"
                  placeholder="15.2"
                />
              </div>
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => setShowNewHealth(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Add Record
            </button>
          </div>
        </div>
      </div>
    );
  };

  const handleDeleteHealth = async (createdAt) => {
    if (!window.confirm('Are you sure you want to delete this health record?')) {
      return;
    }

    try {
      let dateStr;
      if (typeof createdAt === 'string') {
        if (createdAt.includes('T')) {
          dateStr = createdAt.split('T')[0];
        } else if (createdAt.includes(' ')) {
          dateStr = createdAt.split(' ')[0];
        } else {
          dateStr = createdAt;
        }
      } else {
        const date = new Date(createdAt);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        dateStr = `${year}-${month}-${day}`;
      }

      await api.health.deleteHealthRecord(currentUser.user_id, dateStr);
      await fetchAllData();
    } catch (err) {
      console.error('Delete error:', err);
      alert('Error deleting health record: ' + err.message);
    }
  };

  const NewFoodForm = () => {
    const [formData, setFormData] = useState({
      foodName: '',
      servingSize: '100g',
      carbohydrate: '',
      protein: '',
      fat: ''
    });

    const calculateCalories = () => {
      const carbs = parseFloat(formData.carbohydrate) || 0;
      const protein = parseFloat(formData.protein) || 0;
      const fat = parseFloat(formData.fat) || 0;
      return Math.round(carbs * 4 + protein * 4 + fat * 9);
    };

    const handleSubmit = async () => {
      if (!formData.foodName || !formData.carbohydrate || !formData.protein || !formData.fat) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.food.createFood({
          foodName: formData.foodName,
          servingSize: formData.servingSize || '100g',
          carbohydrate: parseFloat(formData.carbohydrate),
          protein: parseFloat(formData.protein),
          fat: parseFloat(formData.fat)
        });

        setShowNewFood(false);
        fetchFoods();
      } catch (err) {
        alert('Error creating food: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Add New Food</h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Food Name</label>
              <input
                type="text"
                value={formData.foodName}
                onChange={(e) => setFormData({ ...formData, foodName: e.target.value })}
                className="form-input"
                placeholder="e.g., Chicken Breast"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Serving Size</label>
              <div className="input-with-suffix">
                <input
                  type="number"
                  step="1"
                  min="1"
                  value={formData.servingSize.replace('g', '')}
                  onChange={(e) => setFormData({ ...formData, servingSize: e.target.value + 'g' })}
                  className="form-input"
                  placeholder="100"
                />
                <span className="input-suffix">g</span>
              </div>
              <p className="form-hint">
                All macros should be per this serving size (we recommend 100g)
              </p>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Carbs (g)</label>
                <input
                  type="number"
                  value={formData.carbohydrate}
                  onChange={(e) => setFormData({ ...formData, carbohydrate: e.target.value })}
                  className="form-input"
                  placeholder="25.5"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Protein (g)</label>
                <input
                  type="number"
                  value={formData.protein}
                  onChange={(e) => setFormData({ ...formData, protein: e.target.value })}
                  className="form-input"
                  placeholder="30.0"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Fat (g)</label>
              <input
                type="number"
                value={formData.fat}
                onChange={(e) => setFormData({ ...formData, fat: e.target.value })}
                className="form-input"
                placeholder="5.5"
              />
            </div>

            {(formData.carbohydrate || formData.protein || formData.fat) && (
              <div className="calorie-preview">
                <p className="calorie-preview-text">
                  Calculated Calories: {calculateCalories()} cal per {formData.servingSize}
                </p>
              </div>
            )}
          </div>

          <div className="modal-buttons">
            <button onClick={() => setShowNewFood(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Add Food
            </button>
          </div>
        </div>
      </div>
    );
  };

  const EditFoodForm = () => {
    const [formData, setFormData] = useState({
      foodName: editingFood.foodName,
      servingSize: editingFood.servingSize || '100g',
      carbohydrate: editingFood.carbohydrate,
      protein: editingFood.protein,
      fat: editingFood.fat
    });

    const calculateCalories = () => {
      const carbs = parseFloat(formData.carbohydrate) || 0;
      const protein = parseFloat(formData.protein) || 0;
      const fat = parseFloat(formData.fat) || 0;
      return Math.round(carbs * 4 + protein * 4 + fat * 9);
    };

    const handleSubmit = async () => {
      if (!formData.carbohydrate || !formData.protein || !formData.fat) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.food.updateFood(editingFood.foodName, {
          servingSize: formData.servingSize || '100g',
          carbohydrate: parseFloat(formData.carbohydrate),
          protein: parseFloat(formData.protein),
          fat: parseFloat(formData.fat)
        });

        setShowEditFood(false);
        setEditingFood(null);
        fetchFoods();
        alert('Food updated successfully!');
      } catch (err) {
        alert('Error updating food: ' + err.message);
      }
    };

    const handleDelete = async () => {
      if (!window.confirm(`Are you sure you want to delete "${editingFood.foodName}"? This will also delete all food logs associated with it.`)) {
        return;
      }

      try {
        await api.food.deleteFood(editingFood.foodName);
        setShowEditFood(false);
        setEditingFood(null);
        fetchFoods();
        alert('Food deleted successfully!');
      } catch (err) {
        alert('Error deleting food: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <div className="modal-title-row">
            <h3 className="modal-title">Edit Food - {editingFood.foodName}</h3>
            <button
              onClick={handleDelete}
              className="btn-delete"
              title="Delete food"
            >
              <Trash2 size={16} />
            </button>
          </div>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Food Name</label>
              <input
                type="text"
                value={formData.foodName}
                className="form-input food-name-disabled"
                disabled
              />
            </div>

            <div className="form-group">
              <label className="form-label">Serving Size</label>
              <div className="input-with-suffix">
                <input
                  type="number"
                  step="1"
                  min="1"
                  value={formData.servingSize.replace('g', '')}
                  onChange={(e) => setFormData({ ...formData, servingSize: e.target.value + 'g' })}
                  className="form-input"
                  placeholder="100"
                />
                <span className="input-suffix">g</span>
              </div>
              <p className="form-hint">
                All macros should be per this serving size
              </p>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Carbs (g)</label>
                <input
                  type="number"
                  value={formData.carbohydrate}
                  onChange={(e) => setFormData({ ...formData, carbohydrate: e.target.value })}
                  className="form-input"
                  placeholder="25.5"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Protein (g)</label>
                <input
                  type="number"
                  value={formData.protein}
                  onChange={(e) => setFormData({ ...formData, protein: e.target.value })}
                  className="form-input"
                  placeholder="30.0"
                />
              </div>
            </div>

            <div className="form-group">
              <label className="form-label">Fat (g)</label>
              <input
                type="number"
                value={formData.fat}
                onChange={(e) => setFormData({ ...formData, fat: e.target.value })}
                className="form-input"
                placeholder="5.5" />
            </div>

            {(formData.carbohydrate || formData.protein || formData.fat) && (
              <div className="calorie-preview">
                <p className="calorie-preview-text">
                  Calculated Calories: {calculateCalories()} cal per {formData.servingSize}
                </p>
              </div>
            )}
          </div>

          <div className="modal-buttons">
            <button onClick={() => {
              setShowEditFood(false);
              setEditingFood(null);
            }} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Update Food
            </button>
          </div>
        </div>
      </div>
    );
  };

  const LogFoodForm = () => {
    const [selectedFood, setSelectedFood] = useState('');
    const [quantity, setQuantity] = useState(1);
    const [logDate, setLogDate] = useState(new Date().toISOString().split('T')[0]);

    const adjustQuantity = (delta) => {
      setQuantity(prev => Math.max(0.1, Number((prev + delta).toFixed(1))));
    };

    const getSelectedFoodData = () => {
      return foods.find(f => f.foodName === selectedFood);
    };

    const calculateTotal = (value) => {
      return Math.round(value * quantity * 10) / 10;
    };

    const handleSubmit = async () => {
      if (!selectedFood) {
        alert('Please select a food');
        return;
      }

      if (quantity <= 0) {
        alert('Quantity must be greater than 0');
        return;
      }

      try {
        const createAt = `${logDate} ${new Date().toTimeString().split(' ')[0]}`;
        await api.food.logFood(currentUser.user_id, selectedFood, quantity, createAt);
        setShowLogFood(false);
        setSelectedFood('');
        setQuantity(1);
        setLogDate(new Date().toISOString().split('T')[0]);
        fetchFoods();
      } catch (err) {
        alert('Error logging food: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Log Food</h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Select Food</label>
              <select
                value={selectedFood}
                onChange={(e) => {
                  setSelectedFood(e.target.value);
                  setQuantity(1);
                }}
                className="form-input"
              >
                <option value="">Choose a food...</option>
                {foods.map((food, i) => (
                  <option key={i} value={food.foodName}>
                    {food.foodName} - {food.servingSize || '100g'} ({Math.round(food.calories || 0)} cal)
                  </option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label className="form-label">Date</label>
              <input
                type="date"
                value={logDate}
                onChange={(e) => setLogDate(e.target.value)}
                className="form-input"
              />
            </div>

            {selectedFood && getSelectedFoodData() && (
              <>
                <div className="form-group">
                  <label className="form-label">
                    Quantity (servings of {getSelectedFoodData().servingSize || '100g'})
                  </label>
                  <div className="quantity-controls">
                    <button
                      type="button"
                      onClick={() => adjustQuantity(-0.5)}
                      className="btn-secondary quantity-btn"
                    >
                      <Minus size={16} />
                    </button>
                    <input
                      type="number"
                      step="0.1"
                      value={quantity}
                      onChange={(e) => {
                        const val = e.target.value;
                        setQuantity(val === '' ? '' : parseFloat(val));
                      }}
                      className="form-input quantity-input"
                    />
                    {quantity !== '' && parseFloat(quantity) <= 0 && (
                      <p className="form-hint error-hint">
                        Quantity must be greater than 0
                      </p>
                    )}
                    <button
                      type="button"
                      onClick={() => adjustQuantity(0.5)}
                      className="btn-secondary quantity-btn"
                    >
                      <Plus size={16} />
                    </button>
                  </div>
                  <p className="quantity-hint">
                    = {(quantity * (getSelectedFoodData().servingSize === '100g' ? 100 : 1)).toFixed(0)}g total
                  </p>
                </div>

                <div className="food-preview">
                  <h4>Total Nutritional Info:</h4>
                  <div className="macro-grid">
                    <div className="macro-item">
                      <span className="macro-label">Calories</span>
                      <span className="macro-value">
                        {calculateTotal(getSelectedFoodData().calories)}
                      </span>
                    </div>
                    <div className="macro-item">
                      <span className="macro-label">Carbs</span>
                      <span className="macro-value">
                        {calculateTotal(getSelectedFoodData().carbohydrate)}g
                      </span>
                    </div>
                    <div className="macro-item">
                      <span className="macro-label">Protein</span>
                      <span className="macro-value">
                        {calculateTotal(getSelectedFoodData().protein)}g
                      </span>
                    </div>
                    <div className="macro-item">
                      <span className="macro-label">Fat</span>
                      <span className="macro-value">
                        {calculateTotal(getSelectedFoodData().fat)}g
                      </span>
                    </div>
                  </div>
                  <p className="quantity-summary">
                    {quantity} × {getSelectedFoodData().servingSize || '100g'} serving
                  </p>
                </div>
              </>
            )}
          </div>

          <div className="modal-buttons">
            <button onClick={() => {
              setShowLogFood(false);
              setSelectedFood('');
              setQuantity(1);
              setLogDate(new Date().toISOString().split('T')[0]);
            }} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Log Food
            </button>
          </div>
        </div>
      </div>
    );
  };

  const EditFoodLogForm = () => {
    const [quantity, setQuantity] = useState(editingFoodLog.quantity || 1);
    const [logDate, setLogDate] = useState(
      editingFoodLog.create_at.split('T')[0] || editingFoodLog.create_at.split(' ')[0]
    );

    const adjustQuantity = (delta) => {
      setQuantity(prev => Math.max(0.1, Number((prev + delta).toFixed(1))));
    };

    const calculateTotal = (value) => {
      return Math.round(value * quantity * 10) / 10;
    };

    const handleSubmit = async () => {
      if (quantity <= 0) {
        alert('Quantity must be greater than 0');
        return;
      }

      try {
        const oldCreateAt = editingFoodLog.create_at.split('T')[0] || editingFoodLog.create_at.split(' ')[0];
        const oldTime = editingFoodLog.create_at.split('T')[1]?.substring(0, 8) ||
          editingFoodLog.create_at.split(' ')[1]?.substring(0, 8) || '00:00:00';

        await api.food.deleteUserFoodLog(
          currentUser.user_id,
          editingFoodLog.foodName,
          `${oldCreateAt} ${oldTime}`
        );

        const newCreateAt = `${logDate} ${oldTime}`;
        await api.food.logFood(currentUser.user_id, editingFoodLog.foodName, quantity, newCreateAt);

        setShowEditFoodLog(false);
        setEditingFoodLog(null);
        fetchFoods();
        alert('Food log updated successfully!');
      } catch (err) {
        alert('Error updating food log: ' + err.message);
      }
    };

    const handleDelete = async () => {
      if (!window.confirm('Are you sure you want to delete this food log entry?')) {
        return;
      }

      try {
        const dateStr = editingFoodLog.create_at.split('T')[0] || editingFoodLog.create_at.split(' ')[0];
        const timeStr = editingFoodLog.create_at.split('T')[1]?.substring(0, 8) ||
          editingFoodLog.create_at.split(' ')[1]?.substring(0, 8) || '00:00:00';

        await api.food.deleteUserFoodLog(
          currentUser.user_id,
          editingFoodLog.foodName,
          `${dateStr} ${timeStr}`
        );

        setShowEditFoodLog(false);
        setEditingFoodLog(null);
        fetchFoods();
        alert('Food log deleted successfully!');
      } catch (err) {
        alert('Error deleting food log: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <div className="modal-title-row">
            <h3 className="modal-title">Edit Food Log</h3>
            <button
              onClick={handleDelete}
              className="btn-delete"
              title="Delete food log"
            >
              <Trash2 size={16} />
            </button>
          </div>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Food</label>
              <input
                type="text"
                value={editingFoodLog.foodName}
                className="form-input food-name-disabled"
                disabled
              />
            </div>

            <div className="form-group">
              <label className="form-label">Date</label>
              <input
                type="date"
                value={logDate}
                onChange={(e) => setLogDate(e.target.value)}
                className="form-input"
              />
            </div>

            <div className="form-group">
              <label className="form-label">
                Quantity (servings of {editingFoodLog.servingSize || '100g'})
              </label>
              <div className="quantity-controls">
                <button
                  type="button"
                  onClick={() => adjustQuantity(-0.5)}
                  className="btn-secondary quantity-btn"
                >
                  <Minus size={16} />
                </button>
                <input
                  type="number"
                  step="0.1"
                  value={quantity}
                  onChange={(e) => {
                    const val = e.target.value;
                    setQuantity(val === '' ? '' : parseFloat(val));
                  }}
                  className="form-input quantity-input"
                />
                <button
                  type="button"
                  onClick={() => adjustQuantity(0.5)}
                  className="btn-secondary quantity-btn"
                >
                  <Plus size={16} />
                </button>
              </div>
              {quantity !== '' && parseFloat(quantity) <= 0 && (
                <p className="form-hint error-hint">
                  Quantity must be greater than 0
                </p>
              )}
            </div>

            <div className="food-preview">
              <h4>Total Nutritional Info:</h4>
              <div className="macro-grid">
                <div className="macro-item">
                  <span className="macro-label">Calories</span>
                  <span className="macro-value">
                    {calculateTotal(editingFoodLog.calories)}
                  </span>
                </div>
                <div className="macro-item">
                  <span className="macro-label">Carbs</span>
                  <span className="macro-value">
                    {calculateTotal(editingFoodLog.carbohydrate)}g
                  </span>
                </div>
                <div className="macro-item">
                  <span className="macro-label">Protein</span>
                  <span className="macro-value">
                    {calculateTotal(editingFoodLog.protein)}g
                  </span>
                </div>
                <div className="macro-item">
                  <span className="macro-label">Fat</span>
                  <span className="macro-value">
                    {calculateTotal(editingFoodLog.fat)}g
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div className="modal-buttons">
            <button onClick={() => {
              setShowEditFoodLog(false);
              setEditingFoodLog(null);
            }} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Update Log
            </button>
          </div>
        </div>
      </div>
    );
  };

  const AddAerobicMetricForm = () => {
    const [formData, setFormData] = useState({
      metricNum: '',
      duration: '',
      distance: ''
    });
    const [existingMetrics, setExistingMetrics] = useState([]);

    useEffect(() => {
      const fetchExisting = async () => {
        if (selectedAerobicExercise) {
          try {
            const metrics = await api.aerobic.getMetrics(
              selectedAerobicExercise.exerciseName,
              selectedSession.session_id
            );
            setExistingMetrics(metrics);
          } catch (err) {
            console.error('Error fetching existing metrics:', err);
            setExistingMetrics([]);
          }
        }
      };
      fetchExisting();
    }, [selectedAerobicExercise]);

    const handleSubmit = async () => {
      if (!formData.metricNum) {
        alert('Please provide a metric number');
        return;
      }

      if (!formData.duration && !formData.distance) {
        alert('Please fill in at least one field (duration or distance)');
        return;
      }

      try {
        const existingMetric = existingMetrics.find(m => m.metricNum === parseInt(formData.metricNum));

        if (existingMetric) {
          await api.aerobic.updateMetric(
            selectedAerobicExercise.exerciseName,
            selectedSession.session_id,
            parseInt(formData.metricNum),
            {
              metricNum: parseInt(formData.metricNum),
              duration: formData.duration || null,
              distance: formData.distance ? parseFloat(formData.distance) : null
            }
          );
        } else {
          await api.aerobic.addMetric(
            selectedAerobicExercise.exerciseName,
            selectedSession.session_id,
            {
              metricNum: parseInt(formData.metricNum),
              duration: formData.duration || null,
              distance: formData.distance ? parseFloat(formData.distance) : null
            }
          );
        }

        setShowAddAerobicMetric(false);
        setExerciseRefreshKey(prev => prev + 1);
        alert('Metrics saved successfully!');
      } catch (err) {
        alert('Error saving metrics: ' + err.message);
      }
    };

    const handleDelete = async () => {
      if (!formData.metricNum) {
        alert('Please select a metric number to delete');
        return;
      }

      if (!window.confirm('Are you sure you want to delete this metric?')) {
        return;
      }

      try {
        await api.aerobic.deleteMetric(
          selectedAerobicExercise.exerciseName,
          selectedSession.session_id,
          parseInt(formData.metricNum)
        );
        setShowAddAerobicMetric(false);
        setExerciseRefreshKey(prev => prev + 1);
        alert('Metric deleted successfully!');
      } catch (err) {
        alert('Error deleting metric: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">
            Manage Metrics - {selectedAerobicExercise?.exerciseName}
          </h3>

          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Metric Number</label>
              <input
                type="number"
                value={formData.metricNum}
                onChange={(e) => {
                  const metricNum = e.target.value;
                  setFormData({ ...formData, metricNum });

                  if (metricNum) {
                    const existing = existingMetrics.find(m => m.metricNum === parseInt(metricNum));
                    if (existing) {
                      setFormData({
                        metricNum,
                        duration: existing.duration || '',
                        distance: existing.distance || ''
                      });
                    }
                  }
                }}
                className="form-input"
                min="1"
                placeholder="1"
              />
              <p className="form-hint">
                {existingMetrics.length > 0 && (
                  <>Existing metrics: {existingMetrics.map(m => m.metricNum).join(', ')}</>
                )}
              </p>
            </div>

            <div className="form-group">
              <label className="form-label">Duration (HH:MM:SS)</label>
              <input
                type="text"
                value={formData.duration}
                onChange={(e) => setFormData({ ...formData, duration: e.target.value })}
                className="form-input"
                placeholder="00:30:00"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Distance (miles)</label>
              <input
                type="number"
                value={formData.distance}
                onChange={(e) => setFormData({ ...formData, distance: e.target.value })}
                className="form-input"
                placeholder="3.5"
              />
            </div>
          </div>

          <div className="modal-buttons">
            {formData.metricNum && existingMetrics.some(m => m.metricNum === parseInt(formData.metricNum)) && (
              <button
                onClick={handleDelete}
                className="btn-delete"
                style={{ marginRight: 'auto' }}
              >
                <Trash2 size={16} />
                Delete
              </button>
            )}
            <button onClick={() => setShowAddAerobicMetric(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              {formData.metricNum && existingMetrics.some(m => m.metricNum === parseInt(formData.metricNum))
                ? 'Update' : 'Add'} Metric
            </button>
          </div>
        </div>
      </div>
    );
  };

  return (
    <div className="app">
      <div className="header">
        <div className="header-content">
          <div>
            <h1 className="header-title">Workout Tracker</h1>
            <p className="header-subtitle">Welcome back, {currentUser.first_name}!</p>
          </div>
          <div className="header-actions">
            <div className="user-info">
              <User size={20} />
              <span>{currentUser.email}</span>
            </div>
            <button onClick={() => setShowNewSession(true)} className="btn-primary">
              <Plus className="btn-icon" />
              New Session
            </button>
            <button onClick={handleLogout} className="btn-secondary btn-logout">
              <LogOut size={20} />
            </button>
          </div>
        </div>
      </div>

      <div className="tabs-container">
        <div className="tabs">
          {[
            { id: 'overview', label: 'Overview', icon: Activity },
            { id: 'sessions', label: 'Sessions', icon: Calendar },
            { id: 'exercises', label: 'Exercises', icon: Dumbbell },
            { id: 'nutrition', label: 'Nutrition', icon: Apple },
            { id: 'health', label: 'Health', icon: Heart }
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`tab ${activeTab === tab.id ? 'tab-active' : ''}`}
            >
              <tab.icon className="tab-icon" />
              <span>{tab.label}</span>
            </button>
          ))}
        </div>
      </div>

      <div className="main-content">
        {loading && <div className="loading">Loading...</div>}
        {error && <div className="error">Error: {error}</div>}

        {!loading && activeTab === 'overview' && (
          <div className="content-container">
            <div className="stats-grid">
              <StatCard
                icon={Calendar}
                label="Total Sessions"
                value={dashboardStats?.total_sessions || 0}
                trend={dashboardStats?.sessions_this_week ? `+${dashboardStats.sessions_this_week} this week` : null}
              />
              <StatCard
                icon={Dumbbell}
                label="Current Weight"
                value={dashboardStats?.current_weight ? `${dashboardStats.current_weight} lbs` : 'N/A'}
              />
              <StatCard
                icon={Activity}
                label="Avg Duration"
                value={dashboardStats?.avg_duration_minutes ? `${dashboardStats.avg_duration_minutes} min` : 'N/A'}
              />
              <StatCard
                icon={Heart}
                label="Body Fat"
                value={dashboardStats?.current_body_fat ? `${dashboardStats.current_body_fat}%` : 'N/A'}
              />
            </div>

            <div className="section">
              <div className="section-header">
                <h2 className="section-title">Recent Sessions</h2>
                <button onClick={() => setActiveTab('sessions')} className="link-button">
                  View All
                </button>
              </div>
              <div className="sessions-list">
                {sessions.slice(0, 5).map((session, index) => (
                  <SessionCard key={index} session={session} />
                ))}
                {sessions.length === 0 && <p className="no-data">No sessions yet</p>}
              </div>
            </div>

            <div className="card">
              <h2 className="card-title">Weight Progress</h2>
              <div className="health-records">
                {healthRecords.slice(0, 5).map((record, i) => (
                  <div key={i} className="health-record">
                    <span className="health-date">{formatDate(record.createdAt)}</span>
                    <div className="health-stats">
                      <span className="health-stat">{record.weight} lbs</span>
                      <span className="health-stat-secondary">{record.body_fat_percent}% BF</span>
                    </div>
                  </div>
                ))}
                {healthRecords.length === 0 && <p className="no-data">No health records yet</p>}
              </div>
            </div>
          </div>
        )}

        {!loading && activeTab === 'sessions' && (
          <div>
            <h2 className="page-title">All Sessions</h2>
            <div className="sessions-list">
              {sessions.map((session, index) => (
                <SessionCard key={index} session={session} />
              ))}
              {sessions.length === 0 && <p className="no-data">No sessions yet</p>}
            </div>
          </div>
        )}

        {!loading && activeTab === 'session-detail' && selectedSession && (
          <SessionDetailView />
        )}

        {!loading && activeTab === 'exercises' && (
          <div>
            <div className="section-header">
              <h2 className="page-title">Exercise Library</h2>
            </div>

            <div className="exercise-filter-group">
              <div className="filter-group-label">Exercise Type:</div>
              <div className="filter-buttons">
                <button
                  onClick={() => setExerciseFilter('all')}
                  className={exerciseFilter === 'all' ? 'filter-btn filter-btn-active' : 'filter-btn'}
                >
                  All ({exercises.length})
                </button>
                <button
                  onClick={() => setExerciseFilter('lifting')}
                  className={exerciseFilter === 'lifting' ? 'filter-btn filter-btn-active' : 'filter-btn'}
                >
                  Lifting ({liftingExercises.length})
                </button>
                <button
                  onClick={() => setExerciseFilter('aerobics')}
                  className={exerciseFilter === 'aerobics' ? 'filter-btn filter-btn-active' : 'filter-btn'}
                >
                  Aerobics ({aerobicExercises.length})
                </button>
              </div>
            </div>

            {exerciseFilter !== 'aerobics' && (
              <div className="exercise-filter-group">
                <div className="filter-group-label">Target Muscle Group:</div>
                <div className="filter-buttons">
                  {uniqueMuscleGroups.map(group => (
                    <button
                      key={group}
                      onClick={() => setMuscleGroupFilter(group.toLowerCase())}
                      className={muscleGroupFilter === group.toLowerCase() ? 'filter-btn filter-btn-active' : 'filter-btn'}
                    >
                      {group}
                    </button>
                  ))}
                </div>
              </div>
            )}

            <div className="exercise-filter-group">
              <div className="filter-group-label">Equipment Available:</div>
              <select
                value={equipmentFilter}
                onChange={(e) => setEquipmentFilter(e.target.value)}
                className="form-input equipment-select"
              >
                {uniqueEquipment.map(eq => (
                  <option key={eq} value={eq}>
                    {eq}
                  </option>
                ))}
              </select>
            </div>

            <div className="exercise-grid">
              {getFilteredExercises().map((exercise, i) => {
                const isAerobic = aerobicExercises.some(e => e.exerciseName === exercise.exerciseName);
                const muscles = !isAerobic ? exerciseMuscles[exercise.exerciseName] || [] : [];
                const equipment = exerciseEquipment[exercise.exerciseName] || [];

                return (
                  <div key={i} className="exercise-card">
                    <div className="exercise-card-header">
                      <div className="exercise-icon">
                        {isAerobic ? (
                          <Activity size={20} />
                        ) : (
                          <Dumbbell size={20} />
                        )}
                      </div>
                      <div className="exercise-badge">
                        {isAerobic ? 'Aerobics' : 'Lifting'}
                      </div>
                    </div>
                    <h3 className="exercise-name">{exercise.exerciseName || exercise.exercise_name}</h3>
                    <p className="exercise-description">
                      {exercise.description || 'No description available'}
                    </p>

                    {equipment.length > 0 && (
                      <div className="exercise-equipment">
                        <div className="equipment-label">Equipment:</div>
                        <div className="equipment-tags">
                          {equipment.map((eq, idx) => (
                            <span key={idx} className="equipment-tag" title={eq.description || eq.equipmentName}>
                              {eq.equipmentName}
                            </span>
                          ))}
                        </div>
                      </div>
                    )}

                    {muscles.length > 0 && (
                      <div className="exercise-muscles">
                        <div className="muscles-label">Target Muscles:</div>
                        <div className="muscles-tags">
                          {muscles.map((muscle, idx) => (
                            <span key={idx} className="muscle-tag">
                              {muscle.muscleName}
                            </span>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            {getFilteredExercises().length === 0 && (
              <p className="no-data">No exercises found matching your filters</p>
            )}
          </div>
        )}
        {!loading && activeTab === 'nutrition' && (
          <div>
            <div className="section-header">
              <h2 className="page-title">Nutrition Tracking</h2>
              <div className="section-actions">
                <button onClick={() => setShowLogFood(true)} className="btn-primary">
                  <Plus className="btn-icon" />
                  Log Food
                </button>
                <button onClick={() => setShowNewFood(true)} className="btn-secondary">
                  <Plus className="btn-icon" />
                  Add Food
                </button>
              </div>
            </div>

            {(() => {
              const today = new Date();
              today.setHours(0, 0, 0, 0);

              const todaysFoods = userFoods.filter(food => {
                const foodDate = new Date(food.create_at);
                foodDate.setHours(0, 0, 0, 0);
                return foodDate.getTime() === today.getTime();
              });

              if (todaysFoods.length > 0) {
                const macroData = calculateDailyMacros(todaysFoods);
                const totalGrams = macroData.reduce((sum, item) => sum + item.value, 0);
                const totalCalories = todaysFoods.reduce((sum, food) => {
                  return sum + ((food.calories || 0) * (food.quantity || 1));
                }, 0);

                return (
                  <div className="card card-spacing">
                    <h3 className="card-title">Today's Macro Distribution</h3>
                    <div className="macro-chart-container">
                      <ResponsiveContainer width={400} height={300}>
                        <PieChart>
                          <Pie
                            data={macroData}
                            cx="50%"
                            cy="50%"
                            labelLine={false}
                            label={({ name, value }) => `${name}: ${value}g`}
                            outerRadius={100}
                            fill="#8884d8"
                            dataKey="value"
                          >
                            {macroData.map((entry, index) => (
                              <Cell key={`cell-${index}`} fill={entry.color} />
                            ))}
                          </Pie>
                          <Tooltip />
                          <Legend />
                        </PieChart>
                      </ResponsiveContainer>

                      <div className="macro-stats-panel">
                        <div className="macro-stats-total">
                          <div className="macro-stats-label">Total Calories Today</div>
                          <div className="macro-stats-value">{Math.round(totalCalories)} cal</div>
                        </div>
                        <div>
                          <div className="macro-stats-subtitle">Total Macros</div>
                          <div className="macro-stats-secondary-value">{totalGrams.toFixed(1)}g</div>
                        </div>
                        <div className="macro-divider" />
                        {macroData.map((macro, i) => (
                          <div key={i} className="macro-stat-item">
                            <div className="macro-color-dot" style={{ backgroundColor: macro.color }} />
                            <span>
                              {macro.name}: {macro.value}g ({Math.round((macro.value / totalGrams) * 100)}%)
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                );
              } else {
                return (
                  <div className="card card-spacing">
                    <h3 className="card-title">Today's Macro Distribution</h3>
                    <p className="no-data">No food logged today. Start logging to see your macro breakdown!</p>
                  </div>
                );
              }
            })()}

            <div className="card card-spacing">
              <div className="food-log-header">
                <h3 className="card-title">Food Log</h3>
                <div className="date-range-controls">
                  <select
                    value={foodLogDateRange}
                    onChange={(e) => setFoodLogDateRange(e.target.value)}
                    className="form-input"
                  >
                    <option value="7days">Last 7 Days</option>
                    <option value="30days">Last 30 Days</option>
                    <option value="thisMonth">This Month</option>
                    <option value="lastMonth">Last Month</option>
                    <option value="custom">Custom Range</option>
                  </select>
                </div>
              </div>

              {foodLogDateRange === 'custom' && (
                <div className="custom-date-range">
                  <input
                    type="date"
                    value={customStartDate}
                    onChange={(e) => setCustomStartDate(e.target.value)}
                    className="form-input"
                  />
                  <span>to</span>
                  <input
                    type="date"
                    value={customEndDate}
                    onChange={(e) => setCustomEndDate(e.target.value)}
                    className="form-input"
                  />
                </div>
              )}

              {(() => {
                const filteredFoods = getFilteredFoodLogs();
                const groupedFoods = groupFoodsByDate(filteredFoods);
                const dates = Object.keys(groupedFoods).sort((a, b) => new Date(b) - new Date(a));

                if (dates.length === 0) {
                  return <p className="no-data">No food logged in this date range</p>;
                }

                return (
                  <div className="food-log-days-container">
                    {dates.map((date, idx) => {
                      const foods = groupedFoods[date];
                      const totals = calculateDailyTotals(foods);
                      const dateObj = new Date(date + 'T00:00:00');
                      const today = new Date();
                      const yesterday = new Date(today);
                      yesterday.setDate(yesterday.getDate() - 1);

                      let dateLabel = formatDate(date);
                      if (dateObj.toDateString() === today.toDateString()) {
                        dateLabel = 'Today';
                      } else if (dateObj.toDateString() === yesterday.toDateString()) {
                        dateLabel = 'Yesterday';
                      }

                      return (
                        <div key={idx} className="card daily-food-card">
                          <div className="daily-food-header">
                            <div className="daily-food-title-row">
                              <h4 className="daily-food-title">{dateLabel}</h4>
                              <div className="daily-food-totals">
                                {totals.calories} cal | C: {totals.carbs}g P: {totals.protein}g F: {totals.fat}g
                              </div>
                            </div>
                          </div>

                          <div className="food-log-list">
                            {foods.map((food, i) => {
                              const qty = food.quantity || 1;
                              const totalCals = Math.round((food.calories || 0) * qty);
                              const totalCarbs = Math.round((food.carbohydrate || 0) * qty * 10) / 10;
                              const totalProtein = Math.round((food.protein || 0) * qty * 10) / 10;
                              const totalFat = Math.round((food.fat || 0) * qty * 10) / 10;

                              return (
                                <div key={i} className="food-log-item">
                                  <div>
                                    <div className="food-log-name">
                                      {food.foodName || food.food_name}
                                      {qty !== 1 && (
                                        <span className="food-quantity-badge">
                                          ({qty} × {food.servingSize || '100g'})
                                        </span>
                                      )}
                                    </div>
                                  </div>
                                  <div className="food-log-actions">
                                    <div className="food-log-macros">
                                      <span className="macro-badge">{totalCals} cal</span>
                                      <span className="macro-badge">C: {totalCarbs}g</span>
                                      <span className="macro-badge">P: {totalProtein}g</span>
                                      <span className="macro-badge">F: {totalFat}g</span>
                                    </div>
                                    <button
                                      onClick={() => {
                                        setEditingFoodLog(food);
                                        setShowEditFoodLog(true);
                                      }}
                                      className="btn-secondary btn-icon-only"
                                      title="Edit food log"
                                    >
                                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                      </svg>
                                    </button>
                                  </div>
                                </div>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                );
              })()}
            </div>

            <div className="card">
              <h3 className="card-title">Food Database ({foods.length} foods)</h3>
              <div className="food-grid">
                {foods.map((food, i) => (
                  <div key={i} className="food-card food-card-relative">
                    <button
                      onClick={() => {
                        setEditingFood(food);
                        setShowEditFood(true);
                      }}
                      className="food-edit-btn"
                      title="Edit food"
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                      </svg>
                    </button>

                    <div className="food-card-header">
                      <h4 className="food-name food-name-no-margin">{food.foodName}</h4>
                      <span className="food-calories">{Math.round(food.calories || 0)} cal</span>
                    </div>

                    <p className="food-serving-text">per {food.servingSize}g</p>

                    <div className="food-macros">
                      <div className="macro-detail">
                        <span className="macro-label">Carbs</span>
                        <span className="macro-value">{food.carbohydrate}g</span>
                      </div>
                      <div className="macro-detail">
                        <span className="macro-label">Protein</span>
                        <span className="macro-value">{food.protein}g</span>
                      </div>
                      <div className="macro-detail">
                        <span className="macro-label">Fat</span>
                        <span className="macro-value">{food.fat}g</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {!loading && activeTab === 'health' && (
          <div>
            <div className="section-header">
              <h2 className="page-title">Health Records</h2>
              <button onClick={() => setShowNewHealth(true)} className="btn-primary">
                <Plus className="btn-icon" />
                Add Record
              </button>
            </div>

            {healthRecords.length > 0 && (
              <div className="card card-spacing">
                <h3 className="card-title">Health Progress</h3>
                <div className="health-charts-grid">
                  <div className="chart-container">
                    <h4 className="chart-title">Weight Progress</h4>
                    <ResponsiveContainer width="100%" height={300}>
                      <LineChart
                        data={healthRecords.slice().reverse()}
                        margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                      >
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis
                          dataKey="createdAt"
                          tickFormatter={(value) => formatDateTime(value)}
                          style={{ fontSize: '0.75rem' }}
                        />
                        <YAxis
                          label={{ value: 'Weight (lbs)', angle: -90, position: 'insideLeft' }}
                          domain={(() => {
                            const weights = healthRecords.map(r => r.weight);
                            const minWeight = Math.min(...weights);
                            const maxWeight = Math.max(...weights);
                            const range = maxWeight - minWeight;
                            const padding = Math.max(range * 0.2, 5);
                            return [
                              Math.floor(minWeight - padding),
                              Math.ceil(maxWeight + padding)
                            ];
                          })()}
                        />
                        <Tooltip
                          labelFormatter={(value) => formatDateTime(value)}
                          formatter={(value) => [`${value} lbs`, 'Weight']}
                        />
                        <Line
                          type="monotone"
                          dataKey="weight"
                          stroke="#2563eb"
                          name="Weight (lbs)"
                          strokeWidth={3}
                          dot={{ r: 4 }}
                          activeDot={{ r: 6 }}
                        />
                      </LineChart>
                    </ResponsiveContainer>
                  </div>
                  <div className="chart-container">
                    <h4 className="chart-title">Body Fat Progress</h4>
                    <ResponsiveContainer width="100%" height={300}>
                      <LineChart
                        data={healthRecords.slice().reverse()}
                        margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                      >
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis
                          dataKey="createdAt"
                          tickFormatter={(value) => formatDateTime(value)}
                          style={{ fontSize: '0.75rem' }}
                        />
                        <YAxis
                          label={{ value: 'Body Fat %', angle: -90, position: 'insideLeft' }}
                          domain={(() => {
                            const bodyFats = healthRecords.map(r => r.body_fat_percent);
                            const minBF = Math.min(...bodyFats);
                            const maxBF = Math.max(...bodyFats);
                            const range = maxBF - minBF;
                            const padding = Math.max(range * 0.2, 2);
                            return [
                              Math.max(0, Math.floor(minBF - padding)),
                              Math.min(100, Math.ceil(maxBF + padding))
                            ];
                          })()}
                        />
                        <Tooltip
                          labelFormatter={(value) => formatDateTime(value)}
                          formatter={(value) => [`${value}%`, 'Body Fat']}
                        />
                        <Line
                          type="monotone"
                          dataKey="body_fat_percent"
                          stroke="#059669"
                          name="Body Fat %"
                          strokeWidth={3}
                          dot={{ r: 4 }}
                          activeDot={{ r: 6 }}
                        />
                      </LineChart>
                    </ResponsiveContainer>
                  </div>
                </div>
              </div>
            )}

            <div className="card">
              <h3 className="card-title">All Records</h3>
              <div className="health-records-list">
                {healthRecords.map((record, i) => (
                  <div key={i} className="health-record-card">
                    <div>
                      <span className="health-record-date">{formatDateTime(record.createdAt)}</span>
                      <div className="health-record-stats">
                        <div>
                          <span className="label">Weight: </span>
                          <span className="value">{record.weight} lbs</span>
                        </div>
                        <div>
                          <span className="label">Body Fat: </span>
                          <span className="value">{record.body_fat_percent}%</span>
                        </div>
                      </div>
                    </div>
                    <button
                      onClick={() => handleDeleteHealth(record.createdAt)}
                      className="btn-delete"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                ))}
                {healthRecords.length === 0 && <p className="no-data">No health records yet</p>}
              </div>
            </div>
          </div>
        )}
      </div>

      {showNewSession && <NewSessionForm />}
      {showEditSession && editingSession && <EditSessionForm />}
      {showNewHealth && <NewHealthRecordForm />}
      {showNewFood && <NewFoodForm />}
      {showEditFood && editingFood && <EditFoodForm />}
      {showLogFood && <LogFoodForm />}
      {showEditFoodLog && editingFoodLog && <EditFoodLogForm />}
      {showAddExercise && <AddExerciseToSessionForm />}
      {showAddSet && <AddSetForm />}
      {showEditSet && editingSet && <EditSetForm />}
      {showAddAerobicMetric && <AddAerobicMetricForm />}
    </div>
  );
};

const App = () => {
  return <Dashboard />;
};

export default App;