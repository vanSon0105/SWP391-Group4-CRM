<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="management-page device-management">
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main class="sidebar-main">
        <section class="panel">
            <h2>Kết quả cho "<c:out value="${searchQuery}" />"</h2>
            <p>Gợi ý tối đa 5 mục ở mỗi mục</p>
        </section>
        <section class="panel">
            <h3>Thiết bị</h3>
	            <c:choose>
	                <c:when test="${empty deviceResults}">
	                    <p>Không có thiết bị phù hợp.</p>
	                </c:when>
	                <c:otherwise>
			            <div class="table-wrapper">
			            	<table class="device-table">
			            		<thead>
			            			<tr>
			            				<th>Tên thiết bị</th>
			            				<th>Hành động</th>
			                    	</tr>
			                    </thead>
			                    <tbody>
		                    		<c:forEach var="device" items="${deviceResults}"> 
				                    	<tr>
			                                <td><c:out value="${device.name}" /></td>
			                                <td><a class="btn device-btn" href="device-view?id=${device.id}">Xem chi tiết</a></td>
				                    	</tr>
			                        </c:forEach>
			                    </tbody>
	                    	</table>
			            </div>
	                </c:otherwise>
	            </c:choose>
        </section>
        <section class="panel">
            <h3>Người dùng</h3>
            <c:choose>
                <c:when test="${empty userResults}">
                    <p>Không có người dùng phù hợp.</p>
                </c:when>
                <c:otherwise>
                	<div class="table-wrapper">
		            	<table class="device-table">
		            		<thead>
		            			<tr>
		            				<th>Tên người dùng</th>
		            				<th>Email</th>
		            				<th>Hành động</th>
		                    	</tr>
		                    </thead>
		                    <tbody>
	                    		<c:forEach var="user" items="${userResults}">
			                    	<tr>
		                                <td><c:out value="${user.fullName != null ? user.fullName : user.username}" /></td>
		                                <td><c:out value="${user.email}" /></td>
		                                <td><a class="btn device-btn" href="permission-user?userId=${user.id}">Phân quyền</a></td>
			                    	</tr>
		                        </c:forEach>
		                    </tbody>
                    	</table>
		            </div>
                </c:otherwise>
            </c:choose>
        </section>
        <section class="panel">
            <h3>Đơn hàng</h3>
            <c:choose>
                <c:when test="${orderResult == null}">
                    <p>Không có đơn trùng khớp mã.</p>
                </c:when>
                <c:otherwise>
                	<div class="table-wrapper">
		            	<table class="device-table">
		            		<thead>
		            			<tr>
		            				<th>Đơn hàng</th>
		            				<th>Hành động</th>
		                    	</tr>
		                    </thead>
		                    <tbody>
	                    		<c:forEach var="user" items="${userResults}">
			                    	<tr>
		                                <td>Đơn #${orderResult.id} của khách #${orderResult.customerId}</td>
		                                <td><a class="btn device-btn" href="order-history-detail?id=${orderResult.id}">Xem chi tiết đơn</a></td>
			                    	</tr>
		                        </c:forEach>
		                    </tbody>
                    	</table>
		            </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
