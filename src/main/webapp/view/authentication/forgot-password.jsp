<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <link rel="stylesheet" 
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" 
          crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        body { font-family: Arial, sans-serif; }
        .error { color: red; font-weight: 600; margin-bottom: 10px; }
        .success { color: green; font-weight: 600; margin-bottom: 10px; }
        .card { max-width: 400px; margin: 40px auto; padding: 24px; border-radius: 12px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        input { padding: 8px; border: 1px solid #ccc; border-radius: 6px; }
        button { margin-top: 12px; width: 100%; padding: 10px; background: #007bff; color: white; border: none; border-radius: 6px; cursor: pointer; }
        button:hover { background: #0056b3; }
    </style>
</head>

<body class="shop-page forgot-page">
<section class="card">
    <h1>Đặt lại mật khẩu</h1>
    <p>Nhập email để nhận mã OTP đặt lại mật khẩu.</p>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <c:if test="${not empty mss}">
        <p class="success">${mss}</p>
    </c:if>

  
    <form action="${pageContext.request.contextPath}/send-otp" method="post">
        <input type="hidden" name="action" value="forgot">
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="email">Email đã đăng ký</label>
            <input id="email" name="email" type="email" placeholder="Nhập email đã đăng ký của bạn" required>
        </div>
        <button type="submit" class="btn btn-primary">Gửi mã OTP</button>
    </form>

    <a href="${pageContext.request.contextPath}/login" style="margin-top:10px; display:inline-block;">Quay về đăng nhập</a>
</section>
</body>
</html>
