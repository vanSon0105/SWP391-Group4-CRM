<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết bảo hành | TechShop</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<style>
.status-badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 12px;
	font-weight: 600;
	font-size: 14px;
}

.status-valid {
	background: #dcfce7;
	color: #166534;
}

.status-expired {
	background: #fee2e2;
	color: #991b1b;
}
</style>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">

		<section class="panel">
			<a class="btn device-btn" href="warranty-list"> <i
				class="fa-solid fa-arrow-left"></i> Quay lại danh sách
			</a>
		</section>

		<c:if test="${not empty error}">
			<p style="color: #ef4444">${error}</p>
		</c:if>

		<section class="panel">
			<h2>Chi tiết bảo hành</h2>

			<c:if test="${not empty warranty}">
				<form action="warranty-update" method="post">
					<input type="hidden" name="warrantyId" value="${warranty.id}" />

					<table class="device-table">
						<tbody>
							<tr>
								<th>Tên thiết bị</th>
								<td>${warranty.device_serial.deviceName}</td>
							</tr>
							<tr>
								<th>Serial</th>
								<td>${warranty.device_serial.serial_no}</td>
							</tr>
							<tr>
								<th>Khách hàng</th>
								<td>${warranty.customer.full_name}
									(${warranty.customer.email})</td>
							</tr>
							<tr>
								<th>Ngày bắt đầu</th>
								<td><fmt:formatDate value="${warranty.start_at}"
										pattern="dd/MM/yyyy" /></td>
							</tr>
							<tr>
								<th>Ngày kết thúc</th>
								<td><fmt:formatDate value="${warranty.end_at}"
										pattern="dd/MM/yyyy" /></td>
							</tr>
							<tr>
								<th>Trạng thái bảo hành</th>
								<td><span
									class="status-badge 
                                        ${warranty.warrantyStatus eq 'Còn hạn' ? 'status-valid' : 'status-expired'}">
										${warranty.warrantyStatus} </span></td>
							</tr>
						</tbody>
					</table>

					<!-- <!-- <button type="submit" class="btn device-btn"
						onclick="return confirm('Bạn có chắc muốn cập nhật ngày bảo hành này không?');">
						Cập nhật</button> --> 
				</form>
			</c:if>

			<c:if test="${empty warranty}">
				<p>Không tìm thấy thông tin bảo hành</p>
			</c:if>
		</section>
		<section class="panel">
			<h3>Lịch sử bảo hành, sửa chữa</h3>

			<c:if test="${empty warrantyHistory}">
				<p style="text-align: center; padding: 10px;">Chưa có lịch sử
					bảo hành nào.</p>
			</c:if>

			<c:if test="${not empty warrantyHistory}">
				<table class="device-table">
					<thead>
						<tr>
							<th>#</th>
							<th>Ngày bắt đầu</th>
							<th>Ngày kết thúc</th>
							<th>Người giao</th>
							<th>Người thực hiện</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${warrantyHistory}" varStatus="loop">
							<tr>
								<td>${loop.index + 1}</td>
								<td><fmt:formatDate value="${item.start_at}"
										pattern="dd/MM/yyyy" /></td>
								<td><fmt:formatDate value="${item.end_at}"
										pattern="dd/MM/yyyy" /></td>
								<td>${item.assignedByName}</td>
								<td>${item.handledByName}</td>	
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</section>

	</main>
</body>
</html>
