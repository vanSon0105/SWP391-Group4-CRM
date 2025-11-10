<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác minh OTP - Đăng ký TechShop</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <style>
        body { font-family: Arial, sans-serif; }
        form div { margin-bottom: 16px; }
        p.error { color: red; font-weight: 600; }
        p.success { color: green; font-weight: 600; }
    </style>
</head>
<body class="shop-page register-page">

<section class="card">
    <h1>Xác minh Email</h1>
    <p>Vui lòng nhập mã OTP được gửi đến email của bạn.</p>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <c:if test="${not empty success}">
        <p class="success">${success}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">       
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="otp">Mã OTP</label>
            <input id="otp" name="otp" type="text" placeholder="Nhập mã OTP" required>
        </div>

        <button type="submit">Xác minh và Đăng ký</button>
    </form>
</section>

</body>
</html>
