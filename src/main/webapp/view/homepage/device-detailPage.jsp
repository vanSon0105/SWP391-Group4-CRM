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

  * { box-sizing: border-box; }
  body { margin:0; font-family:"Segoe UI",Tahoma,Geneva,Verdana,sans-serif; background-color:#f5f5f7; color:#333; min-height:100vh; display:flex; flex-direction:column;}
  header.header-toolbar { background-color:#0066b3; color:white; padding:12px 36px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; position:sticky; top:0; z-index:999; }
  header.header-toolbar h1 { font-size:28px; font-weight:700; margin:0; }
  header .header-center { flex-grow:1; max-width:600px; margin:10px 24px; }
  header .header-center form.search-bar { display:flex; border-radius:8px; overflow:hidden; background:white; width:100%; }
  header .header-center input[type="search"] { flex-grow:1; padding:10px 14px; border:none; font-size:16px; outline:none; }
  header .header-center button { background-color:#ff6600; border:none; color:white; padding:0 20px; cursor:pointer; font-size:18px; display:flex; align-items:center; justify-content:center; transition:background-color 0.3s ease; }
  header .header-center button:hover { background-color:#e65c00; }
  header .header-bottom { display:flex; gap:16px; }
  header .header-bottom a.order-btn { background-color:#ff6600; color:white; padding:10px 18px; border-radius:20px; font-weight:600; display:flex; align-items:center; gap:8px; text-decoration:none; transition:background-color 0.3s ease; }
  header .header-bottom a.order-btn:hover { background-color:#e65c00; }

  main { width:100%; max-width:1200px; margin:30px auto 60px auto; padding:24px 36px; background:white; border-radius:12px; box-shadow:0 8px 24px rgba(0,0,0,0.1); display:grid; grid-template-columns:2fr 1.4fr; gap:48px; }
  @media (max-width:1024px){ main{ grid-template-columns:1fr; padding:20px 24px; } }

  .left-column { display:flex; flex-direction:column; gap:24px; }
  .product-image { background-color:#f9fafb; padding:32px; border-radius:12px; border:1px solid #ddd; display:flex; justify-content:center; align-items:center; }
  .product-image img { max-width:100%; border-radius:12px; max-height:500px; object-fit:contain; box-shadow:0 6px 12px rgba(0,0,0,0.05); }

  .warranty { background-color:#fff6e5; border:1px solid #ffd773; padding:32px 40px; border-radius:16px; box-shadow:0 4px 18px rgba(255,215,0,0.25); }
  .warranty h3 { color:#ff6600; font-weight:700; font-size:26px; margin-bottom:20px; border-bottom:3px solid #ff6600; padding-bottom:8px; }
  .warranty ul { list-style:none; padding-left:0; margin-bottom:20px; }
  .warranty ul li { position:relative; font-size:18px; padding-left:32px; margin-bottom:14px; color:#333; line-height:1.3; }
  .warranty ul li::before { content:"✔"; position:absolute; left:0; top:2px; color:#ff6600; font-weight:700; font-size:20px; }
  .warranty p { font-size:18px; font-weight:600; color:#cc5200; }

  .right-column { display:flex; flex-direction:column; gap:36px; }
  .hero-card { display:flex; flex-direction:column; gap:16px; padding:24px; border:1px solid #ddd; border-radius:12px; background-color:#fff; box-shadow:0 6px 18px rgba(0,0,0,0.08); }
  .hero-card h2 { font-size:28px; color:#0066b3; font-weight:700; margin:0; }
  .hero-card p { font-size:16px; color:#444; margin:4px 0; }
  .hero-card strong.price { font-size:24px; color:#ff6600; font-weight:700; margin-top:8px; }

  .promotion { background-color:#e0f2fe; border:1px solid #90cdf4; border-radius:16px; padding:28px 32px; box-shadow:0 4px 18px rgba(14,165,233,0.3); }
  .promotion h3 { font-size:26px; font-weight:700; color:#0284c7; margin-bottom:18px; border-bottom:3px solid #0284c7; padding-bottom:8px; }
  .promotion ul { list-style:disc inside; font-size:18px; color:#0369a1; padding-left:10px; margin:0; }
  .promotion ul li { margin-bottom:12px; }

  .cta-inline { display:flex; gap:12px; margin-top:16px; flex-wrap:wrap; justify-content:flex-start; }
  .cta-inline a { display:inline-flex; align-items:center; justify-content:center; padding:6px 14px; border-radius:20px; font-size:14px; font-weight:600; text-decoration:none; transition:all 0.3s ease; box-shadow:0 4px 12px rgba(0,0,0,0.15); }
  .cta-inline a i { margin-right:6px; font-size:14px; }

  .cta-inline a.add-to-cart { background-color:#2db400; color:white; }
  .cta-inline a.add-to-cart:hover { background-color:#228800; box-shadow:0 6px 16px rgba(34,136,0,0.4); }

  .cta-inline a.buy-now { background-color:#ff6600; color:white; }
  .cta-inline a.buy-now:hover { background-color:#cc5200; box-shadow:0 6px 16px rgba(204,82,0,0.4); }

  .cta-inline a.back { background-color:#eee; color:#555; }
  .cta-inline a.back:hover { background-color:#ddd; box-shadow:0 4px 12px rgba(0,0,0,0.1); }

  .related-products h2 { text-align:center; margin-bottom:24px; }
  .related-products .hero-card img { height:160px; object-fit:contain; margin-bottom:12px; }
  .related-products .hero-card .cta-inline { justify-content:center; margin-top:12px; }
  .related-products .hero-card .cta-inline a { padding:6px 10px; font-size:13px; }
  
  footer { width:100%; background-color:#0066b3; color:white; padding:24px 36px; text-align:center; font-weight:600; font-size:16px; margin-top:auto; }
</style>
</head>
<body>
<header class="header-toolbar">
  <h1>NovaCare Shop</h1>
  <div class="header-center">
    <form class="search-bar" action="device-page" method="get" role="search">
      <input id="search" name="search" type="search" placeholder="Tìm thiết bị, linh kiện, ..." aria-label="Tìm kiếm thiết bị" />
      <button type="submit" aria-label="Tìm kiếm"><i class="fa-solid fa-magnifying-glass"></i></button>
    </form>
  </div>
  <div class="header-bottom">
    <a href="login.html" class="order-btn login-btn" title="Đăng nhập"><i class="fa-solid fa-user"></i> Đăng nhập</a>
    <a href="cart.jsp" class="order-btn" title="Giỏ hàng"><i class="fa-solid fa-cart-shopping"></i> Giỏ hàng</a>
  </div>
</header>

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
        <h3>Cam kết của NovaCare Shop</h3>
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

<footer>
  NovaCare Shop · Mua sắm an tâm với bảo hành chuẩn quốc tế.
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/js/all.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</body>
</html>
