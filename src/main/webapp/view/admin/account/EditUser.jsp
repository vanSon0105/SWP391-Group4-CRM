<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa người dùng | TechShop</title>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main class="sidebar-main">
		<section class="panel">
	        <a class="btn device-btn" href="account"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
	    </section>
	    
		<section class="panel">
		  <h2>Chỉnh sửa thông tin người dùng</h2>
		  <form class="device-form" action="account" method="post">
		  	<div class="form-grid">
			    <input type="hidden" name="action" value="update">
			    <input type="hidden" name="id" value="${user.id}">
				<input type="hidden" name="status" value="1">
				
				<div class="form-field">
				    <label>Tên đăng nhập:</label>
				    <input type="text" name="username" value="${user.username}" readonly style="background:#f9fafb;">
				</div>
				<div class="form-field">
				    <label>Email:</label>
				    <input type="email" name="email" value="${user.email}" required>
				</div>
				
				<div class="form-field">
				    <label>Họ tên:</label>
				    <input type="text" name="fullName" value="${user.fullName}" required>
				</div>
				<div class="form-field">
				    <label>Số điện thoại:</label>
				    <input type="text" name="phone" value="${user.phone}">
				</div>
				
				<div class="form-field">
				    <label>Vai trò:</label>
				    <select name="roleId" required>
				      <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Quản trị viên</option>
				      <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Nhân viên</option>
				      <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Kỹ thuật viên</option>
				      <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Khách hàng</option>
				    </select>
				</div>
			
			    
			    
			    <c:if test="${not empty errorMessage}">
				  <div style="color:red; text-align:center; font-weight:600;">${errorMessage}</div>
				</c:if>
			
				<div class="form-actions form-actions--spread">
				    <div>
				      <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
				      <a href="${pageContext.request.contextPath}/account" class="btn btn-secondary">Hủy</a>
				    </div>
			    </div>
		    </div>
		  </form>
		</section>
	</main>
<script>
	document.addEventListener('DOMContentLoaded', function() {
	  const form = document.querySelector('form');
	  const emailInput = document.getElementById('email');
	  const fullNameInput = document.getElementById('fullName');
	  const phoneInput = document.getElementById('phone');
	
	  const emailError = document.getElementById('emailError');
	  const fullNameError = document.getElementById('fullNameError');
	  const phoneError = document.getElementById('phoneError');
	
	  [emailInput, fullNameInput, phoneInput].forEach(input => {
	    input.addEventListener('input', () => {
	      document.getElementById(input.id + 'Error').textContent = '';
	    });
	  });
	
	  emailInput.addEventListener('blur', () => {
	    const email = emailInput.value.trim();
	    if (email === '') {
	      emailError.textContent = 'Email không được để trống';
	      return;
	    }
	
	    fetch(window.location.origin + window.location.pathname.replace(/\/[^/]*$/, '') + '/checkDuplicate?email=' + encodeURIComponent(email))
	    .then(res => res.text())
	    .then(data => {
	      if (data === 'EMAIL_EXISTS') {
	        emailError.textContent = 'Email đã tồn tại!';
	      }
	    })
	    .catch(() => {
	      emailError.textContent = 'Lỗi khi kiểm tra email';
	    });
	
	
	  form.addEventListener('submit', function(e) {
	    let valid = true;
	    if (emailInput.value.trim() === '') {
	      emailError.textContent = 'Email không được để trống';
	      valid = false;
	    }
	    if (phoneInput.value.trim() !== '' && !/^\d{10,11}$/.test(phoneInput.value.trim())) {
	      phoneError.textContent = 'Số điện thoại không hợp lệ';
	      valid = false;
	    }
	
	    if (emailError.textContent.includes('tồn tại')) {
	      valid = false;
	    }
	
	    if (!valid) e.preventDefault();
	  });
	});
</script>
</body>
</html>
