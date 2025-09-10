#!/usr/bin/env python3
"""
Script to load comments from 'Copy of comments.json' into the database.
Usage: python load_copy_comments.py
"""

import os
import sys
import django
import json

# Add the project directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'comment_api.settings')
django.setup()

from comments.models import Comment
from django.contrib.auth.models import User

def load_copy_comments():
    """Load comments from Copy of comments.json into the database"""
    
    json_file = 'Copy of comments.json'
    
    try:
        # Check if file exists
        if not os.path.exists(json_file):
            print(f"❌ File {json_file} not found")
            return
        
        # Read JSON file
        with open(json_file, 'r') as f:
            data = json.load(f)
        
        comments_data = data.get('comments', [])
        print(f"📖 Loaded {len(comments_data)} comments from {json_file}")
        
        # Clear existing comments
        existing_count = Comment.objects.count()
        if existing_count > 0:
            Comment.objects.all().delete()
            print(f"🗑️  Cleared {existing_count} existing comments")
        
        # Create Admin user first (so it gets ID 1)
        admin_user, created = User.objects.get_or_create(
            username='admin',
            defaults={
                'email': 'admin@example.com',
                'first_name': 'Admin',
                'is_staff': True,
                'is_superuser': True
            }
        )
        if created:
            admin_user.set_password('admin123')
            admin_user.save()
            print(f"👤 Created Admin user: Admin")
        else:
            print(f"👤 Admin user already exists")
        
        # Create users for each unique author
        authors = {}
        for comment_data in comments_data:
            author_name = comment_data.get('author', 'Unknown')
            if author_name not in authors:
                user, created = User.objects.get_or_create(
                    username=author_name.lower().replace(' ', '_'),
                    defaults={
                        'email': f'{author_name.lower().replace(" ", "_")}@example.com',
                        'first_name': author_name
                    }
                )
                if created:
                    user.set_password('password123')
                    user.save()
                    print(f"👤 Created user: {author_name}")
                authors[author_name] = user
        
        # Create comments
        created_count = 0
        for comment_data in comments_data:
            author_name = comment_data.get('author', 'Unknown')
            text = comment_data.get('text', '')
            likes = comment_data.get('likes', 0)
            image = comment_data.get('image', '')
            
            # Create comment
            comment = Comment.objects.create(
                text=text,
                author=authors[author_name],
                likes=likes,
                image=image
            )
            created_count += 1
            print(f"✅ Created comment by {author_name}: {text[:50]}... (likes: {likes})")
        
        print(f"\n🎉 Successfully created {created_count} comments!")
        print(f"📊 Total comments in database: {Comment.objects.count()}")
        print(f"👥 Total users created: {len(authors)}")
        
        # Show API endpoint
        print(f"\n🌐 You can view the comments at: http://localhost:8000/api/comments/")
        
    except FileNotFoundError:
        print(f"❌ File {json_file} not found")
    except json.JSONDecodeError as e:
        print(f"❌ Invalid JSON in {json_file}: {e}")
    except Exception as e:
        print(f"❌ Error loading comments: {e}")

if __name__ == "__main__":
    load_copy_comments()
