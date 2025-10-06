<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop88</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="shop-page cart-page">
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

    <main>
        <section class="cart-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Bảo hành</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>NovaCore X15</td>
                        <td>32.990.000đ</td>
                        <td>1</td>
                        <td>Mặc định 24 tháng</td>
                        <td>32.990.000đ</td>
                    </tr>
                    <tr>
                        <td>Gói bảo hành Premium</td>
                        <td>3.200.000đ</td>
                        <td>1</td>
                        <td>Gia hạn +12 tháng onsite</td>
                        <td>3.200.000đ</td>
                    </tr>
                    <tr>
                        <td>Kit sửa TV 55"</td>
                        <td>2.850.000đ</td>
                        <td>2</td>
                        <td>Bảo hành linh kiện 12 tháng</td>
                        <td>5.700.000đ</td>
                    </tr>
                </tbody>
            </table>
        </section>
        <section class="cart-summary">
            <h2 style="font-size:24px; color:#0f172a;">Tổng kết</h2>
            <div class="totals">
                <span>Tạm tính: 41.890.000đ</span>
                <span>Giảm giá: -2.000.000đ (Flash Sale)</span>
                <span>Phí vận chuyển: 0đ</span>
                <span><strong>Tổng cộng: 39.890.000đ</strong></span>
            </div>
            <div class="cta">
                <a href="checkout.html">Tiến hành thanh toán</a>
                <a href="product-catalog.html">Tiếp tục mua sắm</a>
            </div>
        </section>
    </main>
    <footer>
        NovaCare Shop · Thanh toán an toàn với chứng chỉ PCI DSS.
    </footer>
</body>
</html>
