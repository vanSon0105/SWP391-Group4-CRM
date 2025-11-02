<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechShop - Danh mục sản phẩm</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">


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

.pagination-pills {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-bottom: 10px;
}

.pagination-pills a {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    text-decoration: none;
    width: 44px;
    height: 44px;
    padding: 0;
    border-radius: 16px;
    border: 1px solid rgba(15, 23, 42, 0.15);
    background: rgba(255, 255, 255, 0.9);
    color: #1f2937;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
}

.pagination-pills a.active {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #f8fafc;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
}

.pagination-pills a:hover {
    transform: translateY(-2px);
}

.pagination:visited {
  color: #333;
}

a.disabled {
    color: black;
    border-color: transparent;
    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
    cursor: not-allowed;
    pointer-events: none;
    opacity: 0.5;
}
</style>

<body class="shop-page catalog-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<h1 style="text-align: center; color: #312e81; margin-top: 10px">Danh
		Mục Sản Phẩm</h1>
	<form action="device-page" method="get" id="filter-form">
		<main>

			<section class="toolbar" style="max-width: 200px; max-height: 500px">


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
							onchange="this.form.submit()"  name="price">
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
						style="margin-left: 10px" name="sortPrice"
						onchange="this.form.submit()">
						<option value="">--Sắp Xếp--</option>
						<option value="asc"
							<c:if test="${param.sortPrice == 'asc'}">selected</c:if>><span>Giá:
								thấp đến cao</span></option>
						<option value="desc"
							<c:if test="${param.sortPrice == 'desc'}">selected</c:if>><span>Giá:
								cao đến thấp</span></option>
					</select>
					<!-- 					<button id="sort" type="submit"
						style="padding: 12px 14px; border-radius: 14px; border: 1px solid rgba(99, 102, 241, 0.35); background: rgba(255, 255, 255, 0.96); font-size: 15px; color: #1e1b4b; margin-left: 10px">
						<span>Phổ biến</span>
					</button> -->
				</section>
				<section class="product-grid">
					<c:forEach var="device" items="${listDevice}">
						<article class="product-card" style="min-width: 350px">
							<img alt="" style="width: 100%; height: 100%; object-fit: cover;"
								src="<%=request.getContextPath()%>/assets/img/laptop.jpg" />
							<h3>${device.name}</h3>
							<p>${device.desc}</p>
							<strong>Giá: <fmt:formatNumber value="${device.price + 0}"
									type="number" />
							</strong>
							<a style="text-align: center;" class="btn order-btn" href="device-detail?id=${device.id}">Xem chi tiết</a>
						</article>
					</c:forEach>

				</section>
			</section>



		</main>
	</form>

	<div class="pagination-pills">
		<c:choose>
			<c:when test="${currentPage > 1}">
				<a href="device-page?page=${currentPage - 1}&category=${param.category}&supplier=${param.supplier}&price=${param.price}&sortPrice=${param.sortPrice}&key=${param.key}">
					&#10094;</a>
			</c:when>
			<c:otherwise>
				<a class="disabled">&#10094;</a>
			</c:otherwise>
		</c:choose>

		
		<c:if test="${totalPages > 0}">
			<c:if test="${startPage > 1}">
				<a href="device-page?page=1&category=${param.category}&supplier=${param.supplier}&price=${param.price}&sortPrice=${param.sortPrice}&key=${param.key}">
					1 </a>
				<c:if test="${startPage > 2}">
					<span>...</span>
				</c:if>
			</c:if>

			
			<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<a class="${i == currentPage ? 'active' : ''}"
					href="device-page?page=${i}&category=${param.category}&supplier=${param.supplier}&price=${param.price}&sortPrice=${param.sortPrice}&key=${param.key}">
					${i} </a>
			</c:forEach>  

			
			<c:if test="${endPage < totalPages}">
				<c:if test="${endPage < totalPages - 1}">
					<span>...</span>
				</c:if>
				<a href="device-page?page=${totalPages}&category=${param.category}&supplier=${param.supplier}&price=${param.price}&sortPrice=${param.sortPrice}&key=${param.key}">
					${totalPages} </a>
			</c:if>
		</c:if>

		
		<c:choose>
			<c:when test="${currentPage < totalPages}">
				<a href="device-page?page=${currentPage + 1}&category=${param.category}&supplier=${param.supplier}&price=${param.price}&sortPrice=${param.sortPrice}&key=${param.key}">
					&#10095; </a>
			</c:when>
			<c:otherwise> 
				<a class="disabled">&#10095;</a>
			</c:otherwise>
		</c:choose>
	</div>

	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>