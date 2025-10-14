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
            <a class="btn device-btn" href="device-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        </section>

        <section class="panel">
            <div class="device-remove-container">
                <div class="danger-box">
                    <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác. Thiết bị và dữ liệu liên quan sẽ bị ảnh hưởng.
                </div>
                <div class="device-summary">
                    <img src="../assets/img/${device.imageUrl }" alt="Thiết bị cần xóa">
                    <div class="device-infor">
                        <div><strong>Mã SP:</strong> <span id="device-id">${device.id}</span></div>
                        <div><strong>Tên:</strong>${device.name}</div>
                        <div><strong>Danh mục:</strong>${device.category.name}</div>
                        <div><strong>Trạng thái hiện tại:</strong>${device.status}</div>
                    </div>
                </div>
                <p>Bạn có chắc chắn muốn xóa thiết bị này khỏi danh mục bán hàng?</p>
                <div class="confirm-actions">
                    <a class="btn device-btn" href="device-view?id=AC-SH-12000">Xem chi tiết</a>
                    <a class="btn device-btn" href="device-show">Hủy</a>
                    
                    <form method="post" action="device-delete?id=${device.id}"
        				onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
	                    <button id="confirm-delete" class="btn device-btn" type="submit">
      						<i class="fa-solid fa-trash"></i><span>Xác nhận xóa</span>
    					</button>       				
        			</form>
                </div>
            </div>
            
        </section>
            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách thiết bị</h2>	
	                <c:if test="${not empty listDeviceSerials}"> 
	                	<a class="btn device-btn" href="device-show#table-panel">Quay lại</a>            
	                </c:if>	
            	</div>
                <div class="table-wrapper">
            
            <table class="device-table" id="device-serial">
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
        	</div>
        </section>
    </main>
</body>
</html>