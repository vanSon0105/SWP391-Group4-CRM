<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<aside class="sidebar" aria-label="Chức năng quản trị">
    <div class="brand">
        <c:when test="${not empty account.imageUrl}">
            <img src="${pageContext.request.contextPath}/${account.imageUrl}" alt="Avatar">
        </c:when>
        <span>${account.username}</span>
    </div>
    <nav>
        <a href="admin" class="active">Dashboard</a>
        <a href="device-show">Thiết bị</a>
        <a href="category-show">Danh mục</a>
        <a href="account">Tài khoản</a>        
        <a href="supplier">Nhà cung cấp</a> 
        <a href="task-list">Danh sách task</a>
        <a href="payment-list">Danh sách thanh toán</a>
        <a href="manager-issues">Task cần giao</a>
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