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

</style>

<body class="shop-page catalog-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<h1 style="text-align: center; color: #312e81; margin-top: 10px">Danh
		Mục Sản Phẩm</h1>
	<form action="device-page" method="get" id="filter-form">
		<main>

			<section class="toolbar" style="max-width: 184px">


				<div class="filters">
					<div style="display: flex; flex-direction: column; gap: 5px">
						<label for="category">Danh mục</label> <span><input
							type="radio" name="category" value=""
							onchange="this.form.submit()" style="margin-right: 5px;"
							<c:if test="${empty param.category}">checked</c:if>> Tất
							cả </input> </span>
						<c:forEach var="category" items="${listCategory}">
							<span> <input type="radio" name="category"
								value="${category.id}" onchange="this.form.submit()"
								style="margin-right: 5px;"
								<c:if test="${param.category == category.id}">checked</c:if>>
								${category.name} </input>
							</span>

						</c:forEach>
					</div>


					<div style="display: flex; flex-direction: column; gap: 5px">
						<label for="supplier">Thương hiệu</label> <span><input
							type="radio" name="supplier" value=""
							onchange="this.form.submit()" style="margin-right: 5px;"
							<c:if test="${empty param.supplier}">checked</c:if> />Tất cả</span>
						<c:forEach var="supplier" items="${listSupplier}">
							<span><input type="radio" name="supplier"
								onchange="this.form.submit()" value="${supplier.id}"
								style="margin-right: 5px;"
								<c:if test="${param.supplier == supplier.id}">checked</c:if> />${supplier.name}</span>
						</c:forEach>
					</div>
					<div>
						<label for="price">Mức giá</label> <select id="price"
							onchange="this.form.submit()" name="price">
							<option value="" ${empty param.price ? 'selected' : ''}>Mọi
								mức giá</option>
							<option value="under5"
								<c:if test="${param.price == 'under5'}">selected</c:if>>Dưới
								5 triệu</option>
							<option value="5to15"
								<c:if test="${param.price == '5to15'}">selected</c:if>>5
								- 15 triệu</option>
							<option value="15to30"
								<c:if test="${param.price == '15to30'}">selected</c:if>>15
								- 30 triệu</option>
							<option value="over30"
								<c:if test="${param.price == 'over30'}">selected</c:if>>Trên
								30 triệu</option>
						</select>
					</div>
				</div>


			</section>
			<section class="main-content">
				<section class="sorts">
					<label for="sort">Sắp xếp theo:</label> <select id="sort"
						style="margin-left: 10px" name="sortPrice" onchange="this.form.submit()">
						<option value="">--Sắp Xếp--</option>
						<option value="asc" <c:if test="${param.sortPrice == 'asc'}">selected</c:if>><span>Giá: thấp đến cao</span></option>
						<option value="desc" <c:if test="${param.sortPrice == 'desc'}">selected</c:if>><span>Giá: cao đến thấp</span></option>
					</select>
<!-- 					<button id="sort" type="submit"
						style="padding: 12px 14px; border-radius: 14px; border: 1px solid rgba(99, 102, 241, 0.35); background: rgba(255, 255, 255, 0.96); font-size: 15px; color: #1e1b4b; margin-left: 10px">
						<span>Phổ biến</span>
					</button> -->
				</section>
				<section class="product-grid">
					<c:forEach var="device" items="${listDevice}">
						<article class="product-card" style="min-width: 350px">
							<h3>${device.name}</h3>
							<p>Laptop mỏng nhẹ, màn 15'' 2K, pin 12 giờ.</p>
							<strong> <fmt:formatNumber value="${device.price + 0}"
									type="number" />
							</strong> 
							<a href="device-detail?id=${device.id}">Xem chi tiết</a>
						</article>
					</c:forEach>

				</section>
			</section>



		</main>
	</form>
	<nav
		style="display: flex; justify-content: center; align-items: center; gap: 2px">
		<button style="padding: 8px; border-radius: 8px">1</button>
		<button style="padding: 8px; border-radius: 8px">2</button>
	</nav>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>