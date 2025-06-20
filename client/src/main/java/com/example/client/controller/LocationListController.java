package com.example.client.controller;

import com.example.client.service.LocationClient;
import com.example.client.service.SimpleImageClient;
import com.mycompany.client.generated.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * LocationListController with integrated filter functionality
 */
@WebServlet(name = "LocationListController", urlPatterns = {"/locations"})
public class LocationListController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LocationListController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {        String filterQuery = request.getParameter("filterQuery");
        String filterRating = request.getParameter("filterRating");
        
        try {
            LOGGER.info("Loading locations list with filters - Query: " + filterQuery + ", Rating: " + filterRating);
            
            // Get all locations from backend
            LocationListWrapper locationWrapper = LocationClient.getAllLocations();
            List<LocationDTO> allLocations = new ArrayList<>();
            
            if (locationWrapper != null && locationWrapper.getLocation() != null) {
                allLocations = locationWrapper.getLocation();
            }
            
            // Apply filters if present
            List<LocationSearchResult> filteredResults = new ArrayList<>();
            if (filterQuery != null || filterRating != null) {
                for (LocationDTO location : allLocations) {
                    LocationSearchResult result = processLocationFilter(location, filterQuery, filterRating);
                    if (result.isMatched()) {
                        filteredResults.add(result);
                    }
                }
                
                // Sort by rating (highest first)
                filteredResults.sort((a, b) -> Double.compare(b.getAverageRating(), a.getAverageRating()));
                
                request.setAttribute("filteredResults", filteredResults);
                request.setAttribute("hasFilter", true);
            } else {
                // No filter, show all locations
                request.setAttribute("hasFilter", false);
            }
            
            request.setAttribute("locations", allLocations);
            request.setAttribute("locationsCount", allLocations.size());            request.setAttribute("searchQuery", filterQuery);   // Đổi tên attribute
            request.setAttribute("minRating", filterRating);    // Đổi tên attribute
            
            LOGGER.info("Found " + allLocations.size() + " total locations, " + 
                       (filteredResults.size()) + " filtered results");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading locations", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách địa điểm: " + e.getMessage());        }
        
        // Forward to locations list page using layout
        request.setAttribute("content", "pages/locations-list.jsp");
        request.getRequestDispatcher("layout.jsp").forward(request, response);
    }
    
    /**
     * Process location for filtering using WSDL imports
     */
    private LocationSearchResult processLocationFilter(LocationDTO location, String filterQuery, String filterRating) {
        LocationSearchResult result = new LocationSearchResult();
        result.setLocation(location);
        result.setMatched(false);
        
        boolean matchesQuery = true;
        boolean matchesRating = true;
        
        // Filter by search query (tên địa điểm, mô tả)
        if (filterQuery != null && !filterQuery.trim().isEmpty()) {
            String query = filterQuery.toLowerCase();
            String title = location.getTitle() != null ? location.getTitle().toLowerCase() : "";
            String description = location.getDescription() != null ? location.getDescription().toLowerCase() : "";
            
            matchesQuery = title.contains(query) || description.contains(query);
        }
        
        // Calculate average rating from comments (using WSDL import)
        double avgRating = 0.0;
        try {
            // Get comments from backend and calculate average
            // Using existing CommentClient which uses WSDL
            avgRating = com.example.client.service.CommentClient.getAverageRating(location.getId());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to get rating for location: " + location.getId(), e);
        }
        result.setAverageRating(avgRating);
        
        // Filter by rating
        if (filterRating != null && !filterRating.trim().isEmpty()) {
            try {
                int minRating = Integer.parseInt(filterRating);
                matchesRating = avgRating >= minRating;
            } catch (NumberFormatException e) {
                // Invalid rating, ignore filter
            }
        }
        
        // Load preview image using SimpleImageClient (WSDL import)
        try {
            @SuppressWarnings("rawtypes")
            java.util.List images = SimpleImageClient.getImagesByLocation(location.getId());
            if (images != null && !images.isEmpty()) {
                result.setPreviewImage(images.get(0));
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to load preview image for location: " + location.getId(), e);
        }
        
        result.setMatched(matchesQuery && matchesRating);
        return result;
    }
    
    /**
     * LocationSearchResult class for filter results
     */
    public static class LocationSearchResult {
        private LocationDTO location;
        private double averageRating;
        private Object previewImage;
        private boolean matched;
        
        // Getters and setters
        public LocationDTO getLocation() { return location; }
        public void setLocation(LocationDTO location) { this.location = location; }
        
        public double getAverageRating() { return averageRating; }
        public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
        
        public Object getPreviewImage() { return previewImage; }
        public void setPreviewImage(Object previewImage) { this.previewImage = previewImage; }
        
        public boolean isMatched() { return matched; }
        public void setMatched(boolean matched) { this.matched = matched; }
    }
}
