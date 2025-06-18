package com.example.client.auth;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//@WebFilter(urlPatterns = "/layout.jsp")
//public class AuthFilter implements Filter {
//    private static final String SECRET_KEY = "secret-key"; // Thay bằng khóa bí mật của bạn
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//
//        // Lấy token từ header Authorization
//        String authHeader = httpRequest.getHeader("Authorization");
//        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp?error=unauthorized");
//            return;
//        }
//
//        try {
//            // Giải mã token
//            String token = authHeader.substring(7); // Bỏ "Bearer "
//            Claims claims = Jwts.parser()
//                    .setSigningKey(SECRET_KEY.getBytes())
//                    .parseClaimsJws(token)
//                    .getBody();
//
//            // Kiểm tra thời gian hết hạn
//            long currentTime = System.currentTimeMillis() / 1000;
//            if (claims.getExpiration().getTime() / 1000 < currentTime) {
//                httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp?error=token_expired");
//                return;
//            }
//
//            // Lưu thông tin người dùng vào request
//            httpRequest.setAttribute("userId", claims.get("id"));
//            httpRequest.setAttribute("username", claims.get("username"));
//            httpRequest.setAttribute("role", claims.get("role"));
//
//            // Cho phép tiếp tục
//            chain.doFilter(request, response);
//        } catch (Exception e) {
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp?error=invalid_token");
//        }
//    }
//}