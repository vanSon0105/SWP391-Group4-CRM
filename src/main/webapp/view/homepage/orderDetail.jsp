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
<title>Chi tiết đơn hàng #${order.id} - TechShop</title>
<style>
body.home-page {
    display: flex;
    flex-direction: column;
}

.home-page main {
	min-width: 1200px;
    flex: 1;
	margin: 40px auto;
	background: #fff;
	padding: 32px !important;
	border-radius: 12px;
	box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
}
.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
}

.page-header h1 {
	margin: 0;
	color: #1f2d3d;
	font-size: 24px;
	font-weight: 600;
}


.info-box {
	display: flex;
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
    margin-bottom: 24px;
    justify-content: center;
}

.info-row {
	display: flex;
	gap: 32px;
	font-size: 15px;
}

.info-label {
	color: #64748b;
	font-weight: 600;
	min-width: 120px;
	text-transform: uppercase;
	font-size: 12px;
	letter-spacing: 0.05em;
}

.info-value {
	color: #1e293b;
	font-weight: 500;
}

.status-pill {
	display: inline-flex;
	align-items: center;
	padding: 4px 12px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: .04em;
}

.status-pending {
	background: #e2e8f0;
	color: #1e293b;
}

.status-confirmed {
	background: #dcfce7;
	color: #15803d;
}

.status-cancelled {
	background: #fee2e2;
	color: #b91c1c;
}

table {
	width: 100%;
	border-collapse: collapse;
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
	margin-bottom: 24px;
}

th, td {
	padding: 14px 16px !important;
	text-align: left;
	border-bottom: 1px solid #eef2f6;
	font-size: 16px;
}

th {
	background: #f8fafc;
	font-weight: 600;
	color: #475569;
}

tr:last-child td {
	border-bottom: none;
}

tr:hover {
	background: #f8fafc;
}

.total-box {
	background: #fff;
	border-radius: 12px;
	padding: 20px;
	box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
	text-align: right;
	font-size: 20px;
	font-weight: 700;
	color: #2563eb;
}

.price {
	font-weight: 600;
	color: #1e293b;
}

main .btn {
	border-radius: 5px !important;
}
</style>
</head>
<body class="home-page">

	<jsp:include page="../common/header.jsp"></jsp:include>

	<main>
		<div class="page-header">
			<h1>Chi tiết đơn hàng #${order.id}</h1>
			<a href="order-tracking" class="btn order-btn">Quay lại</a>
		</div>

		<div class="info-box">
			<div class="info-row">
				<div>
					<div class="info-label">Ngày đặt hàng</div>
					<div class="info-value">
						<fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy HH:mm" />
					</div>
				</div>
				<div>
					<div class="info-label">Trạng thái</div>
					<div class="info-value">
						<span class="status-pill status-${order.status}"> <c:choose>
								<c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
								<c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
								<c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
							</c:choose>
						</span>
					</div>
				</div>
			</div>
		</div>

		<table>
			<thead>
				<tr>
					<th>Sản phẩm</th>
					<th>Đơn giá</th>
					<th>Số lượng</th>
					<th>Thành tiền</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="i" items="${items}">
					<tr>
						<td>${i.deviceName}</td>
						<td class="price"><fmt:formatNumber value="${i.price}"
								type="number" /> đ</td>
						<td>${i.quantity}</td>
						<td class="price"><fmt:formatNumber
								value="${i.price * i.quantity}" type="number" /> đ</td>
					</tr>
				</c:forEach> 
			</tbody>
		</table>

		<div class="total-box">
			Tổng thanh toán:
			<fmt:formatNumber value="${order.totalAmount}" type="number" />
			đ
		</div>
	</main>

	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>