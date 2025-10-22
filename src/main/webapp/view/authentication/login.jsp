<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="shop-page login-page">
<jsp:include page="../common/header.jsp"></jsp:include>
    <section class="card" style="margin: auto 0;">
        <h1>Đăng nhập TechShop</h1>
        <p>Truy cập đơn hàng, bảo hành, lịch sửa chữa và ưu đãi dành riêng cho bạn.</p>
        <c:if test="${sessionScope.mss != null}">
		    <p style="color:green;">${sessionScope.mss}</p>
		</c:if>
        
        <form action="login" method="post">
            <div style="display:grid; gap:10px; text-align:left;">
                <label for="email">Email</label>
                <input id="email" name="email" type="text" placeholder="Nhập email" required>
            </div>

            <div style="display:grid; gap:10px; text-align:left;">
                <label for="password">Mật khẩu</label>
                <input id="password" name="password" type="password" placeholder="Nhập mật khẩu" required>
            </div>

            <div class="links">
                 <a href="forgot-password">Quên mật khẩu?</a>
    			<a href="register">Đăng ký tài khoản</a>
            </div>

            <button type="submit">Đăng nhập</button>
        </form>

        <c:if test="${sessionScope.error != null}">
		    <p style="color:red;">${sessionScope.error}</p>
		</c:if>


        <p class="register">Chưa có tài khoản? <a href="register">Tạo tài khoản ngay</a></p>
    </section>
</body>
</html>
