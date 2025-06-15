package com.example.backend.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.UUID;

public class FileUploadUtil {
    private static final String UPLOAD_DIR = "uploads/images/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"};

    public String uploadImageFromBase64(String base64Data, String originalFilename) throws IOException {
        // Validate và decode base64
        byte[] fileBytes = validateAndDecodeBase64(base64Data, originalFilename);

        // Create upload directory if not exists
        createUploadDirectory();

        // Generate unique filename
        String fileExtension = getFileExtension(originalFilename);
        String uniqueFilename = UUID.randomUUID().toString() + fileExtension;

        // Save file to server
        Path uploadPath = Paths.get(UPLOAD_DIR + uniqueFilename);
        try {
            Files.write(uploadPath, fileBytes);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // Return URL path
        return "/uploads/images/" + uniqueFilename;
    }

    private byte[] validateAndDecodeBase64(String base64Data, String filename) throws IOException {
        if (base64Data == null || base64Data.trim().isEmpty()) {
            throw new IOException("File data is empty");
        }

        // Remove data URL prefix if exists (data:image/png;base64,)
        if (base64Data.contains(",")) {
            base64Data = base64Data.split(",")[1];
        }

        byte[] fileBytes;
        try {
            fileBytes = Base64.getDecoder().decode(base64Data);
        } catch (IllegalArgumentException e) {
            throw new IOException("Invalid base64 data");
        }

        if (fileBytes.length > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 5MB");
        }

        if (filename == null) {
            throw new IOException("Invalid filename");
        }

        String extension = getFileExtension(filename).toLowerCase();
        boolean isValidExtension = false;
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (extension.equals(allowedExt)) {
                isValidExtension = true;
                break;
            }
        }

        if (!isValidExtension) {
            throw new IOException("Invalid file type. Only image files are allowed");
        }

        return fileBytes;
    }

    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf('.') == -1) {
            return "";
        }
        return filename.substring(filename.lastIndexOf('.'));
    }

    private void createUploadDirectory() throws IOException {
        System.out.println("Vào đây");
        Path uploadPath = Paths.get(UPLOAD_DIR);
        System.out.println("Absolute path: " + uploadPath.toAbsolutePath());
        System.out.println("Directory exists: " + Files.exists(uploadPath));
        if (!Files.exists(uploadPath)) {
            try {
                Files.createDirectories(uploadPath);
                System.out.println("Directory created successfully");
            } catch (IOException e) {
                System.err.println("Failed to create directory: " + e.getMessage());
                throw e;
            }
        }
    }

    public boolean deleteFile(String imageUrl) {
        try {
            if (imageUrl != null && imageUrl.startsWith("/uploads/images/")) {
                String filename = imageUrl.substring("/uploads/images/".length());
                Path filePath = Paths.get(UPLOAD_DIR + filename);
                return Files.deleteIfExists(filePath);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
}
