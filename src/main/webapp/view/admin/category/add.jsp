<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	  <main class="sidebar-main">
        <section class="panel">
            <a class="btn device-btn" href="category-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        </section>

        <section class="panel">
            <h2>Thêm danh mục</h2>
            <form class="device-form" action="category-add" method="post">
                <div class="form-grid">
                    <div class="form-field">
                        <label for="name">Tên danh mục</label>
                        <input id="name" name="name" placeholder="Ví dụ: Laptop" required>
                    </div>
                </div>
                <div class="form-actions">
                    <a class="btn ghost" href="category-show">Hủy</a>
                    <button class="btn primary" type="submit">Thêm danh mục</button>
                </div>
            </form>        
        </section>
    </main>
</body>
</html>