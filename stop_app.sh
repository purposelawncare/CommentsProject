#!/bin/bash

echo "🛑 Stopping Comment System Application..."
echo "========================================"

# Stop backend processes
echo "🔄 Stopping backend server..."
BACKEND_PIDS=$(ps aux | grep "python manage.py runserver" | grep -v grep | awk '{print $2}')
if [ ! -z "$BACKEND_PIDS" ]; then
    echo "$BACKEND_PIDS" | xargs kill -9
    echo "✅ Backend stopped"
else
    echo "ℹ️  Backend was not running"
fi

# Stop frontend processes
echo "🔄 Stopping frontend server..."
FRONTEND_PIDS=$(ps aux | grep "react-scripts start" | grep -v grep | awk '{print $2}')
if [ ! -z "$FRONTEND_PIDS" ]; then
    echo "$FRONTEND_PIDS" | xargs kill -9
    echo "✅ Frontend stopped"
else
    echo "ℹ️  Frontend was not running"
fi

# Stop any processes on ports 3000 and 8000
echo "🔄 Cleaning up ports..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:8000 | xargs kill -9 2>/dev/null || true

echo ""
echo "✅ Application stopped successfully!"
echo "📋 To start again: ./start_app.sh"
