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
<title>NovaCare Shop - Chi tiết sản phẩm</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/shop.css" />
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

<main>
<c:choose>
  <c:when test="${not empty device}">
    <!-- Left Column -->
    <div class="left-column">
      <div class="product-image">
        <c:choose>
          <c:when test="${not empty device.imageUrl}">
            <img src="${device.imageUrl}" alt="${device.name}" />
          </c:when>
          <c:otherwise>
            <img src="<%=request.getContextPath()%>/assets/images/no-image.png" alt="No image available" />
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

    <!-- Right Column -->
    <div class="right-column">
      <article class="hero-card" aria-label="Thông tin sản phẩm">
        <h2>${device.name}</h2>
        <p><strong>Loại:</strong> 
          <c:choose>
            <c:when test="${not empty category}">${category.categoryName}</c:when>
            <c:otherwise>Chưa xác định</c:otherwise>
          </c:choose>
        </p>
        <strong class="price">
          Giá bán: 
          <c:choose>
            <c:when test="${not empty device.price}">
              <fmt:formatNumber value="${device.price}" type="number" maxFractionDigits="0" /> đ
            </c:when>
            <c:otherwise>Chưa có thông tin</c:otherwise>
          </c:choose>
        </strong>
        <p><strong>Mô tả:</strong> ${device.desc}</p>
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
      
        <div class="cta-inline">
          <a href="add-to-cart?id=${device.id}" class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a>
          <a href="checkout?id=${device.id}" class="buy-now"><i class="fa-solid fa-bolt"></i> Mua ngay</a>
          <a href="device-page" class="back">← Quay lại</a>
        </div>
      </article>

   <!--   <article class="promotion" aria-label="Danh sách serial">
        <h3>Danh sách serial & trạng thái</h3>
        <c:choose>
          <c:when test="${not empty serialList}">
            <table style="width:100%; border-collapse: collapse;">
              <thead>
                <tr style="background-color:#0284c7; color:white;">
                  <th style="padding:8px; border:1px solid #ddd;">Serial</th>
                  <th style="padding:8px; border:1px solid #ddd;">Trạng thái</th>
                  <th style="padding:8px; border:1px solid #ddd;">Ngày nhập</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="serial" items="${serialList}">
                  <tr>
                    <td style="padding:6px; border:1px solid #ddd;">${serial.serial_no}</td>
                    <td style="padding:6px; border:1px solid #ddd;">
                      <c:choose>
                        <c:when test="${serial.status.name() == 'IN_STOCK'}">Còn hàng</c:when>
                        <c:when test="${serial.status.name() == 'SOLD'}">Đã bán</c:when>
                        <c:when test="${serial.status.name() == 'IN_REPAIR'}">Đang bảo trì</c:when>
                        <c:when test="${serial.status.name() == 'OUT_STOCK'}">Hết hàng</c:when>
                        <c:otherwise>Không xác định</c:otherwise>
                      </c:choose>
                    </td>
                    <td style="padding:6px; border:1px solid #ddd;">
                      <fmt:formatDate value="${serial.import_date}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <p>Chưa có serial nào được nhập cho thiết bị này.</p>
          </c:otherwise>
        </c:choose>
      </article> -->

    </div>

    <c:if test="${not empty relatedDevices}">
      <section class="related-products" style="width:100%; margin-top:60px;">
        <h2>Sản phẩm liên quan</h2>
        <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap:24px;">
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
              <p style="font-size:16px; color:#ff6600; font-weight:700; margin:4px 0;">
                <fmt:formatNumber value="${rel.price}" type="number" maxFractionDigits="0"/> đ
              </p>
              <div class="cta-inline">
                <a href="device-detail?id=${rel.id}" class="buy-now"><i class="fa-solid fa-eye"></i> Xem chi tiết</a>
                <a href="add-to-cart?id=${rel.id}" class="add-to-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</a>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>
    </c:if>

  </c:when>
  <c:otherwise>
    <h2 style="color:red; text-align:center;">Không tìm thấy thiết bị!</h2>
    <a href="device-page" style="display:block; text-align:center; margin-top:24px;">← Quay lại danh sách</a>
  </c:otherwise>
</c:choose>
</main>

<!-- Footer -->
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
