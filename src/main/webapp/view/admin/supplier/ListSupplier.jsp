<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý nhà cung cấp</title>
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

.device-tool-container{
	width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
}

.device-management .pagination-pills {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.device-management .pagination-pills a {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	text-decoration: none;
    width: 44px;
    height: 44px;
    padding: 0;
    border-radius: 16px;
    border: 1px solid rgba(15, 23, 42, 0.15);
    background: rgba(255, 255, 255, 0.9);
    color: #1f2937;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.device-management .pagination-pills a.active {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #f8fafc;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
}

.device-management .pagination-pills a:hover {
    transform: translateY(-2px);
}

.disabled{
	background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #f8fafc;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
    cursor: not-allowed;
    pointer-events: none;
    opacity: 0.5;
}
</style>
</head>
<body class="management-page device-management">

<jsp:include page="../common/sidebar.jsp"></jsp:include>
<jsp:include page="../common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <div class="device-toolbar">
            <div class="device-toolbar-actions">
                <a class="btn btn-add" href="supplier?action=add"><i class="fa-solid fa-plus"></i> Thêm nhà cung cấp</a>
                <a href="supplier?action=trash" class="btn device-remove">Thùng rác</a>
            </div>

			<div class="device-tool-container">
	            <form class="device-search" action="supplier" method="get" style="margin-top:10px;">
	                <input type="hidden" name="action" value="search">
	                <input name="keyword" type="search" placeholder="Tìm theo tên, email, số điện thoại..." value="${param.keyword}">
	                <button type="submit" class="btn device-btn">Tìm</button>
	            </form>
	
	            <form class="device-filter" action="supplier" method="get">
	                <input type="hidden" name="action" value="filter">
	                <label>
	                    <select name="status" class="btn device-btn">
	                        <option value="">Tất cả</option>
	                        <option value="1" ${param.status=='1'?'selected':''}>Hoạt động</option>
	                        <option value="0" ${param.status=='0'?'selected':''}>Ngừng hoạt động</option>
	                    </select>
	                </label>
	                <label>
	                    <input class="btn device-btn" type="text" name="address" placeholder="Nhập địa chỉ" value="${param.address}">
	                </label>
	                <button class="btn device-btn" type="submit">Lọc</button>
	                <a href="supplier?action=list" class="btn device-btn">Reset</a>
	            </form>
            </div>
        </div>
        <c:if test="${action=='add' || action=='edit'}">
            <h3>${action=='add'?'Thêm mới':'Cập nhật'} nhà cung cấp</h3>

            <c:if test="${not empty requestScope.error}"><div class="error">${requestScope.error}</div></c:if>
            <c:if test="${not empty param.error}"><div class="error">${param.error}</div></c:if>
            <c:if test="${not empty param.message}"><div class="message">${param.message}</div></c:if>
            <c:if test="${not empty requestScope.message}"><div class="message">${requestScope.message}</div></c:if>

            <form action="supplier" method="post" class="supplier-form">
                <input type="hidden" name="action" value="${action=='add'?'add':'update'}">
                <c:if test="${action=='edit'}"><input type="hidden" name="id" value="${supplier.id}"></c:if>
                <label>Tên: <input type="text" name="name" value="${supplier.name}"></label>
                <label>SĐT: <input type="text" name="phone" value="${supplier.phone}"></label>
                <label>Email: <input type="email" name="email" value="${supplier.email}"></label>
                <label>Địa chỉ: <input type="text" name="address" value="${supplier.address}"></label>
                <div class="form-actions">
                    <button type="submit" class="btn btn-device-btn">Lưu</button>
                    <a href="supplier?action=list" class="btn device-btn">Hủy</a>
                </div>
            </form>
        </c:if>
        <div class="table-wrapper">
            <c:if test="${action=='list' || action=='trash' || action=='filter'}">
                <table class="device-table">
                    <thead>
                        <tr>
                            <th>ID</th><th>Tên nhà cung cấp</th><th>SĐT</th><th>Email</th><th>Địa chỉ</th><th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty suppliers}">
                                <c:forEach items="${suppliers}" var="s" varStatus="status">
                                    <tr>
                                        <td>${s.id}</td>
                                        <td>${s.name}</td>
                                        <td>${s.phone}</td>
                                        <td>${s.email}</td>
                                        <td>${s.address}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${action=='trash'}">
                                                    <a href="supplier?action=restore&id=${s.id}" class="btn device-btn">Khôi phục</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="supplier?action=viewHistory&id=${s.id}" class="btn device-btn">Xem</a>
                                                    <a href="supplier?action=edit&id=${s.id}" class="btn device-btn">Sửa</a>
                                                    <a href="supplier?action=delete&id=${s.id}" class="btn device-remove" onclick="return confirm('Bạn có chắc muốn dừng nhà cung cấp này?');">Xóa</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6" style="color:gray;">Không có dữ liệu</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:if>
        </div>

        <p style="margin-top:12px; color:#6b7280; text-align:center;">
            Tổng số nhà cung cấp: <strong><c:out value="${fn:length(suppliers)}"/></strong>
        </p>
    </section>

         <div class="pagination-pills" style="padding-bottom: 20px;">
             <c:choose>
                 <c:when test="${currentPage > 1}">
                     <a href="supplier?action=${action}&page=${currentPage-1}"><span>&laquo;</span></a>
                 </c:when>
                 <c:otherwise>
		            <a class="disabled">&#10094;</a>
		        </c:otherwise>
             </c:choose>
             <c:forEach var="i" begin="1" end="${totalPages}">
                 <a class="${i == currentPage ? 'active' : ''}" href="supplier?action=${action}&page=${i}">${i}</a>
             </c:forEach>
             <c:choose>
                 <c:when test="${currentPage < totalPages}">
                     <a href="supplier?action=${action}&page=${currentPage+1}"><span>&raquo;</span></a>
                 </c:when>
                 <c:otherwise>
		            <a class="disabled">&#10095;</a>
		        </c:otherwise>
             </c:choose>
         </div>
</main>
</body>
</html>
