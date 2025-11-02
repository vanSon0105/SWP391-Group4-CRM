<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
</head>
<body class="management-page device-management">
<jsp:include page="../common/sidebar.jsp"></jsp:include>
<jsp:include page="../common/header.jsp"></jsp:include>
<main class="sidebar-main">
	<c:if test="${permissions != null && permissions.contains('DEVICE_MANAGEMENT')}">
		<section class="panel">
	        <a class="btn device-btn" href="device-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh
	                sách</span></a>
	    </section>
	</c:if>
	
	<c:if test="${permissions != null && permissions.contains('DEVICE_MANAGEMENT_NODELETE')}">
		<section class="panel">
	        <a class="btn device-btn" href="des-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh
	                sách</span></a>
	    </section>
	</c:if>

    <section class="panel">
        <div class="device-detail">
            <div class="device-img">
                <img src="${pageContext.request.contextPath}/assets/img/device/${deviceDetail.imageUrl}" alt="Anh thiet bi">
            </div>
            <div class="device-container">
	            <table class="device-table">
	                <tbody>
	                    <tr>
	                        <th>ID</th>
	                        <td id="device-id">${deviceDetail.id}</td>
	                    </tr>
	                    <tr>
	                        <th>Tên thiết bị</th>
	                        <td id="device-name">${deviceDetail.name}</td>
	                    </tr>
	                    <tr>
	                        <th>Danh mục</th>
	                        <td id="device-category">${deviceDetail.category.name}</td>
	                    </tr>
	                    <tr>
	                        <th>Giá bán</th>
	                        <td id="device-price">
	                        	<fmt:formatNumber value="${deviceDetail.price}" type="number" /> VND
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>Đơn vị</th>
	                        <td id="device-price">${deviceDetail.unit}</td>
	                    </tr>
	                    <tr>
	                        <th>Nổi bật</th>
	                        <td id="device-price">${deviceDetail.isFeatured}</td>
	                    </tr>
	                    <tr>
	                        <th>Mô tả</th>
	                        <td id="device-stock">${deviceDetail.desc}</td>
	                    </tr>
	                    <tr>
	                        <th>Ngày tạo</th>
	                        <td id="device-description">${deviceDetail.created_at}</td>
	                    </tr>
	                </tbody>
	            </table>
	            <c:if test="${permissions != null && permissions.contains('DEVICE_MANAGEMENT')}">
		            <div class="device-action">
		                <a id="edit-link" class="btn device-btn" href="device-update?id=${deviceDetail.id}">
		                    <i class="fa-solid fa-pen"></i><span>Sửa thông tin</span>
		                </a>
		                <a id="delete-link" class="btn" href="device-remove?id=${deviceDetail.id}">
		                    <i class="fa-solid fa-trash"></i><span>Xóa thiết bị</span>
		                </a>
		            </div>
	            </c:if>
            </div>
        </div>
    </section>
</main>
</body>
</html>