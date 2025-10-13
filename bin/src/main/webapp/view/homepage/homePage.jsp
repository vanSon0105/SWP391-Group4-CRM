<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechShop</title>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <section class="mega-banner" aria-labelledby="banner-title">
            <div class="mega-banner-content">
                <h2 id="banner-title">Mua sắm điện máy thăng hoa - Ưu đãi đến 20% cho toàn bộ thiết bị</h2>
                <p>Từ laptop, smartphone đến dịch vụ sửa chữa. Chỉ một lần chạm là bạn được chăm sóc tận tình cùng đội ngũ kỹ thuật của Shop88</p>
                <div class="banner-btn">
                    <a href="device-catalog.html">Khám phá sản phẩm</a>
                    <a class="secondary" href="order-tracking.html">Theo dõi đơn hàng &amp; bảo hành</a>
                </div>
            </div>
            <div class="banner-promos" data-hero-slider>
                <button class="hero-nav" type="button" data-hero-direction="prev" aria-label="San pham truoc"><i
                        class="fa-solid fa-chevron-left"></i></button>
                <div class="banner-promos-window">
                    <div class="banner-promos-track">
                        <article class="promo-card">
                            <span class="promo-tag">Xiaomi HyperAI</span>
                            <h3>Xiaomi 15T Series</h3>
                            <p>Thu cu doi moi len den <strong>2.5 trieu</strong> &bull; Tra gop <strong>0%</strong>
                                &bull; Bao hanh 24+6 thang</p>
                            <span class="promo-price">Gia uu dai: 2.99 trieu</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Mini LED Series</span>
                            <h3>Xiaomi TV S Pro</h3>
                            <p>Giam toi <strong>5 trieu</strong> &bull; Tang loa thanh &bull; 55" | 65" | 75"</p>
                            <span class="promo-price">Chi tu 28.990.000d</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Gia dung xanh</span>
                            <h3>NovaBot Clean X</h3>
                            <p>Lau hut dong thoi, tu do rac &bull; Tich hop ban do 3D &bull; ho tro giong noi</p>
                            <span class="promo-price">Chi tu 10.490.000d</span>
                        </article>
                        <article class="promo-card">
                            <span class="promo-tag">Am thanh cao cap</span>
                            <h3>NovaSound Max 7.1</h3>
                            <p>Dolby Atmos, Bluetooth 5.2 &bull; Ket noi da thiet bi &bull; Bao hanh 24 thang</p>
                            <span class="promo-price">Gia: 9.990.000d</span>
                        </article>
                    </div>
                </div>
                <button class="hero-nav" type="button" data-hero-direction="next" aria-label="San pham tiep theo"><i
                        class="fa-solid fa-chevron-right"></i></button>
            </div>
        </section>

        <section class="featured-categories">
            <a class="shortcut-card" href="device-catalog.jsp#laptop">
                <span class="shortcut-icon">💻</span>
                <span class="shortcut-label">Laptop &amp; PC</span>
            </a>
            <a class="shortcut-card" href="device-catalog.jsp#mobile">
                <span class="shortcut-icon">📱</span>
                <span class="shortcut-label">Điện Thoại</span>
            </a>
            <a class="shortcut-card" href="device-catalog.jsp#accessories">
                <span class="shortcut-icon">🔧</span>
                <span class="shortcut-label">Linh Kiện</span>
            </a>
            <a class="shortcut-card" href="order-tracking.jsp">
                <span class="shortcut-icon">🛠️</span>
                <span class="shortcut-label">Theo Dõi Sửa Chữa</span>
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
              			<a href="device-detail?id=${s.id}">
	              			<div class="device-card">
	                        	<div class="device-thumb">
	                        		<img alt="" src="${pageContext.request.contextPath}/assets/img/laptop.jpg">
	                        	</div>
	                            <h4>${s.getName()}</h4>
	                            <p>${s.getDesc()}</p>
	                            <span>Giá: ${s.getPrice()}Đ</span>
	                        </div>
                        </a>
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
            
            <div class="device-page">
                <div class="device-grid">
                <c:forEach items="${listNew}" var="s"> 
	                <a href="device-detail?id=${s.id}">
	                    <div class="device-card">
	                    	<div class="device-thumb">
	                       		<img alt="" src="${pageContext.request.contextPath}/assets/img/laptop.jpg">
	                       	</div>
	                        <h4>${s.getName()}</h4>
	                        <p>${s.getDesc()}</p>
	                        <span>Giá: ${s.getPrice()}Đ</span>
	                    </div>
                    </a>
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
				    <a href="home?npage=1&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#best-sellers">1</a>
				    <span>…</span>
				  </c:if>
				
				  <c:forEach var="i" begin="${start}" end="${end}">
				    <a href="home?npage=${i}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#best-sellers"
				       class="${i == currentNewPage ? 'active' : ''}">${i}</a>
				  </c:forEach>
				
				  <c:if test="${end < totalNewPages}">
				    <span>…</span>
				    <a href="home?npage=${totalNewPages}&fpage=${currentFeaturedPage}&bpage=${currentBestSellingPage}#best-sellers">
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
                <p>Duoc khach hang lua chon va danh gia cao nhat trong thang.</p>
            </div>
            <div class="device-pages">
                <div class="device-page">
                    <div class="device-grid">
                    <c:forEach items="${listBestSellingDevices}" var="s"> 
	                    <a href="device-detail?id=${s.id}">
	                        <div class="device-card">
	                        	<div class="device-thumb">
		                       		<img alt="" src="${pageContext.request.contextPath}/assets/img/laptop.jpg">
		                       	</div>
	                            <h4>${s.getName()}</h4>
	                        	<p>${s.getDesc()}</p>
	                        	<span>Giá: ${s.getPrice()}Đ</span>
	                        </div>
                        </a>
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
                <h2>Danh muc chuyen sau</h2>
                <p>Kham pha giai phap phu hop cho nhu cau cua ban.</p>
            </div>
            <div class="categories">
                <div class="category">
                    <h3>Laptop &amp; PC</h3>
                    <ul>
                        <li>Laptop do hoa, gaming, van phong</li>
                        <li>May ban All-in-one, linh kien nang cap</li>
                        <li>Dich vu ve sinh, toi uu hieu nang dinh ky</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(251,191,36,0.28), rgba(248,113,113,0.28)); border-color:rgba(249,115,22,0.32);">
                    <h3>Dien thoai &amp; Tablet</h3>
                    <ul>
                        <li>Smartphone flagship, mid-range</li>
                        <li>Tablet hoc tap, giai tri</li>
                        <li>Goi bao hiem roi vo, ho tro thay man</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(134,239,172,0.28), rgba(125,211,252,0.28)); border-color:rgba(34,197,94,0.32);">
                    <h3>Linh kien bao hanh</h3>
                    <ul>
                        <li>Board mach, cam bien, motor chinh hang</li>
                        <li>Cong cu ho tro sua chua, kit ve sinh</li>
                        <li>Huong dan lap dat chi tiet kem video</li>
                    </ul>
                </div>
                <div class="category"
                    style="background:linear-gradient(135deg, rgba(199,210,254,0.28), rgba(165,180,252,0.28)); border-color:rgba(129,140,248,0.32);">
                    <h3>Dich vu sua chua</h3>
                    <ul>
                        <li>Dat lich sua chua tai nha hoac trung tam</li>
                        <li>Theo doi tien trinh theo thoi gian thuc</li>
                        <li>Chinh sach hoan tien neu qua SLA</li>
                    </ul>
                </div>
            </div>
        </section>
    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>