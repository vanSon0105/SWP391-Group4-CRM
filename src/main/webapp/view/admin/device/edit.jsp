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
            <a class="btn device-btn" href="device-show#table-panel"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        </section>

        <section class="panel">
            <h2>Cập nhật thông tin</h2>
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
                        <input id="price" name="price" type="number" min="0" value="${device.price}">
                    </div>
					
					<div class="form-field">
					    <label for="isFeatured">Nổi bật</label>
					    <input type="hidden" name="isFeatured" value="false">
					    <input style="margin-bottom: 7px;width: 35px;" type="checkbox" id="isFeatured" name="isFeatured" value="true"
					           <c:if test="${device.isFeatured}">checked</c:if>>
					</div>


                    
                    <div class="form-field file-image">
					    <label for="image">Ảnh</label>
					    <input type="file" id="image" name="image" accept="image/*">
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