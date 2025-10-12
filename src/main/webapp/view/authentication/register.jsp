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

	 <style>
        body { font-family: Arial, sans-serif; }
        form div { margin-bottom: 16px; }
        small.error {
            color: red;
            font-size: 12px;
            margin-top: 4px;
            display: block;
        }
        input.error, select.error {
            border-color: red;
        }
    </style>
	
</head>
<body class="shop-page register-page">
    <section class="card">
        <h1>Tạo tài khoản NovaCare</h1>
        <p>Mua sắm, theo dõi bảo hành và nhận thông báo sửa chữa một cách dễ dàng.</p>
        
        
        <form action="${pageContext.request.contextPath}/register" method="post">

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="name">Họ và tên</label>
      <input id="name" name="name" type="text" placeholder="Nhập họ và tên của bạn" required>
  		<small class="error"></small>
  </div>

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="username">Username</label>
      <input id="username" name="username" type="text" placeholder="Nhập tên người dùng của bạn" required>
         <small class="error"></small>
  </div>

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="email">Email</label>
      <input id="email" name="email" type="text" placeholder="Nhập email của bạn" required>
         <small class="error"></small>
  </div>

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="phone">Số điện thoại</label>
      <input id="phone" name="phone" type="text" placeholder="Nhập số điện thoại của bạn" required>
         <small class="error"></small>
  </div>

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="password">Mật khẩu</label>
      <input id="password" name="password" type="password" placeholder="Nhập mật khẩu của bạn" required>
         <small class="error"></small>
  </div>

  <div style="display:grid; gap:8px; text-align:left;">
      <label for="role">Mục đích sử dụng</label>
      <select id="role" name="role" required>
        <option value="">-- Chọn mục đích --</option>
          <option>Khách hàng cá nhân</option>
          <option>Doanh nghiệp</option>
          <option>Đăng ký dịch vụ sửa chữa</option>
      </select>
         <small class="error"></small>
  </div>

  <button type="submit">Đăng ký</button>
</form>
       
        
        <p class="login">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
        
        <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>
    </section>
    <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
</body>
</html>
