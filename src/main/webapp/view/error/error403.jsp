<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <title>Lỗi 403 - Truy cập bị từ chối</title>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<section class="shop-page error-403-page">
    <div class="card">
        <h1>403</h1>
        <h2>Bạn không có quyền truy cập</h2>
        <p>Tài khoản của bạn chưa được cấp quyền hoặc liên kết yêu cầu xác thực đặc biệt. Vui lòng đăng nhập đúng vai trò</p>
        <div class="error-actions">
            <a class="btn order-btn" href="javascript:history.back()">Quay lại</a>
            <a class="btn order-btn" href="login">Đăng nhập lại</a>
        </div>
    </div>
</section>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
