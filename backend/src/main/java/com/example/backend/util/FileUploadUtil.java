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
        try {
            System.out.println("=== UPLOAD DEBUG ===");
            System.out.println("Original filename: " + originalFilename);
            System.out.println("Base64 data length: " + (base64Data != null ? base64Data.length() : "null"));
            System.out.println("Base64 starts with: " + (base64Data != null && base64Data.length() > 50 ? base64Data.substring(0, 50) : base64Data));

            // Validate và decode base64
            System.out.println("Step 1: Validating and decoding base64...");
            byte[] fileBytes = validateAndDecodeBase64(base64Data, originalFilename);
            System.out.println("Step 1: SUCCESS - File bytes length: " + fileBytes.length);

            // Create upload directory if not exists
            System.out.println("Step 2: Creating upload directory...");
            createUploadDirectory();
            System.out.println("Step 2: SUCCESS");

            // Generate unique filename
            System.out.println("Step 3: Generating filename...");
            String fileExtension = getFileExtension(originalFilename);
            String uniqueFilename = UUID.randomUUID().toString() + fileExtension;
            System.out.println("Step 3: SUCCESS - Unique filename: " + uniqueFilename);

            // Save file to server
            System.out.println("Step 4: Saving file...");
            Path uploadPath = Paths.get(UPLOAD_DIR + uniqueFilename);
            System.out.println("Upload path: " + uploadPath.toString());

            Files.write(uploadPath, fileBytes);
            System.out.println("Step 4: SUCCESS - File saved");

            // Return URL path
            String result = "/uploads/images/" + uniqueFilename;
            System.out.println("Final result: " + result);
            return result;

        } catch (Exception e) {
            System.out.println("ERROR in uploadImageFromBase64: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    private byte[] validateAndDecodeBase64(String base64Data, String filename) {
        try {
            // Nếu có data URI prefix, loại bỏ nó
            if (base64Data.startsWith("data:")) {
                int commaIndex = base64Data.indexOf(',');
                if (commaIndex != -1) {
                    base64Data = base64Data.substring(commaIndex + 1);
                }
            }

            // Decode base64
            return Base64.getDecoder().decode(base64Data);
        } catch (Exception e) {
            System.out.println("Base64 decode error: " + e.getMessage());
            throw new RuntimeException("Invalid base64 data", e);
        }
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
