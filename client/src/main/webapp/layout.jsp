<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
  <title>Website</title>
  <meta charset="UTF-8">

</head>
<body>

<%-- Include phần header --%>
<jsp:include page="layouts/header.jsp" />

<main>
  <%-- Include nội dung chính --%>
  <jsp:include page="${content}" />
</main>

<%-- Include phần footer --%>
<jsp:include page="layouts/footer.jsp" />

</body>
</html>
