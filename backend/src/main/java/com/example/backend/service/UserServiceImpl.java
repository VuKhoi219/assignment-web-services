package com.example.backend.service;

import com.example.backend.entity.User;
import com.example.backend.util.JwtUtil;
import com.example.backend.util.PasswordUtil;

import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

//@WebServlet(urlPatterns = "/users")
@WebService(endpointInterface = "com.example.backend.service.UserService")
public class UserServiceImpl implements UserService {

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
    @WebMethod
    public String register(String username, String password, String email, String role) {
        // Validate input parameters
//        if (username == null || username.trim().isEmpty()) {
//            return "Registration failed: Username is required";
//        }
//        if (password == null || password.length() < 6) {
//            return "Registration failed: Password must be at least 6 characters";
//        }
//        if (email == null || email.trim().isEmpty()) {
//            return "Registration failed: Email is required";
//        }
//        if (role == null || role.trim().isEmpty()) {
//            return "Registration failed: Role is required";
//        }

        try (Connection conn = getConnection()) {
            // Check if username already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return "Registration failed: Username or email already exists";
                }
            }

            // Hash the password before storing
            String hashedPassword = PasswordUtil.hashPassword(password);

            // Insert new user with correct parameter order
            String sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                stmt.setString(3, email);
                stmt.setString(4, role);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    return "Registered successfully!";
                } else {
                    return "Registration failed: Unable to create user";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Registration failed: Database error";
        }
    }

    @WebMethod
    public String login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            return "Login failed: Username is required";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Login failed: Password is required";
        }

        try (Connection conn = getConnection()) {
            String sql = "SELECT id, username, password, role FROM users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String storedHashedPassword = rs.getString("password");

                    if (PasswordUtil.verifyPassword(password, storedHashedPassword)) {
                        int id = rs.getInt("id");
                        String role = rs.getString("role");
                        String token = JwtUtil.generateToken(id, username, role);
                        return token;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Login failed: Invalid credentials";
    }
}