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
	    padding: 0 0 20px 0;
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
	
	.modal-overlay {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.5);
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background-color: #fff;
        margin: auto;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        width: max-content;
        position: relative;
    }

    .modal-close {
        color: #aaa;
        position: absolute;
        top: -5px;
        right: 5px;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        padding: 10px;
    }

    .modal-content h2 {
        margin-top: 0;
        color: #1f2d3d;
        border-bottom: 1px solid #eef2f6;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    
    .disabled{
		background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
	    color: #f8fafc;
	    border-color: transparent;
	    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
	    cursor: not-allowed;
	    pointer-events: none;
	    opacity: 0.5;
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
                        <a class="btn btn-add" href="des-add?id=${deviceId}&action=1">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm device serials</span>
                        </a>
                    </div>
                    
                    <form class="device-search" action="des-show" method="get">
                    	<input type="hidden" name="id" value="${deviceId}">
		                <input id="device-search" name="key" type="search" placeholder="Tìm theo mã, tên thiết bị . . ." value="${param.key}">
		                <label for="device-search" class="sr-only"></label>
		                
					    
					    <select class="btn device-btn" name="sortBy" onchange="this.form.submit()">
					        <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>Sắp xếp theo ID</option>
					        <option value="serial_no" ${param.sortBy == 'serial_no' ? 'selected' : ''}>Sắp xếp theo Serial</option>
					        <option value="import_date" ${param.sortBy == 'import_date' ? 'selected' : ''}>Sắp xếp theo Ngày nhập</option>
					        <option value="status" ${param.sortBy == 'status' ? 'selected' : ''}>Sắp xếp theo trạng thái</option>
					    </select>
					
					    <c:choose>
						    <c:when test="${param.sortBy == 'status'}">
						        <select class="btn device-btn" name="order">
						            <option value="active" ${param.order == 'active' ? 'selected' : ''}>Active</option>
						            <option value="discontinued" ${param.order == 'discontinued' ? 'selected' : ''}>Inactive</option>
						        </select>
						    </c:when>
						    
						    <c:otherwise>
						        <select class="btn device-btn" name="order">
						            <option value="asc" ${param.order == 'asc' ? 'selected' : ''}>Tăng dần</option>
						            <option value="desc" ${param.order == 'desc' ? 'selected' : ''}>Giảm dần</option>
						        </select>
						    </c:otherwise>
						</c:choose>
					    
					    <c:choose>
						    <c:when test="${param.sortBy == 'status'}">
				                <button class="btn device-btn" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Lọc</button>						        
						    </c:when>
						    
						    <c:otherwise>
						        <button class="btn device-btn" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Search</button>
						    </c:otherwise>
						</c:choose>
		            	<a href="de-show" class="btn device-btn">Reset</a>
		            </form>
                </div>
            </section>

            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách device serials</h2>
	                <c:if test="${not empty mess}">
	                	<span class="device-status" style="color: red;font-size: 1.5rem;">${mess}</span>	
	                </c:if>	
	                <a class="btn device-btn" href="de-show#table-panel">Quay lại</a>          
            	</div>

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
                   
                   <c:if test="${not empty listDeviceSerials}">
                    <table class="device-table" id="device-serial">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Serial No</th>
                                <th>Trạng thái tồn kho</th>
                                <th>Trạng thái</th>
                                <th>Ngày nhập</th>
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
			            <a href="des-show?id=${deviceId}&page=${currentPage - 1}&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel">&#10094;</a>
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
				    <a href="des-show?id=${deviceId}&page=1#&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="des-show?id=${deviceId}&page=${i}&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel"
				       class="${i == currentPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalPages}">
				    <span>…</span>
				    <a href="des-show?id=${deviceId}&page=${totalPages}&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel">
				      ${totalPages}
				    </a>
				  </c:if>
				</c:if>
            	
            	<c:if test="${totalPages < 10}">
	            	<c:forEach var="i" begin="1" end="${totalPages}">
	            		<a href="des-show?id=${deviceId}&page=${i}&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel"
	               		class="${i == currentPage ? 'active' : ''}">${i}</a>
	        		</c:forEach>           	
            	</c:if>
            	
            	<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href = "des-show?id=${deviceId}&page=${currentPage + 1}&key=${param.key}&sortBy=${param.sortBy}&order=${param.order}#table-panel">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
            </div>
        </main>
        
        <c:if test="${addDeviceSerials}">
		    <div id="taskDetailModal" class="modal-overlay">
		        <div class="modal-content">
		            <a class="modal-close" href="des-show?id=${deviceId}">&times;</a>
		            <h2>Thêm thiết bị</h2>
			        <div class="task-detail-grid">
			        	<form class="device-form" action="des-add" method="post">
			        		<input name="id" value="${device.id}" hidden>
		                    <div class="form-field">
		                        <label for="name">Tên device serials</label>
		                        <input id="name" name="name" readonly value="${device.name}">
		                    </div>
		                    
		                    <div class="form-field">
		                        <label for="quantity">Số lượng device serials</label>
		                        <input type="number" id="quantity" name="quantity" min="1" max="100">
		                    </div>
		
			                <div class="form-actions">
			                    <a class="btn ghost" href="des-show?id=${device.id}">Hủy</a>
			                    <button class="btn primary" type="submit">Thêm</button>
			                </div>
			            </form>      
			        </div>
		        </div>
		    </div>
		    
		    <script>
		    	document.addEventListener("DOMContentLoaded", function() {
				    var modal = document.getElementById("taskDetailModal");
				    if (!modal) {
				        return;
				    }
					modal.style.display = "flex";
		
					window.addEventListener('click', function(event) {
					    if (event.target == modal) {
					        modal.style.display = "none";
					    }
					});
				});
			</script>
		</c:if>
</body>
</html>
