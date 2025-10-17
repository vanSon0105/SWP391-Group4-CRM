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
	display: flex;
	box-sizing: border-box;
	font-family: 'Segoe UI', Tahoma, sans-serif;
	margin: 0;
	padding: 0;
	background: linear-gradient(135deg, #f0fdfa, #eff6ff 45%, #fff5f5 100%);
}

.side-bar {
	width: 15%;
	height: 100vh;
	color: white;
	background-color: #4E74CA;
}

.side-bar a:hover {
	cursor: pointer;
	background: #2B90C6;
}

.side-bar a {
	width: 80%;
	border-radius: 8px;
	padding: 8px 10px;
	color: white;
	text-decoration: none;
}

.side-bar a.active {
	background: #2B90C6;
}

form {
	width: 80%;
	margin-left: 2%;
	display: flex;
	justify-content: center;
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

button {
	padding: 8px 10px;
	width: 80px;
	border-radius: 6px;
	background: #3b82f6;
	color: white;
	border: none;
	margin-left: auto;
}

form a {
	padding: 5px 10px;
	border-radius: 6px;
	background-color: #3b82f6;
	color: white;
	font-size: 16px;
	text-align: center;
	text-decoration: none;
}
</style>

<body>
	<section class="side-bar">
		<div style="border-bottom: thin solid white; padding: 8px 10px">
			<h1 style="font-weight: 500;">TechShop</h1>
		</div>

		<div
			style="width: 100%; display: flex; flex-direction: column; gap: 14px; margin-top: 20px; align-items: center">
			<a href="task-list" class="active">Task List</a> <a>Staff
				List</a> <a>Device List</a> <a>Report</a>
		</div>

	</section>
	<form action="task-form" method="post">

		<div class="container">
			<div class="head">
				<h2>${task != null ? "Update Task" : "Add Task"}</h2>
			</div>
			<div class="task-form">
				<input type="hidden" name="id" value="${task.id}" /> <label>Title:</label>
				<input type="text" name="title" value="${task.title}" /> <label>Description:</label>
				<input type="text" name="description" value="${task.description}" />
				<label>Customer Issue ID:</label> <select name="customerIssueId">
					<c:forEach var="issue" items="${customerIssues}">
						<option value="${issue.id}"
							${task != null && task.customerIssueId == issue.id ? "selected" : ""}>${issue.title}</option>
					</c:forEach>
				</select> <label>Technical Staff:</label>
				<div class="checkbox-group">
					<c:forEach var="staff" items="${technicalStaffList}">
						<p>
							<input type="checkbox" name="technicalStaffIds"
								value="${staff.id}"> ${staff.username}
						</p>
					</c:forEach>
				</div>

				<label>Deadline</label> <input type="date" name="deadline"
					value="${taskDetail[0].deadline}" />
				<div>
					<a href="task-list">Back</a>
					<button type="submit" style="margin-left: 10px">Submit</button>

				</div>
			</div>
		</div>
	</form>



</body>
</html>