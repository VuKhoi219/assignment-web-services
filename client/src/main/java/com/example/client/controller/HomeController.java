package com.example.client.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Simple Home Controller
 */
@WebServlet(name = "HomeController", urlPatterns = {"", "/"})
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set content page and forward to layout
        request.setAttribute("content", "pages/home.jsp");
        request.getRequestDispatcher("layout.jsp").forward(request, response);
    }
}
