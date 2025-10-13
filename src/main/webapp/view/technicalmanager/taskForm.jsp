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
</head>

<style>
body {
	font-family: Arial, sans-serif;
	background: #f5f5f5;
}

.container {
	width: 80%;
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

button {
	padding: 6px 8px;
	width: 80px;
	border-radius: 6px;
	background: #3b82f6;
	color: white;
	border: none;
	margin-left: auto;
}
</style>

<body>
	<div class="container">
		<div class="head">
			<h2>Add/Update Task</h2>
		</div>
		<div class="task-form">
			<input type="hidden" name="id" value="${task != null ? task.id : ''}"/>
			 <label>Title:</label>
			 <input type="text" name="title" value="${task != null ? task.title : ''}"/> 
			 <label>Description:</label>
			 <input type="text" name="description" value="${task != null ? task.description : ''}"/> 
			 <label>Customer Issue ID:</label>
			<select name="customerIssueId">
				<c:forEach var="issues" items="customerIssues">
					<option value="${issue.id}" ${task != null && task.customerIssueId == issue.id ? "selected" : ""}>${issue.name}</option>
				</c:forEach>
			</select>
			 <label>Technical Staff:</label>
			<div class="checkbox-group">
				<c:forEach var="staff" items="${technicalStaffList}">					
					<p>
						<input type="checkbox" name="technicalStaffIds" value="${staff.id}">
						${staff.name}
					</p>
				</c:forEach>
			</div>

			<label>Deadline</label> <input type="date" name="deadline" value="${task != null ? task.deadline : ''}"/>

			<button type="submit">${task != null ? "Submit" : "Update"}</button>
		</div>
	</div>
</body>
</html>