package com.example.client.controller;

import com.mycompany.client.generated.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "Crud", urlPatterns = {"/crud", "/crud/*"})
public class CrudController extends HttpServlet {
    private LocationService getLocationsService(){
        LocationServiceImplService service = new LocationServiceImplService();
        return service.getLocationServiceImplPort();
    }

    // Sample Location class (replace with your actual model)
    public static class LocationBasic {
        private int id;
        private String title;
        private String description;
        private String status;

        public LocationBasic(int id, String title, String description, String status) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.status = status;
        }

        // Getters
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getStatus() { return status; }
    }
    public static class LocationCliet {
        private int id;
        private String title;
        private String description;
        private String mainImage;
        private Guide guide;
        private List<Image> images;
        private List<Comment> comments;

        public LocationCliet(Integer id, String title, String description, String mainImage,
                             Guide guide, List<Image> images, List<Comment> comments) {
            this.id = id != null ? id : 0; // Handle null case
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

        public Comment() {
        }

        public int getId() { return id; }
        public Guide getUser() { return user; }
        public String getComment() { return comment; }
        public int getRating() { return rating; }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String role = (String) request.getSession().getAttribute("role");
        if(role == null) {
            response.sendRedirect("/auth?action=login");
            return;
        }
        if(!role.equals("guide")) {
            response.sendRedirect("/no-access");
            return;
        }
        String pathInfo = request.getPathInfo(); // Get part after /crud
        String action = request.getParameter("action") ;
        System.out.println("action: " + action);
        // Handle URL pattern /crud/:id
        if (pathInfo != null && !pathInfo.equals("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length >= 2) {
                int id = Integer.parseInt(pathParts[1]);
                if (action == null || "detail".equals(action)) {
                    // Display detail: /crud/123 or /crud/123?action=detail
                    handleDetailView(request, response, id);
                }
                return;
            }
        }

        // Handle other actions (no ID)
        if ("create".equals(action)) {
            request.setAttribute("content", "pages/crud/create-location.jsp");
            request.getRequestDispatcher("layout.jsp").forward(request, response);
            return;
        } else {
            // Default: display list with sample data
            LocationService locationService = getLocationsService();
            LocationListWrapper wrapper = locationService.getLocations(); // Trả về LocationListWrapper
            List<LocationDTO> locations = wrapper.getLocation();
            // Convert LocationDTO objects to Place objects
            List<HomeController.Place> places = new ArrayList<>();
            if (locations != null) {
                for (LocationDTO loc : locations) {
                    HomeController.Place place = new HomeController.Place(
                            loc.getId(),
                            loc.getTitle(),
                            loc.getDescription(),
                            loc.getImageData()
                    );
                    places.add(place);
                }
            }
            System.out.println("Total places created: " + places.size());

            request.setAttribute("locations", locations);
            request.setAttribute("content", "pages/crud/list-locations.jsp");
            request.getRequestDispatcher("layout.jsp").forward(request, response);
            return;
        }
    }

    private void handleDetailView(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        try {
            // Xử lý tham số trang
            String pageStr = request.getParameter("page");
            int page = 1;
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
            System.out.println(cmt.getComment());
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
        System.out.println("page: " + locationCliet.title);
        System.out.println("des: " +locationCliet.description);
        System.out.println(locationCliet.mainImage);
        System.out.println(locationCliet.guide.getUsername());
        System.out.println(locationCliet.guide.getEmail());
        System.out.println(locationCliet.guide.getRole());
        for (Comment comment :  locationCliet.getComments()) {
            System.out.println(comment.getComment());
        }
        for(Image image : locationCliet.getImages()) {
            System.out.println(image.getImageData());
        }

        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("content", "pages/crud/location-detail-guide.jsp");
        request.getRequestDispatcher("/layout.jsp").forward(request, response);} catch (Exception e) {
            System.err.println("Error in handleDetailView: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error processing location detail", e);
        }
    }

    // Sample data (replace with actual database query)
    private List<LocationBasic> getSampleLocations() {
        List<LocationBasic> locations = new ArrayList<>();
        locations.add(new LocationBasic(1, "Dự án phát triển website", "Phát triển website bán hàng với React và Node.js", "active"));
        locations.add(new LocationBasic(2, "Nghiên cứu thị trường", "Phân tích thị trường tiềm năng cho sản phẩm mới", "active"));
        locations.add(new LocationBasic(3, "Đào tạo nhân viên", "Đào tạo kỹ năng mới cho đội ngũ nhân viên", "inactive"));
        locations.add(new LocationBasic(4, "Đào tạo nhân viên", "Đào tạo kỹ năng mới cho đội ngũ nhân viên", "inactive"));
        locations.add(new LocationBasic(5, "Đào tạo nhân viên", "Đào tạo kỹ năng mới cho đội ngũ nhân viên", "inactive"));
        locations.add(new LocationBasic(6, "Đào tạo nhân viên", "Đào tạo kỹ năng mới cho đội ngũ nhân viên", "inactive"));

        // Add more sample data as needed
        return locations;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }


}