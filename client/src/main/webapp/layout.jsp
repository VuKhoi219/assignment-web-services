<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
  <title>Travel Hub - Khám phá điểm đến tuyệt vời</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Global Styles -->
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      color: #333;
      background: #f8f9fa;
    }
    
    a {
      color: inherit;
      text-decoration: none;
    }
    
    img {
      max-width: 100%;
      height: auto;
    }
    
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
    }
    
    /* Common button styles */
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 24px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      font-size: 1em;
    }
    
    .btn-primary {
      background: #667eea;
      color: white;
    }
    
    .btn-primary:hover {
      background: #5a67d8;
      transform: translateY(-2px);
    }
    
    .btn-secondary {
      background: #6c757d;
      color: white;
    }
    
    .btn-secondary:hover {
      background: #5a6268;
      transform: translateY(-2px);
    }
    
    /* Alert styles */
    .alert {
      padding: 20px;
      border-radius: 10px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    
    .alert-error {
      background: #fee;
      color: #c53030;
      border-left: 4px solid #c53030;
    }
    
    .alert-success {
      background: #f0fff4;
      color: #22543d;
      border-left: 4px solid #38a169;
    }
    
    .alert-info {
      background: #e6fffa;
      color: #234e52;
      border-left: 4px solid #38b2ac;
    }
    
    /* Main content area */
    .main-content {
      min-height: calc(100vh - 140px);
      padding: 20px 0;
    }
  </style>
</head>
<body>

<%-- Include phần header --%>
<jsp:include page="layouts/header.jsp" />

<main class="main-content">
  <%-- Include nội dung chính --%>
  <jsp:include page="${content}" />
</main>

<%-- Include phần footer --%>
<jsp:include page="layouts/footer.jsp" />

</body>
</html>
