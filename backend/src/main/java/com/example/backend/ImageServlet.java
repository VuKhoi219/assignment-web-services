package com.example.backend;


import com.example.backend.service.ImageServiceImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet(urlPatterns = "/api/images/serve/*")
public class ImageServlet extends HttpServlet {

    private ImageServiceImpl imageService = new ImageServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy ID từ URL path: /api/images/serve/123
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required");
                return;
            }

            // Bỏ slash đầu và parse ID
            String idStr = pathInfo.substring(1);
            int imageId = Integer.parseInt(idStr);

            // Lấy byte array của ảnh
            byte[] imageBytes = imageService.serveImage(imageId);

            if (imageBytes == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
                return;
            }

            // Set response headers
            response.setContentType(getContentType(imageId));
            response.setContentLength(imageBytes.length);
            response.setHeader("Cache-Control", "max-age=3600"); // Cache 1 giờ

            // Ghi ảnh vào response
            try (OutputStream out = response.getOutputStream()) {
                out.write(imageBytes);
                out.flush();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving image");
        }
    }

    /**
     * Xác định Content-Type dựa vào extension file
     */
    private String getContentType(int imageId) {
        try {
            // Có thể lấy filename từ database để detect chính xác
            // Tạm thời default là JPEG
            return "image/jpeg";
        } catch (Exception e) {
            return "application/octet-stream";
        }
    }
}