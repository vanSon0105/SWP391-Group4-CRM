<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechShop</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<style>
.filters {
	max-width: 1150px;
	width: 100%;
	display: flex;
	align-items: center;
	margin: 16px auto;
	justify-content: space-between;
	margin-top: 30px;
	background: white;
	padding: 16px;
	border-radius: 12px;
	border: 0.5px solid #2B90C6;
}

.filters button, .filters a {
	padding: 8px 8px;
	background: #3b82f6;
	color: white;
	border-radius: 6px;
	font-size: 14px;
}

.filters form {
	width: 100%;
	display: flex;
	justify-content: space-around;
	align-items: center;
}

.device-btn {
	color: black !important;
}

.device-management .pagination-pills {
	display: flex;
	justify-content: center;
	gap: 10px;
}

.device-management .pagination-pills a {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	text-decoration: none;
	width: 44px;
	height: 44px;
	padding: 0;
	border-radius: 16px;
	border: 1px solid rgba(15, 23, 42, 0.15);
	background: rgba(255, 255, 255, 0.9);
	color: #1f2937;
	font-weight: 600;
	cursor: pointer;
	transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s
		ease;
}

.device-management .pagination-pills a.active {
	background: linear-gradient(135deg, rgba(14, 165, 233, 0.95),
		rgba(59, 130, 246, 0.95));
	color: #f8fafc;
	border-color: transparent;
	box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
}

.device-management .pagination-pills a:hover {
	transform: translateY(-2px);
}

body .panel h2 {
	margin-bottom: 0 !important;
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

button {
	padding: 10px 12px !important;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  gap: 8px;
}

.page-link {
  display: inline-block;
  padding: 8px 14px;
  text-decoration: none;
  border-radius: 8px;
  background: #fff;
  color: #1d4ed8;
  font-weight: 500;
  transition: all 0.2s ease;
}

/* .page-link:hover {
  background: #2563eb;
} */

.page-link.active {
  background: #1d4ed8;
  color:white;
  box-shadow: 0 0 10px rgba(37, 99, 235, 0.4);
}


th, td {
	padding: 14px 5px !important;
	font-size: 1.3rem !important;
}

button {
	width: 80px;
	font-size: 1rem !important;
}

.status {
	display: inline-block;
	padding: 5px 7px;
	border-radius: 20px;
	font-weight: 600;
	font-size: 12px;
	text-align: center;
	min-width: 100px;
}

.status.pending {
	background-color: #fef3c7;
	color: #b45309;
	border: 1px solid #facc15;
}

.status.success {
	background-color: #dcfce7;
	color: #166534;
	border: 1px solid #22c55e;
}

.status.failed {
	background-color: #fee2e2;
	color: #b91c1c;
	border: 1px solid #ef4444;
}

.status.unknown {
	background-color: #e5e7eb;
	color: #374151;
	border: 1px solid #9ca3af;
}
</style>

<body class="management-page device-management">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">

		<section class="panel" id="table-panel">
			<h2>Danh sách thanh toán</h2>
			<div class="filters">
				<form action="payment-list" method="get">
					<select id="status" name="status"
						style="border-radius: 6px; padding: 8px 10px"
						onchange="this.form.submit()">
						<option value="" ${empty param.status ? 'selected' : ''}>All
							status</option>
						<option value="pending"
							${param.status == 'pending' ? 'selected' : ''}>Pending</option>
						<option value="success"
							${param.status == 'success' ? 'selected' : ''}>Success</option>
						<option value="failed"
							${param.status == 'failed' ? 'selected' : ''}>Failed</option>
					</select> <select id="sortCreatedAt" name="sortCreatedAt"
						style="border-radius: 6px; padding: 8px 10px"
						onchange="this.form.submit()">
						<option value="" ${empty param.sortCreatedAt ? 'selected' : ''}>Sắp
							xếp theo ngày tạo</option>
						<option value="asc"
							${param.sortCreatedAt == 'asc' ? 'selected' : ''}>Tăng
							dần</option>
						<option value="desc"
							${param.sortCreatedAt == 'desc' ? 'selected' : ''}>Giảm
							dần</option>
					</select> <select id="sortPaidAt" name="sortPaidAt"
						style="border-radius: 6px; padding: 8px 10px"
						onchange="this.form.submit()">
						<option value="" ${empty param.sortPaidAt ? 'selected' : ''}>Sắp
							xếp theo ngày thanh toán</option>
						<option value="asc" ${param.sortPaidAt == 'asc' ? 'selected' : ''}>Tăng
							dần</option>
						<option value="desc"
							${param.sortPaidAt == 'desc' ? 'selected' : ''}>Giảm dần</option>
					</select>
					<div>

						<input type="search" name="search"
							placeholder="Enter keywords to search..." value="${param.search}"
							style="border-radius: 7px; padding: 8px 16px; border: 1px solid #000" />
						<button type="submit" class="search-button">Search</button>
					</div>
				</form>
			</div>
			<div class="table-wrapper">
				<table class="device-table">
					<thead>

						<tr>
							<th>ID</th>
							<th>FullName</th>
							<th>Phone</th>
							<th>Address</th>
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
								<form action="payment-list" method="post">
									<td>${p.id}</td>
									<td>${p.fullName}</td>
									<td>${p.phone}</td>
									<td>${p.address}</td>
									<td>${p.deliveryTime}</td>
									<td>${p.technicalNote}</td>
									<td><c:choose>
											<c:when test="${p.status == 'pending'}">
												<span class="status pending">Đang chờ</span>
											</c:when>
											<c:when test="${p.status == 'success'}">
												<span class="status success">Thành công</span>
											</c:when>
											<c:when test="${p.status == 'failed'}">
												<span class="status failed">Thất bại</span>
											</c:when>
											<c:otherwise>
												<span class="status unknown">Không xác định</span>
											</c:otherwise>
										</c:choose></td>
								<td>${p.createdAt}</td>
								<td>${p.paidAt}</td>
								<td><input type="hidden" name="paymentId" value="${p.id}" />

									<c:if test="${p.status == 'pending'}">
										<button style="background-color: #1976D2" name="action"
											type="submit" value="success"
											onclick="return confirm('Xác nhận thanh toán thành công cho đơn hàng này?')">
											Confirm</button>
										<button style="background-color: #E70043" name="action"
											type="submit" value="failed"
											onclick="return confirm('Bạn có chắc muốn từ chối thanh toán này không?')">
											Deny</button>
									</c:if></td>
								</form>
							</tr>
						</c:forEach>

					</tbody>
				</table>
				
				<p style="margin-top:12px; color:#6b7280; text-align: center;">Tổng số thanh toán: <strong>${totalPayments}</strong></p>

			</div>
			<div class="pagination-wrapper">
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a
						class="page-link ${param.page == null && i == 1 || param.page == i ? 'active' : ''}"
						href="payment-list?page=${i}&status=${param.status}&sortCreatedAt=${param.sortCreatedAt}&sortPaidAt=${param.sortPaidAt}&method=${param.method}&search=${param.search}">${i}</a>
				</c:forEach>
			</div>
	</main>
</body>
</html>
