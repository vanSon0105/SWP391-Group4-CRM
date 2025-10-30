<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    .image-preview {
        margin-top: 12px;
    }
    .image-preview img {
        max-width: 220px;
        border-radius: 12px;
        border: 1px solid #d7dce6;
        background: #fff;
        padding: 6px;
    }
    
    .form-error-box {
        color: #d9534f;
        background-color: #f2dede;
        border: 1px solid #ebccd1;
        padding: 10px 15px;
        border-radius: 4px;
        margin-bottom: 15px;
    }
    
    input[readonly] {
        background-color: #eeeeee !important;
        cursor: not-allowed;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {     
        const fileInput = document.getElementById('avartaFile');
        const previewImage = document.querySelector('.image-preview img');
        fileInput.addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });
    });
</script>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	  <main class="sidebar-main">
        <section class="panel">
            <a class="btn device-btn" href="device-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        </section>

        <section class="panel">
            <h2>Cập nhật thông tin</h2>
            <c:if test="${not empty error}">
                <div class="form-error-box">${error}</div>
            </c:if>
            <c:if test="${not empty device}">
            <form class="device-form" action="device-update" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <input type="hidden" name="id" value="${device.id}">
                    <div class="form-field">
                        <label for="name">Tên thiết bị</label>
                        <input id="name" name="name" value="${device.name}">
                    </div>
                    <div class="form-field">
                        <label for="category">Danh mục</label>
                        <select id="category" name="categoryId">
                        	<c:forEach var="s" items="${categories}">
	                            <option value="${s.id}" <c:if test="${s.id == device.category.id}">selected</c:if>>
						            ${s.name}
						        </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-field">
                        <label for="price">Giá bán (₫)</label>
                        <input id="price" name="price" value="${device.price}" readonly>
                    </div>
                    
                    <div class="form-field">
                        <label for="unit">Đơn vị</label>
                        <input type="text" id="unit"  name="unit" required value="${device.unit}" placeholder="Ví dụ: Cái">
                    </div>
					
					<div class="form-field">
					    <label for="isFeatured">Nổi bật</label>
					    <input type="hidden" name="isFeatured" value="false">
					    <input style="margin-bottom: 7px;width: 35px;" type="checkbox" id="isFeatured" name="isFeatured" value="true"
					           <c:if test="${device.isFeatured}">checked</c:if>>
					</div>
                    
                    <div class="form-field file-image">
					    <label for="avartaFile">Ảnh</label>
					    <input type="file" id="avartaFile" name="image" accept=".png, .jpg, .jpeg">
					    <div class="image-preview">
                            <img src="${pageContext.request.contextPath}/assets/img/device/${device.imageUrl}" alt="Anh thiet bi hien tai">
                        </div>
					</div>

                </div>
                <div class="form-field">
                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description" rows="5">${device.desc}</textarea>
                </div>
                <div class="form-actions form-actions--spread">
                    <div>
                        <a id="view-link" class="btn ghost" href="device-view?id=${device.id}">Xem</a>
                    </div>
                    <div>
                        <a class="btn ghost" href="device-show#table-panel">Hủy</a>
                        <button class="btn primary" type="submit">Lưu thay đổi</button>
                    </div>
                </div>
            </form>
            </c:if>
            
            <c:if test="${empty device}">
		        <p>Không tìm thấy sản phẩm để sửa.</p>
		    </c:if>
        </section>
    </main>
</body>
</html>