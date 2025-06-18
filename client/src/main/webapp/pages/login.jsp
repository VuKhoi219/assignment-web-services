<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập</title>
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
    .login-container {
      background-color: white;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .login-container h2 {
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
    }
    .register-link {
      text-align: center;
      margin-top: 10px;
    }
    .register-link a {
      color: #4CAF50;
      text-decoration: none;
    }
  </style>
</head>
<body>
<div class="login-container">
  <h2>Đăng nhập</h2>
  <form action="auth?action=login" method="post">
    <div class="form-group">
      <label for="username">Tên đăng nhập:</label>
      <input type="text" id="username" name="username" required>
    </div>
    <div class="form-group">
      <label for="password">Mật khẩu:</label>
      <input type="password" id="password" name="password" required>
    </div>
    <div class="form-group">
      <input type="submit" value="Đăng nhập">
    </div>
    <%-- Hiển thị thông báo lỗi nếu có --%>
    <% if (request.getParameter("error") != null) { %>
    <p class="error">Email hoặc mật khẩu không đúng!</p>
    <% } %>
    <div class="register-link">
      <p>Chưa có tài khoản? <a href="auth?action=register">Đăng ký</a></p>
    </div>
  </form>
</div>
</body>
</html>