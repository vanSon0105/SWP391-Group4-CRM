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
.detail-panel { 
    margin: 30px auto; 
    padding: 25px; 
    border: 1px solid #e0e0e0; 
    border-radius: 12px; 
    background: #fff; 
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.detail-panel h2 { 
    margin-bottom: 25px; 
    font-size: 26px; 
    color: #1f2937;
}

.detail-panel .info { 
    display: flex; 
    flex-wrap: wrap; 
    gap: 25px; 
    margin-bottom: 25px; 
}

.detail-panel .info div.small-box { 
    flex: 1 1 180px;
    background: #f9f9f9; 
    padding: 10px 12px; 
    border-radius: 8px; 
    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
    font-size: 14px;
    word-break: break-word;
    white-space: normal;
    overflow-wrap: break-word;
}

.detail-panel .info div.note {
    flex: 2 1 100%;         
    max-height: 200px;
    overflow-y: auto;          
    background-color: #eef2ff;
    padding: 15px 15px 15px 15px; 
    border-radius: 8px;
    font-style: italic;
    color: #3730a3;
    word-break: break-word;
    white-space: pre-wrap;
    overflow-wrap: break-word;
    position: relative;
    margin-top: 10px;
}
</style>
</head>
<body class="management-page device-management">
<jsp:include page="../common/header.jsp"></jsp:include>
<jsp:include page="../common/sidebar.jsp"></jsp:include>

<main class="sidebar-main">
	<section class="panel">
		<div class="head">
			<h2>Chi tiết thanh toán #${payment.id}</h2>
			<a href="payment-list" class="btn device-btn">Quay lại</a>
		</div>
	</section>
	<section class="detail-panel">
		<h2>Thông tin khách hàng</h2>
		<div class="info">
			
			<div class="small-box">
				<strong>Họ tên:</strong>
				<c:out
					value="${payment.fullName}" />
			</div>
			
			<div class="small-box">
				<strong>Số điện thoại:</strong>
				<c:out
					value="${payment.phone}" />
			</div>
			
			<div class="small-box">
				<strong>Địa chỉ:</strong>
				<c:out
					value="${payment.address}" />
			</div>
			
			<div class="small-box">
				<strong>Thời gian giao hàng:</strong>
				<c:out
					value="${payment.deliveryTime}" />
			</div>
			
			<div class="small-box">
				<strong>Địa chỉ:</strong>
				<c:out
					value="${payment.address}" />
			</div>
			
			<div class="note">
				<strong>Ghi chú:</strong>
				<c:out value="${payment.technicalNote != null ? payment.technicalNote : ''}" />
			</div>
			
			<div class="small-box">
				<strong>Trạng thái:</strong>
				<c:out
					value="${payment.status}" />
			</div>
			
			<div class="small-box">
				<strong>Ngày tạo:</strong>
				<fmt:formatDate value="${payment.createdAt}"
						pattern="yyyy-MM-dd HH:mm" />
			</div>
			
			<div class="small-box">
				<strong>Ngày thanh toán:</strong>
				<fmt:formatDate value="${payment.paidAt}"
						pattern="yyyy-MM-dd HH:mm" />
			</div>
		</div>
	
		<div style="margin-top:20px;">
			<h2>Danh sách thiết bị trong đơn hàng</h2>
			<div class="table-wrapper">
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
	</section>
</main>
</body>
</html>
