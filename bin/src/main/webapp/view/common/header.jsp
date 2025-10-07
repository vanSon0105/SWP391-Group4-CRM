<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
                    <a href="device-catalog.html">Thiết bị</a>
                    <a href="device-detail.html">Thông tin thiết bị</a>
                    <a href="checkout.html">Thanh toán</a>
                    <a href="order-tracking.html">Đơn hàng</a>
                    <a href="customer-portal.html">Lịch sử</a>
                </div>
            </div>
            <form class="search-bar" action="#" method="get">
                <label for="search" class="sr-only"></label>
                <input id="search" name="search" type="search" placeholder="Tìm thiết bị, linh kiện, ...">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>
        <div class="header-bottom">
            <a href="login.html" class="order-btn login-btn"><i class="fa-solid fa-user"></i></a>
            <a href="cart.html" class="order-btn"><i class="fa-solid fa-cart-shopping"></i>Sản phẩm</a>
        </div>
    </header>
</body>
</html>