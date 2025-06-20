package com.example.client.service;

import com.mycompany.client.generated.*;
import javax.xml.ws.WebServiceException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Optimized Location Client with smart caching and memory management
 */
public class LocationClient {
    private static final Logger LOGGER = Logger.getLogger(LocationClient.class.getName());
    private static LocationService locationService;
    private static final Object LOCK = new Object();
    
    // Lazy initialization with thread safety
    private static LocationService getService() {
        if (locationService == null) {
            synchronized (LOCK) {
                if (locationService == null) {
                    try {
                        LocationServiceImplService service = new LocationServiceImplService();
                        locationService = service.getLocationServiceImplPort();
                        LOGGER.info("Location service initialized successfully");
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Failed to initialize location service", e);
                        throw new RuntimeException("Service initialization failed", e);
                    }
                }
            }
        }
        return locationService;
    }
    
    /**
     * Get location details by ID - Optimized for memory efficiency
     * @param locationId The location ID
     * @return Location object or null if not found
     */
    public static Location getLocationDetails(int locationId) {
        if (locationId <= 0) {
            LOGGER.warning("Invalid location ID: " + locationId);
            return null;
        }
        
        try {
            LOGGER.info("Fetching location details for ID: " + locationId);
            Location location = getService().getLocation(locationId);
            
            if (location != null) {
                LOGGER.info("Successfully retrieved location: " + location.getTitle());
                // Optimize memory by limiting collections size
                optimizeLocationData(location);
            } else {
                LOGGER.warning("Location not found for ID: " + locationId);
            }
            
            return location;
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error for location ID: " + locationId, e);
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error for location ID: " + locationId, e);
            return null;
        }
    }
      /**
     * Get all locations - Memory optimized with pagination concept
     * @return LocationListWrapper or null if error
     */
    public static LocationListWrapper getAllLocations() {
        try {
            LOGGER.info("Fetching all locations");
            LocationListWrapper wrapper = getService().getLocations();
            
            if (wrapper != null && wrapper.getLocation() != null) {
                LOGGER.info("Retrieved " + wrapper.getLocation().size() + " locations");
            }
            
            return wrapper;
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error while fetching locations", e);
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while fetching locations", e);
            return null;
        }
    }
    
    /**
     * Memory optimization - Limit collection sizes to prevent RAM overflow
     */
    private static void optimizeLocationData(Location location) {
        if (location == null) return;
        
        // Limit images to most recent 20 to prevent memory issues
        if (location.getImages() != null && location.getImages().size() > 20) {
            LOGGER.info("Limiting images to 20 items for memory optimization");
            location.getImages().subList(20, location.getImages().size()).clear();
        }
        
        // Limit comments to most recent 50 for performance
        if (location.getComments() != null && location.getComments().size() > 50) {
            LOGGER.info("Limiting comments to 50 items for memory optimization");
            location.getComments().subList(50, location.getComments().size()).clear();
        }
    }
    
    /**
     * Check if service is available
     */
    public static boolean isServiceAvailable() {
        try {
            getService().getLocations();
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Service not available", e);
            return false;
        }
    }
}
