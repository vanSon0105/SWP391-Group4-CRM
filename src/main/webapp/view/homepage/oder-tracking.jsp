<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi đơn & tiến trình sản phẩm - NovaCare</title>
    <link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="shop-page tracking-page">

    <!-- Header -->
    <header class="header-toolbar">
        <h1>Shop88</h1>
        <div class="header-center">
            <form class="search-bar" action="#" method="get">
                <label for="search" class="sr-only">Tìm kiếm</label>
                <input id="search" name="search" type="search" placeholder="Tìm thiết bị, linh kiện, ..." required>
                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>
        <div class="header-bottom">
            <a href="login.html" class="order-btn login-btn"><i class="fa-solid fa-user"></i></a>
            <a href="cart.html" class="order-btn"><i class="fa-solid fa-cart-shopping"></i> Sản phẩm</a>
        </div>
    </header>

    <!-- Tiêu đề -->
    <h1 style="text-align:center; color:#312e81; margin-top:10px">Theo dõi đơn & tiến trình sản phẩm</h1>

    <main style="max-width:1000px; margin:20px auto; padding:20px; background:#fff; border-radius:8px;">
        <section class="tracker">
            <h2>Tra cứu nhanh</h2>
            <form class="search-form" style="display:grid; gap:20px;">
                <div style="display:grid; gap:6px;">
                    <label for="order">Mã đơn hàng</label>
                    <input id="order" name="order" type="text" placeholder="VD: SO-23918 hoặc WR-2025-8831" required>
                </div>
                <div style="display:grid; gap:6px;">
                    <label for="phone">Số điện thoại</label>
                    <input id="phone" name="phone" type="text" placeholder="Số bạn dùng khi mua hàng" required>
                </div>
                <div style="display:grid; gap:6px;">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" placeholder="email@novacare.vn" required>
                </div>
                <button type="submit" class="order-btn" style="background:#22c55e; color:#fff; padding:10px 20px;">
                    <i class="fa-solid fa-search"></i> Xem tiến trình
                </button>
            </form>

            <!-- Timeline -->
            <div class="timeline" style="margin-top:20px;">
                <div class="step">
                    <strong>Trạng thái: Đang sửa chữa</strong>
                    <span>Thiết bị: TV Samsung QLED 55" · Mã WR-2025-8831</span>
                    <p>Đã nhận tại trung tâm Quận 7, chờ linh kiện Board T-Con (dự kiến 30/09).</p>
                </div>
                <div class="step" style="background:linear-gradient(135deg, rgba(236, 254, 255, 0.4), rgba(191, 219, 254, 0.4)); border-color:rgba(56,189,248,0.32);">
                    <strong>Bước tiếp theo</strong>
                    <p>Kỹ thuật viên Minh Trí sẽ lắp đặt và nghiệm thu, cập nhật video kiểm tra gửi khách.</p>
                </div>
            </div>
        </section>

        <!-- Status Cards -->
        <section class="status" style="margin-top:30px;">
            <article class="status-card" style="border:1px solid #e2e8f0; padding:16px; border-radius:8px;">
                <h3>Đơn hàng SO-23918</h3>
                <p>Giao hàng dự kiến: 01/10/2025 · Shipper: NovaCare Express.</p>
                <p>Đã rời kho chính lúc 08:30 ngày 29/09.</p>
            </article>
            <article class="status-card" style="border:1px solid #e2e8f0; padding:16px; border-radius:8px;">
                <h3>Phiếu sửa chữa WR-2025-6744</h3>
                <p>Trạng thái: Hoàn tất · Chờ phản hồi khách hàng.</p>
                <p>Khuyến nghị: Đặt lịch vệ sinh định kỳ sau 6 tháng.</p>
            </article>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer" style="text-align:center; padding:20px 0; background:#f1f5f9;">
        Trung tâm theo dõi NovaCare · Hỗ trợ 24/7: <a href="mailto:tracking@novacare.vn">tracking@novacare.vn</a>
    </footer>

</body>
</html>
