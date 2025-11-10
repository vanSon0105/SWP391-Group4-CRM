<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/shop.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <style>
        .main-content {
            padding: 50px 60px 70px;
            display: flex;
            justify-content: center;
        }
        .panel {
            width: min(1100px, 95%);
            background: rgba(255, 255, 255, 0.95);
            border-radius: 26px;
            padding: 32px 40px;
            border: 1px solid rgba(34, 197, 94, 0.32);
            box-shadow: 0 22px 48px rgba(15, 118, 110, 0.18);
            display: flex;
            gap: 60px;
            align-items: flex-start;
        }
        .panel a {
            width: 65%;
            background: #0d6efd;
            color: white;
            padding: 10px 15px;
            border-radius: 16px;
            margin-top: 18px;
            text-align: center;
            text-decoration: none;
            font-weight: 600;
        }
        .panel .back-to-home {
            width: 45%;
            background: #ffa500;
            color: white;
        }
        .note {
            width: 100%;
        }
        
        .alert-info {
	        margin-top: 16px;
	        padding: 12px 16px;
	        border-radius: 12px;
	        background: rgba(253,230,138,.35);
	        color: #92400e;
	        font-weight: 600;
	    }
    </style>
</head>
<body class="shop-page">
<jsp:include page="../common/header.jsp"></jsp:include>
<section class="main-content">
    <div class="panel">
        <div style="display:grid; gap:12px; margin-left:18px">
            <p><strong>Chủ tài khoản:</strong> Phạm Ngọc Hiếu</p>
            <p><strong>Số tài khoản:</strong> 0989136435</p>
            <p><strong>Ngân hàng:</strong> MB Bank</p>

            <c:if test="${bankingContext == 'issue'}">
                <div style="margin-top:12px; display:grid; gap:6px; font-size:1.8rem; color:#0f172a;">
                    <p><strong>Người nhận:</strong> ${bankingRecipientName}</p>
                    <p><strong>Số điện thoại:</strong> ${bankingRecipientPhone}</p>
                    <p><strong>Địa chỉ:</strong> ${bankingRecipientAddress}</p>
                    <c:if test="${not empty bankingShippingNote}">
                        <p><strong>Ghi chú:</strong> ${bankingShippingNote}</p>
                    </c:if>
                </div>
            </c:if>

            <div class="note" style="margin-top: 20px">
                <strong>Lưu ý:</strong>
                <c:choose>
                    <c:when test="${bankingContext == 'issue'}">
                        <p><i class="fa-solid fa-caret-right"></i>Vui lòng ghi nội dung chuyển khoản là <strong>${bankingIssueCode}</strong> để chúng tôi đối soát nhanh chóng.</p>
                        <p><i class="fa-solid fa-caret-right"></i>Sau khi chuyển khoản thành công, bộ phận kỹ thuật sẽ xác nhận và giao hàng</p>
                    </c:when>
                    <c:otherwise>
                        <p>Sau khi chuyển khoản thành công bạn có thể vào trang theo dõi đơn để xem tình trạng thanh toán.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <c:if test="${awaitingAdminConfirm}">
                <div class="alert-info">
                    Chúng tôi đã ghi nhận thông tin thanh toán. Vui lòng chờ quản trị viên xác nhận giao dịch
                </div>
            </c:if>

            <c:choose>
                <c:when test="${bankingContext == 'issue'}">
                	<div class="form-actions" style="flex-wrap: nowrap;">
	                    <a href="<%=request.getContextPath()%>/issue"><i class="fa-solid fa-caret-left"></i>
	                        Quay lại danh sách yêu cầu
	                    </a>
	                    <a class="back-to-home"
	                       href="create-issue">
	                        <i class="fa-solid fa-life-ring"></i> Cần hỗ trợ thêm
	                    </a>
                    </div>
                </c:when>
                <c:otherwise>
                	<div class="form-actions" style="flex-wrap: nowrap;">
	                    <a href="<%=request.getContextPath()%>/order-tracking"><i class="fa-solid fa-caret-left"></i>
	                        Tình trạng thanh toán
	                    </a>
	                    <a class="back-to-home" href="<%=request.getContextPath()%>/">
	                        <i class="fa-solid fa-arrow-left"></i> Về trang chủ
	                    </a>
                	</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div style="text-align: center;">
            <h3>Quét mã QR để thanh toán</h3>
            <img
                    src="https://img.vietqr.io/image/970422-0989136435-compact2.png?amount=${finalPrice}&addInfo=${bankingContext == 'issue' ? bankingIssueCode : 'MuaHang'}"
                    alt="QR Code" width="280" height="330"/>
        </div>
    </div>
</section>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
