<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
  <title>Travel Hub - Khám phá điểm đến tuyệt vời</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
