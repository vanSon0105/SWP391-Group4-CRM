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
<title>TechShop</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css">


<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<style>
.main-content {
	padding: 50px 60px 70px;
	display: flex;
	justify-content: center;
}

.panel {
	width: 66%;
	background: rgba(255, 255, 255, 0.95);
	border-radius: 26px;
	padding: 28px;
	border: 1px solid rgba(34, 197, 94, 0.32);
	box-shadow: 0 22px 48px rgba(15, 118, 110, 0.22);
	display: flex;
	gap: 60px;
	align-items: baseline;
	
}

.note {
	width:70%;
}

.panel a {
	width: 65%;
	background: #0d6efd;
	color:white;
	padding: 10px 15px;
	border-radius:16px;
	margin-top: 18px;
}

.panel .back-to-home {
	width: 45%;
	background: #FFA500;
	color:white;
	padding: 10px 15px;
	border-radius:16px;
	margin-top:18px;
}
</style>

<body class="shop-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<section class="main-content">
		<div class="panel">
			<div style="display:grid; gap:10px; margin-left:18px">
				<p><strong>Chủ tài khoản: </strong> Phạm Ngọc Hiếu</p>
				<p><strong>Số tài khoản: </strong> 0989136435</p>
				<p><strong>Ngân hàng: </strong> MB Bank</p>
				<div class="note" style="margin-top: 20px">
					<strong>Lưu ý:</strong>
					<p>Sau khi chuyển khoản thành công bạn có thể vào trang theo dõi đơn để xem tình trạng chuyển khoản</p>
				</div>
				<a href="<%=request.getContextPath()%>/order-tracking">Tình trạng thanh toán <i class="fa-solid fa-arrow-right"></i></a>
				<a class="back-to-home" href="<%=request.getContextPath()%>/"><i class="fa-solid fa-arrow-left"></i> Về trang chủ</a>
			</div>
			<div style="text-align: center;">
				<h3>Quét mã QR để thanh toán</h3>
				<img
					src="https://img.vietqr.io/image/970422-0989136435-compact2.png?amount=${finalPrice}&addInfo=MuaHang"
					alt="QR Code" width="280px" height="330px"/>
			</div>
			
		</div>
	</section>

	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>