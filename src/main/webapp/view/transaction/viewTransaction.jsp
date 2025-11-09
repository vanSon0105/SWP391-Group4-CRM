<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi tiết giao dịch</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<style>
.detail-panel { 
    max-width: 900px; 
    margin: 30px auto; 
    padding: 25px; 
    border: 1px solid #e0e0e0; 
    border-radius: 12px; 
    background: #fff; 
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

.detail-panel .info div { 
    flex: 1 1 300px; 
    background: #f9f9f9; 
    padding: 12px 15px; 
    border-radius: 8px; 
    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
    font-size: 15px;
}

.device-table { 
    width: 100%; 
    border-collapse: collapse; 
    margin-top: 15px; 
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.device-table th, .device-table td { 
    border: 1px solid #e0e0e0; 
    padding: 12px 10px; 
    text-align: center; 
    font-size: 14px;
}

.device-table th { 
    background-color: #f3f4f6; 
    font-weight: 600; 
    color: #374151;
}

.device-table tbody tr:nth-child(even) { 
    background-color: #f9fafb; 
}

.device-table tbody tr:hover { 
    background-color: #e0f2fe; 
    transition: 0.3s; 
}

.btn-back { 
    display: inline-block; 
    margin-top: 20px; 
    padding: 10px 18px; 
    background: #3b82f6; 
    color: #fff; 
    border-radius: 8px; 
    text-decoration: none; 
    font-weight: 500; 
    box-shadow: 0 4px 8px rgba(59, 130, 246, 0.3);
    transition: all 0.2s ease;
}

.btn-back:hover { 
    background: #2563eb; 
    box-shadow: 0 6px 12px rgba(37, 99, 235, 0.4);
}

@media (max-width: 768px) {
    .detail-panel .info { flex-direction: column; }
}
</style>
</head>
<body class="management-page sidebar-collapsed">
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>
<jsp:include page="../admin/common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="detail-panel">
        <h2>Chi tiết giao dịch #${transaction.id}</h2>
        <div class="info">
            <div><strong>Loại:</strong> <c:out value="${transaction.type=='import' ? 'Nhập kho' : 'Xuất kho'}"/></div>
            <div><strong>Nhân viên kho:</strong> <c:out value="${transaction.storekeeperName}"/></div>
            <div><strong>Nhà cung cấp / Người nhận:</strong>
                <c:choose>
                    <c:when test="${transaction.type=='import'}">
                        <c:out value="${transaction.supplierName != null ? transaction.supplierName : 'N/A'}"/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${transaction.userName != null ? transaction.userName : 'N/A'}"/>
                    </c:otherwise>
                </c:choose>
            </div>
            <div><strong>Trạng thái:</strong> <c:out value="${transaction.status}"/></div>
            <div><strong>Ngày tạo:</strong> <fmt:formatDate value="${transaction.date}" pattern="yyyy-MM-dd HH:mm"/></div>
            <div><strong>Ghi chú:</strong> <c:out value="${transaction.note != null ? transaction.note : ''}"/></div>
        </div>

        <h3>Danh sách thiết bị</h3>
        <table class="device-table">
            <thead>
                <tr>
                    <th>Tên thiết bị</th>
                    <th>Số lượng</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty transaction.details}">
                        <c:forEach var="d" items="${transaction.details}">
                            <tr>
                                <td><c:out value="${d.deviceName}"/></td>
                                <td><c:out value="${d.quantity}"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="2">Không có thiết bị</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <a href="${pageContext.request.contextPath}/transactions" class="btn-back">
            <i class="fa fa-arrow-left"></i> Quay lại
        </a>
    </section>
</main>
</body>
</html>
