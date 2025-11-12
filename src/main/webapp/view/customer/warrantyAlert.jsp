<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cảnh báo bảo hành sắp hết</title>
<link rel="stylesheet" href="assets/css/style.css" />
<style>
:root {
	--primary: #2563eb;
	--primary-hover: #1d4ed8;
	--secondary: #6b7280;
	--border: #e5e7eb;
	--background: #f9fafb;
	--hover-bg: #e0e7ff;
	--danger: #dc2626;
	--success: #16a34a;
	--warning: #f59e0b;
	--font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
	font-family: var(--font-family);
	background-color: var(--background);
	margin: 0;
	padding: 0;
}

.container, .sidebar-main {
	max-width: 1200px;
	margin: 20px auto;
	padding: 0 20px;
}

h2 {
	color: var(--primary);
	margin-bottom: 20px;
	font-size: 24px;
}

.search-filter-container {
	background-color: #fff;
	padding: 20px;
	border-radius: 10px;
	margin-bottom: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	display: flex;
	flex-wrap: wrap;
	gap: 15px;
}

.search-filter-container form {
	display: flex;
	flex-wrap: wrap;
	gap: 15px;
	align-items: flex-end;
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 5px;
}

.form-group label {
	font-weight: 600;
	font-size: 13px;
	color: var(--secondary);
}

.form-group input, .form-group select {
	padding: 10px 12px;
	font-size: 14px;
	border: 1px solid var(--border);
	border-radius: 6px;
	transition: border 0.2s ease;
}

.form-group input:focus, .form-group select:focus {
	border-color: var(--primary);
	outline: none;
}

.btn {
	padding: 10px 18px;
	background-color: var(--primary);
	color: #fff;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 600;
	font-size: 14px;
	transition: background-color 0.2s ease, transform 0.1s ease;
	text-decoration: none;
}

.btn:hover {
	background-color: var(--primary-hover);
	transform: translateY(-1px);
}

.btn-reset {
	background-color: var(--secondary);
}

.btn-reset:hover {
	background-color: #4b5563;
}

table.table {
	width: 100%;
	border-collapse: collapse;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	background-color: #fff;
}

table.table th, table.table td {
	padding: 12px 15px;
	border-bottom: 1px solid var(--border);
	text-align: left;
	font-size: 14px;
}

table.table th {
	background-color: #f3f4f6;
	font-weight: 600;
	color: var(--secondary);
}

table.table tbody tr:nth-child(even) {
	background-color: #f9fafb;
}

table.table tbody tr:hover {
	background-color: var(--hover-bg);
	transition: background-color 0.2s ease;
}

.status-expired {
	color: var(--danger);
	font-weight: bold;
}

.status-warning {
	color: var(--warning);
	font-weight: bold;
}

.status-active {
	color: var(--success);
	font-weight: bold;
}

.pagination-pills {
	display: flex;
	justify-content: center;
	gap: 10px;
	flex-wrap: wrap;
	margin-top: 25px;
}

.pagination-pills a {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	width: 38px;
	height: 38px;
	border-radius: 50%;
	border: 1px solid var(--border);
	background: #fff;
	color: var(--secondary);
	font-weight: 600;
	text-decoration: none;
	cursor: pointer;
	transition: all 0.2s ease;
}

.pagination-pills a.active {
	background: var(--primary);
	color: #fff;
	border-color: var(--primary);
}

.pagination-pills a:hover:not(.active) {
	background: var(--hover-bg);
	transform: translateY(-2px);
}

.pagination-pills a.disabled {
	background: #e5e7eb;
	color: #9ca3af;
	cursor: not-allowed;
	pointer-events: none;
}

