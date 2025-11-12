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
<title>Chi tiết đơn hàng #${order.id} - TechShop</title>
<style>
.panel{
	width: 100%;
}
.panel h2 { 
    margin-bottom: 25px; 
    font-size: 26px; 
    color: #1f2937;
}

.panel .info { 
    display: flex; 
    flex-wrap: wrap; 
    gap: 25px; 
    margin-bottom: 25px; 
}

.panel .info div.small-box { 
    flex: 1 1 180px;  /* nhỏ gọn */
    background: #f9f9f9; 
    padding: 10px 12px; 
    border-radius: 8px; 
    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
    font-size: 14px;
    word-break: break-word;
    white-space: normal;
    overflow-wrap: break-word;
}

.panel .info div.note {
    flex: 2 1 100%;         
    max-height: 200px;
    overflow-y: auto;          
    background-color: #eef2ff;
    padding: 15px 15px 15px 15px; 
    border-radius: 8px;
    font-style: italic;
    color: #3730a3;
    word-break: break-word;
    white-space: pre-wrap;
    overflow-wrap: break-word;
    position: relative;
    margin-top: 10px;
}

.status-pill {
    display: inline-flex;
    align-items: center;
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: .04em;
}

.status-pending { background: #e2e8f0; color: #1e293b; }
.status-confirmed { background: #dcfce7; color: #15803d; }
.status-cancelled { background: #fee2e2; color: #b91c1c; }

</style>
</head>
<body class="management-page device-management">

<jsp:include page="../common/header.jsp"></jsp:include>
<jsp:include page="../common/sidebar.jsp"></jsp:include>
<main class="sidebar-main">
	<section class="panel">
       	<a href="order-history" class="btn device-btn"><i class="fa fa-arrow-left"></i> Quay lại</a>
    </section>
	<section class="panel">
        <h1>Chi tiết đơn hàng #${order.id}</h1>
	    <div class="info">
	        <div class="small-box">
                <div class="info-label">Ngày đặt hàng</div>
                <div class="info-value"><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy HH:mm"/></div>
            </div>
            <div class="small-box">
                <div class="info-label">Trạng thái</div>
                <div class="info-value">
                    <span class="status-pill status-${order.status}">
                        <c:choose>
                            <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                            <c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
                            <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                        </c:choose>
                    </span>
                </div>
            </div>
            

            <div class="small-box">
                <div class="info-label">Tổng thanh toán</div>
                <div class="info-value"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</div>
            </div>
	    </div>
		
		<h3>Danh sách thiết bị</h3>
		<div class="table-wrapper">
		    <table class="device-table">
		        <thead>
		            <tr>
		                <th>Sản phẩm</th>
		                <th>Đơn giá</th>
		                <th>Số lượng</th>
		                <th>Thành tiền</th>
		            </tr>
		        </thead>
		        <tbody>
		            <c:forEach var="od" items="${orderDetails}">
		                <tr>
		                    <td><c:out value="${od.deviceName}"/></td>
		                    <td class="price"><fmt:formatNumber value="${od.price}" type="number"/> đ</td>
		                    <td><c:out value="${od.quantity}"/></td>
		                    <td class="price"><fmt:formatNumber value="${od.price * od.quantity}" type="number"/> đ</td>
		                </tr>
		            </c:forEach>
		        </tbody>
		    </table>
		 </div>
	 </section>
</main>


</body>
</html>
