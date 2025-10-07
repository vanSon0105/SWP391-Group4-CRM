<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop88</title>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <section class="mega-banner" aria-labelledby="banner-title">
            <div class="mega-banner-content">
                <h2 id="banner-title">Mua sắm điện máy thăng hoa - Ưu đãi đến 20% cho toàn bộ thiết bị</h2>
                <p>Từ laptop, smartphone đến dịch vụ sửa chữa. Chỉ một lần chạm là bạn được chăm sóc tận tình cùng đội ngũ kỹ thuật của Shop88</p>
                <div class="banner-btn">
                    <a href="device-catalog.html">Kham pha san pham</a>
                    <a class="secondary" href="order-tracking.html">Theo doi don &amp; bao hanh</a>
                </div>
            </div>
            <div class="banner-promos" data-hero-slider>
                <button class="hero-nav" type="button" data-hero-direction="prev" aria-label="San pham truoc"><i
                        class="fa-solid fa-chevron-left"></i></button>
                <div class="banner-promos-window">
                    <div class="banner-promos-track">
                        <article class="promo-card">
                            <span class="promo-tag">Xiaomi HyperAI</span>
                            <h3>Xiaomi 15T Series</h3>
                            <p>Thu cu doi moi len den <strong>2.5 trieu</strong> &bull; Tra gop <strong>0%</strong>
                                &bull; Bao hanh 24+6 thang</p>
                            <span class="promo-price">Gia uu dai: 2.99 trieu</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Mini LED Series</span>
                            <h3>Xiaomi TV S Pro</h3>
                            <p>Giam toi <strong>5 trieu</strong> &bull; Tang loa thanh &bull; 55" | 65" | 75"</p>
                            <span class="promo-price">Chi tu 28.990.000d</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Gia dung xanh</span>
                            <h3>NovaBot Clean X</h3>
                            <p>Lau hut dong thoi, tu do rac &bull; Tich hop ban do 3D &bull; ho tro giong noi</p>
                            <span class="promo-price">Chi tu 10.490.000d</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Am thanh cao cap</span>
                            <h3>NovaSound Max 7.1</h3>
                            <p>Dolby Atmos, Bluetooth 5.2 &bull; Ket noi da thiet bi &bull; Bao hanh 24 thang</p>
                            <span class="promo-price">Gia: 9.990.000d</span>
                        </article>
                    </div>
                </div>
                <button class="hero-nav" type="button" data-hero-direction="next" aria-label="San pham tiep theo"><i
                        class="fa-solid fa-chevron-right"></i></button>
            </div>
        </section>

        <section class="featured-categories">
            <a class="shortcut-card" href="device-catalog.html#laptop">
                <span class="shortcut-icon">💻</span>
                <span class="shortcut-label">Laptop &amp; PC</span>
            </a>
            <a class="shortcut-card" href="device-catalog.html#mobile">
                <span class="shortcut-icon">📱</span>
                <span class="shortcut-label">Điện Thoại</span>
            </a>
            <a class="shortcut-card" href="device-catalog.html#accessories">
                <span class="shortcut-icon">🔧</span>
                <span class="shortcut-label">Linh Kiện</span>
            </a>
            <a class="shortcut-card" href="order-tracking.html">
                <span class="shortcut-icon">🛠️</span>
                <span class="shortcut-label">Theo Dõi Sửa Chữa</span>
            </a>
        </section>

        <section class="featured-devices">
            <div class="section-header">
                <h2 id="featured-title">Thiết Bị Nổi Bật</h2>
                <div class="slider-controls">
                    <button class="slider-btn" type="button" disabled>
                        &#10094;
                    </button>
                    <button class="slider-btn" type="button">
                        &#10095;
                    </button>
                </div>
            </div>
            <div class="device-slider">
                <div class="device-window">
                    <div class="device-track">
              	<c:forEach items="${list}" var="s">
                        <article class="device-card">
                            <h4>${s.getName()}</h4>
                            <p>${s.getDesc()}</p>
                            <span>Giá: ${s.getPrice()}Đ</span>
                        </article>
                </c:forEach>
                    </div>
                </div>
            </div>
        </section>

        <section class="device-list new-devices">
            <div class="section-heading">
                <h2 id="new-devices-title">Thiết Bị Mới Về</h2>
                <p>Những sản phầm vừa mới về Shop88 và sẵn sàng bấm ngay</p>
            </div>
            <div class="device-pages" data-paginated="new-devices">
                <div class="device-page is-active">
                    <div class="device-grid">
                    <c:forEach items="${listNew}" var="s"> 
                        <article class="device-card">
                            <h4>${s.getName()}</h4>
                            <p>${s.getDesc()}</p>
                            <span>Giá: ${s.getPrice()}Đ</span>
                        </article>
                    </c:forEach>
                    </div>
                </div>
                <div class="device-page">
                    <div class="device-grid">
                        <article class="device-card">
                            <h4>Tai nghe NovaTone Air</h4>
                            <p>Driver graphene, chong on ANC, pin 42 gio kem hop sac.</p>
                            <span>Gia: 3.490.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Lo vi song NovaHeat Glass</h4>
                            <p>Cua kinh phan xa, 25L, 12 che do nau tu dong.</p>
                            <span>Gia: 4.290.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>May loc nuoc NovaPure Flow</h4>
                            <p>RO 6 cap, UV-C, ket noi app theo doi chat luong nuoc.</p>
                            <span>Gia: 9.850.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Tablet NovaTab Note</h4>
                            <p>Man 11 inch 120Hz, but stylus, da tac vu chia doi man hinh.</p>
                            <span>Gia: 11.490.000d</span>
                        </article>
                    </div>
                </div>
            </div>
            <div class="pagination-pills" data-pagination="new-devices">
                <button type="button" data-page="0" class="active">1</button>
                <button type="button" data-page="1">2</button>
            </div>
        </section>

        <section class="device-list best-sellers" aria-labelledby="best-sellers-title">
            <div class="section-heading">
                <h2 id="best-sellers-title">Thiết Bị Bán Chạy</h2>
                <p>Duoc khach hang lua chon va danh gia cao nhat trong thang.</p>
            </div>
            <div class="device-pages" data-paginated="best-sellers">
                <div class="device-page is-active">
                    <div class="device-grid">
                        <article class="device-card">
                            <h4>May lanh NovaCool 2HP</h4>
                            <p>Tiet kiem dien A+++, mang loc khang khuan ProShield.</p>
                            <span>Gia: 13.290.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Robot lau nha NovaClean Duo</h4>
                            <p>Lau hut dong thoi, ban do 3D, tu nang khan khi len tham.</p>
                            <span>Gia: 10.490.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Tai nghe NovaPods Max</h4>
                            <p>Chong on chu dong, Spatial Audio, pin 28 gio.</p>
                            <span>Gia: 6.990.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Bep tu NovaHeat Duo</h4>
                            <p>Hai vung nau tu + hong ngoai, bang dieu khien cam ung.</p>
                            <span>Gia: 8.890.000d</span>
                        </article>
                    </div>
                </div>
                <div class="device-page">
                    <div class="device-grid">
                        <article class="device-card">
                            <h4>May hut mui NovaBreeze</h4>
                            <p>Cong suat 1100m3/h, bo loc than hoat tinh, dieu khien cam ung.</p>
                            <span>Gia: 7.450.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>May say quan ao NovaDry S</h4>
                            <p>Cong nghe HeatPump, 14 chuong trinh say thong minh.</p>
                            <span>Gia: 15.900.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Combo loa NovaBeat Party</h4>
                            <p>Am thanh 360 do, microphone bluetooth, pin 16 gio.</p>
                            <span>Gia: 5.790.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Camera an ninh NovaGuard 360</h4>
                            <p>Quan sat 4K, AI phat hien nguoi, luu tru cloud.</p>
                            <span>Gia: 3.650.000d</span>
                        </article>
                    </div>
                </div>
            </div>
            <div class="pagination-pills" data-pagination="best-sellers">
                <button type="button" data-page="0" class="active">1</button>
                <button type="button" data-page="1">2</button>
            </div>
        </section>

        <section class="device-list category-section">
            <div class="section-heading">
                <h2>Danh muc chuyen sau</h2>
                <p>Kham pha giai phap phu hop cho nhu cau cua ban.</p>
            </div>
            <div class="categories">
                <div class="category">
                    <h3>Laptop &amp; PC</h3>
                    <ul>
                        <li>Laptop do hoa, gaming, van phong</li>
                        <li>May ban All-in-one, linh kien nang cap</li>
                        <li>Dich vu ve sinh, toi uu hieu nang dinh ky</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(251,191,36,0.28), rgba(248,113,113,0.28)); border-color:rgba(249,115,22,0.32);">
                    <h3>Dien thoai &amp; Tablet</h3>
                    <ul>
                        <li>Smartphone flagship, mid-range</li>
                        <li>Tablet hoc tap, giai tri</li>
                        <li>Goi bao hiem roi vo, ho tro thay man</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(134,239,172,0.28), rgba(125,211,252,0.28)); border-color:rgba(34,197,94,0.32);">
                    <h3>Linh kien bao hanh</h3>
                    <ul>
                        <li>Board mach, cam bien, motor chinh hang</li>
                        <li>Cong cu ho tro sua chua, kit ve sinh</li>
                        <li>Huong dan lap dat chi tiet kem video</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(199,210,254,0.28), rgba(165,180,252,0.28)); border-color:rgba(129,140,248,0.32);">
                    <h3>Dich vu sua chua</h3>
                    <ul>
                        <li>Dat lich sua chua tai nha hoac trung tam</li>
                        <li>Theo doi tien trinh theo thoi gian thuc</li>
                        <li>Chinh sach hoan tien neu qua SLA</li>
                    </ul>
                </div>
            </div>
        </section>
    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>

</html>