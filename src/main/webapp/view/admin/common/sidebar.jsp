<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<aside class="sidebar" aria-label="Chức năng quản trị">
    <div class="brand">
        <c:if test="${not empty account.imageUrl}">
            <img src="${pageContext.request.contextPath}/assets/img/user/${account.imageUrl}" alt="Avatar">
        </c:if>
        
        <c:if test="${empty account.imageUrl}">
            <img src="${pageContext.request.contextPath}/assets/img/user/imageUrl.jsp" alt="Avatar">
        </c:if>
        <span>${account.username}</span>
    </div>
    <nav>
        <c:if test="${permissions != null && permissions.contains('DEVICE_OVERVIEW')}">
            <a href="admin">Dashboard</a>
            <a href="sales-report">Sales report</a>
        </c:if>
        <c:choose>
			<c:when test="${permissions != null && permissions.contains('DEVICE_OVERVIEW')}">
				<a href="device-show">Thiết bị</a>
			</c:when>
			<c:otherwise>
				<a href="de-show">Thiết bị</a>
			</c:otherwise>
		   </c:choose>
        <c:if test="${permissions != null && permissions.contains('CATEGORY_MANAGEMENT')}">
            <a href="category-show">Danh mục</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('VIEW_ACCOUNT')}">
            <a href="account">Tài khoản</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('CRUD_SUPPLIER')}">
            <a href="supplier">Nhà cung cấp</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('VIEW_TASK_LIST')}">
            <a href="task-list">Danh sách task</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('PAYMENT_REPORTS')}">
            <a href="payment-list">Danh sách thanh toán</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('CUSTOMER_ISSUES_MANAGEMENT')}">
            <a href="manager-issues">Task cần giao</a>
        </c:if>
        <c:if test="${permissions != null && permissions.contains('TRANSACTION_MANAGEMENT')}">
            <a href="transactions">Danh sách giao dịch</a>
        </c:if>
    </nav>
</aside>
    
<script>
document.addEventListener('DOMContentLoaded', function () {
    var toggleBtn = document.querySelector('.sidebar-toggle');
    var sidebar = document.querySelector('.sidebar');
    if (!toggleBtn || !sidebar) return;
    
    document.body.classList.add('sidebar-collapsed');
    toggleBtn.setAttribute('aria-expanded', 'false');
    sidebar.setAttribute('aria-hidden', 'true');

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