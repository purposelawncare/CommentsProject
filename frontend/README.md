# Comment System Frontend

A simple React frontend for the Django Comment API.

## Features

✅ **View Comments** - Display all comments with author and timestamp  
✅ **Add Comments** - Create new comments with text input  
✅ **Edit Comments** - Update existing comment text inline  
✅ **Delete Comments** - Remove comments with confirmation  
✅ **Real-time Updates** - UI updates immediately after operations  

## Setup

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start the development server**:
   ```bash
   npm start
   ```

3. **Open in browser**:
   Navigate to `http://localhost:3000`

## Prerequisites

Make sure the Django backend is running on `http://localhost:8000`

## API Integration

The frontend connects to the Django API at `http://localhost:8000/api/comments/` and provides:

- **GET** - Fetch all comments
- **POST** - Create new comment
- **PUT** - Update existing comment
- **DELETE** - Remove comment

## Components

- **App.js** - Main component with state management
- **App.css** - Styling for the application
- **index.css** - Global styles

## Usage

1. **Add Comment**: Type in the textarea and click "Add Comment"
2. **Edit Comment**: Click "Edit" button, modify text, then "Save" or "Cancel"
3. **Delete Comment**: Click "Delete" button and confirm
4. **View Comments**: All comments are displayed with author and timestamp

## Styling

- Clean, modern design
- Responsive layout for mobile and desktop
- Hover effects and smooth transitions
- Error handling with user-friendly messages