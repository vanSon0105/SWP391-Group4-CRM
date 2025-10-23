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
	
	.supplier-form {
	    display: flex;
	    flex-direction: column;
	    gap: 16px;
	    max-width: 600px;
	    background: #ffffff;
	    padding: 24px 28px;
	    border-radius: 16px;
	    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
	    margin-top: 20px;
	}
	
	.supplier-form label {
	    font-weight: 600;
	    color: #1e293b;
	    display: flex;
	    flex-direction: column;
	    font-size: 15px;
	}
	
	.supplier-form input {
	    margin-top: 6px;
	    padding: 10px 12px;
	    border: 1px solid #cbd5e1;
	    border-radius: 8px;
	    font-size: 15px;
	    color: #0f172a;
	    transition: all 0.2s ease;
	}
	
	.supplier-form input:focus {
	    outline: none;
	    border-color: #3b82f6;
	    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
	}
	
	.supplier-form .form-actions {
	    display: flex;
	    justify-content: flex-end;
	    gap: 10px;
	    margin-top: 10px;
	}
	
	.supplier-form .btn-primary {
	    background: linear-gradient(135deg, #3b82f6, #2563eb);
	    color: white;
	    padding: 8px 18px;
	    border: none;
	    border-radius: 8px;
	    cursor: pointer;
	    font-weight: 600;
	    transition: transform 0.2s ease, box-shadow 0.2s ease;
	}
	
	.supplier-form .btn-primary:hover {
	    transform: translateY(-2px);
	    box-shadow: 0 8px 18px rgba(59, 130, 246, 0.3);
	}
	
	.supplier-form .btn-secondary {
	    background: #e2e8f0;
	    color: #1e293b;
	    padding: 8px 18px;
	    border-radius: 8px;
	    text-decoration: none;
	    font-weight: 600;
	    transition: background 0.2s ease;
	}
	
	.supplier-form .btn-secondary:hover {
	    background: #cbd5e1;
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
                        <a class="btn btn-add" href="supplier?action=add">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm nhà cung cấp</span>
                        </a>
                    </div>
                    
                        
                    <form class="device-search" action="supplier" method="get">
                    	<input type="hidden" name="action" value="search">
		                <label for="supplier-search" class="sr-only"></label>
		                <input id="supplier-search" name="keyword" type="search" placeholder="Tìm theo tên, email, số điện thoại..." value="${param.keyword}">
		                <button type="submit" class="btn device-btn">Tìm</button>
		                <a href="supplier?action=list" class="btn device-btn"
                             style="padding:6px 10px;font-size:14px;">Reset</a>
		            </form>
                </div>
                
                <c:if test="${action == 'add' || action == 'edit'}">
                     <h3>
                         <c:out value="${action == 'add' ? 'Thêm mới' : 'Cập nhật'}" /> nhà cung cấp
                     </h3>

                     <form action="supplier" method="post" class="supplier-form">
                         <input type="hidden" name="action" value="${action == 'add' ? 'add' : 'update'}" />
                         
                         <c:if test="${action == 'edit'}">
                             <input type="hidden" name="id" value="${supplier.id}" />
                         </c:if>

                         <label>Tên: <input type="text" name="name" value="${supplier.name}"
                                 required></label>
                                 
                         <label>SĐT: <input type="text" name="phone"
                                 value="${supplier.phone}"></label>
                                 
                         <label>Email: <input type="email" name="email"
                                 value="${supplier.email}"></label>
                                 
                         <label>Địa chỉ: <input type="text" name="address"
                                 value="${supplier.address}"></label>

                         <div class="form-actions">
                             <button type="submit" class="btn btn-primary">Lưu</button>
                             <a href="supplier?action=list" class="btn btn-secondary">Hủy</a>
                         </div>
                     </form>
                 </c:if>
            </section>

            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách nhà cung cấp</h2>
	                
	                <c:if test="${not empty param.message}">
                        <div class="message">${param.message}</div>
                    </c:if>
                    
                    <c:if test="${not empty param.error}">
                        <div class="error">${param.error}</div>
                    </c:if>     
            	</div>
                <div class="table-wrapper">
                    <c:if test="${not empty suppliers}"> 
	                    <table class="device-table">
	                        <thead>
	                            <tr>
                                    <th>ID</th>
                                    <th>Tên nhà cung cấp</th>
                                    <th>Số điện thoại</th>
                                    <th>Email</th>
                                    <th>Địa chỉ</th>
                                    <th>Thao tác</th>
                                </tr>
	                        </thead>
	                        <tbody>
	                        	<c:forEach items="${suppliers}" var="s">
		                            <tr>
		                            	<td>${s.id}</td>
                                        <td>${s.name}</td>
                                        <td>${s.phone}</td>
                                        <td>${s.email}</td>
                                        <td>${s.address}</td>
                                        <td>
                                            <a href="supplier?action=view&id=${s.id}"
                                                class="btn device-btn">Xem</a>
                                                
	                                    	<a class="btn device-btn" href="supplier?action=edit&id=${s.id}">Sửa</a>
	                                    	
	                                    	<a class="btn device-remove" href="supplier?action=delete&id=${s.id}"
	                                    	onclick="return confirm('Bạn có chắc muốn dừng nhà cung cấp này?');" >Xóa</a>
                                        </td>
		                            </tr>
		                          </c:forEach>
	                        </tbody>
	                    </table>
                   </c:if>
                   
                   <c:if test="${empty suppliers}">
	                   <table class="device-table"> 
	                   		<tbody>
		                   		<tr>
							        <td colspan="7" style="text-align: center; border: none;">
							            Không tìm thấy nhà cung cấp
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
