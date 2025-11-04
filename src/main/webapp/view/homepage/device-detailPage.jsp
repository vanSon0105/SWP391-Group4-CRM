<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>TechShop - Chi tiết sản phẩm</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.left-column {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.product-image {
    background-color: #f9fafb;
    padding: 32px;
    border-radius: 12px;
    border: 1px solid #ddd;
    display: flex;
    justify-content: center;
    align-items: center;
}

.product-image img {
    max-width: 100%;
    border-radius: 12px;
    max-height: 500px;
    object-fit: contain;
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.05);
}

.warranty {
    background-color: #fff6e5;
    border: 1px solid #ffd773;
    padding: 32px 40px;
    border-radius: 16px;
    box-shadow: 0 4px 18px rgba(255, 215, 0, 0.25);
}

.warranty h3 {
    color: #ff6600;
    font-weight: 700;
    font-size: 26px;
    margin-bottom: 20px;
    border-bottom: 3px solid #ff6600;
    padding-bottom: 8px;
}

.warranty ul {
    list-style: none;
    padding-left: 0;
    margin-bottom: 20px;
}

.warranty ul li {
    position: relative;
    font-size: 18px;
    padding-left: 32px;
    margin-bottom: 14px;
    color: #333;
    line-height: 1.3;
}

.warranty ul li::before {
    content: "✔";
    position: absolute;
    left: 0;
    top: 2px;
    color: #ff6600;
    font-weight: 700;
    font-size: 20px;
}

.warranty p {
    font-size: 18px;
    font-weight: 600;
    color: #cc5200;
}

.right-column {
    display: flex;
    flex-direction: column;
    gap: 36px;
}

.hero-card {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 24px;
    border: 1px solid #ddd;
    border-radius: 12px;
    background-color: #fff;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
}

.hero-card h2 {
    font-size: 28px;
    color: #0066b3;
    font-weight: 700;
    margin: 0;
}

.hero-card p {
    font-size: 16px;
    color: #444;
    margin: 4px 0;
}

.hero-card strong.price {
    color: red !important;
    font-weight: 600;
    margin-top: auto;
    padding: 6px 0;
    border-radius: 8px;
    font-size: 3.5rem;
}

.promotion {
    background-color: #e0f2fe;
    border: 1px solid #90cdf4;
    border-radius: 16px;
    padding: 28px 32px;
    box-shadow: 0 4px 18px rgba(14, 165, 233, 0.3);
}

.promotion h3 {
    font-size: 26px;
    font-weight: 700;
    color: #0284c7;
    margin-bottom: 18px;
    border-bottom: 3px solid #0284c7;
    padding-bottom: 8px;
}

.promotion ul {
    list-style: disc inside;
    font-size: 18px;
    color: #0369a1;
    padding-left: 10px;
    margin: 0;
}

.promotion ul li {
    margin-bottom: 12px;
}

.cta-inline {
    display: flex;
    gap: 12px;
    margin-top: 16px;
    flex-wrap: wrap;
    justify-content: flex-start;
}

.cta-inline a {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 12px 14px;
    border-radius: 20px;
    font-size: 1.6rem;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.cta-inline a i {
    margin-right: 6px;
    font-size: 1.6rem;
}

.cta-inline a.back {
  background: linear-gradient(90deg, #f5f5f5, #e0e0e0);
  color: #555;
}


.cta-inline a.buy-now {
    background: linear-gradient(90deg, #d2661a, #ff8a61);
    color: white;
}


.related-products {
  margin-top: 60px;
  text-align: center;
}

.related-products .related-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 24px;
  justify-content: center;
  max-width: 1000px;
  margin: 0 auto; 
}


.related-products h2 {
    text-align: center;
    margin-bottom: 24px;
}

.related-products .hero-card img {
    height: 160px;
    object-fit: contain;
    margin-bottom: 12px;
}

.related-products .hero-card .cta-inline {
    justify-content: center;
    margin-top: 12px;
}

.related-products .hero-card .cta-inline a {
    padding: 12px 10px;
    font-size: 13px;
}


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
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    list-style: none;
    padding-left: 0;
    margin-top: 24px;
    gap: 4px;
}

.page-item {
    display: inline-block;
}

.page-item .page-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    color: black;
    border: 1px solid #dee2e6;
    border-radius: 16px;
    background-color: #fff;
    font-weight: 600;
    transition: transform 0.2s ease;
}

