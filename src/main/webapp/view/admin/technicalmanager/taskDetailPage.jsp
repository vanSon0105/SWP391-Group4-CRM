<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechShop</title>
<%-- <link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css"> --%>


<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.container {
	width: 80%;
	margin: 0 auto;
	padding: 0px 20px;
}

.head {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.task-box {
	background: white;
	padding: 18px;
	margin-top: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.task-title {
	font-size: 22px;
	font-weight: 600;
	margin-bottom: 10px;
}

.task-meta {
	color: #555;
	line-height: 1.6;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 18px;
}

th, td {
	padding: 10px;
	border: 1px solid #ddd;
	text-align: center;
}

th {
	background: #f3f4f6;
}

.btn-gr .btn, .btn-gr a, .head a {
	padding: 6px 12px;
	border: none;
	background: #2563eb;
	color: white;
	border-radius: 4px;
	cursor: pointer;
	text-decoration: none;
	font-size: 16px;
}

.btn-secondary {
	background: #6b7280;
}
</style>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">
		<div class="container">
			<div class="head">
				<h2>Task Detail</h2>
				<a href="task-list" class="btn btn-secondary">Quay lại</a>
			</div>
			<div class="task-box">
				<div class="task-title">#${task.id} - ${task.title}</div>
				<div class="task-meta">
					<b>Mô tả:</b> ${task.description}<br> <b>Manager:</b>
					${task.managerId}<br> <b>Customer Issue:</b> Issue
					#${task.customerIssueId}<br> <b>Trạng thái chung:</b>
					<c:choose>
						<c:when test="${task.status == 'pending'}">
							<span style="color: #f59e0b;">Đang chờ xử lý</span>
						</c:when>
						<c:when test="${task.status == 'in_progress'}">
							<span style="color: #0ea5e9;">Đang xử lý</span>
						</c:when>
						<c:when test="${task.status == 'completed'}">
							<span style="color: #10b981;">Hoàn thành</span>
						</c:when>
						<c:otherwise>
							<span>Không xác định</span>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<div class="btn-gr"
				style="margin-top: 14px; display: flex; gap: 10px;">
				<a href="task-form?id=${task.id}" title="Update Task">Chỉnh sửa</a>
				<form action="task-detail" method="post" style="display: inline;"
					onsubmit="return confirm('Bạn có chắc chắn muốn đánh dấu task này là hoàn thành không?')">
					<input type="hidden" name="taskId" value="${task.id}" />
					<button type="submit" class="btn btn-secondary"
						${not empty listTaskDetail ? '' : 'disabled'}>Đánh dấu
						hoàn thành Task</button>
				</form>

			</div>
			<table>
				<thead>
					<tr>
						<th>ID</th>
						<th>Staff</th>
						<th>Assigned At</th>
						<th>Deadline</th>
						<th>Status</th>
						<!-- <th>Action</th> -->
					</tr>
				</thead>
				<c:forEach var="taskDetail" items="${listTaskDetail}">
					<tbody>
						<tr>
							<td>${taskDetail.id}</td>
							<td>${taskDetail.technicalStaffId}</td>
							<td>${taskDetail.assignedAt}</td>
							<td>${taskDetail.deadline}</td>
							<td>${taskDetail.status}</td>
							<!-- <td><button class="btn btn-secondary">Cập nhật</button></td> -->
						</tr>
					</tbody>
				</c:forEach>
			</table>
		</div>
	</main>
</body>
</html>
