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
<style>
a{
	font-size: 1.5rem;
}
</style>
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
                <div class="device-summary">
                    <img src="../assets/img/${device.imageUrl }" alt="Thiết bị cần xóa">
                    <div class="device-infor">
                        <div><strong>Mã SP:</strong> <span id="device-id">${device.id}</span></div>
                        <div><strong>Tên:</strong>${device.name}</div>
                        <div><strong>Danh mục:</strong>${device.category.name}</div>
                        <div><strong>Trạng thái hiện tại: </strong>${device.status}</div>
                    </div>
                </div>
                <p>Bạn có chắc chắn muốn xóa thiết bị này khỏi danh mục bán hàng?</p>
                <div class="confirm-actions">
                    <a class="btn device-btn" href="device-view?id=${device.id}">Xem chi tiết</a>
                    <a class="btn device-btn" href="device-show">Hủy</a>
                    
                    <form method="post" action="device-delete?id=${device.id}"
        				onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
	                    <button style="width: 100%;height: 100%;" id="confirm-delete" class="btn device-btn" type="submit">
      						<i class="fa-solid fa-trash"></i><span>Xác nhận xóa</span>
    					</button>       				
        			</form>
                </div>
            </div>
            
        </section>
            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách thiết bị</h2>
	                
	                <c:if test="${not empty mess}">
		               	<span class="device-status" style="color: red;font-size: 1.5rem;text-align: right;">${mess}</span>	
		            </c:if>	
            	</div>
                <div class="table-wrapper">
            <c:if test="${not empty listDeviceSerials}">
	            <table class="device-table" id="device-serial">
	                   <thead>
	                       <tr>
	                           <th>ID</th>
	                           <th>Serial No</th>
	                           <th>Stock Status</th>
	                           <th>Status</th>
	                           <th>Import Date</th>
	                           <th></th>
	                       </tr>
	                   </thead>
	                   <tbody>
	                   	<c:forEach items="${listDeviceSerials}" var="s">
	                        <tr>
	                        	<td>${s.id}</td>
	                            <td>${s.serial_no}</td>
	                            <td>${s.stock_status}</td>
	                            <td><span style="<c:if test="${s.status == 'discontinued'}"> background: #f9919194; </c:if>" class="device-status"></i>${s.status}</span></td>
	                            <td>${s.import_date}</td>
	                            
	                            <c:if test="${s.stock_status == 'in_stock' or s.stock_status == 'out_stock'}">
		                            <td>
		                            	<form method="post" action="device-serials"
										      onsubmit="return confirm('Bạn chắc chắn muốn xóa serial này?');">
										    <input type="hidden" name="id" value="${s.id}">
										    <input type="hidden" name="deviceId" value="${device.id}">
										    <c:if test="${s.status == 'active'}">
											    <button class="btn device-btn" type="submit">
											        <i class="fa-solid fa-trash"></i><span>Xóa</span>
											    </button>
										    </c:if>
										    
										    <c:if test="${s.status == 'discontinued'}">
											    <a class="btn device-remove" href="device-serials?id=${device.id}&sid=${s.id}">Active</a>
										    </c:if>
										</form>
		                            </td>
	                            </c:if>
	                        </tr>
	                      </c:forEach>
	                   </tbody>
	               </table>
               </c:if>	
               
               <c:if test="${empty listDeviceSerials}">
                  <table class="device-table"> 
                  		<tbody>
	                   		<tr>
						        <td colspan="7" style="text-align: center; border: none;">
						            Không tìm thấy thiết bị
						        </td>
						    </tr>
				    	</tbody>
					</table>
                </c:if>
        	</div>
        </section>
    </main>
</body>
</html>