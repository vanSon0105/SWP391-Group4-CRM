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

table th,
table td {
	text-align:center;
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
			<a>Task List</a> <a>Staff List</a> <a>Device List</a> <a>Report</a>
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
			</select>
			
			<input type="search" name="search" placeholder="Enter keywords to search..."/> <button type="submit">Search</button>
			<a href="add-task">Add Task</a>
		</div>
		</form>

		<table border="1" style="margin-left:10%; width: 80%;">
			<thead>
				<tr>
					<th>ID</th>
					<th>Title</th>
					<th>Description</th>
					<th>Assigned Staff</th>
					<th>Status</th>
					<th>Deadline</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>1</td>
					<td>Sửa máy</td>
					<td>Đi sửa máy tại địa chỉ này</td>
					<td>NamNV</td>
					<td>Pending</td>
					<td>2025-10-15</td>
					<td>
						<button>Xem</button>
						<button>Chỉnh sửa</button>
					</td>
				</tr>
				<tr>
					<td>2</td>
					<td>Sửa máy</td>
					<td>Đi sửa máy tại địa chỉ này</td>
					<td>NamNV</td>
					<td>Pending</td>
					<td>2025-10-15</td>
					<td>
						<button>Xem</button>
						<button>Chỉnh sửa</button>
					</td>
				</tr>
				<tr>
					<td>3</td>
					<td>Sửa máy</td>
					<td>Đi sửa máy tại địa chỉ này</td>
					<td>NamNV</td>
					<td>Pending</td>
					<td>2025-10-15</td>
					<td>
						<button>Xem</button>
						<button>Chỉnh sửa</button>
					</td>
				</tr>
				<tr>
					<td>4</td>
					<td>Sửa máy</td>
					<td>Đi sửa máy tại địa chỉ này</td>
					<td>NamNV</td>
					<td>Pending</td>
					<td>2025-10-15</td>
					<td>
						<button>Xem</button>
						<button>Chỉnh sửa</button>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="pagination" style="display:flex; justify-content:center; position: relative; top: 10%">
			<button style="padding: 6px">1</button>
			<button style="padding: 6px">2</button>
		</div>
	</section>
</body>
</html>