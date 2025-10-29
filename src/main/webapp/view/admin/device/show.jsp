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
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
	.device-btn{
	    color: black !important;
	}
	.device-management .pagination-pills {
	    display: flex;
	    justify-content: center;
	    gap: 10px;
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

	body .panel h2{
		margin-bottom: 0 !important;
	}
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
                        <a class="btn btn-add" href="device-add">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm thiết bị</span>
                        </a>
                    </div>
                    <form class="device-search" action="device-show" method="get">
		                <label for="device-search" class="sr-only"></label>
		                <input id="device-search" name="key" type="search" placeholder="Tìm theo mã, tên thiết bị . . ." value="${param.key}">
		                
		                <select class="btn device-btn" name="categoryId">
					        <option value="0">Tất cả danh mục</option>
					        <c:forEach var="c" items="${listCategories}">
					            <option value="${c.id}" ${selectedCategory == c.id ? 'selected' : ''}>${c.name}</option>
					        </c:forEach>
					    </select>
					    
					    <select class="btn device-btn" name="sortBy">
					        <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>Sắp xếp theo ID</option>
					        <option value="price" ${param.sortBy == 'price' ? 'selected' : ''}>Sắp xếp theo giá</option>
					    </select>
					
					    <select class="btn device-btn" name="order">
					        <option value="asc" ${param.order == 'asc' ? 'selected' : ''}>Tăng dần</option>
					        <option value="desc" ${param.order == 'desc' ? 'selected' : ''}>Giảm dần</option>
					    </select>
					    
		                <button class="btn device-btn" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Search</button>
		            	<a href="device-show" class="btn device-btn">Reset</a>
		            </form>
                </div>
            </section>

            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách thiết bị</h2>
	                <c:if test="${not empty mess}">
	                	<span style="color: red;font-size: 1.5rem;">${mess}</span>	
	                </c:if>	

	                <c:if test="${not empty listDeviceSerials || empty listDevices}">
	                	<a class="btn device-btn" href="device-show#table-panel">Quay lại</a>       
	                </c:if>	     
  
            	</div>
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
		                            <tr style="<c:if test="${s.status == 'discontinued'}"> background: #f9919194; </c:if>">
		                            	<td>${s.id}</td>
			                            <td><img class="device-thumb" src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}" alt="Anh thiet bi"></td>
		                                <td>${s.name}</td>
		                                <td>${s.category.name}</td>
		                                <td>
		                                	<fmt:formatNumber value="${s.price}" type="number"/> VNĐ
		                                </td>
		                                <td>${s.device_inventory}</td>
		                                <td><span class="device-status"></i>${s.status}</span></td>
		                                <td class="device-show-actions">
		                                    <a class="btn device-btn" href="device-view?id=${s.id}">Xem</a>
		                                    <a class="btn device-btn" href="device-serials?id=${s.id}#device-serial">Xem Serials</a>
		                                    <c:if test="${s.status == 'active'}">
		                                    	<a class="btn device-btn" href="device-update?id=${s.id}">Sửa</a>
		                                    	<a class="btn device-remove" href="device-delete?id=${s.id}">Xóa</a>
		                                    </c:if>
		                                    <c:if test="${s.status == 'discontinued'}">
		                                    	<a class="btn device-remove" href="device-active?id=${s.id}">Active</a>
		                                    </c:if>
		                                </td>
		                            </tr>
		                          </c:forEach>
	                        </tbody>
	                    </table>
                   </c:if>
                   <p style="margin-top:12px; color:#6b7280; text-align: center;">Tổng số thiết bị: <strong>${totalDevices}</strong></p>
                   
                   <c:if test="${empty listDevices && empty listDeviceSerials}">
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
                   
                   <c:if test="${not empty listDeviceSerials}"> 
                    <table class="device-table" id="device-serial">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Serial No</th>
                                <th>Stock Status</th>
                                <th>Status</th>
                                <th>Import Date</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:forEach items="${listDeviceSerials}" var="s">
	                            <tr style="<c:if test="${s.status == 'discontinued'}"> background: #f9919194; </c:if>">
	                            	<td>${s.id}</td>
	                                <td>${s.serial_no}</td>
	                                <td>${s.stock_status}</td>
	                                <td>${s.status}</td>
	                                <td>${s.import_date}</td>
	                            </tr>
	                          </c:forEach>
                        </tbody>
                    </table>
                   </c:if>
                </div>
             </section>
               <div class="pagination-pills">
	           	<c:choose>
			        <c:when test="${currentPage > 1}">
			            <a href="device-show?page=${currentPage - 1}&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel">&#10094;</a>
			        </c:when>
			        <c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
			    </c:choose>
			    
			    <c:if test="${totalPages >= 10}">
				  <c:set var="start" value="${currentPage - 1}" />
				  <c:set var="end" value="${currentPage + 1}" />
				
				  <c:if test="${start < 1}">
				    <c:set var="start" value="1" />
				  </c:if>
				  
				  <c:if test="${end > totalPages}">
				    <c:set var="end" value="${totalPages}" />
				  </c:if>
				
				  <c:if test="${start > 1}">
				    <a href="device-show?page=1#&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="device-show?page=${i}&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel"
				       class="${i == currentPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalPages}">
				    <span>…</span>
				    <a href="device-show?page=${totalPages}&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel">
				      ${totalPages}
				    </a>
				  </c:if>
				</c:if>
            	
            	<c:if test="${totalPages < 10}">
	            	<c:forEach var="i" begin="1" end="${totalPages}">
	            		<a href="device-show?page=${i}&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel"
	               		class="${i == currentPage ? 'active' : ''}">${i}</a>
	        		</c:forEach>           	
            	</c:if>
            	
            	<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href = "device-show?page=${currentPage + 1}&key=${param.key}&categoryId=${selectedCategory}&sortBy=${param.sortBy}&order=${param.order}#table-panel">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
            </div>
        </main>
</body>
</html>
