<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCare Shop - Thanh toán</title>
    <link rel="stylesheet" href="css/shop.css">
</head>
<body class="shop-page checkout-page">

    <!-- Header -->
    <header>
        <h1>Thanh toán an toàn</h1>
        <p>NovaCare sử dụng mã hóa SSL và đối tác thanh toán đạt chuẩn PCI-DSS. Vui lòng kiểm tra thông tin giao hàng, phương thức thanh toán trước khi xác nhận.</p>
    </header>

    <main>
        <section class="checkout-grid">
            <!-- Thông tin giao hàng -->
            <form class="panel" style="background:rgba(255,255,255,0.97);">
                <h2>Thông tin giao hàng</h2>
                <div style="display:grid; gap:8px;">
                    <label for="fullname">Họ tên</label>
                    <input id="fullname" name="fullname" type="text" placeholder="Nguyễn Minh Anh" required>
                </div>
                <div style="display:grid; gap:8px;">
                    <label for="phone">Số điện thoại</label>
                    <input id="phone" name="phone" type="text" placeholder="0901 234 567" required>
                </div>
                <div style="display:grid; gap:8px;">
                    <label for="address">Địa chỉ</label>
                    <textarea id="address" name="address" placeholder="Số nhà, đường, phường, quận, thành phố" required></textarea>
                </div>
                <div style="display:grid; gap:8px;">
                    <label for="time">Thời gian giao hàng</label>
                    <select id="time" name="time" required>
                        <option value="working_hours">Trong giờ hành chính</option>
                        <option value="evening">Tối (18:00 - 21:00)</option>
                        <option value="weekend">Cuối tuần</option>
                    </select>
                </div>
            </form>

            <form class="panel" style="border-color:rgba(14,165,233,0.35); box-shadow:0 22px 48px rgba(14,165,233,0.2);">
                <h2>Phương thức thanh toán</h2>
                <div style="display:grid; gap:8px;">
                    <label for="method">Chọn phương thức</label>
                    <select id="method" name="method" required>
                        <option value="credit_card">Thẻ tín dụng</option>
                        <option value="bank_transfer">Chuyển khoản ngân hàng</option>
                        <option value="e_wallet">Ví điện tử</option>
                        <option value="cash_on_delivery">Thanh toán khi nhận hàng</option>
                    </select>
                </div>
                <div style="display:grid; gap:8px;">
                    <label for="note">Ghi chú cho kỹ thuật</label>
                    <textarea id="note" name="note" placeholder="Ví dụ: cần bàn giao, hướng dẫn sao lưu dữ liệu"></textarea>
                </div>
            </form>

            <section class="summary">
                <h2>Tóm tắt đơn hàng</h2>
                <ul>
                    <li>Laptop NovaCore X15 · 32.990.000đ</li>
                    <li>Gói bảo hành Premium · 3.200.000đ</li>
                    <li>Kit sửa TV 55" ×2 · 5.700.000đ</li>
                    <li>Giảm giá Flash Sale · -2.000.000đ</li>
                    <li><strong>Tổng thanh toán: 39.890.000đ</strong></li>
                </ul>
                <p style="color:#0f172a;">Khi xác nhận, bạn đồng ý với <a href="#" style="color:#22d3ee; text-decoration:none; font-weight:600;">điều khoản mua hàng</a> và chính sách hoàn tiền của NovaCare.</p>
                <div class="cta">
                    <a href="oder-tracking.jsp" class="cta-btn">Xác nhận thanh toán</a>
                    <a href="cart.jsp" class="cta-btn" style="background:linear-gradient(90deg,#f97316,#fb7185); box-shadow:0 18px 36px rgba(249,115,22,0.28);">Quay lại giỏ hàng</a>
                </div>
            </section>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        Thanh toán bởi NovaCare Payments · Hỗ trợ 24/7: <a href="mailto:pay@novacare.vn">pay@novacare.vn</a> · Hotline 1900 6688
    </footer>

</body>
</html>