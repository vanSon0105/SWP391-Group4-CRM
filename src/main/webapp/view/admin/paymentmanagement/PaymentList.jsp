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

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<style>
/* Main content */
.main-content {
	width: calc(100vw - 220px); /* Trừ chiều rộng sidebar */
	min-height: 100vh;
	padding: 20px;
	box-sizing: border-box;
}


.table-container {
	width: 100%;
	overflow-x: auto; 
	margin-bottom: 20px;
	border-radius:16px;
}


table {
	width: 100%;
	min-width: 1000px; 
	border-collapse: collapse;
	font-family: Arial, sans-serif;
}

th, td {
	border: 1px solid #ccc;
	padding: 10px;
	text-align: left;
	white-space: nowrap; 
}

th {
	background-color: #4B9CD3;
	font-weight: bold;
	position: sticky;
	top: 0; 
	z-index: 2;
}

thead {
	background: #E6F0FA;
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
	padding: 8px 10px; 
}

button {
	padding: 6px 12px;
	background-color: #28a745;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
}

button:hover {
	background-color: #218838;
}

button{
	padding: 10px 12px !important;
}
</style>

<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">

		<section class="main-content">
			<h1 style="font-weight: 500; margin-left: 60px; margin-top: 20px">Payment
				List</h1>
			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>FullName</th>
							<th>Phone</th>
							<th>Address</th>
							<th>Method</th>
							<th>DeliveryTime</th>
							<th>Note</th>
							<th>Status</th>
							<th>CreatedAt</th>
							<th>PaidAt</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="p" items="${paymentList}">
							<tr>
								<td>${p.id}</td>
								<td>${p.fullName}</td>
								<td>${p.phone}</td>
								<td>${p.address}</td>
								<td>${p.paymentMethod}</td>
								<td>${p.deliveryTime}</td>
								<td>${p.technicalNote}</td>
								<td>${p.status}</td>
								<td>${p.createdAt}</td>
								<td>${p.paidAt}</td>
								<td>
									<button style="background-color: #1976D2">Confirm</button>
									<button style="background-color: #E70043">Deny</button>
								</td>
							</tr>
						</c:forEach>

					</tbody>
				</table>

			</div>


		</section>
	</main>
</body>
</html>