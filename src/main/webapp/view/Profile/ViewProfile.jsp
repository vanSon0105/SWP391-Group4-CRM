<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
﻿<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCare Shop - Thông tin tài khoản</title>

    <style>
        /* ===============================
           RESET & BASE STYLE
        ================================= */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Inter", "Segoe UI", sans-serif;
        }

        body {
            background: #f8f9fb;
            color: #222;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        h1, h2, h3 {
            font-weight: 600;
            color: #111;
        }

        a {
            text-decoration: none;
            color: #0077cc;
        }

        a:hover {
            text-decoration: underline;
        }

        button {
            cursor: pointer;
            font-size: 0.95rem;
        }

        /* ===============================
           HEADER
        ================================= */
        .account-header {
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            padding: 2rem 3rem;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
        }

        .account-header__info {
            max-width: 500px;
        }

        .account-header__info h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .account-nav {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            align-items: center;
        }

        .account-nav a {
            font-weight: 500;
            color: #444;
            transition: color 0.2s;
        }

        .account-nav a:hover {
            color: #0077cc;
        }

        /* ===============================
           LAYOUT
        ================================= */
        .account-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 2rem;
            padding: 2rem 3rem;
            flex: 1;
        }

        .account-summary {
            background: #fff;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        /* ===============================
           PROFILE CARD
        ================================= */
        .profile-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-avatar {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #0077cc;
            color: #fff;
            font-size: 1.8rem;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 1rem;
        }

        .profile-meta h2 {
            font-size: 1.2rem;
            margin-bottom: 0.25rem;
        }

        .profile-tier {
            font-size: 0.9rem;
            color: #0077cc;
        }

        .profile-email {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.5rem;
        }

        /* ===============================
           SECTIONS
        ================================= */
        .account-overview {
            margin-bottom: 2rem;
        }

        .account-overview h3 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .account-overview ul {
            list-style: none;
        }

        .account-overview li {
            display: flex;
            justify-content: space-between;
            padding: 0.3rem 0;
            border-bottom: 1px dashed #eee;
        }

        .account-links {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .account-links a {
            color: #333;
            background: #f4f6f8;
            padding: 0.6rem 1rem;
            border-radius: 8px;
            transition: background 0.2s;
        }

        .account-links a:hover {
            background: #e8f0ff;
            color: #0077cc;
        }

        /* ===============================
           CONTENT AREA
        ================================= */
        .account-content {
            background: #fff;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }

        .account-form {
            margin-bottom: 3rem;
        }

        .account-form header {
            margin-bottom: 1rem;
        }

        .account-form header h2 {
            font-size: 1.3rem;
            color: #111;
        }

        .account-form p {
            color: #666;
            font-size: 0.95rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem 2rem;
            margin-top: 1rem;
        }

        .field {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 500;
            margin-bottom: 0.4rem;
        }

        input, textarea, select {
            padding: 0.7rem 0.8rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: border 0.2s, box-shadow 0.2s;
        }

        input:focus, textarea:focus {
            border-color: #0077cc;
            box-shadow: 0 0 0 2px rgba(0,119,204,0.15);
            outline: none;
        }

        /* ===============================
           BUTTONS
        ================================= */
        .primary-btn {
            background: #0077cc;
            color: #fff;
            border: none;
            padding: 0.7rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: background 0.25s;
        }

        .primary-btn:hover {
            background: #005fa3;
        }

        .secondary-btn {
            background: #f3f4f6;
            color: #333;
            border: 1px solid #ddd;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            transition: background 0.25s;
        }

        .secondary-btn:hover {
            background: #e5e7eb;
        }

        .link-btn {
            background: none;
            border: none;
            color: #0077cc;
            padding: 0;
            font-weight: 500;
        }

        .link-btn:hover {
            text-decoration: underline;
        }

        .form-actions {
            margin-top: 1rem;
            display: flex;
            gap: 1rem;
        }

        /* ===============================
           ORDER TABLE
        ================================= */
        .order-table {
            width: 100%;
            border-top: 1px solid #eee;
            margin-top: 1rem;
        }

        .order-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr auto;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f2f2f2;
            align-items: center;
        }

        .order-row.header {
            font-weight: 600;
            background: #f9fafb;
            border-top: none;
        }

        .status {
            font-weight: 500;
        }

        .status-progress {
            color: #ff9800;
        }

        .status-done {
            color: #16a34a;
        }

        .status-cancel {
            color: #e11d48;
        }

        /* ===============================
           FOOTER
        ================================= */
        .account-footer {
            background: #ffffff;
            border-top: 1px solid #e5e7eb;
            text-align: center;
            padding: 1rem;
            color: #666;
            font-size: 0.9rem;
            margin-top: auto;
        }

        .account-footer button {
            margin-left: 1rem;
        }

        /* ===============================
           RESPONSIVE
        ================================= */
        @media (max-width: 900px) {
            .account-layout {
                grid-template-columns: 1fr;
            }

            .account-summary {
                order: 2;
            }

            .account-content {
                order: 1;
            }
        }
    </style>
</head>

<body class="shop-page account-page">
    <header class="account-header">
        <div class="account-header__info">
            <h1>Thông tin tài khoản</h1>
            <p>Quản lý dữ liệu cá nhân, địa chỉ giao hàng và các tùy chọn bảo mật cho tài khoản NovaCare.</p>
        </div>
        <nav class="account-nav" aria-label="Điều hướng tài khoản">
            <a href="index.html">Trang chủ</a>
            <a href="order-tracking.html">Đơn hàng</a>
            <a href="customer-portal.html">Bảo hành</a>
            <a href="login.html">Đăng xuất</a>
        </nav>
    </header>

    <main class="account-layout">
        <aside class="account-summary">
            <div class="profile-card">
                <div class="profile-avatar">NA</div>
                <div class="profile-meta">
                    <h2>Nguyễn Anh</h2>
                    <span class="profile-tier">Thành viên NovaCare Plus</span>
                    <span class="profile-email">anh.nguyen@example.com</span>
                </div>
                <button class="secondary-btn" type="button">Thay ảnh đại diện</button>
            </div>

            <section class="account-overview" aria-label="Tổng quan">
                <h3>Trạng thái tài khoản</h3>
                <ul>
                    <li><span>Đơn hàng đang giao</span><strong>02</strong></li>
                    <li><span>Bảo hành đang xử lý</span><strong>01</strong></li>
                    <li><span>Điểm NovaPoint</span><strong>1.250</strong></li>
                </ul>
            </section>

            <section class="account-links" aria-label="Lối tắt">
                <a href="#section-address">Sổ địa chỉ</a>
                <a href="#section-security">Bảo mật &amp; đăng nhập</a>
                <a href="#section-preferences">Tùy chọn thông báo</a>
                <a href="#section-history">Lịch sử đơn hàng</a>
            </section>
        </aside>

        <section class="account-content">
            <form class="account-form" id="section-profile">
                <header>
                    <h2>Thông tin cá nhân</h2>
                    <p>Cập nhật các trường phía dưới để giữ liên hệ chính xác.</p>
                </header>
                <div class="form-grid">
                    <div class="field">
                        <label for="fullname">Họ và tên</label>
                        <input id="fullname" type="text" value="Nguyễn Anh">
                    </div>
                    <div class="field">
                        <label for="phone">Số điện thoại</label>
                        <input id="phone" type="tel" value="0903 123 456">
                    </div>
                    <div class="field">
                        <label for="email">Email</label>
                        <input id="email" type="email" value="anh.nguyen@example.com">
                    </div>
                    <div class="field">
                        <label for="birthday">Ngày sinh</label>
                        <input id="birthday" type="date" value="1995-04-12">
                    </div>
                </div>
                <div class="field">
                    <label for="note">Ghi chú</label>
                    <textarea id="note" rows="3" placeholder="Thông tin thêm về nhu cầu dịch vụ, thời gian liên hệ ưu tiên..."></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="primary-btn">Lưu thay đổi</button>
                    <button type="reset" class="secondary-btn">Đặt lại</button>
                </div>
            </form>

            <form class="account-form" id="section-address">
                <header>
                    <h2>Sổ địa chỉ</h2>
                    <p>Quản lý địa chỉ giao hàng và hóa đơn.</p>
                </header>
                <div class="address-list">
                    <article class="address-card">
                        <span class="address-badge">Mặc định</span>
                        <h3>Nhà riêng</h3>
                        <p>123 Nguyễn Văn Cừ, P.An Khánh, Q.Ninh Kiều, Cần Thơ</p>
                        <p>Người nhận: Nguyễn Anh · 0903 123 456</p>
                        <div class="card-actions">
                            <button type="button" class="secondary-btn">Chỉnh sửa</button>
                            <button type="button" class="link-btn">Đặt làm mặc định</button>
                        </div>
                    </article>
                    <article class="address-card">
                        <h3>Văn phòng</h3>
                        <p>Tầng 8, 42 Điện Biên Phủ, Quận 3, TP.HCM</p>
                        <p>Người nhận: Nguyễn Anh · 0903 123 456</p>
                        <div class="card-actions">
                            <button type="button" class="secondary-btn">Chỉnh sửa</button>
                            <button type="button" class="link-btn">Đặt làm mặc định</button>
                        </div>
                    </article>
                </div>
                <button type="button" class="primary-btn">Thêm địa chỉ mới</button>
            </form>

            <form class="account-form" id="section-security">
                <header>
                    <h2>Bảo mật &amp; đăng nhập</h2>
                    <p>Đổi mật khẩu và bật xác thực đa lớp.</p>
                </header>
                <div class="form-grid">
                    <div class="field">
                        <label for="current-password">Mật khẩu hiện tại</label>
                        <input id="current-password" type="password" placeholder="••••••••">
                    </div>
                    <div class="field">
                        <label for="new-password">Mật khẩu mới</label>
                        <input id="new-password" type="password" placeholder="Tối thiểu 8 ký tự">
                    </div>
                    <div class="field">
                        <label for="confirm-password">Nhập lại mật khẩu</label>
                        <input id="confirm-password" type="password" placeholder="Nhập lại mật khẩu mới">
                    </div>
                </div>
                <div class="field field-switch">
                    <label for="toggle-2fa">Xác thực hai lớp</label>
                    <label class="switch">
                        <input id="toggle-2fa" type="checkbox" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="form-actions">
                    <button type="submit" class="primary-btn">Cập nhật bảo mật</button>
                </div>
            </form>

            <section class="account-form" id="section-preferences" aria-labelledby="preferences-title">
                <header>
                    <h2 id="preferences-title">Tùy chọn thông báo</h2>
                    <p>Chúng tôi sẽ thông báo theo đúng lựa chọn của bạn.</p>
                </header>
                <div class="preferences-grid">
                    <label class="checkbox">
                        <input type="checkbox" checked>
                        <span>Khuyến mãi &amp; ưu đãi độc quyền</span>
                    </label>
                    <label class="checkbox">
                        <input type="checkbox" checked>
                        <span>Cập nhật trạng thái đơn hàng</span>
                    </label>
                    <label class="checkbox">
                        <input type="checkbox">
                        <span>Thông tin sản phẩm mới</span>
                    </label>
                    <label class="checkbox">
                        <input type="checkbox" checked>
                        <span>Tư vấn bảo hành định kỳ</span>
                    </label>
                </div>
                <div class="form-actions">
                    <button type="button" class="primary-btn">Lưu tùy chọn</button>
                </div>
            </section>

            <section class="account-form" id="section-history" aria-label="Lịch sử đơn hàng">
                <header>
                    <h2>Đơn hàng gần đây</h2>
                    <p>Theo dõi nhanh những đơn hàng mới nhất của bạn.</p>
                </header>
                <div class="order-table">
                    <div class="order-row header">
                        <span>Mã đơn</span>
                        <span>Ngày đặt</span>
                        <span>Trạng thái</span>
                        <span>Tổng tiền</span>
                        <span></span>
                    </div>
                    <div class="order-row">
                        <span>#SO-58321</span>
                        <span>12/09/2025</span>
                        <span class="status status-progress">Đang giao</span>
                        <span>21.490.000đ</span>
                        <button type="button" class="link-btn">Xem chi tiết</button>
                    </div>
                    <div class="order-row">
                        <span>#SO-57980</span>
                        <span>01/09/2025</span>
                        <span class="status status-done">Hoàn tất</span>
                        <span>5.320.000đ</span>
                        <button type="button" class="link-btn">Xem chi tiết</button>
                    </div>
                    <div class="order-row">
                        <span>#SO-57811</span>
                        <span>28/08/2025</span>
                        <span class="status status-cancel">Đã hủy</span>
                        <span>3.990.000đ</span>
                        <button type="button" class="link-btn">Xem nguyên nhân</button>
                    </div>
                </div>
            </section>
        </section>
    </main>

    <footer class="account-footer">
        <span>NovaCare Shop · Hỗ trợ 24/7: care@novacare.vn · Hotline: 1900 8888</span>
        <button type="button" class="link-btn">Xóa tài khoản</button>
    </footer>
</body>

</html>