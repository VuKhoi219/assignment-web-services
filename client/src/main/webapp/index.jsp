<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Gán trang nội dung cần hiển thị
    request.setAttribute("content", "pages/home.jsp");

    // Chuyển sang layout.jsp (file layout tổng)
    RequestDispatcher rd = request.getRequestDispatcher("layout.jsp");
    rd.forward(request, response);
%>
