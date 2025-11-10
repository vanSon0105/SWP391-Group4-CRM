<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lịch sử đặt hàng</title>

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
    integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="management-page device-management">
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>

    <main class="sidebar-main">
        <!-- Filter & Search -->
        <section class="panel">
    <div class="filters">
        <form style="width: 100%; display: flex; gap: 15px; flex-wrap: wrap; justify-content: center;" action="order-history" method="get">

            <select class="btn device-btn" name="status" onchange="this.form.submit()">
                <option value="" ${empty param.status ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Đang chờ</option>
                <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Thành công</option>
                <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Hủy</option>
            </select>

            <input class="btn device-btn" type="search" name="customerName" placeholder="Tên khách hàng..." value="${param.customerName}"/>

            <select class="btn device-btn" name="sortAmount" onchange="this.form.submit()">
                <option value="" ${empty param.sortAmount ? 'selected' : ''}>Sắp xếp theo giá</option>
                <option value="asc" ${param.sortAmount == 'asc' ? 'selected' : ''}>Giá tăng dần</option>
                <option value="desc" ${param.sortAmount == 'desc' ? 'selected' : ''}>Giá giảm dần</option>
            </select>

            
            <div style="display: flex; gap: 5px;">
                <input class="btn device-btn" type="date" name="fromDate" value="${param.fromDate}" />
                <span>→</span>
                <input class="btn device-btn" type="date" name="toDate" value="${param.toDate}" />
            </div>

            <button class="btn device-btn" type="submit">Tìm kiếm</button>
        </form>
    </div>
</section>

        <section class="panel" id="table-panel">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2>Lịch sử đặt hàng</h2>
            </div>

            <div class="table-wrapper">
                <table class="device-table">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orderList}">
                            <tr>
                                <td>${o.orderId}</td>
                                <td>${o.customerName}</td>
                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency"/></td>
                                <td><fmt:formatDate value="${o.date}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 'pending'}">
                                            <span class="status pending">Đang chờ</span>
                                        </c:when>
                                        <c:when test="${o.status == 'confirmed'}">
                                            <span class="status success">Thành công</span>
                                        </c:when>
                                        <c:when test="${o.status == 'cancelled'}">
                                            <span class="status failed">Hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status unknown">Không xác định</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/order-history-detail?id=${o.orderId}" class="btn device-btn">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <p style="margin-top:12px; color:#6b7280; text-align: center;">
                    Tổng số đơn: <strong>${totalOrders}</strong>
                </p>
            </div>
        </section>

        <!-- Pagination -->
        <div class="pagination-pills" style="padding-bottom: 20px;">
            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/order-history?page=${currentPage - 1}&status=${param.status}&search=${param.search}&fromDate=${param.fromDate}&toDate=${param.toDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">&#10094;</a>
                </c:when>
                <c:otherwise>
                    <a class="disabled">&#10094;</a>
                </c:otherwise>
            </c:choose>

            <c:forEach var="i" begin="1" end="${totalPages}">
                <a class="${i == currentPage ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/order-history?page=${i}&status=${param.status}&search=${param.search}&fromDate=${param.fromDate}&toDate=${param.toDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">${i}</a>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/order-history?page=${currentPage + 1}&status=${param.status}&search=${param.search}&fromDate=${param.fromDate}&toDate=${param.toDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">&#10095;</a>
                </c:when>
                <c:otherwise>
                    <a class="disabled">&#10095;</a>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</body>
</html>
