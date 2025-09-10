@echo off
echo 🚀 Setting up Comment System Demo...
echo ==================================

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is required but not installed.
    echo Please install Python 3.9+ and try again.
    pause
    exit /b 1
)

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js is required but not installed.
    echo Please install Node.js 16+ and try again.
    pause
    exit /b 1
)

REM Check if PostgreSQL is installed
psql --version >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL is required but not installed.
    echo Please install PostgreSQL 12+ and try again.
    echo Download from: https://www.postgresql.org/download/
    pause
    exit /b 1
)

echo ✅ Python, Node.js, and PostgreSQL found

REM Create database
echo 🗄️  Setting up database...
psql -U postgres -c "CREATE DATABASE comment_system;" 2>nul || echo Database may already exist

REM Setup Backend
echo 📦 Setting up backend...
cd backend

REM Create virtual environment
python -m venv venv
call venv\Scripts\activate.bat

REM Install dependencies
pip install -r requirements.txt

REM Run migrations
python manage.py migrate

REM Load sample data
python load_copy_comments.py

echo ✅ Backend setup complete!

REM Setup Frontend
echo 📦 Setting up frontend...
cd ..\frontend

REM Install dependencies
npm install

echo ✅ Frontend setup complete!

echo.
echo 🎉 Setup complete! To start the application:
echo.
echo 1. Start the backend:
echo    cd backend
echo    venv\Scripts\activate
echo    python manage.py runserver
echo.
echo 2. Start the frontend (in a new terminal):
echo    cd frontend
echo    npm start
echo.
echo 3. Open http://localhost:3000 in your browser
echo.
echo Enjoy the demo! 🚀
pause
