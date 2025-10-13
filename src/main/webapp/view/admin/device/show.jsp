<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	 <main class="sidebar-main">
            <section class="panel">
                <div class="device-toolbar">
                    <div class="device-toolbar-actions">
                        <a class="btn btn-add" href="device-add.html">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm thiết bị</span>
                        </a>
                    </div>
                    <div class="device-search">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                        <input id="device-search" type="search" placeholder="Tìm theo mã, tên thiết bị, danh mục..."
                            aria-label="Tìm kiếm thiết bị">
                    </div>
                </div>
            </section>

            <section class="panel">
                <h2>Danh sách thiết bị</h2>
                <div class="table-wrapper">
                    <c:if test="${not empty listDevices}"> 
                    <table class="device-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Ảnh</th>
                                <th>Tên thiết bị</th>
                                <th>Danh mục</th>
                                <th>Giá</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:forEach items="${listDevices}" var="s">
	                            <tr>
	                            	<td>${s.id}</td>
	                                <td><img class="device-thumb" src="../assets/img/${s.imageUrl}" alt=""></td>
	                                <td>${s.name}</td>
	                                <td>${s.category.name}</td>
	                                <td>
	                                	<fmt:formatNumber value="${s.price}" type="number"/> VNĐ
	                                </td>
	                                <td>${s.device_inventory}</td>
	                                <td><span class="device-status"></i>${s.status}</span></td>
	                                <td class="device-show-actions">
	                                    <a class="btn device-btn" href="device-view?id=${s.id}">Xem</a>
	                                    <a class="btn device-btn" href="device-serials?id=${s.id}">Xem Serials</a>
	                                    <a class="btn device-btn" href="device-edit.html?id=AC-SH-12000">Sửa</a>
	                                    <a class="btn device-remove" href="device-remove.html?id=AC-SH-12000">Xóa</a>
	                                </td>
	                            </tr>
	                          </c:forEach>
                        </tbody>
                    </table>
                   </c:if>
                   
                   <c:if test="${not empty listDeviceSerials}"> 
                    <table class="device-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Serial No</th>
                                <th>Status</th>
                                <th>Import Date</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:forEach items="${listDeviceSerials}" var="s">
	                            <tr>
	                            	<td>${s.id}</td>
	                                <td>${s.serial_no}</td>
	                                <td>${s.status}</td>
	                                <td>${s.import_date}</td>
	                            </tr>
	                          </c:forEach>
                        </tbody>
                    </table>
                   </c:if>
                </div>
            </section>
        </main>
</body>
</html>