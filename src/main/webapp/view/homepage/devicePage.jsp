<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NovaCare Shop - Danh mục sản phẩm</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css">


<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<style>
.sorts button:hover {
	background: linear-gradient(90deg, #38bdf8, #22d3ee) !important;
}

body.shop-page.catalog-page .product-grid {
	margin-top: 20px;
}

a {
	color: #1e1b4b;
	text-decoration: none;
}

a:hover {
	color: #2563eb;
}

a:visited {
	color: #1e1b4b;
}

.category-link.active {
	color: #33C2F6;
}
</style>

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
			
			<form action="device-page" method="get" id="filter-form">
			<div class="filters">
				<div style="display: flex; flex-direction: column; gap: 5px">
					<label for="category">Danh mục</label> <a href="device-page"
						class="category-link ${empty param.category ? 'active' : ''}"> Tất cả </a>
					<c:forEach var="category" items="${listCategory}">
						<a href="device-page?category=${category.id}"
							class="category-link ${param.category == category.id ? 'active' : ''}">
							${category.categoryName} </a>
					</c:forEach>
				</div>


				<div style="display: flex; flex-direction: column; gap: 5px">
					<label for="supplier">Thương hiệu</label> <span><input
						type="checkbox" name="supplier" value="all"
						style="margin-right: 5px;" />Tất cả</span>
					<c:forEach var="supplier" items="${listSupplier}">
						<span><input type="checkbox" name="supplier"
							value="${supplier.id}" style="margin-right: 5px;" />${supplier.name}</span>
					</c:forEach>
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
			</form>
		
		</section>
		<section class="main-content">
			<section class="sorts">
				<label for="sort">Sắp xếp theo:</label> <select id="sort"
					style="margin-left: 10px">
					<option><span>Giá: thấp đến cao</span></option>
					<option><span>Giá: cao đến thấp</span></option>
				</select>
				<button id="sort" type="submit"
					style="padding: 12px 14px; border-radius: 14px; border: 1px solid rgba(99, 102, 241, 0.35); background: rgba(255, 255, 255, 0.96); font-size: 15px; color: #1e1b4b; margin-left: 10px">
					<span>Phổ biến</span>
				</button>
			</section>
			<section class="product-grid">
				<c:forEach var="device" items="${listDevice}">
					<article class="product-card">
						<h3>${device.name}</h3>
						<p>Laptop mỏng nhẹ, màn 15'' 2K, pin 12 giờ.</p>
						<div class="tags">
							<span>Laptop</span><span>NovaCare</span><span>Intel</span>
						</div>
						<strong> <fmt:formatNumber value="${device.price + 0}"
								type="number" />
						</strong> <a href="device-detail.html">Xem chi tiết</a>
					</article>
				</c:forEach>


				<!-- pagination -->

			</section>
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