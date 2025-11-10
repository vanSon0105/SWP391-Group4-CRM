<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error.css">
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<section class="shop-page error-404-page">
    <div class="card">
        <h1>404</h1>
        <h2>Oops! Trang bạn tìm không tồn tại</h2>
        <p>Liên kết có thể đã bị xóa hoặc bạn nhập sai địa chỉ. Hãy quay lại trang chủ NovaCare Shop để tiếp tục mua sắm.</p>
        <a href="${pageContext.request.contextPath}/home">Home</a>
    </div>
</section>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
