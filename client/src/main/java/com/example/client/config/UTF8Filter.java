package com.example.client.config;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

@WebFilter("/*")
public class UTF8Filter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần làm gì
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // Set UTF-8 encoding cho request và response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Tiếp tục chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần làm gì
    }
}
