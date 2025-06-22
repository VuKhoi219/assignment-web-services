package com.example.client.controller;

import com.mycompany.client.generated.ImageService;
import com.mycompany.client.generated.ImageServiceImplService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Base64;

@WebServlet(name = "ImageController",urlPatterns = {"/image","/image/*"})
@MultipartConfig(

)
public class ImageController extends HttpServlet{
    private ImageService getImageService() {
        ImageServiceImplService service = new ImageServiceImplService();
        return service.getImageServiceImplPort();
    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            // Thiết lập encoding để xử lý tiếng Việt
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            String filename = request.getParameter("filename");
            String caption = request.getParameter("caption");
            String locationIdStr = request.getParameter("locationId");
            int locationId = Integer.parseInt(locationIdStr);
            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");

            // Xử lý file upload
            Part filePart = request.getPart("file");
            String base64Image = null;
            boolean uploadSuccess = false;
            String message = "";

            if (filePart != null && filePart.getSize() > 0) {
                // Log thông tin file
                    System.out.println("=== FILE INFO ===");
                    System.out.println("File Name: " + filePart.getSubmittedFileName());
                    System.out.println("Content Type: " + filePart.getContentType());
                    System.out.println("File Size: " + filePart.getSize() + " bytes");

                    // Kiểm tra loại file
                    String contentType = filePart.getContentType();
                    if (contentType != null &&
                            (contentType.startsWith("image/jpeg") ||
                                    contentType.startsWith("image/png") ||
                                    contentType.startsWith("image/jpg"))) {

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

                            // Tạo data URL với content type
                            String base64String = Base64.getEncoder().encodeToString(bytes);
                            base64Image = "data:" + contentType + ";base64," + base64String;

                            // Log base64 (chỉ hiển thị 100 ký tự đầu)
                            System.out.println("Base64 Image (first 100 chars): " +
                                    (base64Image.length() > 100 ? base64Image.substring(0, 100) + "..." : base64Image));
                            System.out.println("Base64 Total Length: " + base64Image.length());

                            // Lưu vào database
                            ImageService service = getImageService();
                            service.uploadImage(locationId,base64Image,filename,caption,token);
                            if (uploadSuccess) {
                                message = "Tải lên hình ảnh thành công!";
                            } else {
                                message = "Có lỗi xảy ra khi lưu vào database!";
                            }
                        }
                    } else {
                        message = "Chỉ chấp nhận file ảnh (JPG, JPEG, PNG)!";
                    }

            } else {
                message = "Vui lòng chọn file ảnh!";
            }
            response.sendRedirect("/crud/"+locationId);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());

        }
    }

    // Method để lưu ảnh vào database
    private boolean saveImageToDatabase(String locationId, String caption, String base64Image, String filename) {
        try {
            // Kết nối database và thực hiện INSERT
            // Ví dụ:
            // String sql = "INSERT INTO location_images (location_id, caption, image_data, filename, created_at) VALUES (?, ?, ?, ?, NOW())";
            // PreparedStatement pstmt = connection.prepareStatement(sql);
            // pstmt.setString(1, locationId);
            // pstmt.setString(2, caption);
            // pstmt.setString(3, base64Image);
            // pstmt.setString(4, filename);
            // int result = pstmt.executeUpdate();
            // return result > 0;

            // Tạm thời return true để test
            System.out.println("Saving to database:");
            System.out.println("Location ID: " + locationId);
            System.out.println("Caption: " + caption);
            System.out.println("Filename: " + filename);
            System.out.println("Base64 length: " + base64Image.length());

            return true; // Thay bằng logic database thực tế

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response){
        try {
            System.out.println("Deleting image:");
            String pathInfo = request.getPathInfo(); // Get part after /crud
            String[] pathParts = pathInfo.split("/");
            String id = null;
            if (pathParts.length >= 2) {
                id = pathParts[1]; // Get ID from URL
            }
            System.out.println("=== FORM DATA ===");
            System.out.println("id " + id);
            int imageId = Integer.parseInt(id);

            HttpSession session = request.getSession();
            String token = (String) session.getAttribute("token");

            ImageService service = getImageService();
            service.deleteImage(imageId,token);

        }
        catch(Exception e){
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
        }
    }
}
