<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách giao dịch nhập/xuất kho</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
      integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
      crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.status-confirmed {
	color: green;
	font-weight: bold;
}

.status-pending {
	color: orange;
	font-weight: bold;
}

.status-cancelled {
	color: red;
	font-weight: bold;
}

.device-management .pagination-pills {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 20px;
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

.disabled {
	background: linear-gradient(135deg, rgba(14, 165, 233, 0.95),
		rgba(59, 130, 246, 0.95));
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
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>
<jsp:include page="../admin/common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <c:if test="${not empty message}">
        <div class="message" style="color:green; font-weight:bold; margin-bottom:10px;">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="error" style="color:red; font-weight:bold; margin-bottom:10px;">${error}</div>
    </c:if>

    <section class="panel">
        <div class="device-toolbar">
	        <form method="get" action="transactions" class="device-search">
	            <input type="search" name="keyword" placeholder="Tìm theo nhân viên kho, ghi chú..." value="${fn:escapeXml(keyword)}"/>
	            <select class="btn device-btn" name="type">
	                <option value="">Tất cả loại</option>
	                <option value="import" ${typeFilter=='import'?'selected':''}>Nhập kho</option>
	                <option value="export" ${typeFilter=='export'?'selected':''}>Xuất kho</option>
	            </select>
	            <select class="btn device-btn" name="status">
	                <option value="">Tất cả trạng thái</option>
	                <option value="pending" ${statusFilter=='pending'?'selected':''}>Chờ duyệt</option>
	                <option value="confirmed" ${statusFilter=='confirmed'?'selected':''}>Đã xác nhận</option>
	                <option value="cancelled" ${statusFilter=='cancelled'?'selected':''}>Đã hủy</option>
	            </select>
	            <button class="btn device-btn" type="submit">Lọc</button>
	            <a href="/transactions" class="btn device-btn">
			        <i class="fa-solid fa-magnifying-glass"></i>Reset
			    </a>
	        </form>
        </div>
    </section>
    <section class="panel">
		<h2>Danh sách giao dịch nhập/xuất kho</h2>
        <div class="table-wrapper">
            <table class="transaction-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Loại</th>
                        <th>Nhân viên kho</th>
                        <th>Nhà cung cấp / Người nhận</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${transactions}">
                        <tr>
                            <td>${t.id}</td>
                            <td><c:out value="${t.type == 'import' ? 'Nhập kho' : 'Xuất kho'}"/></td>
                            <td><c:out value="${t.storekeeperName}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${t.type == 'import'}">
                                        <c:out value="${t.supplierName != null ? t.supplierName : 'N/A'}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${t.userName != null ? t.userName : 'N/A'}"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
							
                            <td class="status-${t.status}">
                                <c:choose>
                                    <c:when test="${t.status=='pending'}">Chờ duyệt</c:when>
                                    <c:when test="${t.status=='confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${t.status=='cancelled'}">Đã hủy</c:when>
                                </c:choose>
                            </td>
								<td><c:if test="${not empty t.date}">
										<fmt:formatDate value="${t.date}" pattern="yyyy-MM-dd'T'HH:mm"
											timeZone="Asia/Ho_Chi_Minh" var="formattedDate" />
										<input type="datetime-local" class="btn device-btn" value="${formattedDate}" disabled>
									</c:if></td>
								<td>
                                <a href="${pageContext.request.contextPath}/transaction-detail?id=${t.id}" class="btn device-btn">
                                   Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty transactions}">
                        <tr><td colspan="9">Không tìm thấy giao dịch nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
	</section>
        <div class="pagination-pills">
        	<c:choose>
		        <c:when test="${currentPage > 1}">
		            <a href="?page=${currentPage - 1}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">&#10094;</a>
		        </c:when>
		        <c:otherwise>
		            <a class="disabled">&#10094;</a>
		        </c:otherwise>
		    </c:choose>
		        
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <a class="active">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:choose>
                <c:when test="${currentPage < totalPages}">
                	<a href="?page=${currentPage + 1}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">&#10095;</a>            	
            	</c:when>
            	<c:otherwise>
		            <a class="disabled">&#10095;</a>
		        </c:otherwise>
            </c:choose>
        </div>

    </section>
</main>
</body>
</html>
