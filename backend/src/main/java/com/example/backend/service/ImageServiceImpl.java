package com.example.backend.service;

import com.example.backend.dto.ImageDTO;
import com.example.backend.dto.ImageListWrapper;
import com.example.backend.entity.Image;
import com.example.backend.entity.Location;
import com.example.backend.util.CheckRole;
import com.example.backend.util.FileUploadUtil;

import javax.jws.WebService;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;

@WebService(endpointInterface = "com.example.backend.service.ImageService")
public class ImageServiceImpl implements ImageService {
    private CheckRole checkRole = new CheckRole();
    private FileUploadUtil fileUploadUtil = new FileUploadUtil();

    // Base URL cho API serve ảnh - cập nhật theo domain/port của bạn
    private static final String BASE_IMAGE_URL = "http://localhost:8080/backend_war_exploded/api/images/serve/";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/web_service?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }

    @Override
    public ImageListWrapper getImages() {
        ArrayList<ImageDTO> images = new ArrayList<>();

        try (Connection conn = getConnection()) {
            String sql = "SELECT i.id, i.image_url, i.caption, i.location_id, " +
                    "l.title, l.description " +
                    "FROM images i " +
                    "JOIN locations l ON i.location_id = l.id " +
                    "ORDER BY i.id DESC";

            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    ImageDTO imageDTO = new ImageDTO();
                    imageDTO.setId(rs.getInt("id"));
                    // Trả về URL API để serve ảnh
                    imageDTO.setImageUrl(BASE_IMAGE_URL + rs.getInt("id"));
                    imageDTO.setCaption(rs.getString("caption"));
                    images.add(imageDTO);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving images", e);
        }

        return new ImageListWrapper(images);
    }

    @Override
    public Image getImage(int id) {
        try (Connection conn = getConnection()) {
            String sql = "SELECT i.id, i.image_url, i.caption, i.location_id, " +
                    "l.title, l.description " +
                    "FROM images i " +
                    "JOIN locations l ON i.location_id = l.id " +
                    "WHERE i.id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Image image = new Image();
                        image.setId(rs.getInt("id"));
                        // Trả về URL API để serve ảnh
                        image.setImageUrl(BASE_IMAGE_URL + id);
                        image.setCaption(rs.getString("caption"));

                        Location location = new Location();
                        location.setId(rs.getInt("location_id"));
                        location.setTitle(rs.getString("title"));
                        location.setDescription(rs.getString("description"));
                        image.setLocation(location);

                        return image;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new Image();
    }

    @Override
    public ArrayList<Image> getImagesByLocation(int locationId) {
        ArrayList<Image> images = new ArrayList<>();
        try (Connection conn = getConnection()) {
            String sql = "SELECT i.id, i.image_url, i.caption, i.location_id " +
                    "FROM images i WHERE i.location_id = ? ORDER BY i.id DESC";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, locationId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Image image = new Image();
                        int imageId = rs.getInt("id");
                        image.setId(imageId);
                        // Trả về URL API để serve ảnh
                        image.setImageUrl(BASE_IMAGE_URL + imageId);
                        image.setCaption(rs.getString("caption"));

                        Location location = new Location();
                        location.setId(locationId);
                        image.setLocation(location);

                        images.add(image);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    // API để serve ảnh dưới dạng file
    public byte[] serveImage(int imageId) {
        try (Connection conn = getConnection()) {
            String sql = "SELECT image_url FROM images WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, imageId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String imageUrl = rs.getString("image_url");
                        return getImageBytes(imageUrl);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public String uploadImage(int locationId, String base64ImageData, String filename, String caption, String token) {
        if(!checkRole.checkRole(token,"guide")){
            return "Bạn không có quyền sử dụng";
        }
        try {
            if (!isLocationExists(locationId)) {
                return "Location with ID " + locationId + " not found";
            }
            System.out.println("location id : "+locationId);
            String imageUrl = fileUploadUtil.uploadImageFromBase64(base64ImageData, filename);
            System.out.println("Vào đây");
            return saveImageToDatabase(locationId, imageUrl, caption);

        } catch (IOException e) {
            return "File upload failed: " + e.getMessage();
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    @Override
    public String updateImage(int imageId, String base64ImageData, String filename, String caption, String token) {
        if(!checkRole.checkRole(token,"guide")){
            return "Bạn không có quyền sử dụng";
        }
        System.out.println(imageId);
        try (Connection conn = getConnection()) {
            String oldImageUrl = null;
            String selectSql = "SELECT image_url FROM images WHERE id = ?";
            try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                selectStmt.setInt(1, imageId);
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        oldImageUrl = rs.getString("image_url");
                    } else {
                        return "Image with ID " + imageId + " not found";
                    }
                }
            }

            String newImageUrl = oldImageUrl;

            if (base64ImageData != null && !base64ImageData.trim().isEmpty()) {
                try {
                    newImageUrl = fileUploadUtil.uploadImageFromBase64(base64ImageData, filename);
                    fileUploadUtil.deleteFile(oldImageUrl);
                } catch (IOException e) {
                    return "File upload failed: " + e.getMessage();
                }
            }

            String updateSql = "UPDATE images SET image_url = ?, caption = ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newImageUrl);
                updateStmt.setString(2, caption != null ? caption.trim() : null);
                updateStmt.setInt(3, imageId);

                int affectedRows = updateStmt.executeUpdate();
                if (affectedRows > 0) {
                    return "Image updated successfully";
                } else {
                    return "Failed to update image";
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Database error: " + e.getMessage();
        }
    }

    @Override
    public String deleteImage(int id, String token) {
        if(!checkRole.checkRole(token,"guide")){
            return "Bạn không có quyền sử dụng";
        }
        try (Connection conn = getConnection()) {
            String imageUrl = null;
            String selectSql = "SELECT image_url FROM images WHERE id = ?";
            try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                selectStmt.setInt(1, id);
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        imageUrl = rs.getString("image_url");
                    } else {
                        return "Image with ID " + id + " not found";
                    }
                }
            }

            String deleteSql = "DELETE FROM images WHERE id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, id);

                int affectedRows = deleteStmt.executeUpdate();
                if (affectedRows > 0) {
                    fileUploadUtil.deleteFile(imageUrl);
                    return "Image deleted successfully";
                } else {
                    return "Failed to delete image";
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Database error: " + e.getMessage();
        }
    }

    // Helper methods
    private boolean isLocationExists(int locationId) {
        try (Connection conn = getConnection()) {
            String sql = "SELECT COUNT(*) FROM locations WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, locationId);
                try (ResultSet rs = stmt.executeQuery()) {
                    return rs.next() && rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String saveImageToDatabase(int locationId, String imageUrl, String caption) {
        try (Connection conn = getConnection()) {
            System.out.println("locationId: " + locationId);
            System.out.println("imageUrl: " + imageUrl);
            System.out.println("caption: " + caption);
            String sql = "INSERT INTO images (location_id, image_url, caption) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, locationId);
                stmt.setString(2, imageUrl);
                stmt.setString(3, caption != null ? caption.trim() : null);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int imageId = generatedKeys.getInt(1);
                            return "Image uploaded successfully with ID: " + imageId;
                        }
                    }
                    return "Image uploaded successfully";
                } else {
                    return "Failed to save image to database";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Database error: " + e.getMessage();
        }
    }

    // Helper method để đọc file ảnh thành byte array
    private byte[] getImageBytes(String imageUrl) {
        try {
            if (imageUrl != null && imageUrl.startsWith("/uploads/images/")) {
                String filename = imageUrl.substring("/uploads/images/".length());
                return Files.readAllBytes(Paths.get("uploads/images/" + filename));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
