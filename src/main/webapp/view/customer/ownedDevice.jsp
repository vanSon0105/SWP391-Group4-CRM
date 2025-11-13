<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thiết bị đã mua</title>
<style>
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
.owned-device-page {
	padding: 36px 40px;
}

.btn-outline {
	font-size: 1.5rem;
	background: transparent;
	border: 1px solid #94a3b8;
	color: #1f2937;
	padding: 10px 10px;
	border-radius: 5px;
	font-weight: 600;
	cursor: pointer;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	transition: all 0.5s ease;
}

.btn-outline:hover{
	scale: 1.1;
}

.metrics {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 16px;
	margin: 24px 0;
}

.metric-card {
	display: flex;
    background: #fff;
    border-radius: 14px;
    padding: 20px;
    box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08);
    border: 1px solid #e2e8f0;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.metric-card .label {
	font-size: 14px;
	color: #64748b;
}

.metric-card .value {
	font-size: 32px;
	font-weight: 700;
	color: #0f172a;
}


.device-table {
	border-collapse: collapse;
	background: #fff;
	border-radius: 16px;
	overflow: hidden;
	box-shadow: 0 16px 48px rgba(15, 23, 42, 0.08);
}

.device-table th, .device-table td {
	padding: 16px 18px;
	text-align: left;
	border-bottom: 1px solid #e2e8f0;
	font-size: 16px;
}

.device-table th {
	background: #f8fafc;
	color: #475569;
	text-transform: uppercase;
	font-size: 14px;
	letter-spacing: 0.05em;
}

.device-info {
	display: flex;
	align-items: center;
	gap: 14px;
}

.device-info img {
	width: 64px;
	height: 64px;
	object-fit: cover;
	border-radius: 12px;
	background: #e2e8f0;
}

.device-name {
	font-weight: 600;
	color: #0f172a;
	margin-bottom: 6px;
}

.device-detail-row {
	display: none;
	background: #f8fafc;
}

.detail-card {
	background: #fff;
	border-radius: 14px;
	padding: 18px;
	box-shadow: inset 0 1px 0 rgba(148, 163, 184, 0.4);
}

.detail-card h3 {
	margin-top: 0;
	color: #0f172a;
}

.unit-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 12px;
}

.unit-table th, .unit-table td {
	padding: 10px 12px;
	text-align: left;
	border-bottom: 1px solid #e2e8f0;
	font-size: 15px;
}

.badge {
	display: inline-flex;
	align-items: center;
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 600;
	text-transform: uppercase;
}

.badge-success {
	background: #dcfce7;
	color: #166534;
}

.badge-warning {
	background: #fef9c3;
	color: #854d0e;
}

.empty-state {
	background: #fff;
	border-radius: 14px;
	padding: 48px;
	text-align: center;
	box-shadow: 0 16px 48px rgba(15, 23, 42, 0.08);
	color: #475569;
}

.page-actions .btn,
.device-table button{
	border-radius: 5px;
}

.modal-overlay {
	position: fixed;
	inset: 0;
	background: rgba(15, 23, 42, 0.6);
	display: none;
	align-items: center;
	justify-content: center;
	z-index: 999;
}

.modal-card {
	position: relative;
	background: #fff;
	border-radius: 16px;
	padding: 24px;
	width: max-content;
	box-shadow: 0 25px 60px rgba(15, 23, 42, 0.25);
	font-size: 3rem;
}

.modal-card h3 {
	margin: 0 0 16px 0;
	color: #0f172a;
}

.modal-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
	color: #475569;
	gap: 40px;
}

.modal-row span {
	font-weight: 600;
	color: #0f172a;
}

.modal-close {
	position: absolute;
    top: -5px;
    right: 10px;
    background: none;
    border: none;
    font-size: 35px;
    color: black;
    cursor: pointer;
}

