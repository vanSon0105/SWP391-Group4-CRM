<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NovaCare Shop - Thanh toán</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css">
</head>
<style>
table tbody tr {
	border-bottom: 1px solid #ddd;
}

table tbody tr td {
	padding: 10px 0px;
}

</style>

<body class="shop-page checkout-page">

	<jsp:include page="../common/header.jsp"></jsp:include>


	<main>
		<form action="checkout" method="post">
			<section class="checkout-grid">
				<!-- Thông tin giao hàng -->
				<div class="panel" style="background: rgba(255, 255, 255, 0.97);">
					<h2>Thông tin thanh toán</h2>
					<div style="display: flex; gap: 20px;margin-bottom:10px">
						<div style="display: grid; gap: 8px; width: 50%; height: 45px">
							<label for="fullname">Họ tên</label> <input id="fullname"
								name="fullname" type="text" placeholder="Nguyễn Minh Anh"
								required>
								<small style="color:red">${errorFullname}</small>
						</div>
						<div style="display: grid; gap: 8px; width: 50%; height: 45px">
							<label for="phone">Số điện thoại</label> <input id="phone"
								name="phone" type="text" placeholder="0901 234 567" required>
								<small style="color:red">${errorPhone}</small>
						</div>

					</div>
					<div style="display: grid; gap: 8px;; margin-top:32px">
						<label for="address">Địa chỉ</label>
						<textarea id="address" name="address"
							placeholder="Số nhà, đường, phường, quận, thành phố" required></textarea>
						<small style="color:red">${errorAddress}</small>
					</div>
					<div style="display: grid; gap: 8px;">
						<label for="time">Thời gian giao hàng</label> <select id="time"
							name="time" required>
							<option value="working_hours">Trong giờ hành chính</option>
							<option value="evening">Tối (18:00 - 21:00)</option>
							<option value="weekend">Cuối tuần</option>
						</select>
					</div>
					<div style="display: grid; gap: 8px;">
						<label for="method">Chọn phương thức</label> <select id="method"
							name="method" required>
							<option value="credit_card">Thẻ tín dụng</option>
							<option value="bank_transfer">Chuyển khoản ngân hàng</option>
							<option value="e_wallet">Ví điện tử</option>
							<option value="cash_on_delivery">Thanh toán khi nhận
								hàng</option>
						</select>
					</div>
					<div style="display: grid; gap: 8px;">
						<label for="note">Ghi chú cho kỹ thuật</label>
						<textarea id="note" name="note"
							placeholder="Ví dụ: cần bàn giao, hướng dẫn sao lưu dữ liệu"></textarea>
					</div>
				</div>


				<section class="summary">
					<h2>Đơn hàng của bạn</h2>
					<table style="margin-top: 14px; border-collapse: collapse;">
						<thead>
							<tr>
								<th width="80%" style="text-align: start">Sản phẩm</th>
								<th width="20%" style="text-align: end">Tạm tính</th>
							</tr>
						</thead>

						<tbody>
							<c:forEach var="cart" items="${listCart}">
								<tr>
									<td>${cart.device.name} x ${cart.quantity}</td>
									<td><fmt:formatNumber value="${cart.totalPrice}"
											type="number" /></td>
								</tr>
							</c:forEach>
							<tr>
								<td><h5>Tạm tính:</h5></td>
								<td><h5>
										<fmt:formatNumber value="${totalPrice}" type="number" />
									</h5></td>
							</tr>
							<tr>
								<td><h5>Giảm giá:</h5></td>
								<td><h5>
										<fmt:formatNumber value="${discount}" type="number" />
									</h5></td>
							</tr>
							<tr>
								<td><Strong>Tổng:</Strong></td>
								<td><strong><fmt:formatNumber
											value="${finalPrice}" type="number" /></strong></td>
							</tr>
						</tbody>
					</table>
					<div style="display: flex; gap: 8px; margin-top: 10px">
						<input type="checkbox" style="margin-bottom: 10px" required />
						<p style="color: #0f172a;">
							Khi xác nhận, bạn đồng ý với <a href="#"
								style="color: #22d3ee; text-decoration: none; font-weight: 600;">điều
								khoản mua hàng</a> và chính sách hoàn tiền của NovaCare.
						</p>
					</div>
					<div class="cta" style="margin-top: 20px">
						<button type="submit" class="cta-btn">Xác nhận
							thanh toán</button> 
						<a href="cart.jsp" class="cta-btn"
							style="background: linear-gradient(90deg, #f97316, #fb7185); box-shadow: 0 18px 36px rgba(249, 115, 22, 0.28);">Quay
							lại giỏ hàng</a>
					</div>
				</section>
			</section>

		</form>
	</main>

	<!-- Footer -->
	<footer>
		Thanh toán bởi NovaCare Payments · Hỗ trợ 24/7: <a
			href="mailto:pay@novacare.vn">pay@novacare.vn</a> · Hotline 1900 6688
	</footer>

</body>
</html>