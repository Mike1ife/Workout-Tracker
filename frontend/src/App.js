import React, { useState, useEffect, useCallback, useRef } from 'react';
import { Calendar, Dumbbell, Activity, Apple, Heart, Plus, ChevronRight, TrendingUp, Clock, Trash2, User, LogOut } from 'lucide-react';
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
                  onChange={(e) => setFormData({...formData, first_name: e.target.value})}
                  className="form-input"
                  required
                />
              </div>
              <div className="form-group">
                <label className="form-label">Last Name *</label>
                <input
                  type="text"
                  value={formData.last_name}
                  onChange={(e) => setFormData({...formData, last_name: e.target.value})}
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
              onChange={(e) => setFormData({...formData, email: e.target.value})}
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
              onChange={(e) => setFormData({...formData, password: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, age: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, gender: e.target.value})}
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

          <button type="submit" className="btn-primary" disabled={loading} style={{width: '100%', justifyContent: 'center'}}>
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
  const [foods, setFoods] = useState([]);
  const [userFoods, setUserFoods] = useState([]);
  const [showNewFood, setShowNewFood] = useState(false);
  const [showLogFood, setShowLogFood] = useState(false);
  const [selectedSession, setSelectedSession] = useState(null);
  const [showAddExercise, setShowAddExercise] = useState(false);
  const [sessionExercises, setSessionExercises] = useState([]);
  const [showAddSet, setShowAddSet] = useState(false);
  const [selectedExercise, setSelectedExercise] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [exerciseRefreshKey, setExerciseRefreshKey] = useState(0);
  const [setRefreshTrigger, setSetRefreshTrigger] = useState(0);
  const [showEditSession, setShowEditSession] = useState(false);
  const [editingSession, setEditingSession] = useState(null);
  const [showAddAerobicMetric, setShowAddAerobicMetric] = useState(false);
  const [selectedAerobicExercise, setSelectedAerobicExercise] = useState(null);
  
  const isFetchingRef = useRef(false);

  const fetchSessionExercises = useCallback(async (sessionId) => {
    if (isFetchingRef.current) return;
    
    isFetchingRef.current = true;
    try {
      const exerciseNames = await api.session.getSessionExercises(sessionId);
      const exerciseDetails = exerciseNames.map(name => ({
        exerciseName: name
      }));
      setSessionExercises(exerciseDetails);
    } catch (err) {
      console.error('Error fetching session exercises:', err);
      setSessionExercises([]);
    } finally {
      isFetchingRef.current = false;
    }
  }, []);

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
    if (!currentUser.user_id) {
      return;
    }
    
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
    } catch (err) {
      console.error('Error fetching exercises:', err);
    }
  };

  const fetchAllData = async () => {
    if (!currentUser.user_id) {
      return;
    }

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
        <div style={{display: 'flex', gap: '0.5rem', alignItems: 'center'}}>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setEditingSession(session);
              setShowEditSession(true);
            }}
            className="btn-secondary"
            style={{padding: '0.5rem'}}
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
    const [formData, setFormData] = useState({
      start_date: editingSession.startTime.split('T')[0] || editingSession.startTime.split(' ')[0],
      start_time: editingSession.startTime.split('T')[1]?.substring(0, 5) || editingSession.startTime.split(' ')[1]?.substring(0, 5),
      end_date: editingSession.endTime.split('T')[0] || editingSession.endTime.split(' ')[0],
      end_time: editingSession.endTime.split('T')[1]?.substring(0, 5) || editingSession.endTime.split(' ')[1]?.substring(0, 5),
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
                  onChange={(e) => setFormData({...formData, start_date: e.target.value})}
                  className="form-input" 
                />
              </div>
              <div className="form-group">
                <label className="form-label">Start Time</label>
                <input 
                  type="time" 
                  value={formData.start_time}
                  onChange={(e) => setFormData({...formData, start_time: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, end_date: e.target.value})}
                  className="form-input" 
                />
              </div>
              <div className="form-group">
                <label className="form-label">End Time</label>
                <input 
                  type="time" 
                  value={formData.end_time}
                  onChange={(e) => setFormData({...formData, end_time: e.target.value})}
                  className="form-input" 
                />
              </div>
            </div>
            
            <div className="form-group">
              <label className="form-label">Notes</label>
              <textarea 
                value={formData.note}
                onChange={(e) => setFormData({...formData, note: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, start_date: e.target.value})}
                  className="form-input" 
                />
              </div>
              <div className="form-group">
                <label className="form-label">Start Time</label>
                <input 
                  type="time" 
                  value={formData.start_time}
                  onChange={(e) => setFormData({...formData, start_time: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, end_date: e.target.value})}
                  className="form-input" 
                />
              </div>
              <div className="form-group">
                <label className="form-label">End Time</label>
                <input 
                  type="time" 
                  value={formData.end_time}
                  onChange={(e) => setFormData({...formData, end_time: e.target.value})}
                  className="form-input" 
                />
              </div>
            </div>
            
            <div className="form-group">
              <label className="form-label">Notes</label>
              <textarea 
                value={formData.note}
                onChange={(e) => setFormData({...formData, note: e.target.value})}
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
        console.log('Sending:', {
          sessionId: selectedSession.session_id,
          exerciseName: selectedExerciseName
        });
        await api.session.addExerciseToSession(selectedSession.session_id, selectedExerciseName);
        setShowAddExercise(false);
        setExerciseRefreshKey(prev => prev + 1);
        alert('Exercise added to session!');
      } catch (err) {
        console.error('Full error:', err);
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
      setNum: 1,
      weight: '',
      reps: ''
    });

    useEffect(() => {
      const fetchNextSetNum = async () => {
        if (selectedExercise) {
          try {
            const sets = await api.lifting.getSets(selectedExercise.exerciseName, selectedSession.session_id);
            const maxSetNum = sets.length > 0 ? Math.max(...sets.map(s => s.setNum)) : 0;
            setFormData(prev => ({...prev, setNum: maxSetNum + 1}));
          } catch (err) {
            console.error('Error fetching sets:', err);
          }
        }
      };
      fetchNextSetNum();
    }, [selectedExercise]);

    const handleSubmit = async () => {
      if (!formData.weight || !formData.reps) {
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
                onChange={(e) => setFormData({...formData, setNum: e.target.value})}
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
                  onChange={(e) => setFormData({...formData, weight: e.target.value})}
                  className="form-input"
                  placeholder="135"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Reps</label>
                <input 
                  type="number" 
                  value={formData.reps}
                  onChange={(e) => setFormData({...formData, reps: e.target.value})}
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
              [exerciseName]: metrics.length > 0 ? metrics[0] : null
            }));
          } catch (err) {
            console.error('Error fetching aerobic metrics:', err);
            setAerobicMetrics(prev => ({
              ...prev,
              [exerciseName]: null
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
            await api.aerobic.deleteMetric(exerciseName, selectedSession.session_id);
          } catch (err) {
            console.log('No metrics to delete or error deleting metrics:', err);
          }
        }
        
        await api.session.removeExerciseFromSession(selectedSession.session_id, exerciseName);
        
        setLocalExercises(prev => prev.filter(ex => ex.exerciseName !== exerciseName));
        
        setExerciseSets(prev => {
          const updated = {...prev};
          delete updated[exerciseName];
          return updated;
        });
        setAerobicMetrics(prev => {
          const updated = {...prev};
          delete updated[exerciseName];
          return updated;
        });
        setExpandedExercises(prev => {
          const updated = {...prev};
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
          }} className="btn-secondary" style={{padding: '0.5rem 1rem'}}>
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
                          style={{marginRight: '0.5rem'}}
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
                            <div className="metric-item">
                              <span className="metric-label">Duration</span>
                              <span className="metric-value">
                                {aerobicMetrics[exercise.exerciseName]?.duration || '--:--'}
                              </span>
                            </div>
                            <div className="metric-item">
                              <span className="metric-label">Distance</span>
                              <span className="metric-value">
                                {aerobicMetrics[exercise.exerciseName]?.distance ? 
                                  `${aerobicMetrics[exercise.exerciseName].distance} mi` : '-- mi'}
                              </span>
                            </div>
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
                                  <button 
                                    onClick={() => handleDeleteSet(exercise.exerciseName, set.setNum)}
                                    className="btn-delete"
                                  >
                                    <Trash2 size={14} />
                                  </button>
                                </div>
                              ))
                            ) : (
                              <p className="no-data" style={{marginTop: '1rem'}}>No sets added yet</p>
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
      time: new Date().toTimeString().slice(0, 5),
      weight: '',
      body_fat_percent: ''
    });

    const handleSubmit = async () => {
      if (!formData.weight || !formData.body_fat_percent) {
        alert('Please fill in all fields');
        return;
      }

      try {
        const createdAt = `${formData.date} ${formData.time}:00`;

        await api.health.createHealthRecord(currentUser.user_id, {
          createdAt: createdAt,
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
            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Date</label>
                <input 
                  type="date" 
                  value={formData.date}
                  onChange={(e) => setFormData({...formData, date: e.target.value})}
                  className="form-input" 
                />
              </div>
              <div className="form-group">
                <label className="form-label">Time</label>
                <input 
                  type="time" 
                  value={formData.time}
                  onChange={(e) => setFormData({...formData, time: e.target.value})}
                  className="form-input" 
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Weight (lbs)</label>
                <input 
                  type="number" 
                  step="0.1"
                  value={formData.weight}
                  onChange={(e) => setFormData({...formData, weight: e.target.value})}
                  className="form-input"
                  placeholder="185.5"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Body Fat (%)</label>
                <input 
                  type="number" 
                  step="0.1"
                  value={formData.body_fat_percent}
                  onChange={(e) => setFormData({...formData, body_fat_percent: e.target.value})}
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
      await api.health.deleteHealthRecord(currentUser.user_id, createdAt);
      fetchAllData();
    } catch (err) {
      alert('Error deleting health record: ' + err.message);
    }
  };

  const NewFoodForm = () => {
    const [formData, setFormData] = useState({
      foodName: '',
      carbohydrate: '',
      protein: '',
      fat: ''
    });

    const handleSubmit = async () => {
      if (!formData.foodName || !formData.carbohydrate || !formData.protein || !formData.fat) {
        alert('Please fill in all fields');
        return;
      }

      try {
        await api.food.createFood({
          foodName: formData.foodName,
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
                onChange={(e) => setFormData({...formData, foodName: e.target.value})}
                className="form-input"
                placeholder="e.g., Chicken Breast"
              />
            </div>
            <div className="form-row">
              <div className="form-group">
                <label className="form-label">Carbs (g)</label>
                <input 
                  type="text" 
                  value={formData.carbohydrate}
                  onChange={(e) => setFormData({...formData, carbohydrate: e.target.value})}
                  className="form-input"
                  placeholder="25.5"
                />
              </div>
              <div className="form-group">
                <label className="form-label">Protein (g)</label>
                <input 
                  type="text"
                  value={formData.protein}
                  onChange={(e) => setFormData({...formData, protein: e.target.value})}
                  className="form-input"
                  placeholder="30.0"
                />
              </div>
            </div>
            <div className="form-group">
              <label className="form-label">Fat (g)</label>
              <input 
                type="text"
                value={formData.fat}
                onChange={(e) => setFormData({...formData, fat: e.target.value})}
                className="form-input"
                placeholder="5.5"
              />
            </div>
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

  const LogFoodForm = () => {
    const [selectedFood, setSelectedFood] = useState('');

    const handleSubmit = async () => {
      if (!selectedFood) {
        alert('Please select a food');
        return;
      }

      try {
        await api.food.logFood(currentUser.user_id, selectedFood);
        setShowLogFood(false);
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
                onChange={(e) => setSelectedFood(e.target.value)}
                className="form-input"
              >
                <option value="">Choose a food...</option>
                {foods.map((food, i) => (
                  <option key={i} value={food.foodName}>
                    {food.foodName} - {food.calories ? Math.round(food.calories) : 0} cal
                  </option>
                ))}
              </select>
            </div>

            {selectedFood && foods.find(f => f.foodName === selectedFood) && (
              <div className="food-preview">
                <h4>Nutritional Info:</h4>
                <div className="macro-grid">
                  <div className="macro-item">
                    <span className="macro-label">Calories</span>
                    <span className="macro-value">
                      {Math.round(foods.find(f => f.foodName === selectedFood).calories || 0)}
                    </span>
                  </div>
                  <div className="macro-item">
                    <span className="macro-label">Carbs</span>
                    <span className="macro-value">
                      {foods.find(f => f.foodName === selectedFood).carbohydrate}g
                    </span>
                  </div>
                  <div className="macro-item">
                    <span className="macro-label">Protein</span>
                    <span className="macro-value">
                      {foods.find(f => f.foodName === selectedFood).protein}g
                    </span>
                  </div>
                  <div className="macro-item">
                    <span className="macro-label">Fat</span>
                    <span className="macro-value">
                      {foods.find(f => f.foodName === selectedFood).fat}g
                    </span>
                  </div>
                </div>
              </div>
            )}
          </div>
          
          <div className="modal-buttons">
            <button onClick={() => setShowLogFood(false)} className="btn-secondary">
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

  const AddAerobicMetricForm = () => {
    const [formData, setFormData] = useState({
      duration: '',
      distance: ''
    });

    const handleSubmit = async () => {
      if (!formData.duration && !formData.distance) {
        alert('Please fill in at least one field (duration or distance)');
        return;
      }

      try {
        await api.aerobic.addMetric(
          selectedAerobicExercise.exerciseName,
          selectedSession.session_id,
          {
            duration: formData.duration || null,
            distance: formData.distance ? parseFloat(formData.distance) : null
          }
        );
        setShowAddAerobicMetric(false);
        setExerciseRefreshKey(prev => prev + 1);
        alert('Metrics added successfully!');
      } catch (err) {
        alert('Error adding metrics: ' + err.message);
      }
    };

    return (
      <div className="modal-overlay">
        <div className="modal-content">
          <h3 className="modal-title">Add Metrics - {selectedAerobicExercise?.exerciseName}</h3>
          
          <div className="form-container">
            <div className="form-group">
              <label className="form-label">Duration (HH:MM:SS)l</label>
              <input 
                type="text" 
                value={formData.duration}
                onChange={(e) => setFormData({...formData, duration: e.target.value})}
                className="form-input"
                placeholder="00:30:00"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Distance (miles)</label>
              <input 
                type="number" 
                step="0.1"
                value={formData.distance}
                onChange={(e) => setFormData({...formData, distance: e.target.value})}
                className="form-input"
                placeholder="3.5"
              />
            </div>
          </div>
          
          <div className="modal-buttons">
            <button onClick={() => setShowAddAerobicMetric(false)} className="btn-secondary">
              Cancel
            </button>
            <button onClick={handleSubmit} className="btn-primary">
              Add Metrics
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
          <div style={{display: 'flex', gap: '1rem', alignItems: 'center'}}>
            <div className="user-info">
              <User size={20} />
              <span>{currentUser.email}</span>
            </div>
            <button onClick={() => setShowNewSession(true)} className="btn-primary">
              <Plus className="btn-icon" />
              New Session
            </button>
            <button onClick={handleLogout} className="btn-secondary" style={{padding: '0.5rem 1rem'}}>
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
                    <span className="health-date">{formatDateTime(record.createdAt)}</span>
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
            
            <div className="exercise-grid">
              {(exerciseFilter === 'all' ? exercises : 
                exerciseFilter === 'lifting' ? liftingExercises : 
                aerobicExercises).map((exercise, i) => (
                <div key={i} className="exercise-card">
                  <div className="exercise-card-header">
                    <div className="exercise-icon">
                      {exerciseFilter === 'aerobics' || aerobicExercises.some(e => e.exerciseName === exercise.exerciseName) ? (
                        <Activity size={20} />
                      ) : (
                        <Dumbbell size={20} />
                      )}
                    </div>
                    <div className="exercise-badge">
                      {aerobicExercises.some(e => e.exerciseName === exercise.exerciseName) ? 'Aerobics' : 'Lifting'}
                    </div>
                  </div>
                  <h3 className="exercise-name">{exercise.exerciseName || exercise.exercise_name}</h3>
                  <p className="exercise-description">
                    {exercise.description || 'No description available'}
                  </p>
                </div>
              ))}
            </div>
            
            {(exerciseFilter === 'all' ? exercises : 
              exerciseFilter === 'lifting' ? liftingExercises : 
              aerobicExercises).length === 0 && (
              <p className="no-data">No exercises found</p>
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

            <div className="card" style={{marginBottom: '1.5rem'}}>
              <h3 className="card-title">Recent Food Log</h3>
              <div className="food-log-list">
                {userFoods.length > 0 ? (
                  userFoods.slice(0, 10).map((food, i) => (
                    <div key={i} className="food-log-item">
                      <div>
                        <div className="food-log-name">{food.foodName || food.food_name}</div>
                        <div className="food-log-date">{formatDateTime(food.create_at)}</div>
                      </div>
                      <div className="food-log-macros">
                        <span className="macro-badge">{Math.round(food.calories || 0)} cal</span>
                        <span className="macro-badge">C: {food.carbohydrate}g</span>
                        <span className="macro-badge">P: {food.protein}g</span>
                        <span className="macro-badge">F: {food.fat}g</span>
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="no-data">No food logged yet</p>
                )}
              </div>
            </div>

            <div className="card">
              <h3 className="card-title">Food Database ({foods.length} foods)</h3>
              <div className="food-grid">
                {foods.map((food, i) => (
                  <div key={i} className="food-card">
                    <div className="food-card-header">
                      <Apple size={20} className="food-icon" />
                      <span className="food-calories">{Math.round(food.calories || 0)} cal</span>
                    </div>
                    <h4 className="food-name">{food.foodName}</h4>
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
            <div className="card">
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
      {showLogFood && <LogFoodForm />}
      {showAddExercise && <AddExerciseToSessionForm />}
      {showAddSet && <AddSetForm />}
      {showAddAerobicMetric && <AddAerobicMetricForm />}
    </div>
  );
};

const App = () => {
  return <Dashboard />;
};

export default App;