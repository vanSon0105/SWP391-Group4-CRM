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

.status.awaiting_admin {
	background-color: #fef3c7;
	color: #92400e;
	border: 1px solid #fbbf24;
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
			<div class="device-toolbar">
				<form class="device-search" method="get">
					<select name="status" class="btn device-btn" onchange="this.form.submit()">
						<option value="">Tất cả trạng thái</option>
						<option value="awaiting_support"
							${status == 'awaiting_support' ? 'selected' : ''}>Chờ hỗ
							trợ</option>
						<option value="awaiting_customer"
							${status == 'awaiting_customer' ? 'selected' : ''}>Chờ
							khách</option>
						<option value="awaiting_admin"
							${status == 'awaiting_admin' ? 'selected' : ''}>Chờ admin xác nhận</option>
						<option value="paid" ${status == 'paid' ? 'selected' : ''}>Đã
							thanh toán</option>
						<option value="closed" ${status == 'closed' ? 'selected' : ''}>Đã
							đóng</option>
					</select> <select class="btn device-btn" name="sortField" onchange="this.form.submit()">
						<option value="created_at"
							${sortField == 'created_at' ? 'selected' : ''}>Ngày tạo</option>
						<option value="amount" ${sortField == 'amount' ? 'selected' : ''}>Số
							tiền</option>
					</select>
						<input type="search" name="search" class="btn device-btn"
							placeholder="Tìm tên, SĐT hoặc địa chỉ" value="${search}" />

						<button type="submit" class="btn device-btn">Tìm</button>

					<input type="hidden" name="page" value="1">
				</form>
			</div>
		</section>
		<section class="panel">
			<h2>Danh sách thanh toán khiếu nại</h2>
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
													<c:when test="${p.status == 'awaiting_admin'}">Chờ admin xác nhận</c:when>
													<c:when test="${p.status == 'paid'}">Đã thanh toán</c:when>
													<c:when test="${p.status == 'closed'}">Đã đóng</c:when>
												</c:choose>
										</span></td>
										<td><fmt:formatDate value="${p.createdAt}"
												pattern="dd/MM/yyyy HH:mm" /></td>
										<td><a href="issue-payment-detail?id=${p.id}"
											class="btn device-btn">Xem</a>
											
											<c:if test="${p.status == 'waiting_confirm'}">
										<button class="btn device-btn" name="action"
											type="submit" value="success"
											onclick="return confirm('Xác nhận thanh toán thành công cho vấn đề này?')">
											Xác nhận</button>
											
										<button class="btn device-btn" name="action"
											type="submit" value="failed"
											onclick="return confirm('Bạn có chắc muốn từ chối thanh toán này không?')">
											Từ chối</button>
									</c:if>
											</td>
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
			</section>
			
			<div class="pagination-pills">
				<c:choose>
			        <c:when test="${currentPage > 1}">
			            <a href="issue-payments?page=${currentPage - 1}&status=${status}&sortField=${sortField}#table-panel">&#10094;</a>
			        </c:when>
			        <c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
			    </c:choose>
				
				<c:forEach begin="1" end="${totalPages}" var="i">
					<a
						class="${param.page == null && i == 1 || param.page == i ? 'active' : ''}"
						href="issue-payments?page=${i}&status=${status}&sortField=${sortField}">${i}</a>
				</c:forEach>
				
				<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href="issue-payments?page=${currentPage + 1}&status=${status}&sortField=${sortField}#table-panel">&#10094;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
			</div>
	</main>
</body>
</html>