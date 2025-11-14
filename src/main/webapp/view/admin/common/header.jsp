<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<c:set var="currentPageTitle" value="${empty pageTitle ? 'Trang quản trị' : pageTitle}" />
<c:set var="topbarNotificationCount" value="${empty notificationCount ? 0 : notificationCount}" />

<header class="topbar">
       <div class="topbar-left">
       	<h1 class="header-title">
            <a href="home" style="position: relative;"><img alt="logo" src="${pageContext.request.contextPath}/assets/img/logo.png"></a>        	
       	</h1>
        
        <button class="sidebar-toggle" aria-label="Mở/đóng menu" aria-expanded="false"><i
                   class="fa-solid fa-bars-staggered"></i></button>
       </div>

       <div class="topbar-center">
       	<div class="page-meta">
       		<p class="page-breadcrumb">Admin / <c:out value="${currentPageTitle}" /></p>
       		<strong class="page-title"><c:out value="${currentPageTitle}" /></strong>
       	</div>
       	<form class="quick-search" action="search" method="get">
       		<label class="sr-only" for="topbar-search">Tìm kiếm</label>
       		<input id="topbar-search" name="q" type="search" placeholder="Tìm nhanh thiết bị, đơn hàng..." />
       		<button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
       	</form>
       </div>

       <div class="topbar-right">
           <div class="user-area">
           	   <div class="user-meta">
           	   		<c:if test="${not empty account}">
           	   			<strong><c:out value="${account.fullName != null ? account.fullName : account.username}" /></strong>
           	   			<small>ID #<c:out value="${account.id}" /></small>
           	   		</c:if>
           	   </div>
               <a class="profile-link" href="profile"><i class="fa-solid fa-user"></i></a>
               <form action="logout" method="post">
               	<button class="logout-link" type="submit" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></button>
               </form>
           </div>
       </div>
   </header>

<style>
.topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 1.5rem;
	padding: 0 1.5rem;
}
.topbar-center {
	display: flex;
	align-items: center;
	gap: 1.5rem;
	flex: 1;
}
.page-meta {
	display: flex;
	flex-direction: column;
	gap: 0.15rem;
}

.profile-link{
	font-size: 1.8rem;
}
.page-breadcrumb {
	margin: 0;
	font-size: 1.3rem;
	color: #94a3b8;
	text-transform: uppercase;
	letter-spacing: .08em;
}
.page-title {
	font-size: 1.4rem;
	color: #0f172a;
}
.quick-search {
	display: flex;
	align-items: center;
	gap: .5rem;
	background: #f8fafc;
	padding: .35rem .75rem;
	border-radius: 999px;
	border: 1px solid transparent;
	flex: 1;
	max-width: 360px;
	height: 35px;
}
.quick-search input {
	border: none;
	background: transparent;
	flex: 1;
	font-size: 1.3rem;
	outline: none;
}
.quick-search button {
	border: none;
	background: transparent;
	color: #475569;
	cursor: pointer;
}
.topbar-right {
	display: flex;
	align-items: center;
	gap: 1rem;
}
.notification-area .notif-button {
	position: relative;
	border: none;
	background: transparent;
	cursor: pointer;
	font-size: 1.1rem;
	color: #0f172a;
}
.notif-badge {
	position: absolute;
	top: -6px;
	right: -6px;
	background: #ef4444;
	color: #fff;
	font-size: 0.65rem;
	padding: 0 5px;
	border-radius: 999px;
}
.user-area {
	display: flex;
	align-items: center;
	gap: .5rem;
	background: #f1f5f9;
	border-radius: 999px;
	padding: .35rem .8rem;
}
.user-meta {
	display: flex;
	flex-direction: column;
	margin-right: .4rem;
}
.user-meta strong {
	font-size: 1.5rem;
	color: #0f172a;
}
.user-meta small {
	font-size: 1.2rem;
	color: #94a3b8;
}
.user-area a,
.user-area button {
	border: none;
	background: transparent;
	color: #0f172a;
	font-size: 1.8rem;
	cursor: pointer;
}
.sr-only {
	position: absolute;
	left: -9999px;
}

</style>
