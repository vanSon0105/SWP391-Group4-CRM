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
<style>

.status-badge {
	display: inline-block;
	white-space: nowrap;
	padding: 4px 10px;
	border-radius: 12px;
	font-weight: 600;
	font-size: 14px;
	text-align: center;
}

.status-pending {
	background: #fef3c7;
	color: #92400e;
}

.status-inprogress {
	background: #dbeafe;
	color: #1d4ed8;
}

.status-completed {
	background: #dcfce7;
	color: #166534;
}

.status-cancelled {
	background: #fee2e2;
	color: #991b1b;
}

</style>
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
						<a href="assign-task?staffId=${staff.id}" class="btn device-btn"
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
							<th>Ghi chú</th>
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
								<td>${task.note}</td>
								<td><c:choose>
											<c:when test="${task.status == 'pending'}">
												<span class="status-badge status-pending">Đang chờ xử
													lý</span>
											</c:when>
											<c:when test="${task.status == 'in_progress'}">
												<span class="status-badge status-inprogress">Đang
													thực hiện</span>
											</c:when>
											<c:when test="${task.status == 'completed'}">
												<span class="status-badge status-completed">Hoàn
													thành</span>
											</c:when>
											<c:when test="${task.status == 'cancelled'}">
												<span class="status-badge status-cancelled">Đã hủy</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge">Không xác định</span>
											</c:otherwise>
										</c:choose></td>
								<td>${task.deadline}</td>
								<td><a href="task-detail?id=${task.taskId}"
									class="btn device-btn">Xem</a>
									<form action="staff-detail" method="post"
										style="display: inline;">
										<input type="hidden" name="action" value="cancel" /> <input
											type="hidden" name="taskId" value="${task.taskId}" /> <input
											type="hidden" name="staffId" value="${staff.id}" />
										<button type="submit" class="btn device-btn"
											onclick="return confirm('Bạn có chắc muốn hủy task này không?');">
											Hủy</button>
									</form></td>
							</tr> 
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</section>

	</main>
</body>
</html>
