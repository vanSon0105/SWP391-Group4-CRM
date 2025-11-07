<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Chi tiết thanh toán</title>

<style>
.container {
	width: 80%;
	margin: 0 auto;
	padding: 0 20px;
}

.head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 20px;
}

.device-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 18px;
}

.device-table th, .device-table td {
	padding: 10px;
	border: 1px solid #ddd;
	text-align: center;
	vertical-align: middle;
}

.device-table th {
	background: #f3f4f6;
}

.task-box {
	background: white;
	padding: 18px;
	margin-top: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.task-title {
	font-size: 22px;
	font-weight: 600;
	margin-bottom: 10px;
}

.task-meta {
	color: #555;
	line-height: 1.6;
}

.btn, .btn a {
	padding: 6px 12px;
	border: none;
	background: #2563eb;
	color: white;
	border-radius: 4px;
	cursor: pointer;
	text-decoration: none;
	font-size: 16px;
}

.btn-secondary {
	background: #6b7280;
}
</style>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<jsp:include page="../common/sidebar.jsp"></jsp:include>

<main class="sidebar-main">
<div class="container">
	<div class="head">
		<h2>Chi tiết thanh toán #${payment.id}</h2>
		<a href="payment-list" class="btn btn-secondary">Quay lại</a>
	</div>

	<div class="task-box">
		<div class="task-title">Thông tin khách hàng</div>
		<div class="task-meta">
			<b>Họ tên:</b> ${payment.fullName}<br>
			<b>Số điện thoại:</b> ${payment.phone}<br>
			<b>Địa chỉ:</b> ${payment.address}<br>
			<b>Thời gian giao hàng:</b> ${payment.deliveryTime}<br>
			<b>Ghi chú:</b> ${payment.technicalNote}<br>
			<b>Trạng thái:</b> ${payment.status}<br>
			<b>Ngày tạo:</b> ${payment.createdAt}<br>
			<b>Ngày thanh toán:</b> ${payment.paidAt}<br>
			
		</div>
	</div>

	<div class="task-box" style="margin-top:20px;">
		<div class="task-title">Danh sách thiết bị trong đơn hàng</div>
		<table class="device-table">
			<thead>
				<tr>
					<th>ID</th>
					<th>Tên thiết bị</th>
					<th>Số lượng</th>
					<th>Giá</th>
					<th>Serial ID</th>
					<th>Warranty Card ID</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="d" items="${details}">
					<tr>
						<td>${d.id}</td>
						<td>${d.deviceName}</td>
						<td>${d.quantity}</td>
						<td><fmt:formatNumber value="${d.price}" type="currency" currencySymbol="₫"/></td>
						<td>${d.deviceSerialId}</td>
						<td>${d.warrantyCardId}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty details}">
					<tr>
						<td colspan="6" style="text-align:center;">Không có thiết bị nào trong đơn hàng này.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</div>
</main>
</body>
</html>
