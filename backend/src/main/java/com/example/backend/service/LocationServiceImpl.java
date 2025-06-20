package com.example.backend.service;

import com.example.backend.dto.LocationDTO;
import com.example.backend.dto.LocationListWrapper;
import com.example.backend.entity.Comment;
import com.example.backend.entity.Image;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;

import javax.jws.WebService;
import java.sql.*;
import java.util.*;

@WebService(endpointInterface = "com.example.backend.service.LocationService")
public class LocationServiceImpl implements LocationService {

    private Connection getConnection() throws SQLException {
        try {
            // Load driver
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
    public LocationListWrapper getLocations() {
        ArrayList<LocationDTO> locations = new ArrayList<>();

        try (Connection conn = getConnection()) {
            String query = "SELECT id, title, description FROM locations";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LocationDTO location = new LocationDTO();
                        location.setId(rs.getInt("id"));
                        location.setTitle(rs.getString("title"));
                        location.setDescription(rs.getString("description"));
                        locations.add(location);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return new LocationListWrapper(locations);
    }

    @Override
    public Location getLocation(int id) {
        try (Connection conn = getConnection()) {
            // Query với LEFT JOIN dựa theo các entities thực tế
            String query =
                    "SELECT " +
                            "l.id as id, l.title, l.description, " +
                            "g.id as guide_id, g.username as guide_username, g.email as guide_email, g.role as guide_role, " +
                            "i.id as image_id, i.image_url, i.caption, " +
                            "c.id as comment_id, c.comment as comment_comment, c.rating, " +
                            "cu.id as comment_user_id, cu.username as comment_username, cu.email as comment_email, cu.role as comment_role " +
                            "FROM locations l " +
                            "LEFT JOIN users g ON l.guide_id = g.id " +
                            "LEFT JOIN images i ON l.id = i.location_id " +
                            "LEFT JOIN comments c ON l.id = c.location_id " +
                            "LEFT JOIN users cu ON c.user_id = cu.id " +
                            "WHERE l.id = ? " +
                            "ORDER BY c.id DESC";
//            String simpleQuery = "SELECT id, title, description FROM locations WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    Location location = null;
                    Map<Integer, Image> imageMap = new LinkedHashMap<>();
                    Map<Integer, Comment> commentMap = new LinkedHashMap<>();

                    while (rs.next()) {
                        if (location == null) {
                            location = new Location();
                            location.setId(rs.getInt("id"));
                            location.setTitle(rs.getString("title"));
                            location.setDescription(rs.getString("description"));

                            // Set guide nếu có
                            if (rs.getString("guide_id") != null) {
                                System.out.println("Vào đây");
                                User guide = new User();
                                guide.setId(rs.getInt("guide_id"));
                                guide.setUsername(rs.getString("guide_username"));
                                guide.setEmail(rs.getString("guide_email"));
                                guide.setRole(rs.getString("guide_role"));
                                location.setGuide(guide);

                            }
                        }

                        // Thêm image nếu có và chưa tồn tại
                        if (rs.getObject("image_id") != null) {
                            int imageId = rs.getInt("image_id");
                            if (!imageMap.containsKey(imageId)) {
                                Image image = new Image();
                                image.setId(imageId);
                                image.setImageUrl(rs.getString("image_url"));
                                image.setCaption(rs.getString("caption"));
                                imageMap.put(imageId, image);
                            }
                        }

                        // Thêm comment nếu có và chưa tồn tại
                        if (rs.getObject("comment_id") != null) {
                            int commentId = rs.getInt("comment_id");
                            if (!commentMap.containsKey(commentId)) {
                                Comment comment = new Comment();
                                comment.setId(commentId);
                                comment.setComment(rs.getString("comment_comment")); // Sử dụng setComment() thay vì setcomment()
                                comment.setRating(rs.getInt("rating"));

                                // Set user cho comment
                                if (rs.getObject("comment_user_id") != null) {
                                    User commentUser = new User();
                                    commentUser.setId(rs.getInt("comment_user_id"));
                                    commentUser.setUsername(rs.getString("comment_username"));
                                    commentUser.setEmail(rs.getString("comment_email"));
                                    commentUser.setRole(rs.getString("comment_role"));
                                    comment.setUser(commentUser);
                                }

                                commentMap.put(commentId, comment);
                            }
                        }
                    }

                    // Set lists cho location
                    if (location != null) {
                        location.setImages(new ArrayList<>(imageMap.values()));
                        location.setComments(new ArrayList<>(commentMap.values()));
                    }
                    return location;
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            return null;
        }
    }

    @Override
    public Location createLocation(String title, String description, int guideId) {
        try (Connection conn = getConnection()) {
            String sql = "INSERT INTO locations (title, description, guide_id) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, title);
                stmt.setString(2, description);
                stmt.setInt(3, guideId);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating location failed, no rows affected.");
                }

                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int locationId = generatedKeys.getInt(1);

                        // Tạo đối tượng Location để trả về
                        Location location = new Location();
                        location.setId(locationId);
                        location.setTitle(title);
                        location.setDescription(description);

                        // Tạo user với ID thôi là đủ (nếu bạn không cần load full User)
                        User guide = new User();
                        guide.setId(guideId);
                        location.setGuide(guide);

                        return location;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    // Hoặc nếu bạn muốn trả về Location object sau khi update:
    @Override
    public Location updateLocation(String title, String description, int id) {
        try (Connection conn = getConnection()) {
            String sql = "UPDATE locations SET title = ?, description = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, title);
                stmt.setString(2, description);
                stmt.setInt(3, id);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    // Lấy lại location sau khi update
                    String selectSql = "SELECT * FROM locations WHERE id = ?";
                    try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                        selectStmt.setInt(1, id);
                        try (ResultSet rs = selectStmt.executeQuery()) {
                            if (rs.next()) {
                                Location location = new Location();
                                location.setId(rs.getInt("id"));
                                location.setTitle(rs.getString("title"));
                                location.setDescription(rs.getString("description"));

                                // Nếu cần thông tin guide
                                int guideId = rs.getInt("guide_id");
                                User guide = new User();
                                guide.setId(guideId);
                                location.setGuide(guide);

                                return location;
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean deleteLocation(int id) {
        try (Connection conn = getConnection()) {
            String sql = "DELETE FROM locations WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);

                int affectedRows = stmt.executeUpdate();
                return affectedRows > 0; // Trả về true nếu xóa thành công
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
