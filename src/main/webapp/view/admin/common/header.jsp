<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
	
<header class="topbar">
       <div class="topbar-left">
       	<h1 class="header-title">
            <a href="home" style="position: relative;"><img alt="logo" src="${pageContext.request.contextPath}/assets/img/logo.png"></a>        	
       	</h1>
        
        <button class="sidebar-toggle" aria-label="Mở/đóng menu" aria-expanded="false"><i
                   class="fa-solid fa-bars-staggered"></i></button>
       </div>
       <div class="topbar-right">
           <div class="user-area">
               <a href="logout"><i class="fa-solid fa-right-from-bracket"></i></a>
               <a href="profile"><i class="fa-solid fa-user"></i></a>
           </div>
       </div>
   </header>