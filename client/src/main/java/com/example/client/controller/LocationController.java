package com.example.client.controller;

import com.mycompany.client.generated.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@WebServlet(name = "LocationController",urlPatterns = {"/location","/location/*"})
@MultipartConfig
public class LocationController  extends HttpServlet {
    private LocationService getLocationsService(){
        LocationServiceImplService service = new LocationServiceImplService();
        return service.getLocationServiceImplPort();
    }    // Các lớp Location, Guide, Image, User, Comment giữ nguyên
    private ImageService getImageService(){
        ImageServiceImplService service = new ImageServiceImplService();
        return service.getImageServiceImplPort();
    }
    public static class LocationCliet {
        private int id;
        private String title;
        private String description;
        private String mainImage;
        private Guide guide;
        private List<Image> images;
        private List<Comment> comments;

        public LocationCliet(int id, String title, String description, String mainImage,
                             Guide guide, List<Image> images, List<Comment> comments) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.mainImage = mainImage;
            this.guide = guide;
            this.images = images;
            this.comments = comments;
        }

        // Getters
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getMainImage() { return mainImage; }
        public Guide getGuide() { return guide; }
        public List<Image> getImages() { return images; }
        public List<Comment> getComments() { return comments; }
        public int getCommentsSize() { return comments.size(); }
    }

    public static class Guide {
        private int id;
        private String username;
        private String email;
        private String role;

        public Guide(int id, String username, String email, String role) {
            this.id = id;
            this.username = username;
            this.email = email;
            this.role = role;
        }

        public int getId() { return id; }
        public String getUsername() { return username; }
        public String getEmail() { return email; }
        public String getRole() { return role; }
    }

    public static class Image {
        private int id;
        private String caption;
        private String imageData;

        public Image(int id, String caption, String imageData) {
            this.id = id;
            this.caption = caption;
            this.imageData = imageData;
        }

        public int getId() { return id; }
        public String getCaption() { return caption; }
        public String getImageData() { return imageData; }
    }


    public static class Comment {
        private int id;
        private Guide user;
        private String comment;
        private int rating;

        public Comment(int id, Guide user, String comment, int rating) {
            this.id = id;
            this.user = user;
            this.comment = comment;
            this.rating = rating;
        }

        public int getId() { return id; }
        public Guide getUser() { return user; }
        public String getComment() { return comment; }
        public int getRating() { return rating; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id = 0;
        try {
            if (idStr != null) {
                id = Integer.parseInt(idStr);
                // Có thể kiểm tra thêm nếu cần
            }
        } catch (NumberFormatException e) {
            id = 0; // hoặc bạn có thể chuyển hướng về trang lỗi
        }
        // Xử lý tham số page
        String pageStr = request.getParameter("page");
        int page = 1; // Trang mặc định
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        System.out.println("Vào đây voiews id là "+id);
        LocationService locationService = getLocationsService();
        Location location = locationService.getLocation(id);

        String mainImage = "";
        if (location.getImages() != null && !location.getImages().isEmpty()) {
            mainImage = location.getImages().get(0).getImageUrl(); // hoặc .getUrl() nếu dùng URL
        }
        Guide guide = new Guide(
                location.getGuide().getId(),
                location.getGuide().getUsername(),
                location.getGuide().getEmail(),
                location.getGuide().getRole()
        );

        List<Image> images = new ArrayList<>();
        for (com.mycompany.client.generated.Image img : location.getImages()) {
            images.add(new Image(img.getId(), img.getCaption(), img.getImageUrl())); // Sử dụng getImageUrl()
        }
        List<Comment> comments = new ArrayList<>();
        for (com.mycompany.client.generated.Comment cmt : location.getComments()) {
            com.mycompany.client.generated.User u = cmt.getUser();
            Guide commentUser = new Guide(u.getId(), u.getUsername(), u.getEmail(), u.getRole());

            comments.add(new Comment(
                    cmt.getId(),
                    commentUser,
                    cmt.getComment(),
                    cmt.getRating()
            ));
        }
        LocationCliet locationCliet = new LocationCliet(
                location.getId(),
                location.getTitle(),
                location.getDescription(),
                mainImage,
                guide,
                images,
                comments
        );

        // Tính số trang tối đa
        int commentsPerPage = 5;
        int totalPages = (int) Math.ceil((double) comments.size() / commentsPerPage);
        if (page > totalPages) {
            page = totalPages; // Giới hạn trang tối đa
        }

        // Đặt dữ liệu vào request attribute
        request.setAttribute("location", locationCliet);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        // Chuyển tiếp tới layout.jsp
        request.setAttribute("content", "pages/location-detail.jsp");
        request.getRequestDispatcher("layout.jsp").forward(request, response);

    }
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            request.setCharacterEncoding("UTF-8");
            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");
            int guiId = (int) session.getAttribute("userId");

            String title = request.getParameter("title");
            String description = request.getParameter("description");

            LocationService locationService = getLocationsService();
            Location location = locationService.createLocation(title, description, guiId, token);

            // CRITICAL: Kiểm tra location ngay sau khi tạo
            System.out.println("=== LOCATION CREATED ===");
            System.out.println("Location ID: " + location.getId());
            System.out.println("Location Title: " + location.getTitle());

            if (location.getId() <= 0) {
                System.out.println("ERROR: Invalid location ID");
                return;
            }

            // Xử lý image upload
            String filename = request.getParameter("filename");
            String caption = request.getParameter("caption");
            Part filePart = request.getPart("file");
            String base64Image = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Đọc file và chuyển thành base64
                try (InputStream inputStream = filePart.getInputStream();
                     ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {

                    int nRead;
                    byte[] data = new byte[1024];
                    while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    buffer.flush();
                    byte[] bytes = buffer.toByteArray();
                    base64Image = Base64.getEncoder().encodeToString(bytes);
                }
            } else {
                System.out.println("No file uploaded");
            }

            // CRITICAL: Log location ID trước khi upload
            System.out.println("=== BEFORE IMAGE UPLOAD ===");
            System.out.println("Using location ID: " + location.getId());

            ImageService imageService = getImageService();
            String resultImage = imageService.uploadImage(location.getId(), base64Image, filename, caption, token);

            System.out.println("=== AFTER IMAGE UPLOAD ===");
            System.out.println("Upload result: " + resultImage);

            response.sendRedirect("/crud");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void doPut(HttpServletRequest request, HttpServletResponse response){
        System.out.println("=== FORM DATA ===");
        try{
            String pathInfo = request.getPathInfo(); // Get part after /crud
            String[] pathParts = pathInfo.split("/");
            String id = null;
            if (pathParts.length >= 2) {
                 id = pathParts[1]; // Get ID from URL
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int locationId = Integer.parseInt(id);
            System.out.println("=== FORM DATA ===");
            System.out.println("id " + id);
            System.out.println("Title: " + title);
            System.out.println("Description: " + description);
            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");

            LocationService service = getLocationsService();
            service.updateLocation(title,description,locationId,token);

        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
        }
    }
    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response){
        try {
            String pathInfo = request.getPathInfo(); // Get part after /crud
            String[] pathParts = pathInfo.split("/");
            String idStr = null;
            if (pathParts.length >= 2) {
                idStr = pathParts[1]; // Get ID from URL
            }
            int id =  Integer.parseInt(idStr);

            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");
            System.out.println("=== FORM DATA Delete ===");
            System.out.println("id " + id);
            LocationService service = getLocationsService();
            service.deleteLocation(id,token);
            return;
        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
        }
    }
}