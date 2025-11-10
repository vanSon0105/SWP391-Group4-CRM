<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
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
    <nav class="sidebar-nav">
        <c:set var="hasDashboard" value="${permissions != null && permissions.contains('DEVICE_OVERVIEW')}"/>
        <c:set var="hasDeviceArea" value="${permissions != null && (permissions.contains('DEVICE_OVERVIEW') or permissions.contains('CATEGORY_MANAGEMENT') or permissions.contains('CRUD_SUPPLIER'))}"/>
        <c:set var="hasAccountArea" value="${permissions != null && permissions.contains('VIEW_ACCOUNT')}"/>
        <c:set var="hasTaskArea" value="${permissions != null && (permissions.contains('VIEW_TASK_LIST') || permissions.contains('CUSTOMER_ISSUES_MANAGEMENT'))}"/>
        <c:set var="hasPaymentArea" value="${permissions != null && permissions.contains('PAYMENT_REPORTS')}"/>
        <c:set var="hasTransactionArea" value="${permissions != null && (permissions.contains('TRANSACTION_MANAGEMENT') || permissions.contains('ORDER_HISTORY_MANAGEMENT'))}"/>

        <c:if test="${hasDashboard}">
            <details open class="sidebar-group">
                <summary>Dashboard</summary>
                <a href="admin">Tổng quan</a>
                <a href="sales-report">Sales report</a>
            </details>
        </c:if>

        <c:if test="${hasDeviceArea}">
            <details class="sidebar-group">
                <summary>Thiết bị</summary>
                <c:if test="${permissions.contains('DEVICE_OVERVIEW')}">
                    <a href="device-show">Danh sách thiết bị</a>
                </c:if>
                <c:if test="${!permissions.contains('DEVICE_OVERVIEW')}">
                    <a href="de-show">Thiết bị</a>
                </c:if>
                <c:if test="${permissions.contains('CATEGORY_MANAGEMENT')}">
                    <a href="category-show">Danh mục</a>
                </c:if>
                <c:if test="${permissions.contains('CRUD_SUPPLIER')}">
                    <a href="supplier">Nhà cung cấp</a>
                </c:if>
            </details>
        </c:if>

        <c:if test="${hasAccountArea}">
            <details class="sidebar-group">
                <summary>Người dùng</summary>
                <a href="account">Tài khoản</a>
                <a href="permission-management">Phân quyền</a>
            </details>
        </c:if>

        <c:if test="${hasTaskArea}">
            <details class="sidebar-group">
                <summary>Nhiệm vụ</summary>
                <c:if test="${permissions.contains('VIEW_TASK_LIST')}">
                    <a href="task-list">Danh sách task</a>
                </c:if>
                <c:if test="${permissions.contains('CUSTOMER_ISSUES_MANAGEMENT')}">
                    <a href="manager-issues">Task cần giao</a>
                </c:if>
            </details>
        </c:if>

        <c:if test="${hasPaymentArea}">
            <details class="sidebar-group">
                <summary>Thanh toán</summary>
                <a href="payment-list">Danh sách thanh toán</a>
            </details>
        </c:if>

        <c:if test="${hasTransactionArea}">
            <details class="sidebar-group">
                <summary>Giao dịch & Kho</summary>
                <c:if test="${permissions.contains('TRANSACTION_MANAGEMENT')}">
                    <a href="transactions">Danh sách giao dịch</a>
                </c:if>
                <c:if test="${permissions.contains('ORDER_HISTORY_MANAGEMENT')}">
                    <a href="order-history">Lịch sử giao dịch</a>
                </c:if>
            </details>
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
