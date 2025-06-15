package com.example.backend.service;

import com.example.backend.dto.CommentDTO;
import com.example.backend.dto.CommentListWrapper;
import com.example.backend.entity.Comment;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;

import javax.jws.WebService;
import java.sql.*;
import java.util.ArrayList;

import java.util.List;

@WebService(endpointInterface = "com.example.backend.service.CommentService")
public class CommentServiceImpl implements CommentService{

    private Connection getConnection() throws SQLException {
        try {
            // Load driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/wed_service?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }

    @Override
    public CommentListWrapper getComments() {
        ArrayList<CommentDTO> comments = new ArrayList<>(); // Đổi từ Comment sang CommentDTO

        try (Connection conn = getConnection()) {
            String sql = "SELECT c.id, c.comment, c.rating, c.user_id, c.location_id, " +
                    "u.username, u.email, " +
                    "l.title, l.description " +
                    "FROM comments c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "JOIN locations l ON c.location_id = l.id " +
                    "ORDER BY c.id DESC";

            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    // Tạo CommentDTO thay vì Comment entity
                    CommentDTO commentDTO = new CommentDTO();
                    commentDTO.setId(rs.getInt("id"));
                    commentDTO.setComment(rs.getString("comment")); // Cần thêm field này vào DTO
                    commentDTO.setRating(rs.getInt("rating"));

                    comments.add(commentDTO);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving comments", e);
        }

        return new CommentListWrapper(comments); // Return wrapper với DTO list
    }

    @Override
    public Comment getComment(int id) {
        try (Connection conn = getConnection()) {
            String sql = "SELECT c.id, c.comment, c.rating, c.user_id, c.location_id, " +
                    "u.username, u.email, " +
                    "l.title, l.description " +
                    "FROM comments c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "JOIN locations l ON c.location_id = l.id " +
                    "WHERE c.id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Comment comment = new Comment();
                        comment.setId(rs.getInt("id"));
                        comment.setComment(rs.getString("comment"));
                        comment.setRating(rs.getInt("rating"));

                        // Tạo User object
                        User user = new User();
                        user.setId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        comment.setUser(user);

                        // Tạo Location object
                        Location location = new Location();
                        location.setId(rs.getInt("location_id"));
                        location.setTitle(rs.getString("title"));
                        location.setDescription(rs.getString("description"));
                        comment.setLocation(location);

                        return comment;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public String createComment(int  locationId, String comment, int userId, int rating) {
        try (Connection conn = getConnection()) {
            // Kiểm tra rating hợp lệ (1-5)
            if (rating < 1 || rating > 5) {
                return "Rating must be between 1 and 5";
            }

            // Kiểm tra comment không rỗng
            if (comment == null || comment.trim().isEmpty()) {
                return "Comment comment cannot be empty";
            }

            String sql = "INSERT INTO comments (comment, rating, user_id, location_id) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, comment.trim());
                stmt.setInt(2, rating);
                stmt.setInt(3, userId);
                stmt.setInt(4, locationId);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            int commentId = generatedKeys.getInt(1);
                            return "Comment created successfully with ID: " + commentId;
                        }
                    }
                    return "Comment created successfully";
                } else {
                    return "Failed to create comment";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage().contains("foreign key constraint")) {
                return "Invalid user or location ID";
            }
            return "Error occurred while creating comment: " + e.getMessage();
        }
    }

    @Override
    public String updateComment(String commentComment, int rating, int commentId) {
        try (Connection conn = getConnection()) {
            // Kiểm tra rating hợp lệ (1-5)
            if (rating < 1 || rating > 5) {
                return "Rating must be between 1 and 5";
            }

            // Kiểm tra comment không rỗng
            if (commentComment == null || commentComment.trim().isEmpty()) {
                return "Comment comment cannot be empty";
            }

            // Kiểm tra comment có tồn tại không
            String checkSql = "SELECT id FROM comments WHERE id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, commentId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        return "Comment with ID " + commentId + " not found";
                    }
                }
            }

            String sql = "UPDATE comments SET comment = ?, rating = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, commentComment.trim());
                stmt.setInt(2, rating);
                stmt.setInt(3, commentId);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    return "Comment updated successfully";
                } else {
                    return "Failed to update comment";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error occurred while updating comment: " + e.getMessage();
        }
    }

    @Override
    public String deleteComment(int id) {
        try (Connection conn = getConnection()) {
            // Kiểm tra comment có tồn tại không
            String checkSql = "SELECT comment FROM comments WHERE id = ?";
            String commentContent = null;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, id);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        commentContent = rs.getString("comment");
                    } else {
                        return "Comment with ID " + id + " not found";
                    }
                }
            }

            String sql = "DELETE FROM comments WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);

                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    return "Comment deleted successfully";
                } else {
                    return "Failed to delete comment";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error occurred while deleting comment: " + e.getMessage();
        }
    }

    // Bonus method: Lấy rating trung bình của location
    public double getAverageRatingByLocation(int locationId) {
        try (Connection conn = getConnection()) {
            String sql = "SELECT AVG(rating) as avg_rating FROM comments WHERE location_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, locationId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getDouble("avg_rating");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
