<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>

body .panel h2 {
	margin-bottom: 0 !important;
}

.device-management .pagination-pills {
    display: flex;
    justify-content: center;
    gap: 10px;
    padding-bottom: 20px;
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


.status-badge {
	display: inline-block;
	white-space: nowrap;
	padding: 4px 10px;
	border-radius: 12px;
	font-weight: 600;
	font-size: 14px;
	text-align: center;
}

.status-pending {
	background: #fef3c7;
	color: #92400e;
}

.status-inprogress {
	background: #dbeafe;
	color: #1d4ed8;
}

.status-completed {
	background: #dcfce7;
	color: #166534;
}

.status-cancelled {
	background: #fee2e2;
	color: #991b1b;
}

.hidden {
    display: none;
}

.summary-modal-overlay {
    position: fixed;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(15, 23, 42, 0.45);
    z-index: 999;
}

.summary-modal-overlay.hidden {
    display: none;
}

.summary-modal {
    width: min(480px, 90%);
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 24px 48px rgba(15, 23, 42, 0.18);
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.summary-modal h2 {
    margin: 0;
    font-size: 18px;
    color: #0f172a;
}

.summary-modal textarea {
    resize: vertical;
    min-height: 120px;
    padding: 12px;
    border-radius: 8px;
    border: 1px solid #cbd5f5;
    font-family: inherit;
    font-size: 14px;
    color: #0f172a;
}

.summary-modal textarea:focus {
    outline: none;
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
}

.summary-modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
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
</style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main class="sidebar-main">
		<section class="panel">
			<div class="device-toolbar">
				<div class="device-toolbar-actions">
					<a class="btn btn-add" href="task-form"> <i
						class="fa-solid fa-plus"></i> <span>Thêm task</span>
					</a>
				</div>


				<form class="device-search" action="task-list" method="get">
					<select class="btn device-btn" id="status" name="status"
						onchange="this.form.submit()">
						<option value="" ${empty param.status ? 'selected' : '' }>Tất cả trạng thái</option>
						<option value="pending"
							${param.status=='pending' ? 'selected' : '' }>Đang chờ xử lí</option>
						<option value="in_progress"
							${param.status=='in_progress' ? 'selected' : '' }>Đang thực hiện</option>
						<option value="completed"
							${param.status=='completed' ? 'selected' : '' }>Đã hoàn thành</option>
						<option value="cancelled"
							${param.status=='cancelled' ? 'selected' : '' }>Đã hủy</option>
					</select> <label for="task-list-search" class="sr-only"></label> <input
						id="task-list-search" name="search" type="search"
						placeholder="Tìm theo tên, email, số điện thoại..."
						value="${param.search}">
					<button type="submit" class="btn device-btn">Tìm</button>
				</form>
			</div>
		</section>

		<section class="panel" id="table-panel">
			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h2>Danh sách task</h2>

				<c:if test="${not empty param.message}">
					<div class="message">${param.message}</div>
				</c:if>

				<c:if test="${not empty param.error}">
					<div class="error">${param.error}</div>
				</c:if>
			</div>
			<div class="table-wrapper">
				<c:if test="${not empty listTask}">
					<table class="device-table">
						<thead>
							<tr>
								<th>ID</th>
								<th>Tiêu đề</th>
								<th>Mô tả</th>
								<th>ManagerID</th>
								<th>CustomerIssueID</th>
								<th>Trạng thái</th>
								<th>Hành động</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listTask}" var="task">
								<tr>
									<td>${task.id}</td>
									<td>${task.title}</td>
									<td>${task.description}</td>
									<td>${task.managerId}</td>
									<td>${task.customerIssueId}</td>
									<td><c:choose>
											<c:when test="${task.status == 'pending'}">
												<span class="status-badge status-pending">Đang chờ xử
													lý</span>
											</c:when>
											<c:when test="${task.status == 'in_progress'}">
												<span class="status-badge status-inprogress">Đang
													thực hiện</span>
											</c:when>
											<c:when test="${task.status == 'completed'}">
												<span class="status-badge status-completed">Hoàn
													thành</span>
											</c:when>
											<c:when test="${task.status == 'cancelled'}">
												<span class="status-badge status-cancelled">Đã hủy</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge">Không xác định</span>
											</c:otherwise>
										</c:choose></td>


									<td style="display: flex; gap: 5px;">

										<a href="task-detail?id=${task.id}" class="btn device-btn">Xem</a>
										
										<c:if test="${task.status != 'cancelled' and task.status != 'completed'}">
											<a class="btn device-btn" href="task-form?id=${task.id}">Sửa</a>

											<form action="task-list" method="post"
												class="btn device-remove">
												<input type="hidden" name="taskId" value="${task.id}" />
												<button
													onclick="return confirm('Bạn có chắc muốn dừng task này?');"
													type="submit"
													style="outline: none; background: none; border: none; color: #fff; padding: 0; font-weight: 600;">
													Hủy</button>
											</form>
										</c:if>
									</td>

								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>

				<p style="margin-top: 12px; color: #6b7280; text-align: center;">
					Tổng số tasks: <strong>${totalTasks}</strong>
				</p>

				<c:if test="${empty listTask}">
					<table class="device-table">
						<tbody>
							<tr>
								<td colspan="7" style="text-align: center; border: none;">
									Không tìm thấy task</td>
							</tr>
						</tbody>
					</table>
				</c:if>

			</div>
			</section>
			<div class="pagination-pills">
				<c:choose>
			        <c:when test="${currentPage > 1}">
			            <a href="task-list?page=${currentPage - 1}&status=${param.status}&search=${param.search}"></a>
			        </c:when>
			        <c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
			    </c:choose>
			    
				<c:forEach var="i" begin="1" end="${totalPages}">
					<a href="task-list?page=${i}&status=${param.status}&search=${param.search}"
						class="${param.page == null && i == 1 || param.page == i ? 'active' : ''}">
						${i} </a>
				</c:forEach>
				
				<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href="task-list?page=${currentPage + 1}&status=${param.status}&search=${param.search}"></a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
			</div>
			
		
	</main>
</body>
</html>
