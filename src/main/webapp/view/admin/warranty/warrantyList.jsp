<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách bảo hành</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>

<style>
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
</style>

<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">

		<section class="panel">
			<form action="${pageContext.request.contextPath}/admin/warranty/list"
				method="get" style="margin-top: 10px">
				<select class="btn device-btn" name="status"
					onchange="this.form.submit()">
					<option value="" ${empty param.status ? 'selected' : ''}>Tất
						cả</option>
					<option value="valid" ${param.status=='valid' ? 'selected' : ''}>Còn
						hạn</option>
					<option value="expired"
						${param.status=='expired' ? 'selected' : ''}>Hết hạn</option>
				</select> <input class="btn device-btn" type="search" name="search"
					placeholder="Tìm theo tên thiết bị hoặc khách hàng..."
					value="${param.search}" />
				<button type="submit" class="btn device-btn">Tìm</button>
			</form>
		</section>

		<section class="panel" id="table-panel">
			<h2>Danh sách thiết bị bảo hành</h2>
			<div class="table-wrapper">
				<c:if test="${not empty warrantyList}">
					<table class="device-table">
						<thead>
							<tr>
								<th>Tên thiết bị</th>
								<th>Serial</th>
								<th>Khách hàng</th>
								<th>Trạng thái bảo hành</th>
								<th>Ngày hết hạn</th>
								<th>Hành động</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${warrantyList}" var="item">
								<tr>
									<td>${item.device_serial.deviceName}</td>
									<td>${item.device_serial.serial_no}</td>
									<td>${item.customer.full_name}</td>
									<td><c:set var="wStatus" value="${item.warrantyStatus}" />
										<c:choose>
											<c:when test="${wStatus == 'Còn hạn'}">
												<span style="color: #10b981; font-weight: 700">Còn
													hạn</span>
											</c:when>
											<c:otherwise>
												<span style="color: #ef4444; font-weight: 700">Hết
													hạn</span>
											</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate value="${item.end_at}"
											pattern="dd/MM/yyyy" /></td>
									<td style="text-align: center;"><a
										href="${pageContext.request.contextPath}/warranty-detail?id=${item.id}"
										class="btn device-btn">Xem chi tiết</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>

				<c:if test="${empty warrantyList}">
					<p style="text-align: center;">Không tìm thấy thiết bị bảo hành</p>
				</c:if>
			</div>
		</section>

<	<div class="pagination-pills" style="padding-bottom: 20px;">
			<c:choose>
				<c:when test="${currentPage > 1}">
					<a
						href="warranty-list?page=${currentPage - 1}&search=${param.search}&status=${param.status}">&#10094;</a>
				</c:when>
				<c:otherwise>
					<a class="disabled">&#10094;</a>
				</c:otherwise>
			</c:choose>

			<c:forEach var="i" begin="1" end="${totalPages}">
				<a class="${i == currentPage ? 'active' : ''}"
					href="warranty-list?page=${i}&search=${param.search}&status=${param.status}">${i}</a>
			</c:forEach>

			<c:choose>
				<c:when test="${currentPage < totalPages}">
					<a
						href="warranty-list?page=${currentPage + 1}&search=${param.search}&status=${param.status}">&#10095;</a>
				</c:when>
				<c:otherwise>
					<a class="disabled">&#10095;</a>
				</c:otherwise>
			</c:choose>
		</div> 

	</main>
</body>
</html>
