<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm nhà cung cấp</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<style>
:root {
	--primary: #2563eb;
	--primary-hover: #1d4ed8;
	--neutral: #6b7280;
	--bg: #f5f7fb;
	--card: #fff;
	--text: #111827;
	--danger: #ef4444;
	--warning: #f59e0b;
	--info: #0ea5e9;
	--success: #10b981;
	--radius: 10px;
	--shadow: 0 6px 18px rgba(0, 0, 0, .08);
	--border: #e5e7eb;
}

.device-btn {
	color: black !important;
}

.btn-primary {
	background: linear-gradient(135deg, #3b82f6, #2563eb);
	color: #fff;
	padding: 8px 18px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-weight: 600;
	transition: all 0.2s ease;
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 18px rgba(59, 130, 246, .3);
}

.btn-secondary {
	background: #e2e8f0;
	color: #1e293b;
	padding: 8px 18px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 600;
	transition: background 0.2s ease;
}

.btn-secondary:hover {
	background: #cbd5e1;
}

.btn-danger {
	background: #ef4444;
	color: #fff;
	padding: 8px 18px;
	border: none;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 600;
}

.btn-add {
	background: linear-gradient(135deg, #3b82f6, #2563eb);
	color: #fff;
}

.supplier-form {
	display: flex;
	flex-direction: column;
	gap: 16px;
	max-width: 600px;
	background: #fff;
	padding: 24px 28px;
	border-radius: 16px;
	box-shadow: 0 4px 16px rgba(0, 0, 0, .08);
	margin-top: 20px;
}

.supplier-form label {
	font-weight: 600;
	color: #1e293b;
	display: flex;
	flex-direction: column;
	font-size: 15px;
}

.supplier-form input {
	margin-top: 6px;
	padding: 10px 12px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	font-size: 15px;
	color: #0f172a;
	transition: all 0.2s ease;
}

.supplier-form input:focus {
	outline: none;
	border-color: #3b82f6;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, .2);
}

.supplier-form .form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 10px;
}

.table-wrapper table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

.table-wrapper th, .table-wrapper td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: left;
}

.table-wrapper th {
	background: #f3f4f6;
}

.pagination {
	display: flex;
	justify-content: center;
	padding-left: 0;
	list-style: none;
	margin-top: 20px;
	font-family: Arial, sans-serif;
}

.page-item {
	margin: 0 5px;
}

.page-link {
	display: block;
	padding: 8px 14px;
	border: 1px solid #ddd;
	color: #007bff;
	text-decoration: none;
	cursor: pointer;
	border-radius: 4px;
	transition: all 0.3s ease;
}

.page-link:hover:not(.disabled):not(.active) {
	background: #e9f5ff;
	color: #0056b3;
}

.page-item.active .page-link {
	background: #007bff;
	color: #fff;
	border-color: #007bff;
	cursor: default;
}

.page-item.disabled .page-link {
	color: #aaa;
	border-color: #ddd;
	cursor: default;
	pointer-events: none;
}

.detail-box {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	box-shadow: var(--shadow);
	padding: 24px 28px;
	margin-top: 12px;
	margin-bottom: 24px;
}

.device-filter {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	margin-top: 10px;
	align-items: center;
}

.device-filter label {
	display: flex;
	flex-direction: row;
	align-items: center;
	font-size: 14px;
	font-weight: 500;
	color: #1e293b;
	gap: 6px;
}

.device-filter input, .device-filter select {
	padding: 6px 10px;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	font-size: 14px;
	color: #0f172a;
	min-width: 160px;
	transition: all 0.2s ease;
}

.device-filter input:focus, .device-filter select:focus {
	outline: none;
	border-color: #3b82f6;
	box-shadow: 0 0 0 2px rgba(59, 130, 246, .2);
}

.device-filter button, .device-filter a {
	padding: 8px 14px;
	border-radius: 8px;
	font-weight: 600;
	text-decoration: none;
	border: none;
	cursor: pointer;
	transition: all 0.2s ease;
}

.device-filter button {
	background: linear-gradient(135deg, #3b82f6, #2563eb);
	color: #fff;
}

.device-filter button:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(59, 130, 246, .25);
}

.device-filter a {
	background: #e2e8f0;
	color: #1e293b;
	text-align: center;
}

.device-filter a:hover {
	background: #cbd5e1;
}

@media ( max-width :768px) {
	.device-filter {
		flex-direction: column;
		align-items: stretch;
	}
	.device-filter label {
		flex-direction: column;
		gap: 4px;
	}
	.device-filter input, .device-filter select, .device-filter button,
		.device-filter a {
		width: 100%;
	}
}

.error {
	color: red;
	font-weight: 600;
	margin-bottom: 12px;
}

.message {
	color: green;
	font-weight: 600;
	margin-bottom: 12px;
}
</style>
</head>
<body class="management-page device-management">
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/header.jsp"/>

<main class="sidebar-main">
		<section class="panel">
			<h3>Thêm mới nhà cung cấp</h3>

			<c:if test="${not empty requestScope.error}">
				<div class="error">${requestScope.error}</div>
			</c:if>
			<c:if test="${not empty param.error}">
				<div class="error">${param.error}</div>
			</c:if>
			<c:if test="${not empty requestScope.message}">
				<div class="message">${requestScope.message}</div>
			</c:if>
			<c:if test="${not empty param.message}">
				<div class="message">${param.message}</div>
			</c:if>

			<form action="supplier" method="post" class="supplier-form">
				<input type="hidden" name="action" value="add"> <label>Tên:
					<input type="text" name="name" value="${supplier.name}">
				</label> <label>SĐT: <input type="text" name="phone"
					value="${supplier.phone}"></label> <label>Email: <input
					type="email" name="email" value="${supplier.email}"></label> <label>Địa
					chỉ: <input type="text" name="address" value="${supplier.address}">
				</label>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">Lưu</button>
					<a href="supplier?action=list" class="btn btn-secondary">Hủy</a>
				</div>
			</form>
		</section>
	</main>
</body>
</html>
