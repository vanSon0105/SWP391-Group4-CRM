<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
<title>Order Tracking - TechShop</title>
<style>
body.home-page {
    display: flex;
    flex-direction: column;
}

.home-page main {
	min-width: 1100px;
    flex: 1;
	margin: 40px auto;
	background: #fff;
	padding: 32px !important;
	border-radius: 12px;
	box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.order-header h1 {
    margin: 0;
    color: #1f2d3d;
}

.alert {
    padding: 12px 16px;
    border-radius: 8px;
    margin-bottom: 16px;
    font-size: 14px;
}

.alert-success {
    background: #dcfce7;
    color: #047857;
}

table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
}

th, td {
    padding: 14px 16px !important;
    text-align: left;
    border-bottom: 1px solid #eef2f6;
    font-size: 18px;
}

th {
    background: #f8fafc;
    font-weight: 600;
    color: #475569;
}

tr:last-child td {
    border-bottom: none;
}

tr:hover {
    background: #f8fafc;
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

.stats-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 16px;
    margin: 24px 0;
}

.stats-card {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
    border: 1px solid #e2e8f0;
}

.stats-card .label {
    font-size: 15px;
    color: #64748b;
    margin-bottom: 8px;
}

.stats-card .value {
    font-size: 32px;
    font-weight: 700;
    color: #0f172a;
}

.stats-card .hint {
    font-size: 13px;
    color: #94a3b8;
    margin-top: 4px;
}

.status-pending {
    background: #e2e8f0;
    color: #1e293b;
}

.status-confirmed {
    background: #dcfce7;
    color: #15803d;
}

.status-cancelled {
    background: #fee2e2;
    color: #b91c1c;
}

.empty-state {
    text-align: center;
    padding: 40px 0;
    color: #475569;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
}

.action-link {
    text-decoration: none;
    color: #2563eb;
    font-weight: 600;
}


.amount {
    font-weight: 600;
    color: #1e293b;
}

.date {
    color: #64748b;
    font-size: 13px;
}

main .btn {
	border-radius: 5px !important;
}
</style>
</head>
<body class="home-page">
<jsp:include page="../common/header.jsp"></jsp:include>
<main>
    <div class="order-header">
        <h1>Đơn hàng của tôi</h1>
        <a class="btn order-btn" href="my-devices">Thiết bị đã mua</a>
    </div>

    <form method="get" class="filter-form">
        <div class="filter-row">
            <div class="filter-group">
                <label class="filter-label">Trạng thái</label>
                <select name="status" class="filter-select" onchange="this.form.submit()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                    <option value="confirmed" ${status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
            
            <div class="filter-group">
                <label class="filter-label">Sắp xếp theo</label>
                <select name="sortField" class="filter-select" onchange="this.form.submit()">
                    <option value="date" ${sortField == 'date' ? 'selected' : ''}>Ngày đặt hàng</option>
                    <option value="total_amount" ${sortField == 'total_amount' ? 'selected' : ''}>Tổng tiền</option>
                </select>
            </div>

            <input type="hidden" name="page" value="1">
        </div>
    </form>

    <c:choose>
        <c:when test="${not empty orders}">
            <table>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#${o.id}</td>
                            <td class="date">
                                <fmt:formatDate value="${o.date}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td class="amount"><fmt:formatNumber value="${o.totalAmount}" type="number" /></td>
                            <td>
                                <span class="status-pill status-${o.status}">
                                    <c:choose>
                                        <c:when test="${o.status == 'pending'}">Chờ xác nhận</c:when>
                                        <c:when test="${o.status == 'confirmed'}">Đã xác nhận</c:when>
                                        <c:when test="${o.status == 'cancelled'}">Đã hủy</c:when>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <a href="order-detail?id=${o.id}" class="btn order-btn">
                                    Xem chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div style="display: flex; justify-content: center; margin-top: 32px; gap: 8px;">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span style="
                                    padding: 8px 16px;
                                    background: #2563eb;
                                    color: white;
                                    border-radius: 8px;
                                    font-weight: 600;
                                ">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="order-tracking?page=${i}&status=${status}&sortField=${sortField}" 
                                   style="
                                    padding: 8px 16px;
                                    border: 2px solid #e2e8f0;
                                    border-radius: 8px;
                                    text-decoration: none;
                                    color: #475569;
                                    font-weight: 600;
                                    transition: all 0.2s ease;
                                " 
                                   onmouseover="this.style.background='#f1f5f9'; this.style.borderColor='#2563eb'; this.style.color='#2563eb';"
                                   onmouseout="this.style.background=''; this.style.borderColor='#e2e8f0'; this.style.color='#475569';"
                                >${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </c:if>

        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <h3 style="color: #1e293b; margin-bottom: 8px;">Chưa có đơn hàng nào</h3>
                <p style="margin: 0;">Hãy mua sắm để xem lịch sử đơn hàng của bạn tại đây.</p>
            </div>
        </c:otherwise>
    </c:choose>

</main>
<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>