<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết Thanh toán Khiếu nại | TechShop</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<style>
.device-detail {
	display: flex !important;
	width: 100%;
}

.device-detail .device-container {
	width: 100%;
}

.flash {
	margin-bottom: 16px;
	padding: 12px 16px;
	border-radius: 12px;
	font-weight: 600;
}
.flash.success {
	background: rgba(34,197,94,.14);
	color: #166534;
}
.flash.error {
	background: rgba(248,113,113,.14);
	color: #b91c1c;
}
</style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">
		<c:if test="${not empty flashMessage}">
			<div class="flash ${flashType}">
				${flashMessage}
			</div>
		</c:if>
		
		<c:if test="${not empty error}">
			<p style="color: #ef4444">${error}</p>
		</c:if>

		<section class="panel">
			<a class="btn device-btn" href="issue-payments"><i
				class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
		</section>

		<section class="panel">
			<div class="device-detail">
				<div class="device-img" style="display: none"></div>

				<div class="device-container">
					<h2>Thông tin Thanh toán</h2>
					<table class="device-table">
						<tbody>
							<tr>
								<th>ID Payment</th>
								<td>${payment.id}</td>
							</tr>
							<tr>
								<th>Issue ID</th>
								<td>${payment.issueId}</td>
							</tr>
							<tr>
								<th>Số tiền</th>
								<td><fmt:formatNumber value="${payment.amount}"
										type="number" /> ₫</td>
							</tr>
							<tr>
								<th>Ghi chú</th>
								<td>${payment.note}</td>
							</tr>
							<tr>
								<th>Người nhận</th>
								<td>${payment.shippingFullName}</td>
							</tr>
							<tr>
								<th>SĐT</th>
								<td>${payment.shippingPhone}</td>
							</tr>
							<tr>
								<th>Địa chỉ giao</th>
								<td>${payment.shippingAddress}</td>
							</tr>
							<tr>
								<th>Ghi chú giao hàng</th>
								<td>${payment.shippingNote}</td>
							</tr>
							<tr>
								<th>Trạng thái</th>
								<td><c:choose>
										<c:when test="${payment.status == 'awaiting_support'}">
											<span style="color: #1e293b; font-weight: 700;">Chờ hỗ
												trợ</span>
										</c:when>
										<c:when test="${payment.status == 'awaiting_customer'}">
											<span style="color: #b45309; font-weight: 700;">Chờ
												khách</span>
										</c:when>
										
										<c:when test="${payment.status == 'awaiting_admin'}">
											<span style="color: #92400e; font-weight: 700;">Chờ admin xác nhận</span>
										</c:when>
										
										<c:when test="${payment.status == 'paid'}">
											<span style="color: #166534; font-weight: 700;">Đã
												thanh toán</span>
										</c:when>
										<c:when test="${payment.status == 'closed'}">
											<span style="color: #b91c1c; font-weight: 700;">Đã
												đóng</span>
										</c:when>
										<c:otherwise>
											<span>Không xác định</span>
										</c:otherwise>
									</c:choose></td>
							</tr>
							<tr>
								<th>Người tạo</th>
								<td>${payment.createdBy}</td>
							</tr>
							<tr>
								<th>Người duyệt</th>
								<td>${payment.approvedBy}</td>
							</tr>
							<tr>
								<th>Người xác nhận</th>
								<td>${payment.confirmedBy}</td>
							</tr>
							<tr>
								<th>Ngày tạo</th>
								<td><fmt:formatDate value="${payment.createdAt}"
										pattern="dd/MM/yyyy HH:mm" /></td>
							</tr>
							<tr>
								<th>Cập nhật gần nhất</th>
								<td><fmt:formatDate value="${payment.updatedAt}"
										pattern="dd/MM/yyyy HH:mm" /></td>
							</tr>
							<tr>
								<th>Ngày thanh toán</th>
								<td><c:if test="${not empty payment.paidAt}">
										<fmt:formatDate value="${payment.paidAt}"
											pattern="dd/MM/yyyy HH:mm" />
									</c:if> <c:if test="${empty payment.paidAt}">
										<span style="color: #9ca3af;">Chưa thanh toán</span>
									</c:if></td>
							</tr>
						</tbody>
					</table>
					
					<c:if test="${payment != null && payment.status == 'awaiting_admin'}">
						<form method="post" action="issue-payment-detail" style="margin-top: 20px;">
							<input type="hidden" name="paymentId" value="${payment.id}">
							<button type="submit" name="action" value="confirm" class="btn btn-add"
								style="background:#16a34a; color:#fff;">
								<i class="fa-solid fa-badge-check"></i> Xác nhận đã thanh toán
							</button>
						</form>
					</c:if>

				</div>
			</div>
		</section>
	</main>
</body>
</html>
