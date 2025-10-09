<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="home-page">
	<header class="header">
        <h1 class="header-title">Shop88</h1>
        <div class="header-center">
            <div class="category-menu" data-category-menu>
                <button type="button" data-category-toggle>
                    <span>Danh mục</span>
                    <span aria-hidden="true">☰</span>
                </button>
                <div class="category-panel" data-category-panel>
                    <a href="device-catalog.jsp">Thiết bị</a>
                    <a href="device-detail.jsp">Thông tin thiết bị</a>
                    <a href="checkout.jsp">Thanh toán</a>
                    <a href="order-tracking.jsp">Đơn hàng</a>
                    <a href="customer-portal.jsp">Lịch sử</a>
                </div>
            </div>
            <form class="search-bar" action="#" method="get">
                <label for="search" class="sr-only"></label>
                <input id="search" name="search" type="search" placeholder="Tìm thiết bị, linh kiện, ...">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>
        <div class="header-bottom">
            <a href="../authentication/login.jsp" class="order-btn login-btn"><i class="fa-solid fa-user"></i></a>
            <a href="../homepage/cart.jsp" class="order-btn"><i class="fa-solid fa-cart-shopping"></i>Sản phẩm</a>
        </div>
    </header>
</body>
</html>