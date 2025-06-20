package com.example.client.controller;

import com.example.client.service.LocationClient;
import com.example.client.service.SimpleImageClient;
import com.example.client.service.CommentClient;
import com.mycompany.client.generated.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Optimized View Details Controller
 * Handles location details with smart data loading
 */
@WebServlet(name = "ViewDetailsController", urlPatterns = {"/view-details"})
public class ViewDetailsController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ViewDetailsController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String locationIdParam = request.getParameter("id");
        
        // Validate input
        if (locationIdParam == null || locationIdParam.trim().isEmpty()) {
            LOGGER.warning("Missing location ID parameter");
            response.sendRedirect("pages/home.jsp?error=missing_id");
            return;
        }
        
        try {
            int locationId = Integer.parseInt(locationIdParam.trim());
            
            if (locationId <= 0) {
                LOGGER.warning("Invalid location ID: " + locationId);
                response.sendRedirect("pages/home.jsp?error=invalid_id");
                return;
            }
            
            LOGGER.info("Processing view details request for location ID: " + locationId);
            
            // Load data efficiently
            LocationDetailsData data = loadLocationDetails(locationId);
            
            if (data.location == null) {
                LOGGER.warning("Location not found: " + locationId);
                response.sendRedirect("pages/home.jsp?error=not_found");
                return;
            }
            
            // Set attributes for JSP
            request.setAttribute("location", data.location);
            request.setAttribute("images", data.images);
            request.setAttribute("averageRating", data.averageRating);
            request.setAttribute("ratingStars", getRatingStars(data.averageRating));
            request.setAttribute("hasImages", data.images != null && !data.images.isEmpty());
            request.setAttribute("imageCount", data.images != null ? data.images.size() : 0);
            
            // Forward to view details page
            request.getRequestDispatcher("pages/location-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid location ID format: " + locationIdParam, e);
            response.sendRedirect("pages/home.jsp?error=invalid_format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing view details request", e);
            response.sendRedirect("pages/home.jsp?error=system_error");
        }
    }
    
    /**
     * Optimized data loading with minimal service calls
     */
    private LocationDetailsData loadLocationDetails(int locationId) {
        LocationDetailsData data = new LocationDetailsData();
        
        try {
            // Load location details (includes comments from backend optimization)
            data.location = LocationClient.getLocationDetails(locationId);
            
            if (data.location != null) {                // Load images separately for better control
                data.images = SimpleImageClient.getImagesByLocation(locationId);
                
                // Get average rating
                data.averageRating = CommentClient.getAverageRating(locationId);
                
                LOGGER.info("Successfully loaded details for location: " + data.location.getTitle());
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading location details for ID: " + locationId, e);
        }
        
        return data;
    }
    
    /**
     * Generate star rating display
     */
    private String getRatingStars(double rating) {
        StringBuilder stars = new StringBuilder();
        int fullStars = (int) rating;
        boolean hasHalfStar = (rating - fullStars) >= 0.5;
        
        // Full stars
        for (int i = 0; i < fullStars; i++) {
            stars.append("★");
        }
        
        // Half star
        if (hasHalfStar) {
            stars.append("☆");
        }
        
        // Empty stars
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
        for (int i = 0; i < emptyStars; i++) {
            stars.append("☆");
        }
        
        return stars.toString();
    }    /**
     * Data transfer object for efficient data handling
     */
    @SuppressWarnings("rawtypes")
    private static class LocationDetailsData {
        Location location;
        java.util.List images;
        double averageRating;
    }
}
