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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
<style>
:root {
	--danger: #dc2626;
	--success: #16a34a;
	--warning: #f59e0b;
}
body.home-page {
    display: flex;
    flex-direction: column;
}

.home-page main {
	min-width: 1100px;
    flex: 1;
	margin: 40px auto;
	background: #fff;
	padding: 32px !important;
	border-radius: 12px;
	box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
}

table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
}

th, td {
  padding: 14px 16px !important;
  text-align: left;
  border-bottom: 1px solid #eef2f6;
  font-size: 2rem;
}

th {
  background: #f8fafc;
  font-weight: 600;
  color: #475569;
  text-align: center;
  font-size: 1.7rem;
}

tr:last-child td {
  border-bottom: none;
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

.actions{
	gap: 10px;
    display: flex;
    height: 100%;
    align-items: end;
}

</style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main>
		<div class="page-header">
			<div>
				<h1>Các thiết bị sắp hết hạn bảo hành trong ${days} ngày</h1>
			</div>
		</div>

		<form method="GET" action="warranty-alert" class="filter-form">
			<div class="filter-row" style="height: 60px;">
				<div class="filter-group">
					<label class="filter-label">Tìm kiếm:</label> 
					<input class="filter-select" type="text" name="search" placeholder="Tên device hoặc serial..." value="${search}">
				</div>
				<div class="filter-group">
					<label class="filter-label">Số ngày:</label> 
					<select name="days" class="filter-select">
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
				<div class="filter-group">
					<label class="filter-label">Sắp xếp:</label> 
					<select name="sortBy" class="filter-select">
						<option value="endDate" ${sortBy == 'endDate' ? 'selected' : ''}>Ngày
							hết hạn</option>
						<option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên
							device</option>
						<option value="serial" ${sortBy == 'serial' ? 'selected' : ''}>Mã
							serial</option>
					</select>
				</div>
				<div class="filter-group">
					<label class="filter-label">Thứ tự:</label> 
					<select name="sortOrder" class="filter-select">
						<option value="ASC" ${sortOrder == 'ASC' ? 'selected' : ''}>Tăng
							dần</option>
						<option value="DESC" ${sortOrder == 'DESC' ? 'selected' : ''}>Giảm
							dần</option>
					</select>
				</div>
				
				<div class="actions">
					<button style="border-radius: 5px;" type="submit" class="btn order-btn">🔍 Tìm kiếm</button>
					<a style="border-radius: 5px;" href="warranty-alert" class="btn order-btn">↻ Đặt lại</a>
				</div>
			</div>
		</form>
		
		<div>
			<c:if test="${empty list}">
				<p style="text-align: center;">Không có thẻ bảo hành nào sắp hết hạn</p>
			</c:if>
			<c:if test="${not empty list}">
				<table>
					<thead>
						<tr>
							<th>STT</th>
							<th>Tên thiết bị</th>
							<th>Mã serial</th>
							<th>Ngày bắt đầu</th>
							<th>Ngày kết thúc</th>
							<th>Số ngày còn lại</th>
							<th>Trạng Thái</th>
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
								<td>
									<span class="${statusClass}">
										<c:choose>
											<c:when test="${daysRem le 0}">Hết hạn</c:when>
											<c:when test="${daysRem le 30}">Sắp hết hạn</c:when>
											<c:otherwise>Còn hạn</c:otherwise>
										</c:choose>
									</span>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<c:if test="${totalPages > 1}">
					<div class="pagination-pills" style="margin-top: 20px;">
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
