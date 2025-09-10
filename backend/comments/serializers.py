from rest_framework import serializers
from .models import Comment


class CommentSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source='author.first_name', read_only=True)
    
    class Meta:
        model = Comment
        fields = ['id', 'text', 'author', 'author_name', 'created_at', 'updated_at', 'likes', 'image']
        read_only_fields = ['author', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        # Set author to Admin user
        from django.contrib.auth.models import User
        admin_user = User.objects.get(username='admin')
        validated_data['author_id'] = admin_user.id
        return super().create(validated_data)
