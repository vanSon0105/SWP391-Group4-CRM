<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết Task | TechShop</title>
</head>
<style>
.device-detail {
	display: flex !important;
	width: 100%;
}

.device-detail .device-container {
	width: 100%
}
</style>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">

		<c:if test="${not empty error}">
			<p style="color: #ef4444;  font-weight: 600; text-align: center;">${error}</p>
		</c:if>
		<c:if test="${not empty message}">
			<p style="color: green; font-weight: 600; text-align: center;">${message}</p>
		</c:if>

		<section class="panel">
			<a class="btn device-btn" href="task-list"><i
				class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
		</section>

		<section class="panel">
			<div class="device-detail">

				<div class="device-img" style="display: none"></div>

				<div class="device-container">
					<table class="device-table">
						<tbody>
							<tr>
								<th>ID</th>
								<td>${task.id}</td>
							</tr>
							<tr>
								<th>Tiêu đề</th>
								<td>${task.title}</td>
							</tr>
							<tr>
								<th>Mô tả</th>
								<td>${task.description}</td>
							</tr>
							<tr>
								<th>Mã quản lý</th>
								<td>${task.managerId}</td>
							</tr>
							<tr>
								<th>Mã yêu cầu</th>
								<td>${task.customerIssueId}</td>
							</tr>
							<tr>
								<th>Trạng thái</th>
								<td><c:choose>
										<c:when test="${task.status == 'pending'}">
											<span style="color: #f59e0b; font-weight: 700;">Đang
												chờ xử lý</span>
										</c:when>
										<c:when test="${task.status == 'in_progress'}">
											<span style="color: #0ea5e9; font-weight: 700;">Đang
												xử lý</span>
										</c:when>
										<c:when test="${task.status == 'completed'}">
											<span style="color: #10b981; font-weight: 700;">Hoàn
												thành</span>
										</c:when>
										<c:when test="${task.status == 'cancelled'}">
											<span style="color: red; font-weight: 700;">Đã hủy</span>
										</c:when>
										<c:otherwise>
											<span>Không xác định</span>
										</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>

					<div class="device-action" style="margin-top: 10px;">
						<c:if
							test="${task.status != 'completed' and task.status != 'cancelled'}">
							<a href="task-form?id=${task.id}" class="btn device-btn">Chỉnh
								sửa</a>
						</c:if>
					</div>
				</div>
			</div>
		</section>

		<section class="panel">
			<h3 style="margin-bottom: 10px;">Danh sách nhân viên đã được giao</h3>

			<c:if test="${empty listTaskDetail}">
				<p style="text-align: center; padding: 10px;">Nhiệm này chưa được
					giao cho ai.</p>
			</c:if>

			<c:if test="${not empty listTaskDetail}">
				<table class="device-table">
					<thead>
						<tr>
							<th>ID</th>
							<th>Mã nhân viên</th>
							<th>Giao vào</th>
							<th>Hạn</th>
							<th>Trạng thái</th>
							<th>Ghi chú</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="td" items="${listTaskDetail}">
							<tr>
								<td>${td.id}</td>
								<td>${td.technicalStaffId}</td>
								<td>${td.assignedAt}</td>
								<td>${td.deadline}</td>
								<td><c:choose>
										<c:when test="${td.status == 'completed'}">
											<span style="color: #10b981; font-weight: 600;">Hoàn
												thành</span>
										</c:when>
										<c:when test="${td.status == 'in_progress'}">
											<span style="color: #0ea5e9; font-weight: 600;">Đang
												xử lý</span>
										</c:when>
										<c:when test="${td.status == 'pending'}">
											<span style="color: #f59e0b; font-weight: 600;">Đang
												chờ</span>
										</c:when>
										<c:when test="${td.status == 'cancelled'}">
											<span style="color: red; font-weight: 600;">Đã hủy</span>
										</c:when>
									</c:choose></td>
								<td>${td.note}</td>
								<td><c:if
										test="${td.status != 'completed' and td.status != 'cancelled'}">
										<form action="task-detail" method="post"
											style="display: inline;">
											<input type="hidden" name="action" value="cancel"> <input
												type="hidden" name="taskId" value="${task.id}"> <input
												type="hidden" name="staffId" value="${td.technicalStaffId}">
											<button type="submit" class="btn btn-danger"
												onclick="return confirm('Bạn có chắc muốn hủy giao nhiệm vụ cho nhân viên này không?');">
												Hủy giao</button>
										</form>
									</c:if> <c:if
										test="${td.status == 'cancelled' && td.cancelledByWarranty && td.warrantyCard != null && !td.warrantyCard.isCancelled}">
										<form action="task-detail" method="post">
											<input type="hidden" name="action" value="cancelWarranty" />
											<input type="hidden" name="warrantyCardId"
												value="${td.warrantyCard.id}" /> <input type="hidden"
												name="taskId" value="${task.id}" />
											<button type="submit" class="btn btn-warning"
												onclick="return confirm('Bạn có chắc muốn hủy bảo hành cho sản phẩm thuộc nhiệm vụ này không?');">
												Hủy bảo hành</button>
										</form>
									</c:if></td>


							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</section>

	</main>
</body>
</html>
