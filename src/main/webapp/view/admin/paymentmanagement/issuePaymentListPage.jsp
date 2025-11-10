<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Danh sách thanh toán khiếu nại</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
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

.filters form {
	width: 100%;
	display: flex;
	justify-content: space-around;
	align-items: center;
	gap: 12px;
}

.filters select, .filters input[type="search"] {
	border-radius: 6px;
	padding: 8px 10px;
	border: 1px solid #d1d5db;
	font-size: 14px;
}

.filters button {
	padding: 8px 16px;
	background: #3b82f6;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	cursor: pointer;
}

.filters button:hover {
	background: #2563eb;
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
	font-size: 1.3rem!四大;
	text-align: center;
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

.status.awaiting_support {
	background-color: #e2e8f0;
	color: #1e293b;
	border: 1px solid #94a3b8;
}

.status.awaiting_customer {
	background-color: #fde68a;
	color: #b45309;
	border: 1px solid #f59e0b;
}

.status.paid {
	background-color: #dcfce7;
	color: #166534;
	border: 1px solid #22c55e;
}

.status.closed {
	background-color: #fee2e2;
	color: #b91c1c;
	border: 1px solid #ef4444;
}

.btn-view {
	display: inline-block;
	padding: 6px 12px;
	background-color: #1d4ed8;
	color: white;
	text-decoration: none;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 500;
	transition: background 0.2s ease;
}

.btn-view:hover {
	background-color: #1e40af;
}

.empty-state {
	text-align: center;
	padding: 40px 20px;
	color: #6b7280;
}

.empty-state h3 {
	margin: 0 0 8px 0;
	color: #1e293b;
}
</style>
</head>
<body class="management-page device-management">

	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>

	<main class="sidebar-main">
		<section class="panel" id="table-panel">
			<h2>Danh sách thanh toán khiếu nại</h2>

			<div class="filters">
				<form method="get">
					<select name="status" onchange="this.form.submit()">
						<option value="">Tất cả trạng thái</option>
						<option value="awaiting_support"
							${status == 'awaiting_support' ? 'selected' : ''}>Chờ hỗ
							trợ</option>
						<option value="awaiting_customer"
							${status == 'awaiting_customer' ? 'selected' : ''}>Chờ
							khách</option>
						<option value="paid" ${status == 'paid' ? 'selected' : ''}>Đã
							thanh toán</option>
						<option value="closed" ${status == 'closed' ? 'selected' : ''}>Đã
							đóng</option>
					</select> <select name="sortField" onchange="this.form.submit()">
						<option value="created_at"
							${sortField == 'created_at' ? 'selected' : ''}>Ngày tạo</option>
						<option value="amount" ${sortField == 'amount' ? 'selected' : ''}>Số
							tiền</option>
					</select>
					<div>
						<input type="search" name="search"
							placeholder="Tìm tên, SĐT hoặc địa chỉ" value="${search}" />

						<button type="submit">Tìm</button>

					</div>
					<input type="hidden" name="page" value="1">
				</form>
			</div>


			<div class="table-wrapper">
				<c:choose>
					<c:when test="${not empty payments}">
						<table class="device-table">
							<thead>
								<tr>
									<th>ID Payment</th>
									<th>Issue ID</th>
									<th>Người nhận</th>
									<th>Điện thoại</th>
									<th>Địa chỉ</th>
									<th>Số tiền</th>
									<th>Trạng thái</th>
									<th>Ngày tạo</th>
									<th>Hành động</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="p" items="${payments}">
									<tr>
										<td>${p.id}</td>
										<td>${p.issueId}</td>
										<td>${p.shippingFullName}</td>
										<td>${p.shippingPhone}</td>
										<td>${p.shippingAddress}</td>
										<td><fmt:formatNumber value="${p.amount}" type="number" />
											₫</td>
										<td><span class="status ${p.status}"> <c:choose>
													<c:when test="${p.status == 'awaiting_support'}">Chờ hỗ trợ</c:when>
													<c:when test="${p.status == 'awaiting_customer'}">Chờ khách</c:when>
													<c:when test="${p.status == 'paid'}">Đã thanh toán</c:when>
													<c:when test="${p.status == 'closed'}">Đã đóng</c:when>
												</c:choose>
										</span></td>
										<td><fmt:formatDate value="${p.createdAt}"
												pattern="dd/MM/yyyy HH:mm" /></td>
										<td><a href="issue-payment-detail?id=${p.id}"
											class="btn-view">Xem</a></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>


						<p style="margin-top: 12px; color: #6b7280; text-align: center;">
							Tổng số thanh toán: <strong>${totalCount}</strong>
						</p>
							
						</c:when>
					<c:otherwise>
						<div class="empty-state">
							<h3>Chưa có thanh toán nào</h3>
							<p>Các thanh toán sẽ hiển thị tại đây.</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="pagination-wrapper">
								<c:forEach begin="1" end="${totalPages}" var="i">
									<a
										class="page-link ${param.page == null && i == 1 || param.page == i ? 'active' : ''}"
										href="issue-payments?page=${i}&status=${status}&sortField=${sortField}">${i}</a>
								</c:forEach>
							</div>
		</section>
	</main>
</body>
</html>