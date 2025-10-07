<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="shop-page register-page">
    <section class="card">
        <h1>Tạo tài khoản NovaCare</h1>
        <p>Mua sắm, theo dõi bảo hành và nhận thông báo sửa chữa một cách dễ dàng.</p>
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="name">Họ và tên</label>
            <input id="name" type="text" placeholder="Nguyễn Minh Anh">
        </div>
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="email">Email</label>
            <input id="email" type="text" placeholder="email@novacare.vn">
        </div>
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="phone">Số điện thoại</label>
            <input id="phone" type="text" placeholder="0901 234 567">
        </div>
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="password">Mật khẩu</label>
            <input id="password" type="password" placeholder="Tối thiểu 8 ký tự">
        </div>
        <div style="display:grid; gap:8px; text-align:left;">
            <label for="role">Mục đích sử dụng</label>
            <select id="role">
                <option>Khách hàng cá nhân</option>
                <option>Doanh nghiệp</option>
                <option>Đăng ký dịch vụ sửa chữa</option>
            </select>
        </div>
        <button type="button">Đăng ký</button>
        <p class="login">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
    </section>
</body>
</html>
