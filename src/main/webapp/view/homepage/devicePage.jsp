<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>NovaCare Shop - Danh mục sản phẩm</title>
	<link rel="stylesheet" href="./css/shop.css">
	
	<!-- Font Awesome -->
	<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body class="shop-page catalog-page">
	<header class="header-toolbar">
		<h1>Shop88</h1>
		<div class="header-center">

			<form class="search-bar" action="#" method="get">
				<label for="search" class="sr-only"></label> <input id="search"
					name="search" type="search"
					placeholder="Tìm thiết bị, linh kiện, ...">
				<button type="submit">
					<i class="fa-solid fa-magnifying-glass"></i>
				</button>
			</form>
		</div>
		<div class="header-bottom">
			<a href="login.html" class="order-btn login-btn"><i
				class="fa-solid fa-user"></i></a> <a href="cart.html" class="order-btn"><i
				class="fa-solid fa-cart-shopping"></i>Sản phẩm</a>
		</div>
	</header>
	<h1 style="text-align: center; color: #312e81; margin-top: 10px">Danh
		Mục Sản Phẩm</h1>
	
	<main>
	
		<section class="toolbar">
			<div class="filters">
				<div style="display:flex; flex-direction:column; gap:5px">
					<label for="category">Danh mục</label> 
					<!-- <select id="category">
						<option>Tất cả</option>
						<option>Laptop</option>
						<option>Điện thoại</option>
						<option>Linh kiện bảo hành</option>
						<option>Dịch vụ sửa chữa</option>
					</select> -->
					<span><input type="checkbox" style="margin-right:5px;"/>Tất cả</span>
					<span><input type="checkbox" style="margin-right:5px"/>Laptop</span>
					<span><input type="checkbox" style="margin-right:5px"/>Điện thoại</span>
					<span><input type="checkbox" style="margin-right:5px"/>Linh kiện bảo hành</span>
					<span><input type="checkbox" style="margin-right:5px"/>Dịch vụ sửa chữa</span>	
				</div>
				<div style="display:flex; flex-direction:column; gap:5px">
					<label for="brand">Thương hiệu</label>
					 <!-- <select id="brand">
						<option>Tất cả</option>
						<option>NovaCare</option>
						<option>Samsung</option>
						<option>Sony</option>
						<option>LG</option>
						<option>Daikin</option>
					</select> -->
					<span><input type="checkbox" style="margin-right:5px;"/>Tất cả</span>
					<span><input type="checkbox" style="margin-right:5px;"/>NovaCare</span>
					<span><input type="checkbox" style="margin-right:5px;"/>Samsung</span>
					<span><input type="checkbox" style="margin-right:5px;"/>Sony</span>
					<span><input type="checkbox" style="margin-right:5px;"/>LG</span>
					<span><input type="checkbox" style="margin-right:5px;"/>Daikin</span>
				</div>
				<div>
					<label for="price">Mức giá</label> <select id="price">
						<option>Dưới 5 triệu</option>
						<option>5 - 15 triệu</option>
						<option>15 - 30 triệu</option>
						<option>Trên 30 triệu</option>
					</select>
				</div>
			</div>
		</section>
		
		<section class="product-grid">
		
			<article class="product-card">
				<h3>NovaCore X15</h3>
				<p>Laptop mỏng nhẹ, màn 15'' 2K, pin 12 giờ.</p>
				<div class="tags">
					<span>Laptop</span><span>NovaCare</span><span>Intel</span>
				</div>
				<strong>32.990.000đ</strong> 
				<a href="device-detail.html">Xem chi tiết</a>
			</article>
			<article class="product-card">
				<h3>NovaCare S9</h3>
				<p>Smartphone flagship, camera AI, chống nước IP68.</p>
				<div class="tags">
					<span>Điện thoại</span><span>5G</span><span>120Hz</span>
				</div>
				<strong>18.490.000đ</strong> <a href="device-detail.html">Xem
					chi tiết</a>
			</article>
			<article class="product-card">
				<h3>Kit sửa TV 55"</h3>
				<p>Board nguồn, cáp tín hiệu, hướng dẫn lắp đặt.</p>
				<div class="tags">
					<span>Linh kiện</span><span>Bảo hành</span>
				</div>
				<strong>2.850.000đ</strong> <a href="device-detail.html">Xem chi
					tiết</a>
			</article>
			<article class="product-card">
				<h3>Gói bảo hành Premium</h3>
				<p>Bảo hành nâng cao 36 tháng, hotline kỹ thuật 24/7.</p>
				<div class="tags">
					<span>Dịch vụ</span><span>Gia dụng</span>
				</div>
				<strong>3.200.000đ</strong> <a href="device-detail.html">Xem chi
					tiết</a>
					
			</article>
			<article class="product-card">
				<h3>Máy lọc không khí NovaPure</h3>
				<p>Lọc HEPA 4 lớp, cảm biến bụi mịn, kết nối app.</p>
				<div class="tags">
					<span>Gia dụng</span><span>Smart home</span>
				</div>
				<strong>7.990.000đ</strong> <a href="device-detail.html">Xem chi
					tiết</a>
			</article>
			<article class="product-card">
				<h3>Combo vệ sinh điều hòa</h3>
				<p>Dịch vụ vệ sinh sâu, nạp gas, kiểm tra rò rỉ.</p>
				<div class="tags">
					<span>Dịch vụ</span><span>Điều hòa</span>
				</div>
				<strong>1.190.000đ</strong> <a href="device-detail.html">Xem chi
					tiết</a>
			</article>
			<!-- pagination -->

		</section>


	</main>
	<nav
		style="display: flex; justify-content: center; align-items: center; gap: 2px">
		<button style="padding: 8px; border-radius: 8px">1</button>
		<button style="padding: 8px; border-radius: 8px">2</button>
	</nav>
	<footer> NovaCare Shop · Mua sắm an tâm với bảo hành chuẩn
		quốc tế. </footer>
</body>

</html>