.page-item .page-link:hover {
    transform: translateY(-2px);
}

.page-item.active .page-link {
    background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
    color: #fff;
}

.page-item.disabled .page-link {
    background-color: #f8f9fa;
    color: #aaa;
    border-color: #dee2e6;
    cursor: not-allowed;
}

.page-link {
    text-decoration: none !important;
}


.product-image {
    text-align: center;
}

.product-image img {
    max-width: 100%;
    border-radius: 8px;
}

.related-price{
	color: #fff !important;
    font-weight: 600;
    margin-top: auto;
    padding: 6px 14px;
    border-radius: 8px;
    background: linear-gradient(135deg, #d50000 60%, #000 60%);
}
</style>
</head>
<body class="shop-page detail-page">
<jsp:include page="../common/header.jsp"></jsp:include>

<main>
<c:choose>
  <c:when test="${not empty device}">
  	<div class="container">
    <!-- Left Column -->
    
    <div class="left-column">
      <div class="product-image">
        <c:choose>
          <c:when test="${not empty device.imageUrl}">
            <img src="${pageContext.request.contextPath}/assets/img/device/${device.imageUrl}" alt="${device.name}" />
          </c:when>
          <c:otherwise>
            <img src="<%=request.getContextPath()%>/assets/images/uno-image.png" alt="No image available" />
          </c:otherwise>
        </c:choose>
      </div>
      
      <article class="warranty" aria-label="Cam kết mua hàng">
        <h3>Cam kết của TechShop</h3>
        <ul>
          <li>Cam kết hàng chính hãng 100%, nguồn gốc xuất xứ rõ ràng.</li>
          <li>Bảo hành chính hãng lên đến 24 tháng, đổi mới trong 7 ngày nếu lỗi kỹ thuật.</li>
          <li>Miễn phí giao hàng nội thành, giao hàng nhanh trong 24h.</li>
          <li>Hỗ trợ kỹ thuật và tư vấn 24/7, tận tâm và chuyên nghiệp.</li>
          <li>Đổi trả linh hoạt, hỗ trợ hoàn tiền nếu không hài lòng.</li>
          <li>Chương trình bảo hành mở rộng lên đến 36 tháng với chi phí ưu đãi.</li>
          <li>Cam kết giá tốt nhất thị trường, không phát sinh thêm chi phí.</li>
          <li>Bảo mật thông tin khách hàng tuyệt đối, an toàn khi giao dịch.</li>
        </ul>
        <p><strong>Đặc biệt:</strong> Nâng cấp gói bảo hành Premium thêm 12 tháng onsite với dịch vụ tận nơi nhanh chóng.</p>
      </article>
    </div>

    <div class="right-column">
      <article class="hero-card" aria-label="Thông tin sản phẩm" id="hero-card">
        <h2>${device.name}</h2>
        <p><strong>Loại:</strong> 
          <c:choose>
            <c:when test="${not empty category}">${category.name}</c:when>
            <c:otherwise>Chưa xác định</c:otherwise>
          </c:choose>
        </p>
        <strong class="price">
          Giá bán: 
          <c:choose>
            <c:when test="${not empty device.price}">
              <fmt:formatNumber value="${device.price}" type="number" maxFractionDigits="0" /> VNĐ
            </c:when>
            <c:otherwise>Chưa có thông tin</c:otherwise>
          </c:choose>
        </strong>
        <p><strong>Mô tả:</strong> ${device.desc}</p>
        
        <div class="cta-inline">
       <!--<a href="cart-add?id=${device.id}#hero-card" class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a> -->
          <a href="cart-add?id=${device.id}" class="btn order-btn"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a>
          <a href="checkout?id=${device.id}" class="btn order-btn buy-now"><i class="fa-solid fa-bolt"></i> Mua ngay</a>
          <a href="device-page" class="btn order-btn back">← Quay lại</a>
        </div>
      </article>

      <article class="promotion" aria-label="Khuyến mãi">
        <h3>Khuyến mãi đặc biệt</h3>
        <ul>
          <li>Giảm giá 10% cho đơn hàng đầu tiên khi đăng ký tài khoản thành viên.</li>
          <li>Voucher mua kèm linh kiện giảm đến 15% cho các sản phẩm phụ kiện chính hãng.</li>
          <li>Tặng quà hấp dẫn trị giá đến 500.000đ theo từng đợt khuyến mãi trong năm.</li>
          <li>Miễn phí vận chuyển toàn quốc cho đơn hàng từ 2 triệu đồng trở lên.</li>
          <li>Hỗ trợ trả góp 0% lãi suất qua các ngân hàng đối tác, thủ tục nhanh gọn.</li>
          <li>Ưu đãi đặc quyền cho khách hàng VIP với các sự kiện riêng và giảm giá sâu.</li>
          <li>Chương trình đổi cũ lấy mới, thu cũ đổi mới với giá hấp dẫn và nhanh chóng.</li>
          <li>Khuyến mãi theo mùa, theo dịp lễ lớn với nhiều quà tặng hấp dẫn.</li>
        </ul>
      
        
      </article>

   
    </div>
	</div>
    <c:if test="${not empty relatedDevices}">
      <section class="related-products">
  <h2 id="related-grid">Sản phẩm liên quan</h2>
  <div class="related-grid">
    <c:forEach var="rel" items="${relatedDevices}">
      <div class="hero-card" style="padding:16px; border:1px solid #ddd; border-radius:12px; text-align:center;">
        <c:choose>
          <c:when test="${not empty rel.imageUrl}">
            <img src="${rel.imageUrl}" alt="${rel.name}" />
          </c:when>
          <c:otherwise>
            <img src="<%=request.getContextPath()%>/assets/images/no-image.png" alt="No image" />
          </c:otherwise>
        </c:choose>
        <h3 style="font-size:18px; color:#0066b3; margin:8px 0;">${rel.name}</h3>
        <p class="related-price">Giá:
          <fmt:formatNumber value="${rel.price}" type="number" maxFractionDigits="0"/> đ
        </p>
        <div class="cta-inline">
          <a href="device-detail?id=${rel.id}" class="btn order-btn buy-now"><i class="fa-solid fa-eye"></i> Xem chi tiết</a>
          <a href="cart-add?id=${rel.id}" class="btn order-btn"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a>
        <!-- <a href="cart-add?id=${device.id}" class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a> --> 
        </div>
      </div>
    </c:forEach>
  </div>

  <c:if test="${totalPages > 1}">
    <nav aria-label="Page navigation" style="margin-top:24px;">
      <ul class="pagination justify-content-center">

        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
          <a class="page-link"
             href="device-detail?id=${device.id}&page=${currentPage - 1}#related-grid">
            &#10094;
          </a>
        </li>

        <c:set var="startPage" value="${currentPage - 2}" />
        <c:set var="endPage" value="${currentPage + 2}" />
        <c:if test="${startPage < 1}">
          <c:set var="endPage" value="${endPage + (1 - startPage)}" />
          <c:set var="startPage" value="1" />
        </c:if>
        <c:if test="${endPage > totalPages}">
          <c:set var="startPage" value="${startPage - (endPage - totalPages)}" />
          <c:set var="endPage" value="${totalPages}" />
        </c:if>
        <c:if test="${startPage < 1}">
          <c:set var="startPage" value="1" />
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link" href="device-detail?id=${device.id}&page=${i}#related-grid">${i}</a>
          </li>
        </c:forEach>

        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
          <a class="page-link"
             href="device-detail?id=${device.id}&page=${currentPage + 1}#related-grid">
            &#10095;
          </a>
        </li>

      </ul>
    </nav>
  </c:if>
</section>
    </c:if>

  </c:when>
  <c:otherwise>
    <h2 style="color:red; text-align:center;">Không tìm thấy thiết bị!</h2>
    <a href="device-page" style="display:block; text-align:center; margin-top:24px;">← Quay lại danh sách</a>
  </c:otherwise>
</c:choose>
</main>

<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
