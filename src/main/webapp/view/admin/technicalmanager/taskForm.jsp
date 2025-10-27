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
</style>

<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">
		<form action="task-form" method="post">
			<div class="panel">
				<div class="head">
					<h2>${task != null ? "Update Task" : "Add Task"}</h2>
				</div>
				<div class="task-form">
					<input type="hidden" name="id" value="${task.id}" /> 
					<label>Title:</label>
					<input type="text" name="title" value="${task.title}" required /> 
					<small style="color:red">${errorTitle}</small> 
					<label>Description:</label>
					<input type="text" name="description" value="${task.description}" />
					<label>Customer Issue ID:</label> <select name="customerIssueId">
						<c:forEach var="issue" items="${customerIssues}">
							<option value="${issue.id}"
								${selectedIssueId != null && selectedIssueId == issue.id ? "selected" : ""}>${issue.title}</option>
						</c:forEach>
					</select> <label>Technical Staff:</label>
					<small style="color:red">${errorStaffLimit}</small>
					<div class="checkbox-group">
						<c:forEach var="staff" items="${technicalStaffList}">
							<p>
								<input type="checkbox" name="technicalStaffIds"
									value="${staff.id}"
									${assignedStaffIds != null && assignedStaffIds.contains(staff.id) ? 'checked' : ''}>
								${staff.username}
							</p>
						</c:forEach>
					</div>

					<label>Deadline</label> 
					<input type="date" name="deadline"
						min="<%= java.time.LocalDate.now() %>"
						value="<fmt:formatDate value='${taskDetail[0].deadline}' pattern='yyyy-MM-dd' />"
						${task.id == null ? 'required' : ''} />
					<small style="color:red">${errorDeadline}</small>
					<div>
						<a href="task-list">Back</a>
						<button type="submit" style="margin-left: 10px">Submit</button>

					</div>
				</div>
			</div>
		</form>
	</main>
</body>
</html>