<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
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
    <section class="card">
        <h1>Đăng nhập NovaCare</h1>
        <p>Truy cập đơn hàng, bảo hành, lịch sửa chữa và ưu đãi dành riêng cho bạn.</p>
        <div style="display:grid; gap:10px; text-align:left;">
            <label for="email">Email</label>
            <input id="email" type="text" placeholder="email@novacare.vn">
        </div>
        <div style="display:grid; gap:10px; text-align:left;">
            <label for="password">Mật khẩu</label>
            <input id="password" type="password" placeholder="Nhập mật khẩu">
        </div>
        <div class="links">
            <a href="forgot-password.jsp">Quên mật khẩu?</a>
            <a href="register.jsp">Đăng ký tài khoản</a>
        </div>
        <button type="button">Đăng nhập</button>
        <p class="register">Chưa có tài khoản? <a href="register.jsp">Tạo tài khoản ngay</a></p>
    </section>
</body>
</html>
