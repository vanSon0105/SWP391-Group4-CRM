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

.device-infor div{
	width: max-content;
}
</style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main class="sidebar-main">
        <section class="panel" style="display: flex; align-items: center;justify-content: space-between;">
            <a class="btn device-btn" href="category-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
	        <c:if test="${not empty mess}">
	        </c:if>	
	           	<span style="color: red;font-size: 1.5rem;text-align: right;">${mess}</span>	
        </section>
        

        <section class="panel">
            <div class="device-remove-container">
                <div class="device-summary">
                    <div class="device-infor">
                        <div><strong>Mã danh mục: </strong> <span id="device-id">${category.id}</span></div>
                        <div><strong>Tên: </strong>${category.name}</div>
                    </div>
                </div>
                <p>Bạn có chắc chắn muốn xóa danh mục này khỏi danh mục bán hàng?</p>
                <div class="confirm-actions">
                    <a class="btn device-btn" href="category-show">Hủy</a>
                    
                    <form method="post" action="category-delete?id=${category.id}"
        				onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
	                    <button style="width: 100%;height: 100%;" id="confirm-delete" class="btn device-btn" type="submit">
      						<i class="fa-solid fa-trash"></i><span>Xác nhận xóa</span>
    					</button>       				
        			</form>
                </div>
            </div>
            
        </section>
    </main>
</body>
</html>