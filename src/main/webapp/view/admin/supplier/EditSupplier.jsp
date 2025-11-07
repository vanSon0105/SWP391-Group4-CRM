<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cập nhật nhà cung cấp</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
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

.supplier-form {
	display: flex;
	flex-direction: column;
	gap: 16px;
	max-width: 600px;
	background: var(--card);
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
	border-color: var(--primary);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, .2);
}

.form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 10px;
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
<jsp:include page="../common/sidebar.jsp"></jsp:include>
<jsp:include page="../common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <h3>Cập nhật nhà cung cấp</h3>

        <c:if test="${not empty requestScope.error}">
            <div class="error">${requestScope.error}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="error">${param.error}</div>
        </c:if>

        <c:if test="${not empty param.message}">
            <div class="message">${param.message}</div>
        </c:if>
        <c:if test="${not empty requestScope.message}">
            <div class="message">${requestScope.message}</div>
        </c:if>

        <form action="supplier" method="post" class="supplier-form">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${supplier.id}">
            <label>Tên:
                <input type="text" name="name" value="${supplier.name}">
            </label>
            <label>SĐT:
                <input type="text" name="phone" value="${supplier.phone}">
            </label>
            <label>Email:
                <input type="email" name="email" value="${supplier.email}">
            </label>
            <label>Địa chỉ:
                <input type="text" name="address" value="${supplier.address}">
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
