<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.device-btn {
	color: black !important;
}
/* 
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
	transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s
		ease;
}

.device-management .pagination-pills a.active {
	background: linear-gradient(135deg, rgba(14, 165, 233, 0.95),
		rgba(59, 130, 246, 0.95));
	color: #f8fafc;
	border-color: transparent;
	box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
}

.device-management .pagination-pills a:hover {
	transform: translateY(-2px);
} */

body .panel h2 {
	margin-bottom: 0 !important;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  gap: 8px;
}

.page-link {
  display: inline-block;
  padding: 8px 14px;
  text-decoration: none;
  border-radius: 8px;
  background: #fff;
  color: #1d4ed8;
  font-weight: 500;
  transition: all 0.2s ease;
}

/* .page-link:hover {
  background: #2563eb;
} */

.page-link.active {
  background: #1d4ed8;
  color:white;
  box-shadow: 0 0 10px rgba(37, 99, 235, 0.4);
}
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
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main class="sidebar-main">
		<section class="panel">
			<div class="device-toolbar">
				<div class="device-toolbar-actions">
					<a class="btn btn-add" href="task-form"> <i
						class="fa-solid fa-plus"></i> <span>Thêm task</span>
					</a>
				</div>


				<form class="device-search" action="task-list" method="get">
					<select id="status" name="status"
						style="border-radius: 6px; padding: 8px 10px"
						onchange="this.form.submit()">
						<option value="" ${empty param.status ? 'selected' : '' }>All
							status</option>
						<option value="pending"
							${param.status=='pending' ? 'selected' : '' }>Pending</option>
						<option value="in_progress"
							${param.status=='in_progress' ? 'selected' : '' }>In
							progress</option>
						<option value="completed"
							${param.status=='completed' ? 'selected' : '' }>
							Completed</option>
						<option value="cancelled"
							${param.status=='cancelled' ? 'selected' : '' }>
							Cancelled</option>
					</select> <label for="task-list-search" class="sr-only"></label> <input
						id="task-list-search" name="search" type="search"
						placeholder="Tìm theo tên, email, số điện thoại..."
						value="${param.search}">
					<button type="submit" class="btn device-btn">Tìm</button>
				</form>
			</div>
		</section>

		<section class="panel" id="table-panel">
			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h2>Danh sách task</h2>

				<c:if test="${not empty param.message}">
					<div class="message">${param.message}</div>
				</c:if>

				<c:if test="${not empty param.error}">
					<div class="error">${param.error}</div>
				</c:if>
			</div>
			<div class="table-wrapper">
				<c:if test="${not empty listTask}">
					<table class="device-table">
						<thead>
							<tr>
								<th>ID</th>
								<th>Title</th>
								<th>Description</th>
								<th>Manager ID</th>
								<th>Customer Issue ID</th>
								<th>Status</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listTask}" var="task">
								<tr>
									<td>${task.id}</td>
									<td>${task.title}</td>
									<td>${task.description}</td>
									<td>${task.managerId}</td>
									<td>${task.customerIssueId}</td>
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


									<td style="display:flex; gap: 5px;"><c:if test="${task.status != 'cancelled'}">

											<a href="task-detail?id=${task.id}" class="btn device-btn">
												Xem</a>

											<a class="btn device-btn" href="task-form?id=${task.id}">Sửa</a>


											<form action="task-list" method="post"
												class="btn device-remove">
												<input type="hidden" name="taskId" value="${task.id}" />
												<button
													onclick="return confirm('Bạn có chắc muốn dừng task này?');"
													type="submit"
													style="outline: none; background: none; border: none; color: #fff; padding: 0; font-weight: 600;">
													Hủy</button>
											</form>
										</c:if></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
				
				<p style="margin-top:12px; color:#6b7280; text-align: center;">Tổng số tasks: <strong>${totalTasks}</strong></p>

				<c:if test="${empty listTask}">
					<table class="device-table">
						<tbody>
							<tr>
								<td colspan="7" style="text-align: center; border: none;">
									Không tìm thấy task</td>
							</tr>
						</tbody>
					</table>
				</c:if>

			</div>
			<div class="pagination-wrapper">
			<c:forEach var="i" begin="1" end="${totalPages}">
				<a
					href="task-list?page=${i}&status=${param.status}&search=${param.search}"
					class="page-link ${param.page == null && i == 1 || param.page == i ? 'active' : ''}">
					${i} </a>
			</c:forEach>

		</div>
		</section>
		
	</main>
</body>
</html>
