<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Checkout</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
    <style>
        table tbody tr {
			border-bottom: 1px solid #ddd;
		}
		
		table tbody tr td {
			padding: 10px 0px;
		}
		
		input{
			padding: 12px 14px !important;
		    border-radius: 14px;
		    border: 1px solid rgba(45, 212, 191, 0.35);
		    background: rgba(255, 255, 255, 0.96);
		    font-size: 15px;
		    color: #0f172a;
		}
		
		.hint {
            color: #64748b;
            font-size: 13px;
        }
    </style>
</head>
<body class="shop-page checkout-page">
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main>
            <form method="post" action="issue-pay">
		        <section class="checkout-grid">
		        	<div class="panel" style="background: rgba(255, 255, 255, 0.97);">
		                <h1>Thông tin thanh toán</h1>
						<div style="display: flex; gap: 20px;margin-bottom:10px">
			                <input type="hidden" name="issueId" value="${issue.id}">
			                <div style="display: grid; gap: 8px; width: 50%; height: 45px">
			                    <label for="fullName">Họ và tên</label>
			                    <input type="text" id="fullName" name="fullName" maxlength="100" value="${fn:escapeXml(formFullName)}" required>
			                    <c:if test="${not empty errorFullName}">
			                        <small style="color:red">${errorFullname}</small>
			                    </c:if>
			                </div>
			
			                <div style="display: grid; gap: 8px; width: 50%; height: 45px">
			                    <label for="phone">Số điện thoại</label>
			                    <input type="text" id="phone" name="phone" maxlength="20" value="${fn:escapeXml(formPhone)}" required>
			                    <c:if test="${not empty errorPhone}">
			                        <small style="color:red">${errorPhone}</small>
			                    </c:if>
			                </div>
		                </div>
		
		                <div style="display: grid; gap: 8px;; margin-top:32px">
		                    <label for="address">Địa chỉ nhận</label>
		                    <textarea id="address" name="address" maxlength="255" required>${fn:escapeXml(formAddress)}</textarea>
		                    <c:if test="${not empty errorAddress}">
		                        <small style="color:red">${errorAddress}</small>
		                    </c:if>
		                </div>
		
		                <div style="display: grid; gap: 8px;">
		                    <label for="shippingNote">Ghi chú bổ sung</label>
		                    <textarea id="shippingNote" name="shippingNote" maxlength="500" placeholder="Vi du: Giao trong gio hanh chinh, xin lien he truoc khi den.">${fn:escapeXml(formNote)}</textarea>
		                    <div class="hint">Tối đa 500 ký tự</div>
		                    <c:if test="${not empty errorNote}">
		                        <small style="color:red">${errorNote}</small>
		                    </c:if>
		                </div>
		
		                <div class="cta">
		                    <a class="cta-btn secondary" href="issue">Quay lại danh sách</a>
		                    <button type="submit" class="cta-btn">Xác nhận thanh toán</button>
		                </div>
		            </div>
	
	            <section class="summary">
	                <h2>Thông tin yêu cầu</h2>
	                <table style="margin-top: 14px; border-collapse: collapse; width: 100%;">
	                	<thead>
							<tr style="text-align: left;">
								<th>Danh mục</th>
								<th>Thông tin</th>
							</tr>
						</thead>
	                	<tbody>
	                		<tr>
								<td><h5>Mã yêu cầu:</h5></td>
								<td>${issue.issueCode}</td>
							</tr>
							
							<tr>
								<td><h5>Loại yêu cầu:</h5></td>
								<td>
										<c:choose>
			                                <c:when test="${issue.issueType == 'warranty'}">Bảo hành</c:when>
			                                <c:when test="${issue.issueType == 'repair'}">Sửa chữa</c:when>
			                                <c:otherwise>Khac</c:otherwise>
			                            </c:choose>
							</td>
							</tr>
							
							<tr>
								<td><h5>Tiêu đề:</h5></td>
								<td>
										${issue.title}
									</td>
							</tr>
							
							<tr>
								<td><h5>Trạng thái hỗ trợ:</h5></td>
								<td>
										<c:if test="${issue.supportStatus == 'resolved'}">Đã hoàn tất</c:if>
									</td>
							</tr>
							
							<tr>
								<td><Strong>Tổng thanh toán:</Strong></td>
								<td><strong>
									<fmt:formatNumber value="${finalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
			                        <c:if test="${payment.amount == 0}">
			                            <span class="badge">Bảo hành</span>
			                        </c:if>
								</strong></td>
							</tr>
		
			                
			                	<tr>
									<td><Strong>Ghi chú kỹ thuật:</Strong></td>
									<td>${payment.note}</td>
								</tr>
			                
		                </tbody>
	                </table>
	            </section>
	        </section>
        </form>
    </main>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
