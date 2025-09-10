#!/usr/bin/env python3
"""
Quick test script to verify the project setup is working.
Run this after following the setup instructions.
"""

import requests
import json

def test_setup():
    print("🧪 Testing Comment System Setup...")
    print("=" * 50)
    
    try:
        # Test backend API
        print("1. Testing backend API...")
        response = requests.get("http://localhost:8000/api/comments/")
        
        if response.status_code == 200:
            comments = response.json()
            print(f"✅ Backend API working - Found {len(comments)} comments")
            
            if len(comments) > 0:
                print(f"✅ Sample data loaded - First comment by: {comments[0]['author_name']}")
            else:
                print("⚠️  No comments found - run: python load_copy_comments.py")
        else:
            print(f"❌ Backend API error - Status: {response.status_code}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Backend not running - Start with: python manage.py runserver")
        return False
    except Exception as e:
        print(f"❌ Backend error: {e}")
        return False
    
    print("\n2. Testing frontend...")
    try:
        response = requests.get("http://localhost:3000")
        if response.status_code == 200:
            print("✅ Frontend is running")
        else:
            print(f"⚠️  Frontend status: {response.status_code}")
    except requests.exceptions.ConnectionError:
        print("❌ Frontend not running - Start with: npm start")
        return False
    except Exception as e:
        print(f"❌ Frontend error: {e}")
        return False
    
    print("\n" + "=" * 50)
    print("🎉 Setup test complete!")
    print("✅ Both backend and frontend are working")
    print("🌐 Visit http://localhost:3000 to see the application")
    
    return True

if __name__ == "__main__":
    test_setup()