@media ( max-width : 768px) {
	.search-filter-container form {
		flex-direction: column;
	}
	table.table th, table.table td {
		font-size: 13px;
		padding: 10px;
	}
	.pagination-pills a {
		width: 32px;
		height: 32px;
	}
}
</style>
</head>
<body class="management-page warranty-alert-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main>
		<div class="sidebar-main">
			<h2>Các thiết bị sắp hết hạn bảo hành trong ${days} ngày</h2>
			<div class="search-filter-container">
				<form method="GET" action="warranty-alert">
					<div class="form-group">
						<label>Tìm kiếm:</label> <input type="text" name="search"
							placeholder="Tên device hoặc serial..." value="${search}">
					</div>
					<div class="form-group">
						<label>Số ngày:</label> <select name="days">
							<option value="7" ${days == 7 ? 'selected' : ''}>7 ngày</option>
							<option value="30" ${days == 30 ? 'selected' : ''}>30
								ngày</option>
							<option value="60" ${days == 60 ? 'selected' : ''}>60
								ngày</option>
							<option value="90" ${days == 90 ? 'selected' : ''}>90
								ngày</option>
							<option value="180" ${days == 180 ? 'selected' : ''}>6
								tháng</option>
							<option value="365" ${days == 365 ? 'selected' : ''}>1
								năm</option>
						</select>
					</div>
					<div class="form-group">
						<label>Sắp xếp:</label> <select name="sortBy">
							<option value="endDate" ${sortBy == 'endDate' ? 'selected' : ''}>Ngày
								hết hạn</option>
							<option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên
								device</option>
							<option value="serial" ${sortBy == 'serial' ? 'selected' : ''}>Mã
								serial</option>
						</select>
					</div>
					<div class="form-group">
						<label>Thứ tự:</label> <select name="sortOrder">
							<option value="ASC" ${sortOrder == 'ASC' ? 'selected' : ''}>Tăng
								dần</option>
							<option value="DESC" ${sortOrder == 'DESC' ? 'selected' : ''}>Giảm
								dần</option>
						</select>
					</div>
					<button type="submit" class="btn">🔍 Tìm kiếm</button>
					<a href="warranty-alert" class="btn btn-reset">↻ Đặt lại</a>
				</form>
			</div>

			<c:if test="${empty list}">
				<p>Không có thẻ bảo hành nào sắp hết hạn.</p>
			</c:if>

			<c:if test="${not empty list}">
				<table class="table">
					<thead>
						<tr>
							<th>STT</th>
							<th>Tên Device</th>
							<th>Mã serial</th>
							<th>Ngày bắt đầu</th>
							<th>Ngày kết thúc</th>
							<th>Số ngày còn lại</th>
							<th>Trạng Thái</th>
							<th>Hành động</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="w" items="${list}" varStatus="st">
							<c:set var="daysRem"
								value="${w.daysRemaining != null ? w.daysRemaining : 0}" />
							<c:set var="statusClass">
								<c:choose>
									<c:when test="${daysRem le 0}">status-expired</c:when>
									<c:when test="${daysRem lt 15}">status-expired</c:when>
									<c:when test="${daysRem le 30}">status-warning</c:when>
									<c:otherwise>status-active</c:otherwise>
								</c:choose>
							</c:set>
							<tr>
								<td>${(currentPage - 1) * 10 + st.index + 1}</td>
								<td><c:out
										value="${w.device != null ? w.device.name : '--'}" /></td>
								<td><c:out
										value="${w.device_serial != null ? w.device_serial.serial_no : '--'}" /></td>
								<td><fmt:formatDate value="${w.start_at}"
										pattern="yyyy-MM-dd" /></td>
								<td><fmt:formatDate value="${w.end_at}"
										pattern="yyyy-MM-dd" /></td>
								<td><span class="${statusClass}"> <c:choose>
											<c:when test="${daysRem le 0}">Hết hạn</c:when>
											<c:otherwise>${daysRem} ngày</c:otherwise>
										</c:choose>
								</span></td>
								<td><span class="${statusClass}"> <c:choose>
											<c:when test="${daysRem le 0}">Hết hạn</c:when>
											<c:otherwise>Còn hạn</c:otherwise>
										</c:choose>
								</span></td>
								<td><c:choose>
										<c:when test="${daysRem le 0}">
											<span class="btn btn-danger disabled">Liên hệ trung
												tâm</span>
										</c:when>
										<c:when test="${daysRem lt 15}">
											<a href="issue?warrantyCardId=${w.id}"
												class="btn btn-warning">Gửi yêu cầu hỗ trợ</a>
										</c:when>
										<c:when test="${daysRem le 30}">
											<a href="renew?warrantyCardId=${w.id}"
												class="btn btn-success">Gia hạn bảo hành</a>
										</c:when>
										<c:otherwise>
											<span class="btn btn-secondary disabled">Đang hoạt
												động</span>
										</c:otherwise>
									</c:choose></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<c:if test="${totalPages > 1}">
					<div class="pagination-pills">
						<c:choose>
							<c:when test="${currentPage > 1}">
								<c:url var="prevUrl" value="warranty-alert">
									<c:param name="page" value="${currentPage - 1}" />
									<c:param name="days" value="${days}" />
									<c:param name="search" value="${search}" />
									<c:param name="sortBy" value="${sortBy}" />
									<c:param name="sortOrder" value="${sortOrder}" />
								</c:url>
								<a href="${prevUrl}" class="pagination-prev">‹</a>
							</c:when>
							<c:otherwise>
								<a class="pagination-prev disabled">‹</a>
							</c:otherwise>
						</c:choose>

						<c:forEach var="i" begin="1" end="${totalPages}">
							<c:url var="pageUrl" value="warranty-alert">
								<c:param name="page" value="${i}" />
								<c:param name="days" value="${days}" />
								<c:param name="search" value="${search}" />
								<c:param name="sortBy" value="${sortBy}" />
								<c:param name="sortOrder" value="${sortOrder}" />
							</c:url>
							<a href="${pageUrl}" class="${i == currentPage ? 'active' : ''}">${i}</a>
						</c:forEach>

						<c:choose>
							<c:when test="${currentPage < totalPages}">
								<c:url var="nextUrl" value="warranty-alert">
									<c:param name="page" value="${currentPage + 1}" />
									<c:param name="days" value="${days}" />
									<c:param name="search" value="${search}" />
									<c:param name="sortBy" value="${sortBy}" />
									<c:param name="sortOrder" value="${sortOrder}" />
								</c:url>
								<a href="${nextUrl}" class="pagination-next">›</a>
							</c:when>
							<c:otherwise>
								<a class="pagination-next disabled">›</a>
							</c:otherwise>
						</c:choose>
					</div>
				</c:if>
			</c:if>
		</div>
	</main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
