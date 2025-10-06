<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>NovaCare Shop - Chi tiết sản phẩm</title>
	<link rel="stylesheet" href="./css/shop.css">

	<!-- Font Awesome -->
	<link rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
		crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body class="shop-page detail-page">

	<!-- Header -->
	<header class="header-toolbar">
		<h1>Shop88</h1>
		<div class="header-center">
			<form class="search-bar" action="#" method="get">
				<label for="search" class="sr-only"></label>
				<input id="search" name="search" type="search"
					placeholder="Tìm thiết bị, linh kiện, ...">
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
	<h1 style="text-align:center; color:#312e81; margin-top:10px">Chi tiết sản phẩm</h1>

	<main style="max-width:1000px; margin:20px auto; padding:20px; background:#fff; border-radius:8px;">
		<section class="product-detail">
			<div class="info-grid" style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
				
				<!-- Hero card -->
				<article class="hero-card" style="border:1px solid #e2e8f0; padding:16px; border-radius:8px;">
					<h2 style="color:#312e81;">NovaCore X15</h2>
					<p>Màn 15" QHD+, 120Hz · Intel Core i7 Gen13 · RAM 16GB DDR5 · SSD 1TB PCIe 4.0.</p>
					<strong style="font-size:18px; color:#e11d48;">Giá: 32.990.000đ</strong>
				</article>

				<!-- Specs -->
				<article class="specs" style="border:1px solid #e2e8f0; padding:16px; border-radius:8px;">
					<h3>Cấu hình nổi bật</h3>
					<ul>
						<li>Khung nhôm nguyên khối 1.4kg, bản lề 180°.</li>
						<li>Pin 82Wh, sạc nhanh 100W USB-C.</li>
						<li>Card đồ họa RTX 4060 Laptop, hỗ trợ Studio Driver.</li>
						<li>Bảo mật: Fingerprint, Windows Hello.</li>
					</ul>
				</article>

				<!-- Warranty -->
				<article class="warranty" style="grid-column:span 2; border:1px solid #e2e8f0; padding:16px; border-radius:8px;">
					<h3>Bảo hành & hỗ trợ</h3>
					<p>Bảo hành 24 tháng tiêu chuẩn, hỗ trợ kỹ thuật 24/7.</p>
					<p>Nâng cấp gói Premium thêm 12 tháng onsite.</p>
					<p>Miễn phí vệ sinh – cân chỉnh hiệu năng 6 tháng/lần trong 2 năm đầu.</p>
				</article>
			</div>

			<!-- CTA Buttons -->
			<div class="cta" style="margin-top:20px; display:flex; gap:10px; flex-wrap:wrap;">
				<a href="cart.html" class="order-btn" style="background:#22c55e; color:#fff;">
					<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
				</a>
				<a href="checkout.html" class="order-btn" style="background:#e11d48; color:#fff;">
					<i class="fa-solid fa-bolt"></i> Mua ngay
				</a>
				<a href="order-tracking.html" class="order-btn" 
					style="background:linear-gradient(90deg,#22d3ee,#0ea5e9); color:#fff;">
					<i class="fa-solid fa-truck"></i> Theo dõi bảo hành
				</a>
				<a href="shop.jsp" class="order-btn" style="background:#f1f5f9; color:#312e81;">
					← Quay lại danh mục
				</a>
			</div>
		</section>

		<!-- Review -->
		<section class="review-block" style="margin-top:30px;">
			<h2 style="font-size:24px; color:#9d174d;">Đánh giá nổi bật</h2>
			<article class="review" style="border:1px solid #e2e8f0; padding:12px; border-radius:6px; margin-top:10px;">
				<strong>Khách hàng Minh Anh</strong>
				<p>"Máy chạy Premiere Pro mượt, pin dùng liên tục 8 tiếng. Dịch vụ tư vấn tận tâm, giao hàng trong ngày."</p>
			</article>
			<article class="review" style="background:rgba(129,140,248,0.18); border:1px solid rgba(129,140,248,0.32); color:#312e81; padding:12px; border-radius:6px; margin-top:10px;">
				<strong>Kỹ thuật viên NovaCare</strong>
				<p>"Thiết kế tối ưu cho sửa chữa, dễ nâng cấp RAM và SSD. Khách nên đăng ký gói vệ sinh định kỳ để giữ hiệu năng ổn định."</p>
			</article>
		</section>
	</main>

	<!-- Footer -->
	<footer>
		NovaCare Shop · Mua sắm an tâm với bảo hành chuẩn quốc tế.
	</footer>
</body>
</html>
