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

<style>
    .form-field .error-message {
        color: #d9534f;
        font-size: 0.9em;
        margin-top: 4px;
    }
    .form-error-box {
        color: #d9534f;
        background-color: #f2dede;
        border: 1px solid #ebccd1;
        padding: 10px 15px;
        border-radius: 4px;
        margin-bottom: 15px;
    }
</style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	  <main class="sidebar-main">
        <section class="panel">
            <a class="btn device-btn" href="device-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        </section>

        <section class="panel">
            <h2>Thêm thiết bị</h2>
            
            <c:if test="${not empty error}">
                <div class="form-error-box">${error}</div>
            </c:if>
            <form class="device-form" action="device-add" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-field" id="device-name">
                        <label for="name">Tên thiết bị</label>
                        <input id="name" name="name" placeholder="Ví dụ: Laptop Asus" required value="${name}">
                    </div>
                    <div class="form-field">
                        <label for="category">Danh mục</label>
                        <select id="category" name="categoryId" required>
                        	<option value="">-- Chọn danh mục --</option>
                        	<c:forEach var="s" items="${categories}">
	                            <option value="${s.id}" <c:if test="${s.id == categoryId}">selected</c:if>>${s.name}
						        </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-field">
                        <label for="price">Giá bán (₫)</label>
                        <input id="price" name="price" type="number" min="0" placeholder="9490000" required value="${price}">
                    </div>
                    <div class="form-field">
                        <label for="unit">Đơn vị</label>
                        <input type="text" id="unit"  name="unit" required value="${unit}">
                    </div>
                    
                    <div class="form-field">
                        <label for="isFeatured">Nổi bật</label>
                        <input style="margin-bottom: 7px;width: 35px;" type="checkbox" id="isFeatured"  name="isFeatured" value="true" <c:if test="${isFeatured}">checked</c:if>>
                    </div>
                    
                    <div class="form-field file-image">
					    <label for="image">Ảnh</label>
					    <input type="file" id="image" name="image" accept="image/*">
					</div>
					
                </div>
                <div class="form-field">
                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description" rows="5" placeholder="Mô tả ngắn gọn về thiết bị...">${desc}</textarea>
                </div>
                <div class="form-actions">
                    <a class="btn ghost" href="device-show">Hủy</a>
                    <button class="btn primary" type="submit">Thêm thiết bị</button>
                </div>
            </form>        
        </section>
    </main>
</body>
</html>