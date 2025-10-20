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

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<style>
.main-content {
	width: 100wh - 220px;
	height: 100vh;
    margin: 0 auto;
}


.main-content form a { 
	padding: 6px 8px;
	border-radius:6px ;
	background-color: #0d6efd;
	color: white;
	font-size:16px;
	text-decoration: none; 
	transition: background 0.2s ease-in-out;
}



.search-button { 
	padding: 6px 8px;
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

th {
	padding: 12px;
	text-align: center;
	font-weight: 600;
}

td {
	padding: 12px;
	text-align: center;
	border-top: 1px solid #e5e7eb;
}

thead {
	background: #2B90C6;
	color: #fff;
	border-radius: 12px;
}

tbody tr {
	background: #ffffff;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	transition: all 0.2s ease-in-out;
}


table th, table td {
	text-align: center;
}

table button {
	padding: 6px 8px;
	border-radius: 6px;
	background-color: white;
	font-size: 16px;
	border: none;
	cursor: pointer;
}

table a {
	padding: 6px 8px;
	border-radius: 6px;
	background-color: white;
	font-size: 16px;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	transition: background 0.2s ease-in-out;
}

table button:hover,
table a:hover {
	background: #f2f2f2;
}
 
.filters {
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
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">
	
	<section class="main-content">
		<h1 style="font-weight: 500; margin-left: 60px; margin-top: 20px">Task List</h1>
		<form action="task-list" method="get">
			<div class="filters">
				<select id="status" name="status" style="border-radius: 6px; padding: 8px 10px" onchange="this.form.submit()">
					<option value="" ${empty param.status ? 'selected' : ''}>All status</option>
					<option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
					<option value="in_progress" ${param.status == 'in_progress' ? 'selected' : ''}>In progress</option>
					<option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
					<option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
				</select>
				<div>
				
				<input type="search" name="search"
					placeholder="Enter keywords to search..."
					value="${param.search}"
					style="border-radius: 7px; padding: 8px 16px; border:1px solid #000" />
				<button type="submit" class="search-button">Search</button></div>
				 
				<a href="task-form">Add Task</a>
			</div>
		</form>

		<table>
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
				<c:forEach var="task" items="${listTask}">
					<tr>
						<td>${task.id}</td>
						<td>${task.title}</td>
						<td>${task.description}</td>
						<td>${task.managerId}</td>
						<td>${task.customerIssueId}</td>
						<td>${task.status}</td>
						<td>
						<div style="display: flex; gap: 6px;">
							<a href="task-detail?id=${task.id}" title="View Task Detail"><i class="fa-solid fa-eye" style="color:#0d6efd;"></i></a>
							<a href="task-form?id=${task.id}"  title="Update Task"><i class="fa-solid fa-pen" style="color:#2ecc71;"></i></a>
							<button><i class="fa-solid fa-trash" style="color:red;"></i></button>
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
	</main>
</body>
</html>