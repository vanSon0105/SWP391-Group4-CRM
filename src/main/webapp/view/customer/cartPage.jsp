<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
</head>
<body class="cart-page">
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <section class="cart-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Mô tả</th>
                        <th>Thành tiền</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${cartList}" var="s"> 
	                    <tr>
	                        <td>${s.device.name}</td>
	                        <td class="price-col">
	                        	<fmt:formatNumber value="${s.price}" type="number" /> VND
	                        </td>
	                        <td class="quantity-td">
	                        	<div class="quantity-control">
							        <form action="cart" method="post">
							          <input type="hidden" name="cartDetailId" value="${s.id}">      
							          <button type="submit" name="action" value="decrease" class="quantity-btn">−</button>
							          <input type="text" name="quantity" value="${s.quantity}" pattern="[0-9]*" class="quantity-input">
							          <button type="submit" name="action" value="increase" class="quantity-btn">+</button>
							        </form>
							    </div>
	                        </td>
	                        <td>${s.device.desc}</td>
	                        <td class="total-col">
	                        	<fmt:formatNumber value="${s.totalPrice}" type="number" /> VND
	                        </td>
	                        <td class="remove-device">
	                        	<button class="remove-btn" title="Xóa sản phẩm">✕</button>
	                        </td>
	                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>
        <section class="cart-summary">
            <h2 style="font-size:24px; color:#0f172a;">Tổng kết</h2>
            <div class="totals">
                <span>Tạm tính: 41.890.000đ</span>
                <span>Giảm giá: -2.000.000đ (Flash Sale)</span>
                <span>Phí vận chuyển: 0đ</span>
                <span><strong>Tổng cộng: 39.890.000đ</strong></span>
            </div>
            <div class="cta">
                <a href="checkout.html">Tiến hành thanh toán</a>
                <a href="device-page">Tiếp tục mua sắm</a>
            </div>
        </section>
    </main>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
