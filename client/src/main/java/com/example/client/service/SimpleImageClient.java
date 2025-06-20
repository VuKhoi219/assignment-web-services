package com.example.client.service;

import com.mycompany.client.generated.*;
import javax.xml.ws.WebServiceException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Simple and efficient Image Client
 */
public class SimpleImageClient {
    private static final Logger LOGGER = Logger.getLogger(SimpleImageClient.class.getName());
    private static ImageService imageService;
    private static final Object LOCK = new Object();
    
    private static ImageService getService() {
        if (imageService == null) {
            synchronized (LOCK) {
                if (imageService == null) {
                    try {
                        ImageServiceImplService service = new ImageServiceImplService();
                        imageService = service.getImageServiceImplPort();
                        LOGGER.info("Image service initialized successfully");
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Failed to initialize image service", e);
                        throw new RuntimeException("Image service initialization failed", e);
                    }
                }
            }
        }
        return imageService;
    }
      /**
     * Get images by location - Memory optimized
     */
    @SuppressWarnings("rawtypes")
    public static java.util.List getImagesByLocation(int locationId) {
        if (locationId <= 0) {
            LOGGER.warning("Invalid location ID for images: " + locationId);
            return new java.util.ArrayList();
        }
        
        try {
            LOGGER.info("Fetching images for location ID: " + locationId);
            Object result = getService().getImagesByLocation(locationId);
            if (result instanceof java.util.List) {
                return (java.util.List) result;
            }
            return new java.util.ArrayList();
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error fetching images for location: " + locationId, e);
            return new java.util.ArrayList();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error fetching images for location: " + locationId, e);
            return new java.util.ArrayList();
        }
    }
    
    /**
     * Get single image details
     */
    public static Image getImageDetails(int imageId) {
        if (imageId <= 0) {
            LOGGER.warning("Invalid image ID: " + imageId);
            return null;
        }
        
        try {
            LOGGER.info("Fetching image details for ID: " + imageId);
            return getService().getImage(imageId);
        } catch (WebServiceException e) {
            LOGGER.log(Level.SEVERE, "Web service error for image ID: " + imageId, e);
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error for image ID: " + imageId, e);
            return null;
        }
    }
}
