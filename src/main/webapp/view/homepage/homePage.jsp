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
		  height: 180px;
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
		
		body.home-page main {
		    padding: 0;
		    display: grid;
		    gap: 0;
		}
		
		.adverse {
		    display: flex;
		    padding: 5px;
		    justify-content: center;
		    gap: 30px;
		    align-items: center;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
		
		.adverse span {
		    font-size: 1.8rem;
		    font-weight: bold;
		    display: flex;
		    align-items: center;
		    gap: 10px;
		}
		
		.adverse i {
		    font-size: 2rem;
		    color: #ff8100;
		}

    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
		<div class="adverse">
		    <span><i class="fas fa-cogs"></i> Bảo hành siêu nhanh</span>
		    <span><i class="fas fa-store"></i> TechShop uy tín hàng đầu</span>
		    <span><i class="fas fa-shopping-cart"></i> Mua hàng dễ dàng</span>
		    <span><i class="fas fa-headset"></i> Hỗ trợ nhanh chóng</span>
		</div>

        <section class="mega-banner" aria-labelledby="banner-title">
            <div class="mega-banner-content">
                <h2 id="banner-title">Mua sắm siêu rẻ, siêu nhanh - Ưu đãi đến 20% cho toàn bộ thiết bị</h2>
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
				              <strong><fmt:formatNumber value="${s.price}" type="number" /> VNĐ</strong>
				            </p>
				            <p><i class="fa-solid fa-shield-heart"></i> Bảo hành ${s.warrantyMonth} tháng</p>
				          </div>
				          <img src="${pageContext.request.contextPath}/assets/img/device/${s.imageUrl}" alt="${s.name}" class="promo-img">
				        </div>
				        <span class="promo-price">
				          <i class="fa-solid fa-tag"></i> Giá ưu đãi: 
				          <strong><fmt:formatNumber value="${s.price}" type="number" /> VNĐ</strong>
				        </span>
				      </article>
				    </c:forEach>
				  </div>
				</div>
			    <button class="hero-nav" type="button" data-hero-direction="next" aria-label="Sản phẩm tiếp theo"><i
			            class="fa-solid fa-chevron-right"></i></button>
			</div>
        </section>

        <section style="padding: 15px;" class="featured-categories">
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
	                            <span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VNĐ</span>
                        </a>
	                            <a class="btn device-buy-btn" href="cart-add?id=${s.id}#featured-devices">Mua sản phẩm</a>
	                        </div>
                    </c:forEach>
                    </div>
                </div>
           </div>
        </section>

		<div class="img-gallery-6">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t1.webp" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t2.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t3.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t4.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t5.webp" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t6.jpeg" alt="">
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
	                        <span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VNĐ</span>
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
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t7.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t8.webp" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t9.jpg" alt="">
            <img src="${pageContext.request.contextPath}/assets/img/img_lay/t10.jpg" alt="">
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
	                        	<span>Giá: <fmt:formatNumber value="${s.price}" type="number" /> VNĐ</span>
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
	<c:if test="${cartJustAdded}">
		<style>
			.cart-modal {
				position: fixed;
				inset: 0;
				background: rgba(0, 0, 0, 0.45);
				display: flex;
				align-items: center;
				justify-content: center;
				z-index: 9999;
				opacity: 0;
				transition: opacity 0.25s ease;
				pointer-events: none;
			}
			.cart-modal.show {
				opacity: 1;
				pointer-events: auto;
			}
			.cart-modal-content {
				background: #fff;
				padding: 28px 32px;
				border-radius: 16px;
				box-shadow: 0 20px 45px rgba(15, 23, 42, 0.25);
				text-align: center;
				max-width: 420px;
				width: 92%;
				position: relative;
				animation: modalSlide 0.35s ease;
			}
			.cart-modal-close {
				position: absolute;
			    top: -5px;
			    right: 9px;
			    border: none;
			    background: transparent;
			    font-size: 3.5rem;
			    color: #94a3b8;
			    cursor: pointer;
			}
			.cart-modal-close:hover {
				color: #0f172a;
			}
			.cart-modal h4 {
				margin-bottom: 8px;
				font-size: 1.25rem;
			}
			.cart-modal p {
				padding: 10px;
			    border-radius: 999px;
			    background: rgba(34, 197, 94, .12);
			    color: #166534;
			    margin-bottom: 18px;
			}
			.cart-modal .cart-modal-actions {
				display: flex;
				gap: 10px;
				justify-content: center;
				flex-wrap: wrap;
			}
			.cart-modal .cart-modal-actions a {
				padding: 10px 18px;
				border-radius: 999px;
				border: none;
				font-weight: 600;
				text-decoration: none;
			}
			.cart-modal .cart-modal-actions .ghost {
				background: #e2e8f0;
				color: #0f172a;
			}
			@keyframes modalSlide {
				from {
					transform: translateY(15px);
					opacity: 0;
				}
				to {
					transform: translateY(0);
					opacity: 1;
				}
			}
		</style>
		<div class="cart-modal show" id="cartSuccessModal">
			<div class="cart-modal-content">
				<button type="button" class="cart-modal-close" data-close="true">&times;</button>
				<h4>Đã thêm vào giỏ hàng</h4>
				<p>Thiết bị của bạn đã được thêm vào giỏ hàng thành công.</p>
				<div class="cart-modal-actions">
					<a href="cart" class="btn order-btn">Xem giỏ hàng</a>
					<a href="home" class="btn order-btn ghost" data-close="true">Tiếp tục mua sắm</a>
				</div>
			</div>
		</div>
		<script>
			(function() {
				const modal = document.getElementById('cartSuccessModal');
				if (!modal) return;
				const hideModal = () => {
					modal.classList.remove('show');
					setTimeout(() => {
						modal.style.display = 'none';
					}, 250);
				};
				modal.addEventListener('click', (e) => {
					if (e.target === modal || e.target.hasAttribute('data-close')) {
						hideModal();
					}
				});
				setTimeout(hideModal, 2000);
			})();
		</script>
	</c:if>
</body>

</html>