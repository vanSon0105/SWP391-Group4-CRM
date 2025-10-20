<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
	<header class="topbar">
        <div class="topbar-left">
        	<h1>
	            <a href="${pageContext.request.contextPath}/home">TechShop</a>        	
        	</h1>
            <button class="sidebar-toggle" aria-label="Mở/đóng menu" aria-expanded="false"><i
                    class="fa-solid fa-bars-staggered"></i></button>
            <div class="top-search">
                <input type="search" placeholder="Tìm kiếm trang, báo cáo, hoặc đơn hàng..."
                    aria-label="Tìm kiếm">
            </div>
        </div>
        <div class="topbar-right">
            <div class="user-area">
                <a href=""><i class="fa-solid fa-gear"></i></a>
                <a href=""><i class="fa-solid fa-user"></i></a>
            </div>
        </div>
    </header>
</body>
</html>