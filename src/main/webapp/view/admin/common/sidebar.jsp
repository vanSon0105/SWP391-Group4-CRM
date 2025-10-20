<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
	<aside class="sidebar" aria-label="Chức năng quản trị">
        <div class="brand">
            <img src="../assets/img/device-placeholder.svg" alt="">
            <span>VanSon</span>
        </div>
        <nav>
            <a href="revenue-dashboard.html" class="active">Dashboard</a>
            <a href="admin-console.html">Bảng điều khiển</a>
            <a href="order-tracking.html">Theo dõi đơn hàng</a>
            <a href="storekeeper-dashboard.html">Kho & Nhân viên kho</a>
            <a href="technical-manager-suite.html">Quản lý kỹ thuật</a>
            <a href="technical-staff-hub.html">Nhân viên kỹ thuật</a>
            <a href="technical-support-center.html">Hỗ trợ kỹ thuật</a>
        </nav>
    </aside>
    
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        var toggleBtn = document.querySelector('.sidebar-toggle');
        var sidebar = document.querySelector('.sidebar');
        if (!toggleBtn || !sidebar) return;

        toggleBtn.addEventListener('click', function () {
            var isCollapsed = document.body.classList.contains('sidebar-collapsed');

            if (isCollapsed) {
                document.body.classList.remove('sidebar-collapsed');
                toggleBtn.setAttribute('aria-expanded', 'true');
                sidebar.setAttribute('aria-hidden', 'false');
            } else {
            	document.body.classList.add('sidebar-collapsed');
                toggleBtn.setAttribute('aria-expanded', 'false');
                sidebar.setAttribute('aria-hidden', 'true');
            }
        });
    });
</script>
</body>
</html>