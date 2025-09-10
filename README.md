# Comment System - Full Stack Demo

A modern comment system built with Django REST Framework and React, featuring a discussion about backend technologies for solo developers.

**Built with Django REST Framework and PostgreSQL as requested.**

## 🚀 Quick Start (Automated)

**Recommended:** Use the automated setup and start process:

```bash
# 1. Clone the repository
git clone <repository-url>
cd CommentsProject

# 2. Run automated setup
./setup.sh

# 3. Start the application
./start_app.sh
```

**That's it!** The application will open in your browser automatically.

---

## 🔧 Manual Setup (Fallback)

If the automated setup doesn't work, follow these manual steps:

### Prerequisites
- Python 3.9+ 
- Node.js 16+
- PostgreSQL 12+

### 1. Clone the Repository
```bash
git clone <repository-url>
cd CommentsProject

# Verify you're in the right directory
ls -la
# You should see: backend/, frontend/, README.md, setup.sh
```

### 2. Install PostgreSQL

**macOS:**
```bash
# Install PostgreSQL
brew install postgresql@15

# Start PostgreSQL service
brew services start postgresql@15

# Add PostgreSQL to PATH (add this to your ~/.zshrc or ~/.bash_profile)
echo 'export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
psql --version
```

**Windows:**
- Download from https://www.postgresql.org/download/
- Install with default settings
- Start PostgreSQL service

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 3. Create Database
```bash
# Create database (this will work if PostgreSQL is in PATH)
createdb comment_system

# If the above fails, try:
psql -U postgres -c "CREATE DATABASE comment_system;"

# Verify database was created
psql -U postgres -l | grep comment_system
```

### 4. Backend Setup
```bash
# Make sure you're in the project root directory
pwd
# Should show: /path/to/CommentsProject

# Navigate to backend directory
cd backend

# Verify you're in the backend directory
ls -la
# Should see: manage.py, requirements.txt, venv/, etc.

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Load sample data
python load_copy_comments.py

# Start development server
python manage.py runserver
```

**⚠️ Important:** If you get `source: no such file or directory: venv/bin/activate`, it means the virtual environment doesn't exist yet. Make sure you're in the `backend` directory and run `python3 -m venv venv` first.

### 5. Frontend Setup
```bash
# Open new terminal and navigate to project root
cd /path/to/CommentsProject

# Verify you're in the project root
pwd
# Should show: /path/to/CommentsProject

# Navigate to frontend directory
cd frontend

# Verify you're in the frontend directory
ls -la
# Should see: package.json, src/, public/, etc.

# Install dependencies
npm install

# Start development server
npm start
```

### 6. Access the Application
Open your browser and go to `http://localhost:3000`

### 7. Verify Everything is Working
- **Backend API**: Visit `http://localhost:8000/api/comments/` - you should see JSON data
- **Frontend**: Visit `http://localhost:3000` - you should see the comment interface
- **Sample Data**: You should see 16 pre-loaded comments about backend technologies

## 🔧 Alternative: Automated Setup

If you prefer automated setup, run:
```bash
# On macOS/Linux
./setup.sh

# On Windows
setup.bat
```

## 📁 Project Structure

```
Take Home Project/
├── backend/                 # Django REST API
│   ├── comment_api/        # Django project settings
│   ├── comments/           # Comments app
│   ├── manage.py
│   ├── requirements.txt
│   ├── load_copy_comments.py
│   └── Copy of comments.json
├── frontend/               # React application
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── README.md
└── README.md
```

## 🎯 Features

### Backend (Django REST Framework)
- ✅ **RESTful API** with full CRUD operations
- ✅ **PostgreSQL** database (with SQLite fallback)
- ✅ **CORS** configured for frontend communication
- ✅ **Sample data** loaded from JSON file
- ✅ **User management** with proper relationships

### Frontend (React)
- ✅ **Modern UI** with clean, professional design
- ✅ **Post header** explaining the discussion context
- ✅ **Comment display** with avatars, likes, and images
- ✅ **Real-time updates** when adding/editing comments
- ✅ **Responsive design** for mobile and desktop
- ✅ **Interactive features** (edit, delete, like buttons)

## 🔧 API Endpoints

- `GET /api/comments/` - List all comments
- `POST /api/comments/` - Create new comment
- `GET /api/comments/{id}/` - Get specific comment
- `PUT /api/comments/{id}/` - Update comment
- `DELETE /api/comments/{id}/` - Delete comment

## 📊 Sample Data

The project includes 16 sample comments from developers discussing backend technologies:
- **Authors**: Joe, Jane, Smith, Marry, Peter, John, Lily, Tom, Jack, Rose, David, Linda, Mike, Emily, Bob, Sara
- **Content**: Real discussions about Firebase, Supabase, Node.js, .NET, Ruby on Rails, etc.
- **Images**: Relevant technology logos and screenshots
- **Likes**: Realistic like counts (6-101 likes per comment)

## 🎨 Design Features

- **Post Context**: Clear question "What backend technology should I use as a solo developer?"
- **User Avatars**: Colored circles with user initials
- **Comment Images**: Inline images that accompany the text
- **Like System**: Display like counts with interactive buttons
- **Modern Layout**: Card-based design with gradients and shadows
- **Responsive**: Works perfectly on all screen sizes

## 🛠️ Technical Stack

### Backend
- **Django 4.2.24** - Web framework
- **Django REST Framework 3.16.1** - API framework
- **PostgreSQL** - Primary database (SQLite fallback)
- **psycopg2-binary** - PostgreSQL adapter
- **django-cors-headers** - CORS handling

### Frontend
- **React 18** - UI library
- **Axios** - HTTP client
- **CSS3** - Modern styling with gradients and animations

## 🚀 Deployment Ready

The project is structured for easy deployment:
- **Backend**: Ready for Heroku, Render, or any Python hosting
- **Frontend**: Ready for Vercel, Netlify, or any static hosting
- **Database**: PostgreSQL configuration included
- **Environment**: Production settings prepared

## 📝 Development Notes

- **CORS**: Configured for localhost:3000 and production domains
- **Authentication**: Simple user system (can be extended)
- **Data Loading**: Automated script loads sample data
- **Error Handling**: Proper error messages and validation
- **Code Quality**: Clean, readable, well-commented code

## 🎯 Demo Scenario

This comment system simulates a real discussion thread where developers are sharing their experiences with different backend technologies. The post asks for recommendations, and the comments show various perspectives from the developer community.

Perfect for demonstrating:
- Full-stack development skills
- Modern UI/UX design
- RESTful API design
- Database relationships
- Responsive web design
- Code organization and best practices

## 🔧 Troubleshooting

If the automated setup doesn't work, try these common fixes:

**PostgreSQL not found:**
```bash
# macOS with Homebrew
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
brew services start postgresql@15
```

**Port already in use:**
```bash
# Stop existing processes
./stop_app.sh
```

**Virtual environment issues:**
```bash
# Recreate virtual environment
cd backend
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Still having issues?**
Run the test script to diagnose: `python test_setup.py`

---

**Built with ❤️ for demonstrating full-stack development capabilities**