<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard doanh thu - NovaCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body class="management-page dashboard">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
            <main class="sidebar-main">
                <section class="panel">
                    <h2>Chỉ số chính</h2>
                    <div class="grid">
                        <div class="card">
                            <span>DOANH THU TUẦN</span>
                            <strong>12.4 tỷ</strong>
                            <small>+8.6% so với tuần trước</small>
                        </div>
                        <div class="card">
                            <span>LỢI NHUẬN GỘP</span>
                            <strong>2.15 tỷ</strong>
                            <small>Biên lợi nhuận: 17.3%</small>
                        </div>
                        <div class="card">
                            <span>TỶ LỆ CHUYỂN ĐỔI ONLINE</span>
                            <strong>3.9%</strong>
                            <small>+0.6 điểm phần trăm</small>
                        </div>
                        <div class="card">
                            <span>GIÁ TRỊ ĐƠN TRUNG BÌNH</span>
                            <strong>7.2 triệu</strong>
                            <small>Thiết bị gia dụng thúc đẩy tăng trưởng</small>
                        </div>
                    </div>
                </section>

                <section class="panel">
                    <h2>Xu hướng doanh thu 12 tuần</h2>
                    <div class="trend-board">
                        <div class="trend-chart">
                            <div class="plot-line">
                                <svg viewBox="0 0 100 100" preserveAspectRatio="none">
                                    <polyline points="0,78 12,65 24,72 36,58 48,44 60,52 72,38 84,30 96,40" fill="none"
                                        stroke="#ef4444" stroke-width="4" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <span style="left:0%; bottom:22%;"></span>
                                <span style="left:12%; bottom:35%;"></span>
                                <span style="left:24%; bottom:28%;"></span>
                                <span style="left:36%; bottom:42%;"></span>
                                <span style="left:48%; bottom:56%;"></span>
                                <span style="left:60%; bottom:48%;"></span>
                                <span style="left:72%; bottom:62%;"></span>
                                <span style="left:84%; bottom:70%;"></span>
                                <span style="left:96%; bottom:60%;"></span>
                            </div>
                        </div>
                        <aside class="trend-notes">
                            <h3>Ghi chú</h3>
                            <ul>
                                <li>Đỉnh cao tuần 34 nhờ chiến dịch Flash Sale máy lạnh (+38%).</li>
                                <li>Tuần 30 giảm do gián đoạn kho miền Trung; đã phục hồi sau 2 tuần.</li>
                                <li>Xu hướng chung tăng 14% trong quý III; dự báo tiếp tục tăng 6-8% tháng tới.</li>
                            </ul>
                        </aside>
                    </div>
                </section>

                <section class="panel">
                    <h2>Danh mục dẫn đầu doanh thu</h2>
                    <div style="border-radius:20px; overflow:hidden; border:1px solid rgba(248,113,113,0.35);">
                        <table>
                            <thead>
                                <tr>
                                    <th>Danh mục</th>
                                    <th>Doanh thu (tỷ)</th>
                                    <th>Tăng trưởng</th>
                                    <th>Đơn hàng</th>
                                    <th>Tỷ lệ hoàn</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>TV & giải trí</td>
                                    <td>3.8</td>
                                    <td>+12%</td>
                                    <td>4,215</td>
                                    <td>1.6%</td>
                                </tr>
                                <tr>
                                    <td>Điều hòa & lọc không khí</td>
                                    <td>2.9</td>
                                    <td>+18%</td>
                                    <td>3,102</td>
                                    <td>1.2%</td>
                                </tr>
                                <tr>
                                    <td>Gia dụng nhà bếp</td>
                                    <td>2.1</td>
                                    <td>+9%</td>
                                    <td>2,744</td>
                                    <td>0.9%</td>
                                </tr>
                                <tr>
                                    <td>Máy giặt & sấy</td>
                                    <td>1.8</td>
                                    <td>+6%</td>
                                    <td>1,988</td>
                                    <td>1.1%</td>
                                </tr>
                                <tr>
                                    <td>Smart home</td>
                                    <td>1.2</td>
                                    <td>+24%</td>
                                    <td>2,410</td>
                                    <td>0.7%</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <section class="panel">
                    <h2>Hiệu suất theo khu vực</h2>
                    <div class="region-grid">
                        <div class="region-card">
                            <h3>Miền Bắc</h3>
                            <span>Doanh thu: 4.6 tỷ (+9%)</span>
                            <span>Giá trị đơn TB: 7.5 triệu</span>
                            <span>Sản phẩm dẫn đầu: TV OLED, máy lọc không khí</span>
                        </div>
                        <div class="region-card">
                            <h3>Miền Trung</h3>
                            <span>Doanh thu: 2.7 tỷ (+11%)</span>
                            <span>Giá trị đơn TB: 6.1 triệu</span>
                            <span>Sản phẩm dẫn đầu: Máy lạnh, combo vệ sinh</span>
                        </div>
                        <div class="region-card">
                            <h3>Miền Nam</h3>
                            <span>Doanh thu: 5.1 tỷ (+7%)</span>
                            <span>Giá trị đơn TB: 7.8 triệu</span>
                            <span>Sản phẩm dẫn đầu: Máy giặt inverter, smart home</span>
                        </div>
                        <div class="region-card">
                            <h3>Kênh online</h3>
                            <span>Doanh thu: 3.2 tỷ (+15%)</span>
                            <span>Đơn thành công: 8,420</span>
                            <span>Chiến dịch hiệu quả: Livestream cuối tuần</span>
                        </div>
                    </div>
                </section>

                <section class="panel">
                    <h2>Insight & hành động đề xuất</h2>
                    <div class="insight-grid">
                        <article class="insight">
                            <h3>Tăng gói combo lắp đặt</h3>
                            <p>Tỷ lệ chọn combo cho máy lạnh tăng 32% sau khi hiển thị ưu đãi trên trang checkout. Đề
                                xuất nhân rộng cho máy giặt và máy rửa chén.</p>
                        </article>
                        <article class="insight">
                            <h3>Đẩy mạnh upsell smart home</h3>
                            <p>Khách mua TV cao cấp có xu hướng mua kèm thiết bị smart home (tỷ lệ 21%). Gợi ý gói đề
                                xuất tự động trong giỏ hàng.</p>
                        </article>
                        <article class="insight">
                            <h3>Khuyến mại cuối tuần</h3>
                            <p>Doanh thu cuối tuần chiếm 42% tổng tuần. Đề xuất mini game tặng voucher bảo hành mở rộng
                                vào khung giờ 18:00 - 22:00.</p>
                        </article>
                        <article class="insight">
                            <h3>Tối ưu chi phí trả hàng</h3>
                            <p>Tỷ lệ hoàn cao nhất ở nhóm TV nhập khẩu. Cần đào tạo lại quy trình tư vấn kích thước và
                                triển khai checklist khảo sát trước giao.</p>
                        </article>
                    </div>
                </section>
            </main>

            <footer>
                Trung tâm phân tích doanh thu NovaCare · Email: revenue@novacare.vn · Hotline nội bộ: 1900 6688
            </footer>
</body>
</html>