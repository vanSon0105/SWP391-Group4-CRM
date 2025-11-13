<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
	:root{
      --primary:#2563eb; 
      --neutral:#6b7280; 
      --border:#e5e7eb;
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
	
	.pager {
         display: flex;
         gap: 6px;
         align-items: center;
         justify-content: flex-end;
         margin-top: 12px;
         flex-wrap: wrap;
     }

     .pager .page-btn {
         min-width: 36px;
         height: 36px;
         display: inline-flex;
         align-items: center;
         justify-content: center;
         border: 1px solid var(--border);
         border-radius: 8px;
         background: #fff;
         cursor: pointer;
     }

     .pager .page-btn[disabled] {
         opacity: .5;
         cursor: not-allowed
     }

     .pager .active {
         background: var(--primary);
         color: #fff;
         border-color: var(--primary)
     }

     .pager .info {
         margin-right: auto;
         color: var(--neutral)
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
	
	.alert-banner.success{
		background: rgba(34,197,94,.12);
		color: #166534;
	}
	.alert-banner.failed{
		background-color: #fee2e2;
		color: #b91c1c;
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
                    <a class="btn btn-add" href="${pageContext.request.contextPath}/view/admin/account/AddUser.jsp">
                        <i class="fa-solid fa-plus"></i>
                        <span>Thêm tài khoản mới</span>
                    </a>
                </div>
				
				<div style="display: flex; gap: 20px;">
	                <form class="device-search" action="account" method="get">
	                	<input type="hidden" name="action" value="search">
		                <input id="account-search" name="keyword" type="search"
		                       placeholder="Tìm theo tên, email, username..." value="${param.keyword}">
		                <button type="submit" class="btn device-btn">Tìm</button>
		            </form>
	
		            <form action="account" method="get" class="device-search">
	                    <input type="hidden" name="action" value="filter">
	                    <select name="roleId" class="btn device-btn">
	                        <option value="">-- Lọc vai trò --</option>
	                        <option value="1" ${filterRole==1 ? 'selected' : '' }>Quản trị viên</option>
	                        <option value="2" ${filterRole==2 ? 'selected' : '' }>Nhân viên</option>
	                        <option value="3" ${filterRole==3 ? 'selected' : '' }>Kỹ thuật viên</option>
	                        <option value="4" ${filterRole==4 ? 'selected' : '' }>Khách hàng</option>
	                    </select>
	                    <button type="submit" class="btn device-btn">Lọc</button>
	                </form>
	             </div>
            </div>
        </section>

        <section class="panel" id="table-panel">
        	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2>Danh sách tài khoản</h2>
                <c:if test="${not empty mess}">
	                <div class="alert-banner ${type}">
						${mess}
					</div>
                </c:if>
        	</div>

            <div class="table-wrapper">
                <c:if test="${not empty users}"> 
                    <table class="device-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên đăng nhập</th>
                                <th>Email</th>
                                <th>Họ tên</th>
                                <th>Số điện thoại</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<c:forEach items="${users}" var="u">
									<tr style="${u.status == 'inactive' ? 'background: #f9919194;' : ''}">
	                            	<td>${u.id}</td>
                                    <td>${u.username}</td>
                                    <td>${u.email}</td>
                                    <td>${u.fullName}</td>
                                    <td>${empty u.phone ? '-' : u.phone}</td>
	                                <td>
                                        <c:choose>
                                            <c:when test="${u.roleId == 1}">Quản trị viên</c:when>
                                            <c:when test="${u.roleId == 2}">Nhân viên</c:when>
                                            <c:when test="${u.roleId == 3}">Kỹ thuật viên</c:when>
                                            <c:otherwise>Khách hàng</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="${u.status == 'active' ? 'status-active' : 'status-inactive'}">
                                            ${u.status == 'active' ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </td>
                                    <td style="display: flex; gap: 5px;">
    <a href="account?action=detail&id=${u.id}" class="btn device-btn">Xem</a>

    <c:if test="${u.status == 'active'}">
        <c:if test="${u.username != currentUsername && !(currentRole == 1 && (u.roleId+0) eq 1)}">
            <a class="btn device-btn" href="account?action=edit&id=${u.id}">Sửa</a>
            <a class="btn device-remove"
               href="account?action=delete&id=${u.id}"
               onclick="return confirm('Bạn có chắc muốn khóa người dùng này?');">
               Xóa
            </a>
        </c:if>
    </c:if>
    <c:if test="${u.status == 'inactive'}">
        <a class="btn device-btn"
           href="account?action=activate&id=${u.id}"
           onclick="return confirm('Bạn có muốn kích hoạt lại người dùng này?');">
           Mở khóa
        </a>
    </c:if>
	</td>



	                            </tr>
	                        </c:forEach>
                        </tbody>
                    </table>
               </c:if>

               <c:if test="${empty users}">
                   <table class="device-table"> 
                   		<tbody>
	                   		<tr>
						        <td colspan="8" style="text-align: center; border: none;">
						            Không tìm thấy người dùng
						        </td>
						    </tr>
					    </tbody>
					</table>
               </c:if>
               <p style="margin-top:12px; color:#6b7280; text-align: center;">
                   Tổng số người dùng: <strong>${total}</strong>
               </p>
            </div>
         </section>
         
         <div class="pagination-pills" style="padding-bottom: 20px;">	 
				    <c:choose>
		                 <c:when test="${currentPage > 1}">
		                     <a href="account?page=${currentPage - 1}">&#10094;</a>
		                 </c:when>
		                 <c:otherwise>
				            <a class="disabled">&#10094;</a>
				        </c:otherwise>
		             </c:choose>
				
				    <c:forEach var="i" begin="1" end="${totalPages}">
				      <a class="${i == currentPage ? 'active' : ''}"
				         href="account?page=${i}">${i}</a>
				    </c:forEach>
				    
				    <c:choose>
		                 <c:when test="${currentPage > 1}">
		                     <a href="account?page=${currentPage + 1}">&#10095;</a>
		                 </c:when>
		                 <c:otherwise>
				            <a class="disabled">&#10095;</a>
				        </c:otherwise>
		             </c:choose>
		 </div>
         
    </main>
</body>
</html>
