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
<body class="home-page">
    <header class="header">
        <h1 class="header-title">NovaCare</h1>
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
            <a href="login.jsp" class="order-btn login-btn"><i class="fa-solid fa-user"></i></a>
            <a href="cart.jsp" class="order-btn"><i class="fa-solid fa-cart-shopping"></i>Sản phẩm</a>
        </div>
    </header>

    <main>
        <section class="mega-banner" aria-labelledby="banner-title">
            <div class="mega-banner-content">
                <h2 id="banner-title">Mua sam dien may thang hoa - uu dai den 20% cho toan bo he sinh thai</h2>
                <p>Tu laptop, smartphone den dich vu sua chua tai nha. Chi mot lan cham la ban duoc cham soc tron ven
                    cung doi ky thuat NovaCare.</p>
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
                <span class="shortcut-label">Dien thoai</span>
            </a>
            <a class="shortcut-card" href="device-catalog.html#accessories">
                <span class="shortcut-icon">🔧</span>
                <span class="shortcut-label">Linh kien</span>
            </a>
            <a class="shortcut-card" href="order-tracking.html">
                <span class="shortcut-icon">🛠️</span>
                <span class="shortcut-label">Theo doi sua chua</span>
            </a>
        </section>

        <section class="featured-devices">
            <div class="section-header">
                <h2 id="featured-title">San pham noi bat</h2>
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
                        <article class="device-card">
                            <h4>Laptop NovaCore X15</h4>
                            <p>CPU Intel Gen13, RAM 16GB, SSD 1TB. Tang kem bao tri onsite 12 thang.</p>
                            <span>Gia: 32.990.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Smartphone NovaCare S9</h4>
                            <p>Man AMOLED 120Hz, camera AI 108MP, sac nhanh 80W.</p>
                            <span>Gia: 18.490.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Bo linh kien sua chua TV</h4>
                            <p>Board nguon, bo tu va cap man hinh chinh hang cho dong TV 2023.</p>
                            <span>Gia: 2.850.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Goi bao hanh Premium</h4>
                            <p>Bao hanh mo rong 36 thang cho thiet bi gia dinh, ho tro ky thuat 24/7.</p>
                            <span>Gia: 3.200.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>May loc khong khi NovaPure</h4>
                            <p>Loc HEPA 4 lop, cam bien bui min, ket noi ung dung thong minh.</p>
                            <span>Gia: 7.990.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Combo ve sinh dieu hoa</h4>
                            <p>Dich vu ve sinh sau, nap gas va kiem tra ro ri tai nha.</p>
                            <span>Gia: 1.190.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Loa soundbar NovaSound 500</h4>
                            <p>Cong suat 320W, Dolby Atmos, ket noi Bluetooth 5.2.</p>
                            <span>Gia: 9.490.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Robot hut bui NovaBot X</h4>
                            <p>Dieu huong Lidar, tu do rac, ho tro giong noi tieng Viet.</p>
                            <span>Gia: 12.500.000d</span>
                        </article>
                    </div>
                </div>
            </div>
        </section>

        <section class="device-list new-devices">
            <div class="section-heading">
                <h2 id="new-devices-title">San pham moi ve</h2>
                <p>Nhung san pham vua cap ben showroom va san sang giao ngay.</p>
            </div>
            <div class="device-pages" data-paginated="new-devices">
                <div class="device-page is-active">
                    <div class="device-grid">
                        <article class="device-card">
                            <h4>May anh NovaShot Z6</h4>
                            <p>Cam bien full-frame 30MP, quay 6K, chong rung 5 truc.</p>
                            <span>Gia: 28.900.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>May giat NovaWash Pro</h4>
                            <p>Khoi luong 12kg, cong nghe hoi nuoc TrueSteam, Inverter.</p>
                            <span>Gia: 16.490.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Bo phat Wi-Fi Mesh NovaAir</h4>
                            <p>Chuan Wi-Fi 7, dien phu 450m2, quan tri qua ung dung.</p>
                            <span>Gia: 6.590.000d</span>
                        </article>
                        <article class="device-card">
                            <h4>Man hinh cong NovaView 34"</h4>
                            <p>Do phan giai QHD, 165Hz, ho tro HDR600.</p>
                            <span>Gia: 12.990.000d</span>
                        </article>
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
                <h2 id="best-sellers-title">San pham ban chay</h2>
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
    <footer class="footer">
        <div class="container">
            <div class="footer__body">
                <section class="footer__logo">
                    <!-- Logo -->
                    <a href="#">
                        <div class="logo">
                            <span class="logo__circle"></span>
                            <span class="logo__text">
                                <span class="logo__brand">shine</span>
                                <span class="logo__brand logo__brand--small">smile</span>
                            </span>
                        </div>
                    </a>
                    <p class="section-desc footer__desc">Exceptional dental care for all ages. Your great smile begins
                        with a great dentist.</p>
                </section>

                <section class="footer__support">
                    <h4 class="footer__title">Support</h4>
                    <ul>
                        <li>
                            <a href="#!">Help center</a>
                        </li>
                        <li>
                            <a href="#!">Account information</a>
                        </li>
                        <li>
                            <a href="#!">About</a>
                        </li>
                        <li>
                            <a href="#!">Contact us</a>
                        </li>
                    </ul>

                    <h4 class="footer__title">Support</h4>
                    <ul>
                        <li>
                            <a href="#!">Help center</a>
                        </li>
                        <li>
                            <a href="#!">Account information</a>
                        </li>
                    </ul>

                </section>

                <section class="footer__support">
                    <h4 class="footer__title">Support</h4>
                    <ul>
                        <li>
                            <a href="#!">Help center</a>
                        </li>
                        <li>
                            <a href="#!">Account information</a>
                        </li>
                    </ul>

                    <h4 class="footer__title">Support</h4>
                    <ul>
                        <li>
                            <a href="#!">Help center</a>
                        </li>
                    </ul>
                </section>

                <section class="footer__contact">
                    <!-- <h4 class="footer__title">Stay In Touch</h4>

                    <div class="footer__society">
                        <a href="#!"><i class="fa-brands fa-facebook"></i></a>
                        <a href="#!"><i class="fa-brands fa-square-x-twitter"></i></a>
                        <a href="#!"><img src="./assets/img/linked.svg" alt="Linked"></a>
                    </div> -->

                    <h4 class="footer__title">Subscribe</h4>
                    <p class="footer__sub">Subscribe our newsletter for the latest update of Dental care</p>

                    <label for="">
                        <input type="email" name="email" class="footer__input" placeholder="Enter your email...">
                        <a href="#!" class="btn footer-sub__btn">Subscribe</a>
                    </label>
                </section>

            </div>
            <strong class="footer__copyright">2021 GDN. Copyright and All rights reserved.</strong>
        </div>
    </footer>

    <script>
        // Banner promos
        (function () {
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
            var delay = 5000;

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

            slider.addEventListener('mouseenter', stop);
            slider.addEventListener('mouseleave', start);

            updateSlider();
        })();



    </script>
</body>

</html>