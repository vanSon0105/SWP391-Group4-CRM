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

.supplier-form {
	display: flex;
	flex-direction: column;
	gap: 16px;
	width: 50%;
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
	box-shadow: 0 0 0 3px rgba(59, 130, 246, .2);
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
    	<a class="btn device-btn" href="supplier"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>

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
    </section>
	<section class="panel">
        <h2>Cập nhật nhà cung cấp</h2>
        <div style="display: flex; justify-content: center; align-items: center;">
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
	            <div class="form-actions" style="text-align: end;">
	                <button type="submit" class="btn btn-primary">Lưu</button>
	                <a href="supplier?action=list" class="btn btn-secondary">Hủy</a>
	            </div>
	        </form>
	     </div>
    </section>
</main>
</body>
</html>
