import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

// Configure axios to use our Django API
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';
axios.defaults.baseURL = API_BASE_URL;

function App() {
  const [comments, setComments] = useState([]);
  const [newComment, setNewComment] = useState('');
  const [editingId, setEditingId] = useState(null);
  const [editingText, setEditingText] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Fetch all comments on component mount
  useEffect(() => {
    fetchComments();
  }, []);

  const fetchComments = async () => {
    try {
      setLoading(true);
      const response = await axios.get('/comments/');
      setComments(response.data);
      setError('');
    } catch (err) {
      setError('Failed to fetch comments');
      console.error('Error fetching comments:', err);
    } finally {
      setLoading(false);
    }
  };

  const addComment = async (e) => {
    e.preventDefault();
    if (!newComment.trim()) return;

    try {
      const response = await axios.post('/comments/', {
        text: newComment.trim()
      });
      setComments([response.data, ...comments]);
      setNewComment('');
      setError('');
    } catch (err) {
      setError('Failed to add comment');
      console.error('Error adding comment:', err);
    }
  };

  const startEdit = (comment) => {
    setEditingId(comment.id);
    setEditingText(comment.text);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditingText('');
  };

  const updateComment = async (id) => {
    if (!editingText.trim()) return;

    try {
      const response = await axios.put(`/comments/${id}/`, {
        text: editingText.trim()
      });
      setComments(comments.map(comment => 
        comment.id === id ? response.data : comment
      ));
      setEditingId(null);
      setEditingText('');
      setError('');
    } catch (err) {
      setError('Failed to update comment');
      console.error('Error updating comment:', err);
    }
  };

  const deleteComment = async (id) => {
    if (!window.confirm('Are you sure you want to delete this comment?')) return;

    try {
      await axios.delete(`/comments/${id}/`);
      setComments(comments.filter(comment => comment.id !== id));
      setError('');
    } catch (err) {
      setError('Failed to delete comment');
      console.error('Error deleting comment:', err);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="App">
      {/* Post Header */}
      <div className="post-header">
        <div className="post-content">
          <h1 className="post-title">What backend technology should I use as a solo developer?</h1>
          <p className="post-description">
            I'm starting a new project and need to choose a backend technology. 
            I'll be working solo, so I need something that's efficient to set up and maintain. 
            What would you recommend?
          </p>
          <div className="post-meta">
            <span className="post-author">Posted by SoloDev</span>
            <span className="post-date">2 days ago</span>
            <span className="post-stats">{comments.length} comments</span>
          </div>
        </div>
      </div>

      <main className="App-main">
        {error && <div className="error">{error}</div>}

        {/* Add Comment Form */}
        <form onSubmit={addComment} className="comment-form">
          <h3>Add a Comment</h3>
          <textarea
            value={newComment}
            onChange={(e) => setNewComment(e.target.value)}
            placeholder="Share your thoughts on backend technologies..."
            rows="4"
            required
          />
          <button type="submit" disabled={loading}>
            {loading ? 'Posting...' : 'Post Comment'}
          </button>
        </form>

        {/* Comments Section */}
        <div className="comments-section">
          <h2 className="comments-title">Comments ({comments.length})</h2>
          {loading && <div className="loading">Loading comments...</div>}
          
          {comments.length === 0 && !loading ? (
            <div className="no-comments">
              <p>No comments yet. Be the first to share your thoughts!</p>
            </div>
          ) : (
            <div className="comments-list">
              {comments.map(comment => (
                <div key={comment.id} className="comment">
                  <div className="comment-avatar">
                    <div className="avatar-placeholder">
                      {comment.author_name.charAt(0).toUpperCase()}
                    </div>
                  </div>
                  
                  <div className="comment-body">
                    <div className="comment-header">
                      <span className="author-name">{comment.author_name}</span>
                      <span className="comment-date">{formatDate(comment.created_at)}</span>
                    </div>
                    
                    {editingId === comment.id ? (
                      <div className="edit-form">
                        <textarea
                          value={editingText}
                          onChange={(e) => setEditingText(e.target.value)}
                          rows="4"
                          className="edit-textarea"
                        />
                        <div className="edit-buttons">
                          <button onClick={() => updateComment(comment.id)} className="save-btn">
                            Save
                          </button>
                          <button onClick={cancelEdit} className="cancel-btn">
                            Cancel
                          </button>
                        </div>
                      </div>
                    ) : (
                      <div className="comment-content">
                        <p className="comment-text">{comment.text}</p>
                        
                        {comment.image && (
                          <div className="comment-image">
                            <img src={comment.image} alt="Comment content" className="comment-img" />
                          </div>
                        )}
                        
                        <div className="comment-footer">
                          <div className="comment-actions">
                            <button className="like-btn">
                              <span className="like-icon">👍</span>
                              <span className="like-count">{comment.likes}</span>
                            </button>
                            <button onClick={() => startEdit(comment)} className="action-btn">
                              Edit
                            </button>
                            <button onClick={() => deleteComment(comment.id)} className="action-btn delete-btn">
                              Delete
                            </button>
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}

export default App;