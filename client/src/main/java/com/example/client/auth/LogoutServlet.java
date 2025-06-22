package com.example.client.auth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "logout", value = "/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session hiện tại
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Xóa tất cả attributes trong session
            session.removeAttribute("token");
            session.removeAttribute("role");
            session.removeAttribute("username");
            session.removeAttribute("userId");

            // Hoặc invalidate toàn bộ session
            session.invalidate();
        }

        // Redirect về trang chủ hoặc trang login
        response.sendRedirect(request.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi lại doGet để xử lý
        doGet(request, response);
    }
}