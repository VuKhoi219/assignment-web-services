package com.example.client.auth;

import com.example.client.config.JwtUtil;
import com.mycompany.client.generated.UserService;
import com.mycompany.client.generated.UserServiceImplService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;


@WebServlet(name = "auth", value = "/auth")
public class RegisterAndLogin extends HttpServlet {


    private UserService getUserService() {
        UserServiceImplService service = new UserServiceImplService();
        return service.getUserServiceImplPort();
    }


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
        } else {
            // Mặc định hiển thị trang login
            request.getRequestDispatcher("pages/login.jsp").forward(request, response);
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");
        System.out.println("Action received: " + action); // Debug này
        if ("register".equals(action)) {
            // Xử lý đăng ký
            handleRegister(request, response);
        } else if ("login".equals(action)) {
            // Xử lý đăng nhập
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        System.out.println("Login request received");
        UserService service = getUserService(); // Giả lập, thay bằng service thực tế
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            String result = service.login(username, password);
            System.out.println(result);
            if (!result.equals("Login failed: Invalid credentials") &&
                    !result.equals("Login failed: Username is required") &&
                    !result.equals("Login failed: Password is required")) {
                // Giải mã token để lấy role
                Claims claims = null;
                try {
                     claims = Jwts.parserBuilder()
                            .setSigningKey(JwtUtil.getKey())
                            .build()
                            .parseClaimsJws(result)
                            .getBody();

                    System.out.println("Jwt claims: " + claims);
                } catch (Exception e) {
                    e.printStackTrace(); // In lỗi đầy đủ
                    request.setAttribute("error", "Token không hợp lệ: " + e.getMessage());
                    request.getRequestDispatcher("pages/login.jsp").forward(request, response);
                }
                String role = claims.get("role", String.class);
                String usernameFromToken = claims.get("username", String.class);
                int userId = claims.get("id", Integer.class);
                System.out.println(role);
                System.out.println(userId);

                // Lưu token và thông tin vào session
                HttpSession session = request.getSession();
                session.setAttribute("token", result);
                session.setAttribute("role", role);
                session.setAttribute("username", usernameFromToken);
                session.setAttribute("userId", userId);
                System.out.println(role);
                System.out.println(userId);
                System.out.println(usernameFromToken);
                // Gửi token vào localStorage và chuyển hướng
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                response.sendRedirect("hello-servlet"); // Không cần dấu "/" đầu nếu không dùng contextPath

            } else {
                request.setAttribute("message", result);
                request.setAttribute("messageType", "Unsuccessful");
                request.getRequestDispatcher("pages/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("pages/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        UserService service = getUserService();
        // Logic đăng ký
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role"); // Hoặc mặc định
        try {
            // Thực hiện đăng ký (save vào database)
            String result =  service.register(username, password, email, role);
            System.out.println("Vào đây ");
            if (result.equals("Registered successfully!")) {
                // Đăng ký thành công
                request.setAttribute("message", result);
                request.setAttribute("messageType", "success");
                System.out.println("Vào đây 2");

                // Chuyển đến trang login với thông báo
                request.getRequestDispatcher("pages/login.jsp").forward(request, response);
            } else {
                // Đăng ký thất bại
                System.out.println("Vào đây 3");

                request.setAttribute("error", result);
                request.getRequestDispatcher("pages/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Lỗi xảy ra
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("pages/register.jsp").forward(request, response);
        }
    }
}