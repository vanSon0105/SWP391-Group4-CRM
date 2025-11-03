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
.table-wrapper {
	overflow-x: auto;
	margin-top: 20px;
}

.transaction-table {
	width: 100%;
	border-collapse: collapse;
}

.transaction-table th, .transaction-table td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: center;
}

.transaction-table th {
	background-color: #f7f7f7;
}

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

.filter-form input[type="text"], .filter-form select {
	padding: 6px 10px;
	border-radius: 5px;
	border: 1px solid #ccc;
}

.filter-form button {
	padding: 6px 15px;
	background-color: #007bff;
	color: #fff;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.create-btn {
	margin-bottom: 15px;
	padding: 8px 20px;
	background-color: #28a745;
	color: #fff;
	border-radius: 5px;
	text-decoration: none;
	display: inline-block;
}

.pagination {
	margin-top: 15px;
	text-align: center;
}

.pagination a, .pagination strong {
	margin: 0 3px;
	padding: 5px 10px;
	text-decoration: none;
	border-radius: 5px;
	border: 1px solid #ddd;
}

.pagination strong {
	background-color: #007bff;
	color: #fff;
	border-color: #007bff;
}

.pagination a:hover {
	background-color: #f0f0f0;
}
</style>
</head>
<body class="management-page device-management sidebar-collapsed">
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>
<jsp:include page="../admin/common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <h2>Danh sách giao dịch nhập/xuất kho</h2>

        <c:if test="${not empty message}">
            <div class="message" style="color:green; font-weight:bold; margin-bottom:10px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error" style="color:red; font-weight:bold; margin-bottom:10px;">${error}</div>
        </c:if>

        <!-- Create button -->
        <a href="${pageContext.request.contextPath}/create-transaction" class="create-btn">
            <i class="fa fa-plus"></i> Create Import/Export Order
        </a>

        <!-- Filter + Search Form -->
        <form method="get" action="${pageContext.request.contextPath}/transactions" class="filter-form">
            <input type="text" name="keyword" placeholder="Search by storekeeper, user, supplier, note..." value="${fn:escapeXml(keyword)}"/>
            <select name="type">
                <option value="">All Types</option>
                <option value="import" ${typeFilter=='import'?'selected':''}>Import</option>
                <option value="export" ${typeFilter=='export'?'selected':''}>Export</option>
            </select>
            <select name="status">
                <option value="">All Status</option>
                <option value="pending" ${statusFilter=='pending'?'selected':''}>Pending</option>
                <option value="confirmed" ${statusFilter=='confirmed'?'selected':''}>Confirmed</option>
                <option value="cancelled" ${statusFilter=='cancelled'?'selected':''}>Cancelled</option>
            </select>
            <button type="submit"><i class="fa fa-filter"></i> Filter</button>
            <a href="${pageContext.request.contextPath}/transactions" style="padding:6px 15px; background-color:#6c757d; color:#fff; border-radius:5px; text-decoration:none;">
		        <i class="fa fa-undo"></i> Reset
		    </a>
        </form>
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

        <div class="pagination">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&type=${typeFilter}&status=${statusFilter}&keyword=${fn:escapeXml(keyword)}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

    </section>
</main>
</body>
</html>
