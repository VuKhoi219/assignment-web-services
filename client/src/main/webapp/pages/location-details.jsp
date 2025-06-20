<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.client.generated.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Location Details</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .back-button {
            background: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 20px;
            transition: background 0.3s ease;
        }
        
        .back-button:hover {
            background: #0056b3;
        }
        
        .header {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .location-title {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .rating-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .stars {
            font-size: 1.5em;
            color: #ffd700;
        }
        
        .rating-value {
            font-weight: bold;
            color: #666;
        }
        
        .description {
            font-size: 1.1em;
            line-height: 1.6;
            color: #555;
            margin-bottom: 20px;
        }
        
        .guide-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
            margin-bottom: 20px;
        }
        
        .stats {
            display: flex;
            gap: 30px;
        }
        
        .stat-item {
            text-align: center;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            flex: 1;
        }
        
        .stat-number {
            font-size: 1.5em;
            font-weight: bold;
            color: #007bff;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .section {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .section-title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .images-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .image-card {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            background: #f0f0f0;
        }
        
        .image-card:hover {
            transform: translateY(-5px);
        }
        
        .image-placeholder {
            width: 100%;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 1.1em;
            flex-direction: column;
        }
        
        .image-caption {
            padding: 15px;
            background: white;
            font-size: 0.9em;
            color: #666;
        }
        
        .comment-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            background: #fafafa;
        }
        
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .comment-user {
            font-weight: bold;
            color: #333;
        }
        
        .comment-rating {
            color: #ffd700;
            font-size: 1.2em;
        }
        
        .comment-text {
            color: #555;
            line-height: 1.5;
        }
        
        .no-data {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 40px;
        }
    </style>
</head>
<body>    <div class="container">
        <!-- Multiple navigation options -->
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/" class="back-button">← Back to Home</a>
            <a href="${pageContext.request.contextPath}/home" class="back-button" style="margin-left: 10px;">🏠 Home</a>
        </div>
        
        <!-- Location Header -->
        <div class="header">
            <h1 class="location-title">
                <c:choose>
                    <c:when test="${location != null}">
                        ${location.title}
                    </c:when>
                    <c:otherwise>
                        Location Details
                    </c:otherwise>
                </c:choose>
            </h1>
            
            <c:if test="${location != null}">
                <div class="rating-section">
                    <span class="stars">${ratingStars != null ? ratingStars : '☆☆☆☆☆'}</span>
                    <span class="rating-value">(${averageRating != null ? averageRating : 0}/5.0)</span>
                </div>
                
                <div class="description">
                    ${location.description != null ? location.description : 'No description available.'}
                </div>
                
                <c:if test="${location.guide != null}">
                    <div class="guide-info">
                        <strong>Guide:</strong> ${location.guide.username} 
                        <span style="color: #666;">(${location.guide.email})</span>
                    </div>
                </c:if>
                
                <div class="stats">
                    <div class="stat-item">
                        <div class="stat-number">${imageCount != null ? imageCount : 0}</div>
                        <div class="stat-label">Photos</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:choose>
                                <c:when test="${location.comments != null}">
                                    ${location.comments.size()}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Reviews</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${averageRating != null ? averageRating : 0}</div>
                        <div class="stat-label">Rating</div>
                    </div>
                </div>
            </c:if>
        </div>
        
        <!-- Images Section -->
        <div class="section">
            <h2 class="section-title">Photos</h2>
            
            <c:choose>
                <c:when test="${hasImages != null && hasImages && images != null}">
                    <div class="images-grid">
                        <c:forEach var="image" items="${images}">
                            <div class="image-card">
                                <div class="image-placeholder">
                                    <span>📷</span>
                                    <small>Image ID: ${image.id}</small>
                                    <c:if test="${image.imageUrl != null}">
                                        <small>${image.imageUrl}</small>
                                    </c:if>
                                </div>
                                <c:if test="${image.caption != null && !empty image.caption}">
                                    <div class="image-caption">
                                        ${image.caption}
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        No photos available for this location yet.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Comments Section -->
        <div class="section">
            <h2 class="section-title">Reviews & Comments</h2>
            
            <c:choose>
                <c:when test="${location != null && location.comments != null && location.comments.size() > 0}">
                    <c:forEach var="comment" items="${location.comments}">
                        <div class="comment-card">
                            <div class="comment-header">
                                <span class="comment-user">
                                    <c:choose>
                                        <c:when test="${comment.user != null}">
                                            ${comment.user.username}
                                        </c:when>
                                        <c:otherwise>Anonymous</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="comment-rating">
                                    <c:if test="${comment.rating != null}">
                                        <c:forEach begin="1" end="${comment.rating}">★</c:forEach>
                                        <c:forEach begin="${comment.rating + 1}" end="5">☆</c:forEach>
                                    </c:if>
                                </span>
                            </div>
                            <div class="comment-text">
                                ${comment.comment != null ? comment.comment : 'No comment text.'}
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        No reviews yet. Be the first to share your experience!
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script>
        // Simple JavaScript for enhanced UX
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Location details page loaded');
            
            // Add click handlers for images
            const imageCards = document.querySelectorAll('.image-card');
            imageCards.forEach(card => {
                card.addEventListener('click', function() {
                    console.log('Image clicked');
                    // Future: Open image in modal
                });
            });
        });
    </script>
</body>
</html>
