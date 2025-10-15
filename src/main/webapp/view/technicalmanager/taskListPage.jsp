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
	color:white;
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
	color:white;
	text-decoration: none;
}

.side-bar a.active {
	background:#2B90C6;
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
	text-decoration: none; 
}

.search-button { 
	padding: 4px 6px;
	border-radius:6px ;
	background-color: #0d6efd;
	color: white;
	font-size:16px;
	border:none;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 18px;
	border-radius: 12px;
}

th, td {
	padding: 10px;
	border: 1px solid #999;
	text-align: center;
}

thead {
	background: #2B90C6;
    color: #f8fafc;
}

table th, table td {
	text-align: center;
}

.filters {
	margin-left:5%;
	width:90%;
	display:flex;
	align-items: center;
	justify-content: space-between;
	margin-top: 30px;
	background: white;
	border-radius: 12px;
	padding: 16px;
	border: 0.5px solid #2B90C6;
} 
</style>

<body>
	<section class="side-bar">
		<div style="border-bottom: thin solid white; padding: 8px 10px">
			<h1 style="font-weight: 500;">TechShop</h1>
			<p>Technical Manager</p>
		</div>

		<div
			style="width: 100%; display: flex; flex-direction: column; gap: 14px; margin-top: 20px; align-items: center">
			<a href="task-list-page" class="active">Task List</a>
			<a>Staff List</a>
			<a>Device List</a>
			<a>Report</a>
		</div>

	</section>

	<section class="main-content">
		<h1 style="font-weight: 500; margin-left: 60px; margin-top: 20px">Task List</h1>
		<form action="task-list" method="get">
			<div class="filters">
				<select id="status" name="status" style="border-radius: 6px; padding: 6px 8px">
					<option value="">All status</option>
					<option value="">Pending</option>
					<option value="">In progress</option>
					<option value="">Completed</option>
					<option value="">Cancelled</option>
				</select>
				<div>
				
				<input type="search" name="search"
					placeholder="Enter keywords to search..."
					style="border-radius: 6px; padding: 6px 8px; border:1px solid #000" />
				<button type="submit" class="search-button">Search</button></div>
				 
				<a href="task-form">Add Task</a>
			</div>
		</form>

		<table style="margin-left: 6.5%; width: 90%">
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
							<a href="task-detail?id=${task.id}" style="background:white" title="View Task Detail"><i class="fa-solid fa-eye" style="color:#0d6efd;"></i></a>
							<a href="task-form?id=${task.id}"  style="background:white" title="Update Task"><i class="fa-solid fa-pen" style="color:#2ecc71;"></i></a>
						</div>
							
						</td>
					</tr>
				</c:forEach>

			</tbody>
		</table>
		<div class="pagination"
			style="display: flex; justify-content: center; position: relative; top: 10%; gap: 4px;">
			<button style="padding: 8px 12px; border-radius: 8px; border:none">1</button>
			<button style="padding: 8px 12px; border-radius: 8px; border:none">2</button>
		</div>
	</section>
</body>
</html>