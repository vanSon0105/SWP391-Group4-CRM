<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff List</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">
		<section class="panel">
			<form action="staff-list" method="get" style="margin-top: 10px;">
				<select class="btn device-btn" name="status"
					onchange="this.form.submit()">
					<option value="" ${empty param.status ? 'selected' : ''}>Tất
						cả</option>
					<option value="available"
						${param.status=='available' ? 'selected' : ''}>Rảnh</option>
					<option value="busy" ${param.status=='busy' ? 'selected' : ''}>Bận</option>
				</select> <input class="btn device-btn" type="search" name="search"
					placeholder="Tìm theo tên, email..." value="${param.search}" />
				<button type="submit" class="btn device-btn">Tìm</button>
			</form>
		</section>

		<section class="panel" id="table-panel">
			<h2>Danh sách nhân viên kỹ thuật</h2>
			<div class="table-wrapper">
				<c:if test="${not empty staffList}">
					<table class="device-table">
						<thead>
							<tr>
								<th>ID</th>
								<th>Username</th>
								<th>Họ tên</th>
								<th>Email</th>
								<th>Trạng thái</th>
								<th>Hành động</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${staffList}" var="staff">
								<tr>
									<td>${staff.id}</td>
									<td>${staff.username}</td>
									<td>${staff.fullName}</td>
									<td>${staff.email}</td>
									<td><c:choose>
											<c:when test="${staff.available}">
												<span style="color: #10b981; font-weight: 700">Rảnh</span>
											</c:when>
											<c:otherwise>
												<span style="color: #ef4444; font-weight: 700">Đang
													bận</span>
											</c:otherwise>
										</c:choose></td>

									<td style="display: flex; gap: 5px; justify-content: center">
										<c:choose>
											<c:when test="${staff.available}">
												<a href="staff-detail?id=${staff.id}" class="btn device-btn">Xem</a>

												<a
													href="${pageContext.request.contextPath}/assign-task?staffId=${staff.id}"
													class="btn device-btn">Giao Task</a>
											</c:when>
											<c:otherwise>
												<a href="staff-detail?id=${staff.id}" class="btn device-btn">Xem</a>
											</c:otherwise>
										 </c:choose>
									</td>

								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>

				<c:if test="${empty staffList}">
					<p style="text-align: center;">Không tìm thấy nhân viên kỹ thuật</p>
				</c:if>
			</div>
		</section>
		<div class="pagination-pills" style="padding-bottom: 20px;">

			<c:choose>
				<c:when test="${currentPage > 1}">
					<a
						href="staff-list?page=${currentPage - 1}&search=${search}&status=${status}">&#10094;</a>
				</c:when>
				<c:otherwise>
					<a class="disabled">&#10094;</a>
				</c:otherwise>
			</c:choose>
			<c:forEach var="i" begin="1" end="${totalPages}">
				<a class="${i == currentPage ? 'active' : ''}"
					href="staff-list?page=${i}&search=${search}&status=${status}">${i}</a>
			</c:forEach>
			<c:choose>
				<c:when test="${currentPage < totalPages}">
					<a
						href="staff-list?page=${currentPage + 1}&search=${search}&status=${status}">&#10095;</a>
				</c:when>
				<c:otherwise>
					<a class="disabled">&#10095;</a>
				</c:otherwise>
			</c:choose>
		</div>


	</main>
</body>
</html>
