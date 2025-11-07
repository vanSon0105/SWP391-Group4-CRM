<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP - NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
</head>
<body class="shop-page forgot-page">



    <section class="card">
        <h1>Xác nhận mã OTP</h1>
        <c:if test="${sessionScope.mss != null}">
        	<p style="color: green;">${sessionScope.mss}</p>
        </c:if>
        	
        <form action="${pageContext.request.contextPath}/verify-otp" method="post">

            <div style="display:grid; gap:8px; text-align:left;">
                <label for="otp">Mã OTP</label>
                <input id="otp" name="otp" type="text" placeholder="Nhập mã gồm 6 chữ số" required>
            </div>

            <div style="display:grid; gap:8px; text-align:left;">
                <label for="newPassword">Mật khẩu mới</label>
                <input id="newPassword" name="newPassword" type="password" placeholder="*******" required>
            </div>

            <button type="submit">Xác nhận</button>
        </form>

        <a href="login" style="margin-top:10px; display:inline-block;">Quay về đăng nhập</a>

        <p style="color:red; text-align:center;">
            ${error != null ? error : ""}
        </p>
    </section>
</body>
</html>
