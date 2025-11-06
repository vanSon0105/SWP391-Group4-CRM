<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transaction List</title>
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

.filter-form {
	margin-bottom: 15px;
	display: flex;
	gap: 10px;
	align-items: center;
	flex-wrap: wrap;
}


.device-management .pagination-pills {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 20px;
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
<body class="management-page device-management sidebar-collapsed">
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>
<jsp:include page="../admin/common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <c:if test="${not empty message}">
            <div class="message" style="color:green; font-weight:bold; margin-bottom:10px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error" style="color:red; font-weight:bold; margin-bottom:10px;">${error}</div>
        </c:if>

        <!-- Create button -->
        <a style="margin-bottom: 20px;" href="${pageContext.request.contextPath}/create-transaction" class="btn btn-add">
            <i class="fa fa-plus"></i> Create Import/Export Order
        </a>

        <!-- Filter + Search Form -->
        <form method="get" action="${pageContext.request.contextPath}/transactions" class="filter-form">
            <input class="btn device-btn" type="text" name="keyword" placeholder="Search by storekeeper, user, supplier, note..." value="${fn:escapeXml(keyword)}"/>
            <select class="btn device-btn" name="type">
                <option value="">All Types</option>
                <option value="import" ${typeFilter=='import'?'selected':''}>Import</option>
                <option value="export" ${typeFilter=='export'?'selected':''}>Export</option>
            </select>
            <select class="btn device-btn" name="status">
                <option value="">All Status</option>
                <option value="pending" ${statusFilter=='pending'?'selected':''}>Pending</option>
                <option value="confirmed" ${statusFilter=='confirmed'?'selected':''}>Confirmed</option>
                <option value="cancelled" ${statusFilter=='cancelled'?'selected':''}>Cancelled</option>
            </select>
            <button class="btn device-btn" type="submit"><i class="fa fa-filter"></i> Filter</button>
            <a class="btn device-btn" href="${pageContext.request.contextPath}/transactions">
		        <i class="fa fa-undo"></i> Reset
		    </a>
        </form>
       </section>
        <section class="panel" id="table-panel">
        	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        		<h2 style="margin: 0;">Danh sách giao dịch nhập/xuất kho</h2>
        	</div>
	        <div class="table-wrapper">
	            <table class="transaction-table">
	                <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>Type</th>
	                        <th>Storekeeper</th>
	                        <th>Supplier / User</th>
	                        <th>Note</th>
	                        <th>Status</th>
	                        <th>Created At</th>
	                    </tr>
	                </thead>
	                <tbody>
	                    <c:forEach var="t" items="${transactions}">
	                        <tr>
	                            <td>${t.id}</td>
	                            <td><c:out value="${t.type}"/></td>
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
	                            <td><c:out value="${t.note != null ? t.note : ''}"/></td>
	                            <td class="status-${t.status}"><c:out value="${t.status}"/></td>
	                            <td>
	                                <c:if test="${not empty t.date}">
	                                    <fmt:formatDate value="${t.date}" pattern="yyyy-MM-dd HH:mm"/>
	                                </c:if>
	                            </td>
	                        </tr>
	                    </c:forEach>
	                    <c:if test="${empty transactions}">
	                        <tr><td colspan="7">No transactions found.</td></tr>
	                    </c:if>
	                </tbody>
	            </table>
	        </div>
		</section>
        <div class="pagination-pills" style="padding-bottom: 20px;">
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
                        <a class="${i == currentPage ? 'active' : ''}">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a class="${i == currentPage ? 'active' : ''}" href="?page=${i}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:choose>
                <c:when test="${currentPage < totalPages}">
                	<a href = "?page=${currentPage + 1}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">&#10095;</a>            	
            	</c:when>
            	<c:otherwise>
		            <a class="disabled">&#10095;</a>
		        </c:otherwise>
            </c:choose>
        </div>
</main>
</body>
</html>
