<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <title>Lỗi 500 - Sự cố máy chủ</title>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<section class="shop-page error-500-page">
    <div class="card">
        <h1>500</h1>
        <h2>Oops! Máy chủ đang gặp sự cố</h2>
        <p>Shop88 đã ghi nhận lỗi hệ thống và đang khắc phục. Hãy thử lại sau vài phút hoặc quay lại trang chủ để tiếp tục mua sắm</p>
        <div class="error-actions">
            <a class="btn order-btn" href="javascript:history.back()">Quay lại</a>
	        <a class="btn order-btn" href="${pageContext.request.contextPath}/home">Home</a>
        </div>
    </div>
</section>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
