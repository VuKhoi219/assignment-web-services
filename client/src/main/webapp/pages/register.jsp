<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .register-container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 300px;
        }
        .register-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .form-group input[type="submit"]:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            text-align: center;
            font-size: 14px;
        }
        .login-link {
            text-align: center;
            margin-top: 10px;
        }
        .login-link a {
            color: #4CAF50;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Đăng ký</h2>
    <form action="auth?action=register" method="post">
        <div class="form-group">
            <label for="username">Tên đăng nhập:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <select class="form-control" id="role" name="role">
                <option value="consumer">Người dùng</option>
                <option value="guide">Hướng dẫn viên</option>
            </select>
        </div>

        <div class="form-group">
            <input type="submit" value="Đăng ký">
        </div>
        <%-- Hiển thị thông báo lỗi nếu có --%>
        <% if (request.getParameter("error") != null) { %>
        <p class="error">
            <%
                String error = request.getParameter("error");
                if ("username_exists".equals(error)) {
                    out.print("Tên đăng nhập đã tồn tại!");
                } else if ("email_exists".equals(error)) {
                    out.print("Email đã được sử dụng!");
                } else {
                    out.print("Đã có lỗi xảy ra, vui lòng thử lại!");
                }
            %>
        </p>
        <% } %>
        <div class="login-link">
            <p>Đã có tài khoản? <a href="auth?action=login">Đăng nhập</a></p>
        </div>
    </form>
</div>
</body>
</html>