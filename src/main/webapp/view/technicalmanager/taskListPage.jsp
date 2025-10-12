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
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css">


<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
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
	background-color: white;
}

.side-bar a:hover {
	cursor: pointer;
	background: grey;
}

.side-bar a {
	width: 80%;
}


.main-content {
	width: 85%;
	height: 100vh;
}


.main-content a { 
	padding: 4px 6px;
	border-radius:6px ;
	background-color: #0d6efd;
	color: white;
	font-size:16px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 18px;
}

th, td {
	padding: 10px;
	border: 1px solid #999;
	text-align: center;
}

thead {
	background: linear-gradient(90deg, #38bdf8, #f97316);
    color: #f8fafc;
}

table th, table td {
	text-align: center;
}
</style>

<body>
	<section class="side-bar">
		<div>
			<h1 style="font-weight: 500;">TechShop</h1>
			<p>Technical Manager</p>
		</div>

		<div
			style="width: 100%; display: flex; flex-direction: column; gap: 8px; margin-top: 10px; border-top: thin solid grey; align-items: center">
			<a href="task-list-page">Task List</a> <a>Staff List</a> <a>Device List</a> <a>Report</a>
		</div>

	</section>

	<section class="main-content">
		<h1 style="font-weight: 500; margin-left: 30px">Task List</h1>
		<form action="task-list" method="get">
			<div class="filters">
				<select id="status" name="status">
					<option value="">All status</option>
					<option value="">Pending</option>
					<option value="">In progress</option>
					<option value="">Completed</option>
					<option value="">Cancelled</option>
				</select> <input type="search" name="search"
					placeholder="Enter keywords to search..." />
				<button type="submit">Search</button>
				<a href="add-task">Add Task</a>
			</div>
		</form>

		<table style="margin-left: 5%; width: 90%">
			<thead>
				<tr>
					<th>ID</th>
					<th>Title</th>
					<th>Description</th>
					<th>Manager ID</th>
					<th>Customer Issue ID</th>
					<!-- <th>Status</th> -->
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="task" items="${listTask}">
					<tr>
						<td>${task.id}</td>
						<td>${task.title}</td>
						<td>${task.description}</td>
						<td>${task.managerId}</td>
						<td>${task.customerIssueId}</td>
						<%-- <td>${task.status}</td> --%>
						<td>
						<div style="display: flex; gap: 6px;">
							<a href="task-detail?id=${task.id}">Xem</a>
							<a href="update-task?id=${task.id}">Chỉnh sửa</a>
						</div>
							
						</td>
					</tr>
				</c:forEach>

			</tbody>
		</table>
		<div class="pagination"
			style="display: flex; justify-content: center; position: relative; top: 10%">
			<button style="padding: 6px">1</button>
			<button style="padding: 6px">2</button>
		</div>
	</section>
</body>
</html>