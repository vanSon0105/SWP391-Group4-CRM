<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết người dùng | TechShop</title>
</head>
<body class="management-page device-management">
<jsp:include page="../common/sidebar.jsp"></jsp:include>
<jsp:include page="../common/header.jsp"></jsp:include>
<main class="sidebar-main">
    <c:if test="${not empty error}">
      <p style="color:#ef4444">${error}</p>
    </c:if>
	  
	<section class="panel">
        <a class="btn device-btn" href="account"><i class="fa-solid fa-arrow-left"></i><span>Về danh
                sách</span></a>
    </section>

	<section class="panel">
		<div class="device-detail">
			<div class="device-img">
                <c:choose>
		          <c:when test="${not empty userDetail.imageUrl}">
		            <img src="${pageContext.request.contextPath}/${userDetail.imageUrl}" alt="avatar">
		          </c:when>
		          <c:otherwise>
		            <img src="${pageContext.request.contextPath}/static/images/default-avatar.png" alt="avatar">
		          </c:otherwise>
		        </c:choose>
            </div>
			<div class="device-container">		
			    <table class="device-table">
			    	<tbody>
			    		<tr>
	                        <th>ID</th>
	                        <td>${userDetail.id}</td>
	                    </tr>
	                    <tr>
	                        <th>Tên đăng nhập</th>
	                        <td>${userDetail.username}</td>
	                    </tr>
	                    <tr>
	                        <th>Họ tên</th>
	                        <td>${userDetail.fullName}</td>
	                    </tr>
	                    <tr>
	                        <th>Email</th>
	                        <td>${userDetail.email}</td>
	                    </tr>
	                    <tr>
	                        <th>Số điện thoại</th>
	                        <td>${userDetail.phone}</td>
	                    </tr>
	                    <tr>
	                        <th>Vai trò</th>
	                        <td>${userDetail.role}</td>
	                    </tr>
	                    <tr>
	                        <th>Trạng thái</th>
	                        <td>
	                        	<c:choose>
					              <c:when test="${userDetail.status == 'active'}"><span style="color:#10b981;font-weight:700">Hoạt động</span></c:when>
					              <c:otherwise><span style="color:#ef4444;font-weight:700">Bị khóa</span></c:otherwise>
					            </c:choose>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>Tạo lúc</th>
	                        <td>${userDetail.createdAt}</td>
	                    </tr>
	                    <tr>
	                        <th>Lần đăng nhập cuối</th>
	                        <td>${userDetail.lastLoginAt}</td>
	                    </tr>
			    </table>
			        
			        <div class="device-action">
		                <a href="account" class="btn device-btn">Quay lại</a>
			          	<a href="account?action=edit&id=${userDetail.id}" class="btn device-btn">Sửa</a>
		            </div>
			</div>
		</div>
	</section>
</main>
</body>
</html>
