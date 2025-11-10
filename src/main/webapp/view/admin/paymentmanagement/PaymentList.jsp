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
	background: white;
	border-radius: 12px;
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
    transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.device-management .pagination-pills a.active {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #f8fafc;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
}

.device-management .pagination-pills a:hover {
    transform: translateY(-2px);
}

th, td {
	padding: 14px 5px !important;
	font-size: 1.3rem !important;
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

.action-btn{
	display: flex;
    gap: 5px;
    justify-content: center;
    align-items: center;
}

.disabled{
	background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #f8fafc;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
    cursor: not-allowed;
    pointer-events: none;
    opacity: 0.5;
}

.alert-banner{
	max-width: 1150px;
	margin: 0 auto 16px;
	padding: 14px 18px;
	border-radius: 14px;
	font-weight: 600;
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;
}
.alert-banner.success{
	background: rgba(34,197,94,.12);
	color: #166534;
}
.alert-banner.error{
	background: rgba(248,113,113,.12);
	color: #991b1b;
}
.alert-banner.info{
	background: rgba(129,140,248,.15);
	color: #4338ca;
}
</style>

<body class="management-page device-management">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<main class="sidebar-main">
		<c:if test="${not empty paymentMessage}">
			<div class="alert-banner ${paymentMessageType}">
				<span>${paymentMessage}</span>
				<button type="button" class="btn device-btn" onclick="this.parentElement.style.display='none'">Close</button>
			</div>
		</c:if>
		<section class="panel">
			<div class="filters">
				<form style="width: 100%; display: flex; gap: 30px; justify-content: center;" action="payment-list" method="get">
					<select class="btn device-btn" id="status" name="status"
						onchange="this.form.submit()">
						<option value="" ${empty param.status ? 'selected' : ''}>All
							status</option>
						<option value="pending"
							${param.status == 'pending' ? 'selected' : ''}>Pending</option>
						<option value="success"
							${param.status == 'success' ? 'selected' : ''}>Success</option>
						<option value="failed"
							${param.status == 'failed' ? 'selected' : ''}>Failed</option>
					</select> 
					<select class="btn device-btn" id="sortCreatedAt" name="sortCreatedAt"
						onchange="this.form.submit()">
						<option value="" ${empty param.sortCreatedAt ? 'selected' : ''}>Sắp
							xếp theo ngày tạo</option>
						<option value="asc"
							${param.sortCreatedAt == 'asc' ? 'selected' : ''}>Tăng
							dần</option>
						<option value="desc"
							${param.sortCreatedAt == 'desc' ? 'selected' : ''}>Giảm
							dần</option>
					</select> 
					<select class="btn device-btn" id="sortPaidAt" name="sortPaidAt"
						onchange="this.form.submit()">
						<option value="" ${empty param.sortPaidAt ? 'selected' : ''}>Sắp
							xếp theo ngày thanh toán</option>
						<option value="asc" ${param.sortPaidAt == 'asc' ? 'selected' : ''}>Tăng
							dần</option>
						<option value="desc"
							${param.sortPaidAt == 'desc' ? 'selected' : ''}>Giảm dần</option>
					</select>
					<div>

						<input class="btn device-btn" type="search" name="search"
							placeholder="Enter keywords to search..." value="${param.search}"/>
						<button class="btn device-btn" type="submit">Search</button>
					</div>
				</form>
			</div>
		</section>
		<section class="panel" id="table-panel">
			<div style="display: flex;justify-content: space-between;align-items: center;margin-bottom: 20px;">
				<h2>Danh sách thanh toán</h2>			
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
								<td class="action-btn">
								<input type="hidden" name="paymentId" value="${p.id}" />
								 	<a style="display: flex;height: 52px;" href="payment-detail?id=${p.id}&orderId=${p.orderId}" class="btn device-btn">
       									Xem
   									</a>

									<c:if test="${p.status == 'pending'}">
										<button class="btn device-btn" name="action"
											type="submit" value="success"
											onclick="return confirm('Xác nhận thanh toán thành công cho đơn hàng này?')">
											Xác nhận</button>
										<button class="btn device-btn" name="action"
											type="submit" value="failed"
											onclick="return confirm('Bạn có chắc muốn từ chối thanh toán này không?')">
											Từ chối</button>
									</c:if></td>
								</form>
							</tr>
						</c:forEach>

					</tbody>
				</table>
				
				<p style="margin-top:12px; color:#6b7280; text-align: center;">Tổng số thanh toán: <strong>${totalPayments}</strong></p>
			</div>
			</section>
			<div class="pagination-pills" style="padding-bottom: 20px;">
				<c:choose>
	                <c:when test="${currentPage > 1}">
	                	<a href = "payment-list?page=${currentPage - 1}&status=${param.status}&sortCreatedAt=${param.sortCreatedAt}&sortPaidAt=${param.sortPaidAt}&method=${param.method}&search=${param.search}">&#10094;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
	            </c:choose>
				
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a class="${i == currentPage ? 'active' : ''}" href="payment-list?page=${i}&status=${param.status}&sortCreatedAt=${param.sortCreatedAt}&sortPaidAt=${param.sortPaidAt}&method=${param.method}&search=${param.search}">${i}</a>
				</c:forEach>
				
				<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href = "payment-list?page=${currentPage + 1}&status=${param.status}&sortCreatedAt=${param.sortCreatedAt}&sortPaidAt=${param.sortPaidAt}&method=${param.method}&search=${param.search}">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
			</div>
	</main>
</body>
</html>
