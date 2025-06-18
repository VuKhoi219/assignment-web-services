package com.example.client;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Truyền trang nội dung cần nhúng (ví dụ: pages/home.jsp)
        request.setAttribute("content", "pages/home.jsp");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        // Chuyển hướng đến layout.jsp
        request.getRequestDispatcher("layout.jsp").forward(request, response);
    }

    public void destroy() {
    }
}