<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Cập nhật hồ sơ | TechShop</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/profile.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
body {
	background: #f5f5f5;
	font-family: Arial, sans-serif;
}

.profile-container {
	display: flex;
	max-width: 1200px;
	margin: 30px auto;
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.profile-sidebar {
	width: 280px;
	border-right: 1px solid #eee;
	padding: 24px;
	background: #fff;
}

.profile-card {
	display: flex;
	align-items: center;
	gap: 12px;
	padding-bottom: 16px;
	border-bottom: 1px solid #eee;
	margin-bottom: 20px;
}

.profile-avatar {
	width: 55px;
	height: 55px;
	border-radius: 50%;
	overflow: hidden;
	background: #e5e7eb;
	flex-shrink: 0;
}

.profile-avatar img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.profile-meta h3 {
	margin: 0;
	font-size: 16px;
	font-weight: bold;
	color: #111;
}

.profile-meta span {
	font-size: 13px;
	color: #666;
}

.profile-menu {
	font-size: 15px;
}

.menu-group {
	margin-bottom: 16px;
	transition: all 0.3s ease;
}

.menu-title {
	font-weight: 600;
	color: #333;
	display: flex;
	align-items: center;
	cursor: pointer;
	transition: color 0.2s ease;
	font-size: 15px;
}

.menu-title i {
	font-size: 18px;
	color: #2563eb;
	margin-right: 10px;
}

.menu-title:hover {
	color: #ee4d2d;
}

.submenu {
	margin-top: 8px;
	margin-left: 28px;
	max-height: 0;
	overflow: hidden;
	transition: max-height 0.3s ease;
}

.submenu a {
	display: block;
	color: #333;
	padding: 5px 0;
	text-decoration: none;
	transition: 0.2s;
}

.submenu a:hover, .submenu a.active {
	color: #ee4d2d;
}

.menu-group.active .submenu {
	max-height: 300px;
}

.menu-group.active .menu-title {
	color: #ee4d2d;
}

.profile-content {
	flex: 1;
	padding: 30px 40px;
}

.profile-section {
	background: #fff;
	border-radius: 8px;
	padding: 24px;
}

.profile-section h2 {
	font-size: 20px;
	margin-bottom: 20px;
}

.form-group {
	margin-bottom: 18px;
}

label {
	display: block;
	font-weight: 500;
	margin-bottom: 6px;
}

input[type="text"], input[type="email"]:not(.footer-input), input[type="tel"],
	input[type="date"], input[type="password"] {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 6px;
}

.gender-group {
	display: flex;
	align-items: center;
	gap: 20px;
}

.gender-group label {
	display: flex;
	align-items: center;
	gap: 6px;
}

.profile-actions {
	margin-top: 20px;
}

.btn-primary {
	background: #ee4d2d;
	color: #fff;
	padding: 10px 20px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
}

.btn-primary:hover {
	background: #d73211;
}

.btn-secondary {
	background: #f5f5f5;
	border: 1px solid #ddd;
	color: #333;
	padding: 10px 20px;
	border-radius: 6px;
	cursor: pointer;
}

.btn-secondary:hover {
	background: #eaeaea;
}

.avatar-upload {
	margin-top: 10px;
}

.profile-actions {
	margin-top: 25px;
	display: flex;
	gap: 12px;
}

.btn {
	display: inline-block;
	padding: 10px 22px;
	border-radius: 6px;
	border: none;
	font-weight: 500;
	cursor: pointer;
	text-decoration: none;
	text-align: center;
}

.btn-edit {
	background: #ee4d2d;
	color: #fff;
}

.btn-edit:hover {
	background: #d73211;
}

.btn-cancel {
	background: #f5f5f5;
	color: #333;
	border: 1px solid #ddd;
}

.btn-cancel:hover {
	background: #eaeaea;
}
</style>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="profile-container">
		<aside class="profile-sidebar">
			<div class="profile-card">
				<div class="profile-avatar">
					<c:choose>
						<c:when test="${not empty user.imageUrl}">
							<img
								src="${pageContext.request.contextPath}/assets/img/user/${user.imageUrl}"
								alt="Avatar">
						</c:when>
						<c:otherwise>
							<img
								src="${pageContext.request.contextPath}/assets/img/default-avatar.png"
								alt="Avatar">
						</c:otherwise>
					</c:choose>
				</div>
				<div class="profile-meta">
					<h3>${user.username}</h3>
					<span>${user.email}</span>
				</div>
			</div>
			<nav class="profile-menu">
				<div class="menu-group active">
					<div class="menu-title" onclick="toggleMenu(this)">
						<i class="fa fa-user-circle"></i> <span>Tài Khoản Của Tôi</span>
					</div>
					<div class="submenu">
						<a href="profile" class="${param.action == null ? 'active' : ''}">Hồ
							Sơ</a> <a href="account?action=list"
							class="${param.action == 'list' ? 'active' : ''}">Xem Tài
							Khoản</a>
					</div>
				</div>
			</nav>
		</aside>
		<section class="profile-content">
			<h2>Cập nhật thông tin cá nhân</h2>
			<c:if test="${not empty errorMessage}">
				<div
					style="padding: 10px; background-color: #fee2e2; color: #991b1b; margin-bottom: 20px; border-radius: 6px;">
					${errorMessage}</div>
			</c:if>
			<form action="profile" method="post" enctype="multipart/form-data">
				<div class="form-group">
					<label for="fullName">Họ và tên</label> <input type="text"
						id="fullName" name="fullName" value="${user.fullName}" required>
				</div>
				<div class="form-group gender-group">
					<label>Giới tính:</label> <label><input type="radio"
						name="gender" value="Male"
						<c:if test="${user.gender eq 'Male'}">checked</c:if>> Nam</label>
					<label><input type="radio" name="gender" value="Female"
						<c:if test="${user.gender eq 'Female'}">checked</c:if>> Nữ</label>
					<label><input type="radio" name="gender" value="Other"
						<c:if test="${user.gender eq 'Other'}">checked</c:if>>
						Khác</label>
				</div>
				<div class="form-group">
					<label for="birthday">Ngày sinh</label>
					<c:choose>
						<c:when test="${not empty user.birthday}">
							<fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"
								var="birthdayFormatted" />
							<input type="date" id="birthday" name="birthday"
								value="${birthdayFormatted}">
						</c:when>
						<c:otherwise>
							<input type="date" id="birthday" name="birthday">
						</c:otherwise>
					</c:choose>
				</div>
				<div class="form-group">
					<label for="email">Email</label> <input type="email" id="email"
						name="email" value="${user.email}" required>
				</div>
				<div class="form-group">
					<label for="phone">Số điện thoại</label> <input type="tel"
						id="phone" name="phone" value="${user.phone}">
				</div>
				<div class="form-group">
					<label>Ảnh đại diện</label> <input type="file" id="imageUrl"
						name="imageUrl" accept="image/*">
				</div>
				<div class="profile-actions">
					<button type="submit" class="btn-primary">Lưu thay đổi</button>
					<a href="profile" class="btn-secondary">Hủy</a>
				</div>
			</form>
		</section>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>