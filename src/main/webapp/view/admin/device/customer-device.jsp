<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý thiết bị khách hàng</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
    crossorigin="anonymous"/>
</head>
<body class="management-page device-management">
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>

    <main class="sidebar-main">
        <section class="panel">
            <h2>Danh sách khách hàng</h2>
            <div class="table-wrapper">
                <table class="device-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${customers}">
                            <tr>
                                <td>${customer.id}</td>
                                <td>${customer.fullName}</td>
                                <td>${customer.email}</td>
                                <td>${customer.phone}</td>
                                <td>
                                    <form action="customer-devices" method="get">
                                        <input type="hidden" name="customerId" value="${customer.id}"/>
                                        <button type="submit" class="btn device-btn">Xem thiết bị</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

		<c:if test="${not empty selectedCustomer}">
	        <section class="panel" style="margin-top: 30px;">
	            <h2>Thiết bị của ${selectedCustomer.fullName}</h2>
	            <div class="table-wrapper">
	                <table class="device-table">
	                    <thead>
	                        <tr>
	                            <th>Mã Seri</th>
	                            <th>Tên thiết bị</th>
	                            <th>Trạng thái kho</th>
	                            <th>Bảo hành</th>
	                            <th>Vấn đề</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <c:forEach var="device" items="${devices}">
	                            <tr>
	                                <td>${device.serialNumber}</td>
	                                <td>${device.deviceName}</td>
	                                <td>${device.status}</td>
	                                <td>
	                                    <c:if test="${device.hasWarranty}">
	                                       <a href="${pageContext.request.contextPath}/warranty-details?id=${device.warrantyCardId}" class="btn device-btn">Xem</a>
	                                    </c:if>
	                                    <c:if test="${!device.hasWarranty}">
	                                        N/A
	                                    </c:if>
	                                </td>
	                                <td>
	                                    <c:if test="${device.hasIssue}">
	                                        <a href="admin-issue-detail?id=${device.issueId}" class="btn device-btn">Xem</a>
	                                    </c:if>
	                                    <c:if test="${!device.hasIssue}">
	                                        Không có
	                                    </c:if>
	                                </td>
	                            </tr>
	                        </c:forEach>
	                    </tbody>
	                </table>
	            </div>
	        </section>
       	</c:if>
    </main>
</body>
</html>
