<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechShop</title>
    <style>
		.banner-btn a:not(a:first-child) {
		  background: transparent !important;
		  color: #fff !important;
    	  border: 1px solid rgba(248, 250, 252, 0.65);
    	  padding: 14px 28px;
		  border-radius: 999px;
		  text-decoration: none;
		  font-weight: 600;
		  box-shadow: 0 16px 30px rgba(248, 250, 252, 0.32);
		}
		
		.banner-btn .btn:first-child {
		  background-color: #fff;
		  color: #000;
		  z-index: 1;
		  border: 1px solid rgba(248, 250, 252, 0.65);
    	  padding: 14px 28px;
		  border-radius: 999px;
		  text-decoration: none;
		  font-weight: 600;
		  box-shadow: 0 16px 30px rgba(248, 250, 252, 0.32);
		}
		
		.banner-btn .btn:first-child:hover {
		  color: black;
		}
		
		.banner-btn .btn:first-child::after {
		  background-color: #fbbf24;
		}
		
		.device-card {
		  background: #fff;
		  border-radius: 12px;
		  padding: 16px;
		  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
		  transition: all 0.3s ease;
		}
		.device-card:hover {
		  transform: translateY(-5px);
		  box-shadow: 0 8px 20px rgba(0,0,0,0.15);
		}
		.device-thumb img {
		  transition: transform 0.3s ease;
		}
		.device-card:hover .device-thumb img {
		  transform: scale(1.05);
		}
		
		.category {
		  transition: transform 0.3s ease, box-shadow 0.3s ease;
		}
		.category:hover {
		  transform: translateY(-6px);
		  box-shadow: 0 8px 20px rgba(0,0,0,0.1);
		}
		.category h3::before {
		  content: "💡";
		  margin-right: 8px;
		}
		
		.img-banner{
		  object-fit: cover;
		  height: 435px;
		  width: 580px;
		  position: absolute;
		  top: -55px;
		  right: 70px;
		}
		
		.promo-card-item{
			display: flex;
			align-items: center;
			gap: 5px;
			justify-content: space-between;
		}
		
		.promo-card img{
	      object-fit: cover;
		  height: 100%;
		  width: 180px;
		  border-radius: 5px;
		}
		
		.container-item{
			display: flex;
			flex-direction: column;
			gap: 7px;
		}
		
		.promo-card h3 {
		  display: flex;
		  align-items: center;
		  gap: 6px;
		  margin: 8px 0;
		}
		
		.promo-tag i,
		.promo-card i {
		  color: #00ffc9;
		}
		
		.promo-tag {
		  align-items: center;
		  color: #00ffc9;
		  font-weight: 600;
		}
		
		.promo-price {
		  display: inline-flex;
		  align-items: center;
		  gap: 6px;
		  padding: 6px 14px;
		  border-radius: 8px;
		  background: linear-gradient(135deg, #d50000 60%, #000 60%);
		}
		
		.promo-price strong {
		  font-size: 3.5rem;
		  font-weight: 700;
		}
		
		.promo-card {
		  position: relative;
		  background: #fff;
		  border-radius: 12px;
		  padding: 16px;
		  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
		  transition: all 0.3s ease;
		  overflow: hidden;
		}
		
		.promo-card:hover {
		  transform: translateY(-5px);
		  box-shadow: 0 8px 20px rgba(0,0,0,0.15);
		}
		
		.promo-link {
		  position: absolute;
		  inset: 0;
		  z-index: 2;
		}
		
		.promo-card * {
		  pointer-events: none;
		}
		
		.promo-link {
		  pointer-events: auto;
		  cursor: pointer;
		}
    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <section class="mega-banner" aria-labelledby="banner-title">
            <div class="mega-banner-content">
                <h2 id="banner-title">Mua sắm điện máy thăng hoa - Ưu đãi đến 20% cho toàn bộ thiết bị</h2>
                <p>Từ laptop, smartphone đến dịch vụ sửa chữa. Chỉ một lần chạm là bạn được chăm sóc tận tình cùng đội ngũ kỹ thuật của TechShop</p>
                <div class="banner-btn">
                    <a class="btn" href="device-page">Khám phá sản phẩm</a>
                    <a class="btn" href="order-tracking">Theo dõi đơn hàng</a>
                    <a class="btn" href="issue">Theo dõi bảo hành</a>
                </div>
            </div>
            
            <img class="img-banner" alt="" src="${pageContext.request.contextPath}/assets/img/img-banner.png">
            
            <div class="banner-promos" data-hero-slider>
			    <button class="hero-nav" type="button" data-hero-direction="prev" aria-label="Sản phẩm trước"><i
			            class="fa-solid fa-chevron-left"></i></button>
			    <div class="banner-promos-window">
				  <div class="banner-promos-track">
				    <c:forEach items="${bannerList}" var="s"> 
				      <article class="promo-card">
				      	<a href="device-detail?id=${s.id}" class="promo-link"></a>
				        <div class="promo-card-item">
				          <div class="container-item">
				            <span class="promo-tag"><i class="fa-solid fa-bolt"></i> ${s.category.name}</span>
				            <h3><i class="fa-solid fa-gift"></i> ${s.name}</h3>
				            <p>
				              <i class="fa-solid fa-exchange-alt"></i> Thu cũ đổi mới lên đến 
				              <strong><fmt:formatNumber value="${s.price}" type="number" /> VND</strong>
				            </p>
				            <p><i class="fa-solid fa-shield-heart"></i> Bảo hành ${s.warrantyMonth} tháng</p>
				          </div>
				          <img src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}" alt="${s.name}" class="promo-img">
				        </div>
				        <span class="promo-price">
				          <i class="fa-solid fa-tag"></i> Giá ưu đãi: 
				          <strong><fmt:formatNumber value="${s.price}" type="number" /> VND</strong>
				        </span>
				      </article>
				    </c:forEach>
				  </div>
				</div>
			    <button class="hero-nav" type="button" data-hero-direction="next" aria-label="Sản phẩm tiếp theo"><i
			            class="fa-solid fa-chevron-right"></i></button>
			</div>
        </section>

        <section class="featured-categories">
            <a class="shortcut-card" href="device-page?category=1">
                <span class="shortcut-icon">💻</span>
                <span class="shortcut-label">Laptop &amp; PC</span>
            </a>
            <a class="shortcut-card" href="device-page?category=2">
                <span class="shortcut-icon">📱</span>
                <span class="shortcut-label">Điện Thoại</span>
            </a>
            <a class="shortcut-card" href="create-issue">
                <span class="shortcut-icon">🔧</span>
                <span class="shortcut-label">Bảo Hành</span>
            </a>
            <a class="shortcut-card" href="create-issue">
                <span class="shortcut-icon">🛠️</span>
                <span class="shortcut-label">Sửa Chữa</span>
            </a>
        </section>

        <section class="featured-devices" id= "featured-devices">
            <div class="section-header">
                <h2 id="featured-title">Thiết Bị Nổi Bật</h2>
                <div class="slider-controls">
                    <c:choose>
				        <c:when test="${currentFeaturedPage > 1}">
				            <a href="home?fpage=${currentFeaturedPage - 1}&npage=${currentNewPage}&bpage=${currentBestSellingPage}#featured-devices">&#10094;</a>
				        </c:when>
				        <c:otherwise>
				            <a class="disabled">&#10094;</a>
				        </c:otherwise>
				    </c:choose>
	        		
            		 <c:choose>
		                <c:when test="${currentFeaturedPage < totalFeaturedPages}">
		                	<a href = "home?fpage=${currentFeaturedPage + 1}&npage=${currentNewPage}&bpage=${currentBestSellingPage}#featured-devices">&#10095;</a>            	
		            	</c:when>
		            	<c:otherwise>
				            <a class="disabled">&#10095;</a>
				        </c:otherwise>
		            </c:choose>
                </div>
            </div>
            <div class="device-slider">
                <div class="device-window">
                    <div class="device-track">
              		<c:forEach items="${listFeatured}" var="s">
	              			<div class="device-card">
              			<a href="device-detail?id=${s.id}">
	                        	<div class="device-thumb">
	                        		<img alt="" src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}">
	                        	</div>
	                            <h4>${s.getName()}</h4>
	                            <p>${s.getDesc()}</p>
	                            <span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VND</span>
                        </a>
	                            <a class="btn device-buy-btn" href="cart-add?id=${s.id}#featured-devices">Mua sản phẩm</a>
	                        </div>
                    </c:forEach>
                    </div>
                </div>
           </div>
        </section>

		<div class="img-gallery-6">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
        </div>

        <section class="device-list new-devices" id="new-devices">
            <div class="section-heading">
                <h2 id="new-devices-title">Thiết Bị Mới Về</h2>
                <p>Những sản phầm vừa mới về Shop88 và sẵn sàng bấm ngay</p>
            </div>
            
            <div class="device-window">
                <div class="device-track">
                <c:forEach items="${listNew}" var="s"> 
	                    <div class="device-card">
	                <a href="device-detail?id=${s.id}">
	                    	<div class="device-thumb">
	                       		<img alt="" src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}">
	                       	</div>
	                        <h4>${s.getName()}</h4>
	                        <p>${s.getDesc()}</p>
	                        <span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VND</span>
                    </a>
	                        <a class="btn device-buy-btn" href="cart-add?id=${s.id}#new-devices">Mua sản phẩm</a>
	                    </div>
                </c:forEach>
                </div>
            </div>
                
            <div class="pagination-pills">
            	<c:choose>
			        <c:when test="${currentNewPage > 1}">
			            <a href="home?npage=${currentNewPage - 1}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devices">&#10094;</a>
			        </c:when>
			        <c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
			    </c:choose>
			    
			    <c:if test="${totalNewPages >= 10}">
				  <c:set var="start" value="${currentNewPage - 1}" />
				  <c:set var="end" value="${currentNewPage + 1}" />
				
				  <c:if test="${start < 1}">
				    <c:set var="start" value="1" />
				  </c:if>
				  
				  <c:if test="${end > totalNewPages}">
				    <c:set var="end" value="${totalNewPages}" />
				  </c:if>
				
				  <c:if test="${start > 1}">
				    <a href="home?npage=1&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devicesd">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="home?npage=${i}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devices"
				       class="${i == currentNewPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalNewPages}">
				    <span>…</span>
				    <a href="home?npage=${totalNewPages}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devices">
				      ${totalNewPages}
				    </a>
				  </c:if>
				</c:if>
            	
            	<c:if test="${totalNewPages < 10}">
	            	<c:forEach var="i" begin="1" end="${totalNewPages}">
	            		<a href="home?npage=${i}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devices"
	               		class="${i == currentNewPage ? 'active' : ''}">${i}</a>
	        		</c:forEach>           	
            	</c:if>
            	
            	<c:choose>
	                <c:when test="${currentNewPage < totalNewPages}">
	                	<a href = "home?npage=${currentNewPage + 1}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#new-devices">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
            </div>
        </section>
        
        <div class="img-gallery-4">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/laptop.jpg" alt="">
        </div>

        <section class="device-list best-sellers" id="best-sellers">
            <div class="section-heading">
                <h2 id="best-sellers-title">Thiết Bị Bán Chạy</h2>
                <p>Được khách hàng lựa chọn và mua nhiều nhất.</p>
            </div>
            <div class="device-slider">
                <div class="device-window">
                    <div class="device-track">
                    <c:forEach items="${listBestSellingDevices}" var="s"> 
	                        <div class="device-card">
	                    <a href="device-detail?id=${s.id}">
	                        	<div class="device-thumb">
		                       		<img alt="" src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}">
		                       	</div>
	                            <h4>${s.getName()}</h4>
	                        	<p>${s.getDesc()}</p>
	                        	<span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VND</span>
                        </a>
	                        	<a class="btn device-buy-btn" href="cart-add?id=${s.id}#best-sellers">Mua sản phẩm</a>
	                        </div>
                    </c:forEach>
                    </div>
                </div>
            </div>
            <div class="pagination-pills" data-pagination="best-sellers">          
                <c:choose>
			        <c:when test="${currentBestSellingPage > 1}">
			            <a href="home?bpage=${currentBestSellingPage - 1}&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers">&#10094;</a>
			        </c:when>
			        <c:otherwise>
			            <a class="disabled">&#10094;</a>
			        </c:otherwise>
			    </c:choose>
            	
            	<c:if test="${totalBestSellingPages >= 10}">
				  <c:set var="start" value="${currentBestSellingPage - 1}" />
				  <c:set var="end" value="${currentBestSellingPage + 1}" />
				
				  <c:if test="${start < 1}">
				    <c:set var="start" value="1" />
				  </c:if>
				  
				  <c:if test="${end > totalBestSellingPages}">
				    <c:set var="end" value="${totalBestSellingPages}" />
				  </c:if>
				
				  <c:if test="${start > 1}">
				    <a href="home?bpage=1&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="home?bpage=${i}&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers"
				       class="${i == currentBestSellingPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalBestSellingPages}">
				    <span>…</span>
				    <a href="home?bpage=${totalBestSellingPages}&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers">
				      ${totalBestSellingPages}
				    </a>
				  </c:if>
				</c:if>
            	
            	<c:if test="${totalBestSellingPages < 10}">
	            	<c:forEach var="i" begin="1" end="${totalBestSellingPages}">
	            		<a href="home?bpage=${i}&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers"
	               		class="${i == currentBestSellingPage ? 'active' : ''}">${i}</a>
	        		</c:forEach>           	
        		</c:if>
            	
            	<c:choose>
	                <c:when test="${currentBestSellingPage < totalBestSellingPages}">
	                	<a href = "home?bpage=${currentBestSellingPage + 1}&fpage=${currentFeaturedPage}&npage=${currentNewPage}#best-sellers">&#10095;</a>            	
	            	</c:when>
	            	<c:otherwise>
			            <a class="disabled">&#10095;</a>
			        </c:otherwise>
	            </c:choose>
            </div>
        </section>

        <section class="device-list category-section">
		    <div class="section-heading">
		        <h2>Danh mục chuyên sâu</h2>
		        <p>Khám phá giải pháp phù hợp cho nhu cầu của bạn.</p>
		    </div>
		    <div class="categories">
		        <div class="category">
		            <h3>Laptop &amp; PC</h3>
		            <ul>
		                <li>Laptop đồ họa, gaming, văn phòng</li>
		                <li>Máy bàn All-in-one, linh kiện nâng cấp</li>
		                <li>Dịch vụ vệ sinh, tối ưu hiệu năng định kỳ</li>
		            </ul>
		        </div>
		        <div class="category"
		            style="background:linear-gradient(135deg, rgba(251,191,36,0.28), rgba(248,113,113,0.28)); border-color:rgba(249,115,22,0.32);">
		            <h3>Điện thoại &amp; Tablet</h3>
		            <ul>
		                <li>Smartphone flagship, mid-range</li>
		                <li>Tablet học tập, giải trí</li>
		                <li>Gói bảo hiểm rơi vỡ, hỗ trợ thay màn</li>
		            </ul>
		        </div>
		        <div class="category"
		            style="background:linear-gradient(135deg, rgba(134,239,172,0.28), rgba(125,211,252,0.28)); border-color:rgba(34,197,94,0.32);">
		            <h3>Linh kiện bảo hành</h3>
		            <ul>
		                <li>Board mạch, cảm biến, motor chính hãng</li>
		                <li>Công cụ hỗ trợ sửa chữa, kit vệ sinh</li>
		                <li>Hướng dẫn lắp đặt chi tiết kèm video</li>
		            </ul>
		        </div>
		        <div class="category"
		            style="background:linear-gradient(135deg, rgba(199,210,254,0.28), rgba(165,180,252,0.28)); border-color:rgba(129,140,248,0.32);">
		            <h3>Dịch vụ sửa chữa</h3>
		            <ul>
		                <li>Đặt lịch sửa chữa tại nhà hoặc trung tâm</li>
		                <li>Theo dõi tiến trình theo thời gian thực</li>
		                <li>Chính sách hoàn tiền nếu quá SLA</li>
		            </ul>
		        </div>
		    </div>
		</section>
    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>