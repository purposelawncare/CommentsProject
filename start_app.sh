#!/bin/bash

echo "🚀 Starting Comment System Application..."
echo "========================================"

# Check if we're in the right directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: This script must be run from the project root directory."
    echo "Current directory: $(pwd)"
    echo "Expected to find: backend/ and frontend/ directories"
    echo ""
    echo "Please run this script from the Take-Home-Project directory:"
    echo "  cd Take-Home-Project"
    echo "  ./start_app.sh"
    exit 1
fi

echo "✅ Found project directories (backend/, frontend/)"

# Check if backend is already running
if curl -s http://localhost:8000/api/comments/ > /dev/null 2>&1; then
    echo "✅ Backend is already running on port 8000"
else
    echo "🔄 Starting backend server..."
    cd backend
    
    # Check if virtual environment exists
    if [ ! -d "venv" ]; then
        echo "❌ Virtual environment not found. Please run setup first:"
        echo "  ./setup.sh"
        exit 1
    fi
    
    # Start backend in background
    source venv/bin/activate
    python manage.py runserver > ../backend.log 2>&1 &
    BACKEND_PID=$!
    echo "✅ Backend started (PID: $BACKEND_PID)"
    cd ..
    
    # Wait for backend to start
    echo "⏳ Waiting for backend to start..."
    sleep 3
fi

# Check if frontend is already running
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend is already running on port 3000"
else
    echo "🔄 Starting frontend server..."
    cd frontend
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo "❌ Node modules not found. Please run setup first:"
        echo "  ./setup.sh"
        exit 1
    fi
    
    # Start frontend in background
    npm start > ../frontend.log 2>&1 &
    FRONTEND_PID=$!
    echo "✅ Frontend started (PID: $FRONTEND_PID)"
    cd ..
    
    # Wait for frontend to start
    echo "⏳ Waiting for frontend to start..."
    sleep 5
fi

echo ""
echo "🎉 Application is starting up!"
echo "================================"
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:8000/api/comments/"
echo ""
echo "📋 To stop the application:"
echo "  ./stop_app.sh"
echo ""
echo "📋 To view logs:"
echo "  tail -f backend.log    # Backend logs"
echo "  tail -f frontend.log   # Frontend logs"
echo ""
echo "⏳ Opening application in your browser..."
sleep 2

# Try to open the application in browser
if command -v open &> /dev/null; then
    open http://localhost:3000
elif command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:3000
else
    echo "Please open http://localhost:3000 in your browser"
fi

echo "✅ Application started successfully!"
echo "Press Ctrl+C to stop this script (servers will continue running)"
echo ""

# Keep script running and show status
while true; do
    sleep 10
    BACKEND_STATUS="❌"
    FRONTEND_STATUS="❌"
    
    if curl -s http://localhost:8000/api/comments/ > /dev/null 2>&1; then
        BACKEND_STATUS="✅"
    fi
    
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        FRONTEND_STATUS="✅"
    fi
    
    echo "Status: Backend $BACKEND_STATUS | Frontend $FRONTEND_STATUS | $(date)"
done
