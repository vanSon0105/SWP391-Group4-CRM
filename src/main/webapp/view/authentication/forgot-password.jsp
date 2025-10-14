<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - NovaCare</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="shop-page forgot-page">
      <section class="card">
        <h1>Đặt lại mật khẩu</h1>
        <p>Nhập email để nhận mã OTP đặt lại mật khẩu.</p>

		<form action="${pageContext.request.contextPath}/SendOTPController" method="post">
            <div style="display:grid; gap:8px; text-align:left;">
                <label for="email">Email đã đăng ký</label>
                <input id="email" name="email" type="email" placeholder="Nhập email đã đăng ký của bạn" required>
            </div>
            <button type="submit" class="btn-primary">Gửi mã OTP</button>
        </form>

        <a href="../authentication/login.jsp" style="margin-top:10px; display:inline-block;">Quay về đăng nhập</a>
    </section>
</body>
</html>