.filter-form{
	display: flex;
	align-items: center;
	gap: 10px;
}
</style>
</head>
<body class="home-page">
<jsp:include page="../common/header.jsp"></jsp:include>
<main>
	<div class="page-header">
		<div>
			<h1>Thiết bị đã mua</h1>
			<p style="color:#475569;">Theo dõi toàn bộ thiết bị bạn sở hữu và trạng thái yêu cầu hỗ trợ.</p>
		</div>
		<div class="page-actions">
			<a class="btn order-btn" href="order-tracking">Đơn hàng của tôi</a>
			<a class="order-btn btn" href="create-issue">Gửi yêu cầu mới</a>
		</div>
	</div>
	
	<div class="metrics">
		<div class="metric-card">
			<div class="label">Tổng thiết bị</div>
			<div class="value">${totalOwnedUnits}</div>
		</div>
		<div class="metric-card">
			<div class="label">Thiết bị đã gửi yêu cầu</div>
			<div class="value">${totalUnitsWithIssue}</div>
		</div>
	</div>
	
	<c:set var="hasFilter" value="${not empty filterKeyword}" />
	<form class="filter-form" action="my-devices" method="get">
		<div class="filter-group">
			<label for="keyword" class="filter-label">Tìm theo tên hoặc serial</label>
			<input class="filter-select" id="keyword" name="keyword" type="search" placeholder="Nhập tên thiết bị hoặc serial..."
				   value="${fn:escapeXml(filterKeyword)}">
		</div>
		<div style="margin-top: 15px;">
			<button type="submit" class="btn btn-outline">Tìm kiếm</button>
			<a href="my-devices" class="btn btn-outline">Xóa lọc</a>
		</div>
	</form>
	<c:choose>
		<c:when test="${not empty ownedDevices}">
			<table class="device-table">
				<thead>
					<tr>
						<th>Thiết bị</th>
						<th>Số lượng sở hữu</th>
						<th>Đã gửi yêu cầu</th>
						<th>Lần mua gần nhất</th>
						<th>Đã sử dụng</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="device" items="${ownedDevices}">
						<tr>
							<td>
								<div class="device-info">
									<c:choose>
										<c:when test="${not empty device.imageUrl}">
											<img src="${pageContext.request.contextPath}/assets/img/device/${device.imageUrl}" alt="${device.deviceName}">
										</c:when>
										<c:otherwise>
											<img src="${pageContext.request.contextPath}/assets/img/default-device.png" alt="device">
										</c:otherwise>
									</c:choose>
									<div>
										<div class="device-name">${device.deviceName}</div>
										<div style="color:#94a3b8;">ID: ${device.deviceId}</div>
									</div>
								</div>
							</td>
							<td>${device.totalUnits}</td>
							<td>${device.unitsWithIssue}</td>
							<td>
								<c:if test="${not empty device.latestPurchaseAt}">
									<fmt:formatDate value="${device.latestPurchaseAt}" pattern="dd/MM/yyyy HH:mm" />
								</c:if>
							</td>
							<td>${device.daysSinceLatestPurchase} ngày</td>
							<td>
								<button class="btn order-btn" type="button" onclick="toggleDetail(${device.deviceId})">
									Xem
								</button>
							</td>
						</tr>
						<tr id="detail-${device.deviceId}" class="device-detail-row">
							<td colspan="6">
								<div class="detail-card">
									<h3>Chi tiết thiết bị</h3>
									<table class="unit-table">
										<thead>
											<tr>
												<th>Serial</th>
												<th>Warranty Card</th>
												<th>Ngày mua</th>
												<th>Hết hạn</th>
												<th>Đã dùng</th>
												<th>Yêu cầu</th>
												<th>Thao tác</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="unit" items="${device.units}">
												<tr>
													<td>${unit.serialNo}</td>
													<td>#${unit.warrantyCardId}</td>
													<td>
														<fmt:formatDate value="${unit.purchaseDate}" pattern="dd/MM/yyyy HH:mm"/>
													</td>
													<td>
														<c:choose>
															<c:when test="${not empty unit.warrantyEnd}">
																<fmt:formatDate value="${unit.warrantyEnd}" pattern="dd/MM/yyyy"/>
															</c:when>
															<c:otherwise>-</c:otherwise>
														</c:choose>
													</td>
													<td>${unit.daysSincePurchase} ngày</td>
													<td>
														<c:choose>
															<c:when test="${unit.hasIssue}">
																<span class="badge badge-warning">
																	<c:choose>
									                                    <c:when test="${unit.latestIssueStatus == 'awaiting_customer'}">Chờ bổ sung</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'submitted'}">Đã chuyển kỹ thuật</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'in_progress'}">Đang xử lý</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'manager_rejected'}">Quản lí từ chối! Xem yêu cầu</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'customer_cancelled'}">Đã hủy theo yêu cầu khách</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'manager_review'}">Đang đợi quản lí duyệt</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'manager_approved'}">Đã duyệt tạo task</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'task_created'}">Đã tạo task</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'tech_in_progress'}">Đang thực hiện</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'create_payment'}">Nhân viên đang xử lí</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'waiting_payment'}">Vui lòng thanh toán</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'completed'}">Xử lí xong vấn đề</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'waiting_confirm'}">Chờ admin xác nhận</c:when>
									                                    <c:when test="${unit.latestIssueStatus == 'resolved'}">Đã hoàn tất</c:when>
									                                    <c:otherwise>Tiếp nhận mới</c:otherwise>
									                                </c:choose>
																</span>
															</c:when>
															<c:otherwise>
																<span class="badge badge-success">Chưa gửi</span>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<div style="display:flex; gap:8px; flex-wrap:wrap;">
															<a class="btn-outline" href="create-issue?warrantyCardId=${unit.warrantyCardId}">
																Gửi yêu cầu
															</a>
															<button type="button" class="btn-outline"
																	onclick="openWarrantyModal(${unit.warrantyCardId}, '${unit.serialNo}',
																		'<fmt:formatDate value="${unit.purchaseDate}" pattern="dd/MM/yyyy HH:mm"/>',
																		'<c:choose><c:when test="${not empty unit.warrantyEnd}"><fmt:formatDate value="${unit.warrantyEnd}" pattern="dd/MM/yyyy"/></c:when><c:otherwise>-</c:otherwise></c:choose>')">
																Xem thẻ BH
															</button>
															<c:if test="${unit.hasIssue}">
																<a class="btn-outline" href="issue-detail?id=${unit.latestIssueId}">
																	Xem yêu cầu
																</a>
															</c:if>
														</div>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			<c:if test="${totalPages > 1}">
				<div class="pagination-pills">
					<c:url var="prevUrl" value="my-devices">
						<c:param name="page" value="${currentPage - 1}" />
						<c:if test="${not empty filterKeyword}">
							<c:param name="keyword" value="${filterKeyword}" />
						</c:if>
					</c:url>
					<c:choose>
						<c:when test="${currentPage > 1}">
							<a href="${prevUrl}">&#10094;</a>
						</c:when>
						<c:otherwise>
							<a class="disabled">&#10094;</a>
						</c:otherwise>
					</c:choose>
					
					<c:forEach var="i" begin="1" end="${totalPages}">
						<c:url var="pageUrl" value="my-devices">
							<c:param name="page" value="${i}" />
							<c:if test="${not empty filterKeyword}">
								<c:param name="keyword" value="${filterKeyword}" />
							</c:if>
						</c:url>
						<a href="${pageUrl}" class="${i == currentPage ? 'active' : ''}">${i}</a>
					</c:forEach>
					
					<c:url var="nextUrl" value="my-devices">
						<c:param name="page" value="${currentPage + 1}" />
						<c:if test="${not empty filterKeyword}">
							<c:param name="keyword" value="${filterKeyword}" />
						</c:if>
					</c:url>
					<c:choose>
						<c:when test="${currentPage < totalPages}">
							<a href="${nextUrl}">&#10095;</a>
						</c:when>
						<c:otherwise>
							<a class="disabled">&#10095;</a>
						</c:otherwise>
					</c:choose>
				</div>
			</c:if>
		</c:when>
		<c:otherwise>
			<div class="empty-state">
				<h2>Bạn chưa sở hữu thiết bị nào</h2>
				<p>Những thiết bị đã mua thành công sẽ hiển thị tại đây.</p>
				<a class="btn btn-primary" href="home">Tiếp tục mua sắm</a>
			</div>
		</c:otherwise>
	</c:choose>
