package com.example.backend.service;

import com.example.backend.dto.LocationDTO;
import com.example.backend.dto.LocationListWrapper;
import com.example.backend.entity.Comment;
import com.example.backend.entity.Image;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;
import com.example.backend.util.CheckRole;

import javax.jws.WebService;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;
import java.util.*;


@WebService(endpointInterface = "com.example.backend.service.LocationService")
public class LocationServiceImpl implements LocationService {
    private static final String BASE_IMAGE_URL = "http://localhost:8080/backend_war_exploded/api/images/serve/";

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
    private CheckRole checkRole = new CheckRole();

    @Override
    public LocationListWrapper getLocations() {
        ArrayList<LocationDTO> locations = new ArrayList<>();

        try (Connection conn = getConnection()) {
            String query = "SELECT l.id, l.title, l.description, " +
                    "i.id as image_id " +  // Thêm alias này
                    "FROM locations l " +
                    "LEFT JOIN images i ON l.id = i.location_id " +
                    "WHERE i.id = ( " +
                    "    SELECT MIN(id) " +
                    "    FROM images i2 " +
                    "    WHERE i2.location_id = l.id " +
                    ") OR i.id IS NULL";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LocationDTO location = new LocationDTO();
                        location.setId(rs.getInt("id"));
                        location.setTitle(rs.getString("title"));
                        location.setDescription(rs.getString("description"));
                        // Xử lý ảnh
                        int imageId = rs.getInt("image_id");
                        if (imageId > 0) { // Có ảnh
                            String imageUrl = BASE_IMAGE_URL + imageId;
                            location.setImageData(imageUrl);
                        } else { // Không có ảnh
                            location.setImageData(null); // hoặc default image
                        }
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
        System.out.println("Getting location by id: " + id);
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
                                User guide = new User();
                                guide.setId(rs.getInt("guide_id"));
                                guide.setUsername(rs.getString("guide_username"));
                                guide.setEmail(rs.getString("guide_email"));
                                guide.setRole(rs.getString("guide_role"));
                                location.setGuide(guide);

                            }
                        }

                        if (rs.getObject("image_id") != null) {
                            int imageId = rs.getInt("image_id");
                            if (!imageMap.containsKey(imageId)) {
                                Image image = new Image();
                                image.setId(imageId);

                                // Dùng URL API thay vì Base64
                                String imageApiUrl = BASE_IMAGE_URL + imageId;
                                image.setImageUrl(imageApiUrl); // Dùng setImageUrl thay vì setImageData

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
    public Location createLocation(String title, String description, int guideId,String token) {
        System.out.println("Received token: " + token);
        System.out.println("Dot count: " + token.chars().filter(c -> c == '.').count());
        System.out.println(checkRole.checkRole(token,"guide"));
        if(!checkRole.checkRole(token,"guide")){
            Location empty = new Location();
            empty.setId(-1); // hoặc ID đặc biệt báo lỗi
            empty.setTitle("Unauthorized");
            empty.setDescription("You are not allowed to perform this action.");
            return empty;
        }
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
        Location empty = new Location();
        empty.setId(-1); // hoặc ID đặc biệt báo lỗi
        empty.setTitle("Lỗi Server");
        empty.setDescription("Lỗi Server");
        return empty;
    }


    // Hoặc nếu bạn muốn trả về Location object sau khi update:
    @Override
    public Location updateLocation(String title, String description, int id, String token) {
        System.out.println("Received token: " + token);
        System.out.println("Dot count: " + token.chars().filter(c -> c == '.').count());
        System.out.println(checkRole.checkRole(token,"guide"));
        if(!checkRole.checkRole(token,"guide")){
            Location empty = new Location();
            empty.setId(-1); // hoặc ID đặc biệt báo lỗi
            empty.setTitle("Unauthorized");
            empty.setDescription("You are not allowed to perform this action.");
            return empty;
        }
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
    public boolean deleteLocation(int id, String token) {
        if(!checkRole.checkRole(token,"guide")){
            return false;
        }

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Xóa comments trước
            String deleteComments = "DELETE FROM comments WHERE location_id = ?";
            try (PreparedStatement stmt1 = conn.prepareStatement(deleteComments)) {
                stmt1.setInt(1, id);
                stmt1.executeUpdate();
            }

            // 2. Xóa images (nếu có)
            String deleteImages = "DELETE FROM images WHERE location_id = ?";
            try (PreparedStatement stmt2 = conn.prepareStatement(deleteImages)) {
                stmt2.setInt(1, id);
                stmt2.executeUpdate();
            }

            // 3. Cuối cùng xóa location
            String deleteLocation = "DELETE FROM locations WHERE id = ?";
            try (PreparedStatement stmt3 = conn.prepareStatement(deleteLocation)) {
                stmt3.setInt(1, id);
                int affectedRows = stmt3.executeUpdate();

                if (affectedRows > 0) {
                    conn.commit(); // Commit nếu thành công
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback(); // Rollback nếu có lỗi
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    private String convertImageToBase64(String imageUrl) {
        try {
            if (imageUrl != null && imageUrl.startsWith("/uploads/images/")) {
                String filename = imageUrl.substring("/uploads/images/".length());
                byte[] fileBytes = Files.readAllBytes(Paths.get("uploads/images/" + filename));
                return Base64.getEncoder().encodeToString(fileBytes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
