<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý nhà cung cấp</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" crossorigin="anonymous" />
<style>
.error {
	color: red;
	font-weight: 600;
	margin-bottom: 12px;
}

.message {
	color: green;
	font-weight: 600;
	margin-bottom: 12px;
}

.device-tool-container{
	width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
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
            <a class="btn btn-add" href="supplier?action=add"><i class="fa-solid fa-plus"></i> Thêm nhà cung cấp</a>
            <a href="supplier?action=trash" class="btn btn-danger">Thùng rác</a>
        </div>
        <form class="device-search" action="supplier" method="get" style="margin-top:10px;">
            <input type="hidden" name="action" value="search">
            <input name="keyword" type="search" placeholder="Tìm theo tên, email, số điện thoại..." 
                   value="${param.keyword != null ? param.keyword : ''}">
            <button type="submit" class="btn device-btn">Tìm</button>
            <a href="supplier?action=list" class="btn device-btn" style="padding:6px 10px;font-size:14px;">Reset</a>
        </form>
        <form class="device-search" action="supplier" method="get">
            <input type="hidden" name="action" value="filter">
            <label>
                <select class="btn device-btn" name="status">
                    <option value="">Tất cả</option>
                    <option value="1" ${param.status=='1'?'selected':''}>Hoạt động</option>
                    <option value="0" ${param.status=='0'?'selected':''}>Ngừng hoạt động</option>
                </select>
            </label>
            <label>
                <input class="btn device-btn" type="text" name="address" placeholder="Nhập địa chỉ" value="${param.address != null ? param.address : ''}">
            </label>
            <button class="btn device-btn" type="submit">Lọc</button>
        </form>
    </div>
    <c:if test="${not empty param.message}">
        <div class="message">${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="error">${param.error}</div>
    </c:if>
</section>
    <c:if test="${action=='list' || action=='trash' || action=='filter'}">
	    <section class="panel">
	    		<h2>Danh sách nhà cung cấp</h2>
			    <div class="table-wrapper">
			            <table class="device-table">
			                <thead>
			                    <tr>
			                        <th>ID</th><th>Tên nhà cung cấp</th><th>SĐT</th><th>Email</th><th>Địa chỉ</th><th>Thao tác</th>
			                    </tr>
			                </thead>
			                <tbody>
			                    <c:choose>
			                        <c:when test="${not empty suppliers}">
			                            <c:forEach items="${suppliers}" var="s" varStatus="status">
			                                <tr>
			                                    <td>${s.id}</td>
			                                    <td>${s.name}</td>
			                                    <td>${s.phone}</td>
			                                    <td>${s.email}</td>
			                                    <td>${s.address}</td>
			                                    <td style="white-space: nowrap;">
			                                        <c:choose>
			                                            <c:when test="${action=='trash'}">
			                                                <a href="supplier?action=restore&id=${s.id}" class="btn device-btn">Khôi phục</a>
			                                            </c:when>
			                                            <c:otherwise>
			                                                <a href="supplier?action=viewHistory&id=${s.id}" class="btn device-btn">Xem</a>
			                                                <a href="supplier?action=edit&id=${s.id}" class="btn device-btn">Sửa</a>
			                                                <a href="supplier?action=delete&id=${s.id}" class="btn device-remove" 
			                                                   onclick="return confirm('Bạn có chắc muốn dừng nhà cung cấp này?');">Xóa</a>
			                                            </c:otherwise>
			                                        </c:choose>
			                                    </td>
			                                </tr>
			                            </c:forEach>
			                        </c:when>
			                        <c:otherwise>
			                            <tr><td colspan="6" style="color:gray;">Không có dữ liệu</td></tr>
			                        </c:otherwise>
			                    </c:choose>
			                </tbody>
			            </table>
			            <p style="margin-top:12px; color:#6b7280; text-align:center;">
			            Tổng số nhà cung cấp: <strong><c:out value="${not empty suppliers ? fn:length(suppliers) : 0}" /></strong>
			        </p>
			    </div>
	    </section>
    </c:if>
    
    <c:if test="${(action=='view' || action=='viewHistory') && not empty supplier}">
	    <section class="panel">
	    	<div style="display: flex; justify-content: space-between;">
		        <h2 style="margin: 0;">Chi tiết nhà cung cấp</h2>
		        <a href="supplier?action=list" class="btn btn-secondary">Quay lại</a>	    	
	    	</div>
            <div class="device-container">
            	<table class="device-table">
            		<tbody>
            			<tr>
	                        <th>ID</th>
	                        <td>${supplier.id}</td>
	                    </tr>
	                    
	                    <tr>
	                        <th>Tên</th>
	                        <td>${supplier.name}</td>
	                    </tr>
	                    
	                    <tr>
	                        <th>SĐT</th>
	                        <td>${supplier.phone}</td>
	                    </tr>
	                    
	                    <tr>
	                        <th>Email</th>
	                        <td>${supplier.email}</td>
	                    </tr>
	                    
	                    <tr>
	                        <th>Địa chỉ</th>
	                        <td>${supplier.address}</td>
	                    </tr>
	                    
	                    <tr>
	                        <th>Trạng thái</th>
	                        <td>
	                        	<c:choose>
			                        <c:when test="${supplier.status == 1}">Hoạt động</c:when>
			                        <c:otherwise>Ngừng hoạt động</c:otherwise>
			                    </c:choose>
	                        </td>
	                    </tr>
	                </tbody>
                </table>
            </div>
	      </section>
	  </c:if>
      <c:if test="${action=='viewHistory' && not empty history}">
		  <section class="panel">
                <div class="detail-box">
                    <h2>Lịch sử cung cấp thiết bị</h2>
                    <table>
                        <thead>
                            <tr><th>#</th><th>Device ID</th><th>Tên thiết bị</th><th>Ngày</th><th>Giá</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${history}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${h.deviceId}</td>
                                    <td>${h.deviceName}</td>
                                    <td><fmt:formatDate value="${h.date}" pattern="dd/MM/yyyy" /></td>
                                    <td>${h.price}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                     </table>
                </div>
	      </section>
      </c:if>
    <c:if test="${action != 'viewHistory'}">
        <div class="pagination-pills">
               <c:choose>
		        <c:when test="${currentPage > 1}">
		            <a class="page-link" href="supplier?action=${action}&page=${currentPage-1}">&laquo;</a>
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
                        <a class="page-link" href="supplier?action=${action}&page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
               
               <c:choose>
                <c:when test="${currentPage < totalPages}">
                	<a class="page-link" href="supplier?action=${action}&page=${currentPage+1}">&raquo;</a>
            	</c:when>
            	<c:otherwise>
		            <a class="disabled">&#10095;</a>
		        </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</main>
</body>
</html>
