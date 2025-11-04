<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <link rel="stylesheet" 
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        body { font-family: Arial, sans-serif; }
        form div { margin-bottom: 16px; }
        small.error { color: red; font-size: 12px; display: block; }
        p.message { font-weight: bold; margin-bottom: 10px; }
        p.error { color: red; }
        p.success { color: green; }
    </style>
</head>
<body class="shop-page register-page">

<section class="card">
    <h1>Tạo tài khoản NovaCare</h1>
    <p>Nhập thông tin cá nhân và xác minh email bằng mã OTP.</p>

    <!-- Hiển thị thông báo lỗi hoặc thành công -->
    <c:if test="${not empty error}">
        <p class="message error">${error}</p>
    </c:if>
    <c:if test="${not empty success}">
        <p class="message success">${success}</p>
    </c:if>

    <!-- Form chính -->
    <form action="${pageContext.request.contextPath}/send-otp" method="post">
        <input type="hidden" name="action" value="register">

        <div style="display:grid; gap:8px; text-align:left;">
            <label for="name">Họ và tên</label>
            <input id="name" name="name" type="text" 
                   value="${sessionScope.tempUser != null ? sessionScope.tempUser.name : ''}" 
                   placeholder="Nhập họ và tên" required>
        </div>

        <div style="display:grid; gap:8px; text-align:left;">
            <label for="username">Tên đăng nhập</label>
            <input id="username" name="username" type="text"
                   value="${sessionScope.tempUser != null ? sessionScope.tempUser.username : ''}" 
                   placeholder="Nhập tên người dùng" required>
        </div>

        <div style="display:grid; gap:8px; text-align:left;">
            <label for="email">Email</label>
            <input id="email" name="email" type="email"
                   value="${sessionScope.tempUser != null ? sessionScope.tempUser.email : ''}" 
                   placeholder="Nhập email để nhận mã OTP" required>
        </div>

        <div style="display:grid; gap:8px; text-align:left;">
            <label for="phone">Số điện thoại</label>
            <input id="phone" name="phone" type="text"
                   value="${sessionScope.tempUser != null ? sessionScope.tempUser.phone : ''}" 
                   placeholder="Nhập số điện thoại" required>
        </div>

        <div style="display:grid; gap:8px; text-align:left;">
            <label for="password">Mật khẩu</label>
            <input id="password" name="password" type="password" 
                   placeholder="Nhập mật khẩu" required>
        </div>

        <!-- Nếu OTP chưa gửi -->
        <c:if test="${sessionScope.otpSent != true}">
            <button type="submit">Gửi mã OTP</button>
        </c:if>

        <!-- Nếu OTP đã gửi, hiển thị ô nhập OTP -->
        <c:if test="${sessionScope.otpSent == true}">
            <div style="display:grid; gap:8px; text-align:left;">
                <label for="otp">Mã OTP</label>
                <input id="otp" name="otp" type="text"
                       placeholder="Nhập mã OTP đã được gửi qua email" required>
            </div>

            <button type="submit" formaction="${pageContext.request.contextPath}/verify-otp">
                Xác minh OTP & Đăng ký
            </button>
        </c:if>
    </form>

    <p class="login">Đã có tài khoản? <a href="login">Đăng nhập</a></p>
</section>

</body>
</html>
