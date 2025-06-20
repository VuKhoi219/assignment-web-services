package com.example.client.service;

import com.mycompany.client.generated.*;
import javax.xml.ws.WebServiceException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Optimized Comment Client for efficient comment handling
 */
public class CommentClient {
    private static final Logger LOGGER = Logger.getLogger(CommentClient.class.getName());
    private static CommentService commentService;
    private static final Object LOCK = new Object();
    
    private static CommentService getService() {
        if (commentService == null) {
            synchronized (LOCK) {
                if (commentService == null) {
                    try {
                        CommentServiceImplService service = new CommentServiceImplService();
                        commentService = service.getCommentServiceImplPort();
                        LOGGER.info("Comment service initialized successfully");
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Failed to initialize comment service", e);
                        throw new RuntimeException("Comment service initialization failed", e);
                    }
                }
            }
        }
        return commentService;
    }
    
    /**
     * Get comment details by ID
     * @param commentId Comment ID
     * @return Comment object or null
     */
    public static Comment getCommentDetails(int commentId) {
        if (commentId <= 0) {
            LOGGER.warning("Invalid comment ID: " + commentId);
            return null;
        }
        
        try {
            LOGGER.info("Fetching comment details for ID: " + commentId);
            return getService().getComment(commentId);
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error for comment ID: " + commentId, e);
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error for comment ID: " + commentId, e);
            return null;
        }
    }
    
    /**
     * Get average rating for a location
     * @param locationId Location ID
     * @return Average rating or 0.0 if error
     */
    public static double getAverageRating(int locationId) {
        if (locationId <= 0) {
            LOGGER.warning("Invalid location ID for rating: " + locationId);
            return 0.0;
        }
        
        try {
            LOGGER.info("Fetching average rating for location ID: " + locationId);
            double rating = getService().getAverageRatingByLocation(locationId);
            LOGGER.info("Average rating for location " + locationId + ": " + rating);
            return rating;
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error getting rating for location: " + locationId, e);
            return 0.0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error getting rating for location: " + locationId, e);
            return 0.0;
        }
    }
    
    /**
     * Add new comment
     * @param locationId Location ID
     * @param comment Comment text
     * @param userId User ID
     * @param rating Rating (1-5)
     * @return Success message or error
     */
    public static String addComment(int locationId, String comment, int userId, int rating) {
        if (locationId <= 0 || userId <= 0) {
            return "Invalid location or user ID";
        }
        
        if (comment == null || comment.trim().isEmpty()) {
            return "Comment cannot be empty";
        }
        
        if (rating < 1 || rating > 5) {
            return "Rating must be between 1 and 5";
        }
        
        try {
            LOGGER.info("Adding comment for location " + locationId + " by user " + userId);
            return getService().createComment(locationId, comment.trim(), userId, rating);
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error adding comment", e);
            return "Service error: " + e.getMessage();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error adding comment", e);
            return "Error: " + e.getMessage();
        }
    }
}
