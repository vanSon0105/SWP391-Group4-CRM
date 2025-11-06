<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo doanh thu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.6/dist/chart.umd.min.js"></script>
</head>
<body class="management-page dashboard sidebar-collapsed">

    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>

    <main class="sidebar-main">

        <section class="panel">
            <h2>Tổng quan doanh thu</h2>
            <div class="grid">
                <div class="card">
                    <span>Tổng doanh thu</span>
                    <strong><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> ₫</strong>
                    <small>Thanh toán thành công</small>
                </div>
                <div class="card">
                    <span>Số đơn hàng</span>
                    <strong><fmt:formatNumber value="${totalOrders}" type="number" /></strong>
                    <small>Giá trị TB: <fmt:formatNumber value="${avgOrder}" type="number" maxFractionDigits="0"/> ₫</small>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Biểu đồ doanh thu & lợi nhuận</h2>
            <div class="trend-board">
                <div class="trend-chart">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Chi tiết theo tháng</h2>
            <table>
                <thead>
                    <tr>
                        <th>Tháng</th>
                        <th>Doanh thu</th>
                        <th>Lợi nhuận (30%)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty monthlyData}">
                            <tr><td colspan="3" style="text-align:center; padding:24px;">Chưa có dữ liệu</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${monthlyData}">
                                <tr>
                                    <td>Tháng ${s.month}/${s.year}</td>
                                    <td><fmt:formatNumber value="${s.revenue}" type="number" maxFractionDigits="0"/> ₫</td>
                                    <td><fmt:formatNumber value="${s.profit}" type="number" maxFractionDigits="0"/> ₫</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </section>

    </main>

    <script>
        const ctx = document.getElementById('revenueChart');
        if (ctx && ${not empty monthlyData}) {
            const labels = [<c:forEach var="s" items="${monthlyData}" varStatus="loop">'Tháng ${s.month}/${s.year}'<c:if test="${!loop.last}">,</c:if></c:forEach>];
            const revenue = [<c:forEach var="s" items="${monthlyData}" varStatus="loop">${s.revenue}<c:if test="${!loop.last}">,</c:if></c:forEach>];
            const profit = [<c:forEach var="s" items="${monthlyData}" varStatus="loop">${s.profit}<c:if test="${!loop.last}">,</c:if></c:forEach>];

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Doanh thu',
                            data: revenue,
                            borderColor: '#f97316',
                            backgroundColor: 'rgba(249, 115, 22, 0.15)',
                            borderWidth: 3,
                            tension: 0.3,
                            fill: true
                        },
                        {
                            label: 'Lợi nhuận',
                            data: profit,
                            borderColor: '#10b981',
                            backgroundColor: 'rgba(16, 185, 129, 0.15)',
                            borderWidth: 3,
                            tension: 0.3,
                            fill: true
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' }
                    },
                    scales: {
                        y: { 
                            beginAtZero: true,
                            ticks: { 
                                callback: v => new Intl.NumberFormat('vi-VN').format(v) + '₫'
                            }
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>