<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <title>Lỗi 404 - Không tìm thấy trang</title>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<section class="shop-page error-404-page">
    <div class="card">
        <h1>404</h1>
        <h2>Oops! Trang bạn tìm không tồn tại</h2>
        <p>Liên kết có thể đã bị xóa hoặc bạn nhập sai địa chỉ. Hãy quay lại trang chủ TechShop để tiếp tục mua sắm.</p>
        <div class="error-actions">
            <a class="btn order-btn" href="javascript:history.back()">Quay lại</a>
	        <a class="btn order-btn" href="${pageContext.request.contextPath}/home">Home</a>
        </div>
    </div>
</section>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