</main>
<div id="warrantyModal" class="modal-overlay" onclick="closeWarrantyModal()">
	<div class="modal-card">
	<button class="modal-close" onclick="closeWarrantyModal()">&times;</button>
		<h3>Chi tiết thẻ bảo hành</h3>
		<div class="modal-row">
			<label>Mã thẻ</label>
			<span id="modalWarrantyId">#0</span>
		</div>
		<div class="modal-row">
			<label>Serial</label>
			<span id="modalSerial">N/A</span>
		</div>
		<div class="modal-row">
			<label>Ngày kích hoạt</label>
			<span id="modalStart">-</span>
		</div>
		<div class="modal-row">
			<label>Ngày hết hạn</label>
			<span id="modalEnd">-</span>
		</div>
	</div>
</div>
<jsp:include page="../common/footer.jsp"></jsp:include>
<script>
function toggleDetail(id) {
	const row = document.getElementById('detail-' + id);
	if (!row) return;
	row.style.display = row.style.display === 'table-row' ? 'none' : 'table-row';
}

function openWarrantyModal(id, serial, start, end) {
	document.getElementById('modalWarrantyId').textContent = '#' + id;
	document.getElementById('modalSerial').textContent = serial || 'N/A';
	document.getElementById('modalStart').textContent = start && start.trim() !== '' ? start : '-';
	document.getElementById('modalEnd').textContent = end && end.trim() !== '' ? end : '-';
	document.getElementById('warrantyModal').style.display = 'flex';
}

function closeWarrantyModal() {
	document.getElementById('warrantyModal').style.display = 'none';
}
</script>
</body>
</html>
