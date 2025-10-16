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
                        <a class="btn btn-add" href="category-add">
                            <i class="fa-solid fa-plus"></i>
                            <span>Thêm Danh Mục</span>
                        </a>
                    </div>
                    <form class="device-search" action="category-show" method="get">
		                <label for="category-search" class="sr-only"></label>
		                <input id="category-search" name="key" type="search" placeholder="Tìm theo tên danh mục . . ." value="${param.key}">
		                
		                <select class="btn device-btn" name="categoryId">
					        <option value="0">Tất cả danh mục</option>
					        <c:forEach var="c" items="${listCategories}">
					            <option value="${c.id}" ${selectedCategory == c.id ? 'selected' : ''}>${c.name}</option>
					        </c:forEach>
					    </select>
					    
		                <button class="btn device-btn" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Search</button>
		            </form>
                </div>
            </section>

            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách danh mục</h2>
	                <c:if test="${not empty mess}">
	                	<span style="color: red;font-size: 1.5rem;">${mess}</span>	
	                </c:if>	
            	</div>
                <div class="table-wrapper">
                    <c:if test="${not empty listCategories}"> 
	                    <table class="device-table">
	                        <thead>
	                            <tr>
	                                <th>ID</th>
	                                <th>Name</th>
	                                <th>Thao tác</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                        	<c:forEach items="${listCategories}" var="s">
		                            <tr>
		                            	<td>${s.id}</td>
		                                <td>${s.name}</td>
		                                <c:if test="${!s.hasDevice}">
			                                <td class="device-show-actions" style="display: inline-block;width: 100%;">
		                                    	<a class="btn device-btn" href="category-update?id=${s.id}">Sửa</a>
		                                    	<a class="btn device-remove" href="category-delete?id=${s.id}">Xóa</a>
			                                </td>
		                                </c:if>
		                            </tr>
		                          </c:forEach>
	                        </tbody>
	                    </table>
                   </c:if>
                   
                   <c:if test="${empty listCategories}">
	                   <table class="device-table"> 
	                   		<tbody>
		                   		<tr>
							        <td colspan="7" style="text-align: center; border: none;">
							            Không tìm thấy danh mục
							        </td>
							    </tr>
						    </tbody>
						</table>
                   </c:if>
                </div>
             </section>
               <div class="pagination-pills">
	           	<c:choose>
			        <c:when test="${currentPage > 1}">
			            <a href="category-show?page=${currentPage - 1}#table-panel">&#10094;</a>
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
				    <a href="category-show?page=1#&key=${param.key}#table-panel">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="category-show?page=${i}&key=${param.key}#table-panel"
				       class="${i == currentPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalPages}">
				    <span>…</span>
				    <a href="category-show?page=${totalPages}&key=${param.key}#table-panel">
				      ${totalPages}
				    </a>
				  </c:if>
				</c:if>
            	
            	<c:if test="${totalPages < 10}">
	            	<c:forEach var="i" begin="1" end="${totalPages}">
	            		<a href="category-show?page=${i}&key=${param.key}#table-panel"
	               		class="${i == currentPage ? 'active' : ''}">${i}</a>
	        		</c:forEach>           	
            	</c:if>
            	
            	<c:choose>
	                <c:when test="${currentPage < totalPages}">
	                	<a href = "category-show?page=${currentPage + 1}&key=${param.key}#table-panel">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
            </div>
        </main>
</body>
</html>