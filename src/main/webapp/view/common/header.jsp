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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/error.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="home-page">
	<header class="header">
        <h1 class="header-title">
        	<a href="home" style="color: #fff;">TechShop</a>
        </h1>
        <div class="header-center">
            <div class="category-menu" data-category-menu>
                <button class="search-bar-btn" type="button" data-category-toggle>
                    <span>Danh mục</span>
                    <span aria-hidden="true">☰</span>
                </button>
                <div class="category-panel" data-category-panel>
                    <a href="device-page">Thiết bị</a>
                    <a href="device-detail.jsp">Thông tin thiết bị</a>
                    <a href="checkout.jsp">Thanh toán</a>
                    <a href="order-tracking.jsp">Đơn hàng</a>
                    <a href="customer-portal.jsp">Lịch sử</a>
                </div>
            </div>
            <form class="search-bar" action="device-page" method="get">
                <label for="search" class="sr-only"></label>
                <input id="search" name="key" type="search" placeholder="Tìm thiết bị, linh kiện, ..." value="${param.key}">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>
        <div class="header-bottom">
            <form action="login" method="post" style="display:inline;">
			    <button type="submit" class="order-btn login-btn">
			        <i class="fa-solid fa-user"></i>
			    </button>
			</form>
            <a href="cart" class="order-btn"><i class="fa-solid fa-cart-shopping"></i>Sản phẩm</a>
        </div>
    </header>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var slider = document.querySelector('[data-hero-slider]');
            if (!slider) return;

            var track = slider.querySelector('.banner-promos-track');
            var cards = Array.from(track.children);
            if (!cards.length) return;

            var prevBtn = slider.querySelector('[data-hero-direction="prev"]');
            var nextBtn = slider.querySelector('[data-hero-direction="next"]');
            var dots = [];
            var currentIndex = 0;
            var gap = parseFloat(getComputedStyle(track).gap) || 0;
            var timer = null;
            var delay = 2000;

            function getVisibleCount() {
                return window.innerWidth >= 1100 ? 2 : 1;
            }

            function maxIndex() {
                return Math.max(cards.length - getVisibleCount(), 0);
            }

            function clamp(index) {
                var max = maxIndex();
                if (index < 0) return max;
                if (index > max) return 0;
                return index;
            }

            function updateDots() {
                if (!dots.length) return;
                dots.forEach(function (dot, i) {
                    dot.classList.toggle('active', i === currentIndex);
                    dot.disabled = i === currentIndex;
                });
            }

            function updateSlider() {
                var cardWidth = cards[0].getBoundingClientRect().width;
                var offset = currentIndex * (cardWidth + gap);
                track.style.transform = 'translateX(-' + offset + 'px)';
                updateDots();
            }

            function stop() {
                if (timer) {
                    clearInterval(timer);
                    timer = null;
                }
            }

            function start() {
                stop();
                if (maxIndex() <= 0) return;
                timer = setInterval(function () {
                    currentIndex = clamp(currentIndex + 1);
                    updateSlider();
                }, delay);
            }


            if (prevBtn) {
                prevBtn.addEventListener('click', function () {
                    currentIndex = clamp(currentIndex - 1);
                    updateSlider();
                    start();
                });
            }

            if (nextBtn) {
                nextBtn.addEventListener('click', function () {
                    currentIndex = clamp(currentIndex + 1);
                    updateSlider();
                    start();
                });
            }
        });


        document.addEventListener('DOMContentLoaded', function () {
            var menu = document.querySelector('[data-category-menu]');
            if (!menu) return;

            var toggleBtn = menu.querySelector('[data-category-toggle]');
            var panel = menu.querySelector('[data-category-panel]');
            if (!toggleBtn || !panel) return;

            toggleBtn.addEventListener('click', function () {
                panel.classList.toggle('show');
            });

            document.addEventListener('click', function (event) {
                if (!menu.contains(event.target)) {
                    panel.classList.remove('show');
                }
            });
        });
    </script>
</body>
</html>