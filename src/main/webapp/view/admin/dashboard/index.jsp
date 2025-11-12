<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    
   	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.6/dist/chart.umd.min.js"></script>
</head>
<body class="management-page dashboard sidebar-collapsed">
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main class="sidebar-main">
        <section class="panel">
            <h2>Chỉ số tổng quan</h2>
            <div class="grid">
                <div class="card">
                    <span>Doanh thu</span>
                    <strong><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VND</strong>
                    <small>Tổng thanh toán thành công</small>
                </div>
                <div class="card">
                    <span>Đơn hàng</span>
                    <strong><fmt:formatNumber value="${totalOrders}" type="number" /></strong>
                    <small>Giá trị trung bình <fmt:formatNumber value="${averageOrderValue}" type="number" maxFractionDigits="0"/> VND</small>
                </div>
                <div class="card">
                    <span>Khách hàng</span>
                    <strong><fmt:formatNumber value="${totalCustomers}" type="number" /></strong>
                    <small>Tài khoản có quyền customer</small>
                </div>
                <div class="card">
                    <span>Thiết bị đang bán</span>
                    <strong><fmt:formatNumber value="${activeDevices}" type="number" /></strong>
                    <small>Trạng thái active trong kho</small>
                </div>
                <div class="card">
                    <span>Ticket mở</span>
                    <strong><fmt:formatNumber value="${openIssues}" type="number" /></strong>
                    <small>Chưa giải quyết / chờ khách</small>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Xu hướng & ghi chú</h2>
            <div class="trend-board">
                <div class="trend-chart">
                    <canvas id="revenueChart" style="width:100%;height:100%;"></canvas>
                </div>
                <aside class="trend-notes">
                    <h3>Diễn biến đáng chú ý</h3>
                    <ul>
                        <li>So sánh 6 tháng: <strong><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> VND</strong> doanh thu lũy kế.</li>
                        <li>Đơn hàng trung bình: <fmt:formatNumber value="${averageOrderValue}" type="number" maxFractionDigits="0"/> VND.</li>
                        <li>Top danh mục góp doanh thu hiển thị bên dưới để ưu tiên chiến dịch.</li>
                    </ul>
                </aside>
            </div>
        </section>

        <section class="panel">
            <h2>Phân bổ công việc</h2>
            <div class="region-grid">
                <div class="region-card">
                    <h3>Tình trạng task</h3>
                    <canvas id="taskChart"></canvas>
                </div>
                <div class="region-card">
                    <h3>Pipeline hỗ trợ</h3>
                    <canvas id="issueChart"></canvas>
                </div>
                <div class="region-card">
                    <h3>Top danh mục</h3>
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Bảng doanh thu theo danh mục</h2>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Danh mục</th>
                        <th>Doanh thu (VND)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty topCategories}">
                        <tr>
                            <td colspan="3" style="text-align:center; padding:24px;">Chưa có dữ liệu.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="item" items="${topCategories}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${item.label}</td>
                            <td><fmt:formatNumber value="${item.value}" type="number" maxFractionDigits="0"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>

        <section class="panel">
            <h2>Gợi ý hành động</h2>
            <div class="insight-grid">
                <article class="insight">
                    <h3>Cân đối kỹ thuật</h3>
                    <p>Dùng biểu đồ task để phân phối lại nhân sự tránh trạng thái pending kéo dài.</p>
                </article>
                <article class="insight">
                    <h3>Ưu tiên ticket</h3>
                    <p>Nhóm awaiting customer cần gọi nhắc nhanh để tránh trễ SLA.</p>
                </article>
                <article class="insight">
                    <h3>Tập trung danh mục mạnh</h3>
                    <p>Danh mục top revenue nên có combo sản phẩm và ưu đãi vận chuyển.</p>
                </article>
                <article class="insight">
                    <h3>Theo dõi doanh thu</h3>
                    <p>Alert khi doanh thu tháng giảm dưới trung bình 3 tháng để kích hoạt chiến dịch.</p>
                </article>
            </div>
        </section>
    </main>

    <script>
        const revenueLabels = [
            <c:forEach var="point" items="${revenueTrend}" varStatus="loop">
                '${point.label}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const revenueData = [
            <c:forEach var="point" items="${revenueTrend}" varStatus="loop">
                ${point.value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const categoryLabels = [
            <c:forEach var="point" items="${topCategories}" varStatus="loop">
                '${point.label}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const categoryData = [
            <c:forEach var="point" items="${topCategories}" varStatus="loop">
                ${point.value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const taskLabels = [
            <c:forEach var="point" items="${taskStatus}" varStatus="loop">
                '${point.label}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const taskData = [
            <c:forEach var="point" items="${taskStatus}" varStatus="loop">
                ${point.value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const issueLabels = [
            <c:forEach var="point" items="${issueStatus}" varStatus="loop">
                '${point.label}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const issueData = [
            <c:forEach var="point" items="${issueStatus}" varStatus="loop">
                ${point.value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const palette = [
            '#f97316',
            '#fb923c',
            '#1d4ed8',
            '#38bdf8',
            '#34d399',
            '#fbbf24',
            '#ef4444',
            '#8b5cf6'
        ];

        const revenueCanvas = document.getElementById('revenueChart');
        if (revenueCanvas) {
            new Chart(revenueCanvas, {
                type: 'line',
                data: {
                    labels: revenueLabels,
                    datasets: [{
                        label: 'Doanh thu',
                        data: revenueData,
                        borderColor: '#f97316',
                        backgroundColor: 'rgba(249, 115, 22, 0.18)',
                        borderWidth: 3,
                        tension: 0.35,
                        fill: true,
                        pointRadius: 4,
                        pointBackgroundColor: '#f97316'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            ticks: {
                                callback: (value) => Intl.NumberFormat().format(value)
                            }
                        }
                    }
                }
            });
        }

        const categoryCanvas = document.getElementById('categoryChart');
        if (categoryCanvas) {
            new Chart(categoryCanvas, {
                type: 'bar',
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        label: 'Doanh thu',
                        data: categoryData,
                        backgroundColor: palette,
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        x: {
                            ticks: {
                                callback: (value) => Intl.NumberFormat().format(value)
                            }
                        }
                    }
                }
            });
        }

        const taskCanvas = document.getElementById('taskChart');
        if (taskCanvas) {
            new Chart(taskCanvas, {
                type: 'doughnut',
                data: {
                    labels: taskLabels,
                    datasets: [{
                        data: taskData,
                        backgroundColor: palette,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        }

        const issueCanvas = document.getElementById('issueChart');
        if (issueCanvas) {
            new Chart(issueCanvas, {
                type: 'polarArea',
                data: {
                    labels: issueLabels,
                    datasets: [{
                        data: issueData,
                        backgroundColor: palette
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        r: { ticks: { display: false } }
                    },
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        }
    </script>
</body>
</html>
