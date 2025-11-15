<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Task Form</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<style>
.management-page.device-management form {
	width: 100%;
}

.panel {
	margin: 30px auto;
	padding: 20px 30px;
	background: white;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.panel h2 {
	font-size: 22px;
	margin-bottom: 20px;
	color: #0f172a;
}

.device-form {
	display: grid;
	gap: 16px;
}

.device-form label {
	font-weight: 600;
	color: #1e293b;
}

.device-form input[type="text"], .device-form input[type="date"],
	.device-form select {
	padding: 8px 10px;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	font-size: 14px;
	width: 100%;
}

.device-form input:focus, .device-form select:focus {
	border-color: #2563eb;
	box-shadow: 0 0 4px rgba(37, 99, 235, 0.4);
	outline: none;
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

.device-form .form-actions {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.btn.device-btn {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	padding: 8px 12px;
	border: none;
	background-color: #2563eb;
	color: white;
	border-radius: 8px;
	font-weight: 600;
	text-decoration: none;
	transition: 0.2s;
}

.btn.device-btn:hover {
	background-color: #1e40af;
}

small {
	color: #dc2626;
	font-size: 13px;
}
</style>
</head>

<body class="management-page device-management">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>

	<main class="sidebar-main">
		<form action="task-form" method="post">
			<section class="panel">
				<c:if test="${fromReviewNotice}">
					<div class="notice">
						Yêu cầu này vừa được phê duyệt để tạo task. Vui lòng kiểm tra lại
						thông tin trước khi giao kỹ thuật.
						<c:if test="${not empty currentIssue.feedback}">
							<br />
							<strong>Lý do quản lý ghi chú:</strong> ${currentIssue.feedback}
                        </c:if>
					</div>
				</c:if>

				<h2>${task != null ? "Cập nhật Task" : "Thêm Task Mới"}</h2>

				<div class="device-form">
					<c:if test="${fromReviewNotice}">
						<input type="hidden" name="fromReview" value="1" />
					</c:if>
					<input type="hidden" name="id" value="${task.id}" /> <label>Tiêu
						đề</label> <input type="text" name="title" value="${task.title}"
						maxlength="100" required /> <small>${errorTitle}</small> <label>Mô
						tả</label> <input type="text" name="description"
						value="${task.description}" maxlength="500" /> <small>${errorDescription}</small>

					<label>Vấn đề của khách hàng</label> <select name="customerIssueId">
						<c:forEach var="issue" items="${customerIssues}">
							<option value="${issue.id}"
								${selectedIssueId != null && selectedIssueId == issue.id ? "selected" : ""}>
								${issue.title}</option>
						</c:forEach>
					</select> 
					<small>${errorIssue}</small>
					<%-- 
					<label>Hạn hoàn thành</label> <input type="date" name="deadline"
						min="<%= java.time.LocalDate.now() %>"
						value="<fmt:formatDate value='${taskDetail[0].deadline}' pattern='yyyy-MM-dd' />"
						${task.id == null ? 'required' : ''} /> <small>${errorDeadline}</small>
						--%>

					<div class="form-actions">
						<a href="task-list" class="btn device-btn">  Quay lại
						</a>
						<button type="submit" class="btn device-btn"> Tạo
						</button>
					</div>
				</div>
			</section>
		</form>
	</main>
</body>
</html>
