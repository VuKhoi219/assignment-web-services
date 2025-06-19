package com.example.client.auth;


import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
@WebFilter("/*") // Áp dụng cho tất cả các URL
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // Loại trừ các URL không cần kiểm tra quyền
        if (path.equals("/auth")) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra session và role
        if (session == null || session.getAttribute("role") == null) {
            httpResponse.sendRedirect("auth?active=login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = httpRequest.getParameter("action");
        // Chỉ cho phép role là "consumer" hoặc "guide"
        if (!"consumer".equals(role) && !"guide".equals(role)) {
            httpRequest.setAttribute("error", "Bạn không có quyền truy cập hệ thống!");
            httpRequest.getRequestDispatcher("pages/error.jsp").forward(httpRequest, httpResponse);
            return;
        }

        if ("consumer".equals(role)) {
            // Consumer chỉ được xem list và detail
            if (action != null && !action.equals("list") && !action.equals("detail")) {
                httpRequest.setAttribute("error", "Bạn không có quyền thực hiện hành động này!");
                httpRequest.getRequestDispatcher("pages/error.jsp").forward(httpRequest, httpResponse);
                return;
            }
        }

        // Nếu là guide thì được phép tất cả hành động -> không cần kiểm tra
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}