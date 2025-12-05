# Workout Tracker

A React-based web application for tracking workouts, nutrition, and health metrics.

## Features

### Workout Management
- Create and manage workout sessions with start/end times and notes
- Add lifting exercises with multiple sets (weight × reps) and aerobic exercises with duration/distance
- View detailed session history with expandable exercise cards

### Nutrition Tracking
- Food database with macronutrient information
- Log daily food intake with customizable quantities
- Today's macro distribution pie chart showing real-time carbs, protein, and fat breakdown
- Food log with date range filtering (7 days, 30 days, monthly, custom)
- Daily calorie and macro totals grouped by date

### Health Monitoring
- Track weight and body fat percentage over time
- Side-by-side line charts with automatic Y-axis scaling based on your data range
- Historical health records with full CRUD operations

### Exercise Library
- Pre-loaded database of 50+ exercises categorized as Lifting or Aerobics
- Filter exercises by type
- Exercise descriptions and equipment information

### Dashboard
- Summary statistics: total sessions, current weight, average duration, body fat percentage
- Recent sessions and weight progress preview

## Tech Stack

- **React** 18.x - UI framework
- **Recharts** - Data visualization (line charts, pie charts)
- **Lucide React** - Icon library
- **CSS3** - Custom styling with responsive design
- **LocalStorage** - User authentication persistence

## Prerequisites

Before starting the frontend, ensure the backend is running:

1. **Setup Database** (one-time setup)
```bash
mysql -u root -p < workout_tracker_dump.sql
```

2. **Install Python Dependencies**
```bash
cd backend
pip install -r requirements.txt
```

3. **Change Database Connection Configuration**
```python
# backend/config.py
DATABASE_CONFIG = {
    "host": "localhost",
    "user": "Your User Name",
    "password": "Your Password",
    "database": "workout_tracker",
    "cursorclass": "DictCursor",
}
```

4. **Start Backend Server**
```bash
uvicorn main:app --reload
```

Backend should be running on `http://localhost:8000`

4. **Node.js** (v14 or higher) and npm

## Installation

Navigate to the frontend directory and install all dependencies:
```bash
cd frontend
npm install
```

All required packages will be installed automatically from `package.json`:
- react & react-dom (UI framework)
- lucide-react (icons)
- recharts (charts)
- react-scripts (build tools)

## Running the Application

Start the development server:
```bash
npm start
```

Access the application at `http://localhost:3000`.

## Project Structure

```
frontend/
├── public/
│   └── index.html
├── src/
│   ├── App.js           # Main application component
│   ├── App.css          # Global styles
│   ├── api.js           # API service layer
│   ├── index.js         # React entry point
│   └── index.css        # Base styles
├── package.json
└── README.md
```

## Key Components

### Authentication
- Login and registration with LocalStorage session management
- Auto-login on page refresh

### Main Tabs
1. Overview - Summary statistics and recent activity
2. Sessions - Workout session management
3. Exercises - Exercise library with filtering
4. Nutrition - Food logging and macro tracking
5. Health - Weight and body fat tracking

### Data Visualization
- Pie Chart: Today's macro distribution with total calories
- Line Charts: Side-by-side weight and body fat progress with automatic scaling

## API Integration

The frontend communicates with the FastAPI backend at `http://localhost:8000` through the `api.js` service layer.

Example API calls:
```javascript
api.user.getAllUsers()
api.session.getUserSessions(userId)
api.food.logFood(userId, foodName, quantity, createAt)
api.health.getHealthRecords(userId)
```

To change the API URL, edit `src/api.js`:
```javascript
const BASE_URL = 'http://localhost:8000';
```

## Features

### Chart Scaling
Health charts automatically adjust Y-axis ranges for better visibility:

### Nutrition Focus
The macro pie chart displays only today's food intake for real-time dietary tracking. Historical data is available in the food log.

### Responsive Design
Fully responsive with automatic layout adjustments for desktop, tablet, and mobile devices.

## Development

Build for production:
```bash
npm run build
```

Creates optimized build in `build/` folder.
