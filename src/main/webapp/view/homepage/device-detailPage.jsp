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
<title>NovaCare Shop - Chi tiết sản phẩm</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/shop.css">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>

.product-detail {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.product-detail article {
    border: 1px solid #e2e8f0;
    padding: 16px;
    border-radius: 8px;
}

.warranty {
    grid-column: span 2;
}

.cta a.order-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 10px 16px;
    border-radius: 8px;
    font-weight: bold;
    text-decoration: none;
}

.cta a.order-btn:hover {
    opacity: 0.9;
}

.product-image {
    text-align: center;
}

.product-image img {
    max-width: 100%;
    border-radius: 8px;
}
</style>
</head>

<body class="shop-page detail-page">
<jsp:include page="../common/header.jsp"></jsp:include>

<h1 style="text-align:center; color:#312e81; margin-top:10px">Chi tiết sản phẩm</h1>

<main>
    <c:choose>
        <c:when test="${not empty device}">
            <section class="product-detail">
                <article class="product-image">
                    <c:choose>
                        <c:when test="${not empty device.imageUrl}">
                            <img src="${device.imageUrl}" alt="${device.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="<%=request.getContextPath()%>/assets/images/no-image.png" alt="No image available">
                        </c:otherwise>
                    </c:choose>
                </article>
                <article class="hero-card">
                    <h2>${device.name}</h2>
                    <p>Loại: <c:choose>
                        <c:when test="${not empty category}">${category.categoryName}</c:when>
                        <c:otherwise>Chưa xác định</c:otherwise>
                    </c:choose></p>
                    <strong style="font-size:18px; color:#e11d48;">
                        Giá bán: 
                        <c:choose>
                            <c:when test="${not empty device.price}">
                                <fmt:formatNumber value="${device.price}" type="number" maxFractionDigits="0"/> đ
                            </c:when>
                            <c:otherwise>Chưa có thông tin</c:otherwise>
                        </c:choose>
                    </strong>
                    <p>Mô tả: ${device.desc}</p>
                </article>

                <!-- Nhà cung cấp & Bảo hành -->
                <article class="warranty">
                    <h3>Nhà cung cấp & Giá nhập</h3>
                    <ul>
                        <c:forEach var="supplier" items="${suppliers}">
                            <li>${supplier.name} - Giá nhập: 
                                <c:choose>
                                    <c:when test="${not empty supplier.price}">
                                        <fmt:formatNumber value="${supplier.price}" type="number" maxFractionDigits="0"/> đ
                                    </c:when>
                                    <c:otherwise>Chưa có thông tin</c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                    </ul>
                    <h3>Bảo hành & hỗ trợ</h3>
                    <p>Bảo hành 24 tháng tiêu chuẩn, hỗ trợ kỹ thuật 24/7.</p>
                    <p>Nâng cấp gói Premium thêm 12 tháng onsite.</p>
                </article>
            </section>

            <!-- CTA Buttons -->
            <div class="cta" style="margin-top:20px; display:flex; gap:10px; flex-wrap:wrap;">
                <a href="add-to-cart?id=${device.id}" class="order-btn" style="background:#22c55e; color:#fff;">
                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                </a>
                <a href="checkout?id=${device.id}" class="order-btn" style="background:#e11d48; color:#fff;">
                    <i class="fa-solid fa-bolt"></i> Mua ngay
                </a>
                <a href="device-page" class="order-btn" style="background:#f1f5f9; color:#312e81;">
                    ← Quay lại danh mục
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <h2 style="color:red;text-align:center;">Không tìm thấy thiết bị!</h2>
            <a href="device-page" style="display:block;text-align:center;">← Quay lại danh sách</a>
        </c:otherwise>
    </c:choose>
</main>

<!-- Footer -->
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
