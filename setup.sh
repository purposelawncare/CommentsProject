#!/bin/bash

echo "🚀 Setting up Comment System Demo..."
echo "=================================="

# Check if we're in the right directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: This script must be run from the project root directory."
    echo "Current directory: $(pwd)"
    echo "Expected to find: backend/ and frontend/ directories"
    echo ""
    echo "Please run this script from the Take-Home-Project directory:"
    echo "  cd Take-Home-Project"
    echo "  ./setup.sh"
    exit 1
fi

echo "✅ Found project directories (backend/, frontend/)"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3.9+ and try again."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed."
    echo "Please install Node.js 16+ and try again."
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    # Try to add PostgreSQL to PATH (macOS Homebrew)
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "/opt/homebrew/opt/postgresql@15/bin" ]; then
        export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
        echo "🔧 Added PostgreSQL to PATH"
    elif [[ "$OSTYPE" == "darwin"* ]] && [ -d "/usr/local/opt/postgresql@15/bin" ]; then
        export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
        echo "🔧 Added PostgreSQL to PATH"
    fi
    
    # Check again after PATH update
    if ! command -v psql &> /dev/null; then
        echo "❌ PostgreSQL is required but not installed."
        echo "Please install PostgreSQL 12+ and try again."
        echo ""
        echo "Installation instructions:"
        echo "  macOS: brew install postgresql@15"
        echo "  Ubuntu: sudo apt-get install postgresql postgresql-contrib"
        echo "  Windows: Download from https://www.postgresql.org/download/"
        exit 1
    fi
fi

echo "✅ Python, Node.js, and PostgreSQL found"

# Check if PostgreSQL is running
if ! pg_isready -q; then
    echo "⚠️  PostgreSQL is not running. Attempting to start it..."
    
    # Try to start PostgreSQL automatically
    if command -v brew &> /dev/null; then
        echo "Starting PostgreSQL with Homebrew..."
        brew services start postgresql@15
        sleep 3
        
        if pg_isready -q; then
            echo "✅ PostgreSQL started successfully"
        else
            echo "❌ Failed to start PostgreSQL automatically"
            echo "Please start PostgreSQL manually:"
            echo "  brew services start postgresql@15"
            exit 1
        fi
    else
        echo "Please start PostgreSQL manually:"
        echo "  macOS: brew services start postgresql@15"
        echo "  Ubuntu: sudo systemctl start postgresql"
        echo "  Windows: Start PostgreSQL service"
        exit 1
    fi
else
    echo "✅ PostgreSQL is running"
fi

# Create database if it doesn't exist
echo "🗄️  Setting up database..."
createdb comment_system 2>/dev/null || echo "Database 'comment_system' already exists or creation failed"

# Setup Backend
echo "📦 Setting up backend..."
cd backend

# Verify we're in the backend directory
if [ ! -f "manage.py" ]; then
    echo "❌ Error: manage.py not found. Make sure you're in the project root directory."
    echo "Current directory: $(pwd)"
    echo "Expected to find: manage.py in backend directory"
    exit 1
fi

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Load sample data
python load_copy_comments.py

echo "✅ Backend setup complete!"

# Setup Frontend
echo "📦 Setting up frontend..."
cd ../frontend

# Verify we're in the frontend directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Make sure you're in the project root directory."
    echo "Current directory: $(pwd)"
    echo "Expected to find: package.json in frontend directory"
    exit 1
fi

# Install dependencies
npm install

echo "✅ Frontend setup complete!"

# Test the setup
echo "🧪 Testing setup..."
cd ..

# Test backend API
echo "Testing backend API..."
if curl -s http://localhost:8000/api/comments/ > /dev/null 2>&1; then
    echo "✅ Backend API is working"
else
    echo "⚠️  Backend not running yet (will start when you run the commands below)"
fi

echo ""
echo "🎉 Setup complete! To start the application:"
echo ""
echo "🚀 AUTOMATED (Recommended):"
echo "   ./start_app.sh    # Starts both backend and frontend automatically"
echo "   ./stop_app.sh     # Stops both servers"
echo ""
echo "🔧 MANUAL (Fallback):"
echo "1. Start the backend:"
echo "   cd backend"
echo "   source venv/bin/activate"
echo "   python manage.py runserver"
echo ""
echo "2. Start the frontend (in a new terminal):"
echo "   cd frontend"
echo "   npm start"
echo ""
echo "3. Open http://localhost:3000 in your browser"
echo ""
echo "💡 Pro tip: Run 'python test_setup.py' to verify everything is working!"
echo ""
echo "Enjoy the demo! 🚀"
