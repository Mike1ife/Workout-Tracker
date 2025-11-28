import React, { useState, useEffect } from 'react';
import { Calendar, Dumbbell, Activity, Apple, Heart, Plus, ChevronRight, TrendingUp, Clock } from 'lucide-react';
import './App.css';
import api from './api';

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState('overview');
  const [showNewSession, setShowNewSession] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const [currentUser, setCurrentUser] = useState({ user_id: 1, first_name: 'User' });
  const [sessions, setSessions] = useState([]);
  const [healthRecords, setHealthRecords] = useState([]);
  const [dashboardStats, setDashboardStats] = useState(null);

  useEffect(() => {
    const fetchAllData = async () => {
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
        setError(err.message);
        console.error('Error fetching data:', err);
      } finally {
        setLoading(false);
      }
    };
    
    fetchAllData();
  }, []);

  const fetchAllData = async () => {
    try {
      setLoading(true);
      const [sessionsData, healthData, statsData] = await Promise.all([
        api.session.getUserSessions(currentUser.user_id),
        api.health.getHealthRecords(currentUser.user_id),
        api.dashboard.getDashboardStats(currentUser.user_id)
      ]);
      
      setSessions(sessionsData);
      setHealthRecords(healthData);
      setDashboardStats(statsData);
      setError(null);
    } catch (err) {
      setError(err.message);
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
    <div className="session-card">
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
        <ChevronRight className="chevron-icon" />
      </div>
    </div>
  );

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

  return (
    <div className="app">
      <div className="header">
        <div className="header-content">
          <div>
            <h1 className="header-title">Workout Tracker</h1>
            <p className="header-subtitle">Welcome back, {currentUser.first_name}!</p>
          </div>
          <button onClick={() => setShowNewSession(true)} className="btn-primary">
            <Plus className="btn-icon" />
            New Session
          </button>
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

        {!loading && activeTab === 'exercises' && (
          <div className="card">
            <h2 className="card-title">Exercise Library</h2>
            <p className="card-text">Browse all available exercises (lifting and aerobics)</p>
          </div>
        )}

        {!loading && activeTab === 'nutrition' && (
          <div className="card">
            <h2 className="card-title">Nutrition Tracking</h2>
            <p className="card-text">Track your food consumption and view macronutrients</p>
          </div>
        )}

        {!loading && activeTab === 'health' && (
          <div className="card">
            <h2 className="card-title">Health Records</h2>
            <div className="health-records-list">
              {healthRecords.map((record, i) => (
                <div key={i} className="health-record-card">
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
              ))}
              {healthRecords.length === 0 && <p className="no-data">No health records yet</p>}
            </div>
          </div>
        )}
      </div>

      {showNewSession && <NewSessionForm />}
    </div>
  );
};

export default Dashboard;