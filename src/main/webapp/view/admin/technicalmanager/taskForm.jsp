<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Task Form</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>

<style>
body form {
	margin: 0 auto;
	width: 90%;
}

.container {
	width: 100%;
	margin: 30px auto;
	padding: 20px 30px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.head h2 {
	margin-bottom: 20px;
}

.task-form {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.task-form label {
	font-weight: bold;
}

.task-form input[type="text"], .task-form input[type="date"], .task-form select
	{
	padding: 8px 10px;
	border: 1px solid #ccc;
	border-radius: 4px;
	outline: none;
	transition: 0.2s;
}

.task-form input:focus, .task-form select:focus {
	border-color: #2196F3;
	box-shadow: 0 0 4px rgba(33, 150, 243, 0.4);
}

.checkbox-group {
	display: grid;
	gap: 10px;
}

.staff-option {
	display: flex;
	flex-direction: column;
	padding: 10px 12px;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	background: #f8fafc;
	gap: 4px;
}

.staff-option-row {
	display: flex;
	align-items: center;
	gap: 10px;
}

.staff-info {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.staff-option.unavailable {
	opacity: 0.75;
}

.staff-option input {
	margin-right: 0;
}

.staff-name {
	font-weight: 600;
	color: #0f172a;
}

.staff-status {
	display: inline-flex;
	align-items: center;
	padding: 2px 8px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 600;
	width: fit-content;
}

.staff-status.available {
	background: #bbf7d0;
	color: #047857;
}

.staff-status.busy {
	background: #fee2e2;
	color: #b91c1c;
}

.staff-note {
	font-size: 12px;
	color: #64748b;
}

form a:hover,
form button {
	cursor:pointer;
}

form a,
form button {
	padding: 8px 10px;
	border-radius: 6px;
	background-color: #3b82f6;
	font-weight:bold;
	color: white;
	font-size: 16px;
	text-align: center;
	border:none;
	text-decoration: none;
}

.panel {
	width: 100%;
	margin: 30px auto;
	padding: 20px 30px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.notice {
	background-color: #eff6ff;
	color: #1d4ed8;
	padding: 12px 16px;
	border-radius: 6px;
	margin-bottom: 16px;
	font-size: 14px;
}

.notice strong {
	color: #1e3a8a;
}
</style>

<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">
		<form action="task-form" method="post">
			<div class="panel">
				<c:if test="${fromReviewNotice}">
					<div class="notice">
						Yêu cầu này vừa được phê duyệt để tạo task. Vui lòng kiểm tra lại thông tin trước khi giao kỹ thuật.
						<c:if test="${not empty currentIssue.feedback}">
							<br />
							<strong>Lý do quản lý ghi chú:</strong> ${currentIssue.feedback}
						</c:if>
					</div>
				</c:if>
				
				<div class="head">
					<h2>${task != null ? "Update Task" : "Add Task"}</h2>
				</div>
				<div class="task-form">
					<c:if test="${fromReviewNotice}">
						<input type="hidden" name="fromReview" value="1" />
					</c:if>
					<input type="hidden" name="id" value="${task.id}" /> 
					<label>Tiêu đề</label>
					<input type="text" name="title" value="${task.title}" maxlength="100" required /> 
					<small style="color:red">${errorTitle}</small> 
					<label>Mô tả</label>
					<input type="text" name="description" value="${task.description}" maxlength="500" />
					<small style="color: red" >${errorDescription}</small>
					<label>Vấn đề của khách hàng</label> <select name="customerIssueId">
						<c:forEach var="issue" items="${customerIssues}">
							<option value="${issue.id}"
								${selectedIssueId != null && selectedIssueId == issue.id ? "selected" : ""}>${issue.title}</option>
						</c:forEach>
					</select> <label>Nhân viên kỹ thuật:</label>
					<small style="color:red">${errorStaffLimit}</small>
					<div class="checkbox-group">
						<c:forEach var="staff" items="${technicalStaffList}">
							<c:set var="isAssigned"
								value="${assignedStaffIds != null && assignedStaffIds.contains(staff.id)}" />
							<c:set var="isAvailable" value="${staff.available}" />
							<label class="staff-option ${!isAvailable ? 'unavailable' : ''}">
								<div class="staff-option-row">
									<input type="checkbox" name="technicalStaffIds"
										value="${staff.id}"
										${isAssigned ? 'checked' : ''}
										${!isAvailable && !isAssigned ? 'disabled' : ''}>
									<div class="staff-info">
										<span class="staff-name">${staff.username}</span>
										<span class="staff-status ${isAvailable ? 'available' : 'busy'}">
											${isAvailable ? 'Rảnh' : 'Đang bận'}
										</span>
									</div>
								</div>
								<c:if test="${!isAvailable}">
									<span class="staff-note">
										${isAssigned ? '(Đang tham gia task này)' : '(Không thể giao mới)'}
									</span>
								</c:if>
							</label>
						</c:forEach>
					</div>
					<small style="color:red">${errorStaffAvailability}</small>

					<label>Hạn</label> 
					<input type="date" name="deadline"
						min="<%= java.time.LocalDate.now() %>"
						value="<fmt:formatDate value='${taskDetail[0].deadline}' pattern='yyyy-MM-dd' />"
						${task.id == null ? 'required' : ''} />
					<small style="color:red">${errorDeadline}</small>
					<div>
						<a href="task-list">Quay lại</a>
						<button type="submit" style="margin-left: 10px">Gửi</button>

					</div>
				</div>
			</div>
		</form>
	</main>
</body>
</html>