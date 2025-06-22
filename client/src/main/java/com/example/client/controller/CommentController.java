package com.example.client.controller;

import com.mycompany.client.generated.CommentService;
import com.mycompany.client.generated.CommentServiceImplService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "Comment", urlPatterns = {"/comment", "/comment/*"})
public class CommentController extends HttpServlet {

    private CommentService createCommentService() {
        CommentServiceImplService service = new CommentServiceImplService();
        return service.getCommentServiceImplPort();
    }


    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        handleCreateComment(request, response);
    }


    public class Comment {
        private Integer id;
        private Integer locationId;
        private Integer userId;
        private String comment;
        private Integer rating;

        // Constructors
        public Comment() {}

        public Comment(Integer locationId, Integer userId, String comment, Integer rating) {
            this.locationId = locationId;
            this.userId = userId;
            this.comment = comment;
            this.rating = rating;
        }

        // Getters and Setters
        public Integer getId() { return id; }
        public void setId(Integer id) { this.id = id; }

        public Integer getLocationId() { return locationId; }
        public void setLocationId(Integer locationId) { this.locationId = locationId; }

        public Integer getUserId() { return userId; }
        public void setUserId(Integer userId) { this.userId = userId; }

        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }

        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }

    }
    private void handleCreateComment(HttpServletRequest request, HttpServletResponse response )throws IOException, ServletException{
        CommentService service = createCommentService();

        try {
            // Thiết lập encoding để xử lý tiếng Việt
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

// Lấy dữ liệu từ form comment
            String locationIdStr = request.getParameter("locationId");
            String userIdStr = request.getParameter("userId");
            String comment = request.getParameter("comment");
            String ratingStr = request.getParameter("rating");
// Lấy token từ session
            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");
// Chuyển đổi String sang int
            int locationId = Integer.parseInt(locationIdStr);
            int userId = Integer.parseInt(userIdStr);
            int rating = Integer.parseInt(ratingStr);

            String result = service.createComment(locationId,comment,userId, rating,token);

            // Redirect về trang location detail
            response.sendRedirect(request.getContextPath() + "location?id=" + locationId);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error adding comment: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding comment");
        }
    }
}
//@Override
//public void doPut(HttpServletRequest request, HttpServletResponse response)
//        throws IOException, ServletException {
//    try {
//        // Thiết lập encoding
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//
//        // Lấy comment ID từ URL hoặc parameter
//        String commentId = request.getParameter("commentId");
//        String userId = request.getParameter("userId");
//        String comment = request.getParameter("comment");
//        String rating = request.getParameter("rating");
//
//        System.out.println("=== UPDATE COMMENT DATA ===");
//        System.out.println("Comment ID: " + commentId);
//        System.out.println("Updated Comment: " + comment);
//        System.out.println("Updated Rating: " + rating);
//
//        // Validate dữ liệu
//        if (commentId == null || commentId.trim().isEmpty()) {
//            System.out.println("Error: Comment ID is required");
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Comment ID is required");
//            return;
//        }
//
//        if (userId == null || userId.trim().isEmpty()) {
//            System.out.println("Error: User ID is required");
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
//            return;
//        }
//
//        if (comment != null && !comment.trim().isEmpty()) {
//            if (comment.length() < 10) {
//                System.out.println("Error: Comment too short");
//                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Comment must be at least 10 characters");
//                return;
//            }
//
//            if (comment.length() > 500) {
//                System.out.println("Error: Comment too long");
//                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Comment must be less than 500 characters");
//                return;
//            }
//        }
//
//        if (rating != null && !rating.trim().isEmpty()) {
//            try {
//                int ratingValue = Integer.parseInt(rating);
//                if (ratingValue < 1 || ratingValue > 5) {
//                    System.out.println("Error: Invalid rating value");
//                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5");
//                    return;
//                }
//            } catch (NumberFormatException e) {
//                System.out.println("Error: Rating is not a valid number");
//                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating format");
//                return;
//            }
//        }
//
//        // Tạo đối tượng Comment để update
//        Comment updatedComment = new Comment();
//        updatedComment.setId(Integer.parseInt(commentId));
//        updatedComment.setUserId(Integer.parseInt(userId));
//        if (comment != null && !comment.trim().isEmpty()) {
//            updatedComment.setComment(comment.trim());
//        }
//        if (rating != null && !rating.trim().isEmpty()) {
//            updatedComment.setRating(Integer.parseInt(rating));
//        }
//
//        System.out.println("Comment update object created successfully");
//
//        // TODO: Update comment trong database
//        // commentService.updateComment(updatedComment);
//
//        System.out.println("=== COMMENT UPDATED SUCCESSFULLY ===");
//
//        // Trả về JSON response
//        response.setContentType("application/json");
//        response.getWriter().write("{\"status\":\"success\",\"message\":\"Comment updated successfully\"}");
//
//    } catch (Exception e) {
//        e.printStackTrace();
//        System.out.println("Error updating comment: " + e.getMessage());
//        response.setContentType("application/json");
//        response.getWriter().write("{\"status\":\"error\",\"message\":\"Error updating comment\"}");
//    }
//}
//
//@Override
//public void doDelete(HttpServletRequest request, HttpServletResponse response)
//        throws IOException, ServletException {
//    try {
//        // Thiết lập encoding
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//        String pathInfo = request.getPathInfo(); // Get part after /crud
//        String[] pathParts = pathInfo.split("/");
//        String id = null;
//        if (pathParts.length >= 2) {
//            id = pathParts[1]; // Get ID from URL
//        }
//        System.out.println("=== FORM DATA ===");
//        System.out.println("id " + id);
//        // Lấy comment ID và user ID
//        String commentId = id;
//
//        System.out.println("=== DELETE COMMENT DATA ===");
//        System.out.println("Comment ID: " + commentId);
//
//
//        // Validate dữ liệu
//        if (commentId == null || commentId.trim().isEmpty()) {
//            System.out.println("Error: Comment ID is required");
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Comment ID is required");
//            return;
//        }
//
//
//        System.out.println("=== COMMENT DELETED SUCCESSFULLY ===");
//
//    } catch (Exception e) {
//        e.printStackTrace();
//        System.out.println("Error deleting comment: " + e.getMessage());
//        response.setContentType("application/json");
//        response.getWriter().write("{\"status\":\"error\",\"message\":\"Error deleting comment\"}");
//    }
//}