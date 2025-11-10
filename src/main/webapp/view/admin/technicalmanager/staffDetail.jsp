<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết nhân viên kỹ thuật | TechShop</title>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">

		<c:if test="${not empty error}">
			<p style="color: #ef4444">${error}</p>
		</c:if>

		<section class="panel">
			<a class="btn device-btn" href="staff-list"><i
				class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
		</section>

		<!-- Staff Info -->
		<section class="panel">
			<div class="device-detail">
				<div class="device-img">
					<c:choose>
						<c:when test="${not empty staff.imageUrl}">
							<img src="${pageContext.request.contextPath}/${staff.imageUrl}"
								alt="avatar">
						</c:when>
						<c:otherwise>
							<img
								src="${pageContext.request.contextPath}/static/images/default-avatar.png"
								alt="avatar">
						</c:otherwise>
					</c:choose>
				</div>

				<div class="device-container">
					<table class="device-table">
						<tbody>
							<tr>
								<th>ID</th>
								<td>${staff.id}</td>
							</tr>
							<tr>
								<th>Tên đăng nhập</th>
								<td>${staff.username}</td>
							</tr>
							<tr>
								<th>Họ tên</th>
								<td>${staff.fullName}</td>
							</tr>
							<tr>
								<th>Email</th>
								<td>${staff.email}</td>
							</tr>
							<tr>
								<th>Trạng thái</th>
								<td><c:choose>
										<c:when test="${staff.available}">
											<span style="color: #10b981; font-weight: 700">Rảnh</span>
										</c:when>
										<c:otherwise>
											<span style="color: #ef4444; font-weight: 700">Đang
												bận</span>
										</c:otherwise>
									</c:choose></td>
							</tr>
							<tr>
								<th>Số task đã xử lý</th>
								<td>${taskCount}</td>
							</tr>
					</table>

					<div class="device-action">
						<a href="staff-list" class="btn device-btn">Quay lại</a> <a
							href="assign-task?staffId=${staff.id}" class="btn device-btn"
							<c:if test="${!staff.available}">style="pointer-events:none;opacity:0.5;"</c:if>>
							Giao Task </a>
					</div>
				</div>
			</div>
		</section>

		<section class="panel">
			<h3 style="margin-bottom: 10px;">Danh sách Task đang xử lý</h3>

			<c:if test="${empty taskDetails}">
				<p style="text-align: center; padding: 10px;">Nhân viên này hiện
					không có task nào.</p>
			</c:if>

			<c:if test="${not empty taskDetails}">
				<table class="device-table">
					<thead>
						<tr>
							<th>ID</th>
							<th>Tiêu đề</th>
							<th>Trạng thái</th>
							<th>Hạn xử lý</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody> 
						<c:forEach var="task" items="${taskDetails}">
							<tr>  
								<td>${task.id}</td>
								<td>${task.taskTitle}</td>
								<td><c:choose>
										<c:when test="${task.status == 'completed'}">
											<span style="color: #10b981; font-weight: 600">Hoàn
												thành</span>
										</c:when>
										<c:otherwise>
											<span style="color: #ef4444; font-weight: 600">Đang xử
												lý</span>
										</c:otherwise>
									</c:choose></td>
								<td>${task.deadline}</td>
								<td><a href="task-detail?id=${task.id}"
									class="btn device-btn">Xem</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</section>

	</main>
</body>
</html>
