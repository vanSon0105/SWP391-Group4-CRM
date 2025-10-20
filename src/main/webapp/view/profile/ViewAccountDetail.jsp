<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết người dùng | NovaCare</title>
  <style>
    body{font-family:system-ui;background:#f5f7fb;margin:0;padding:20px}
    .card{max-width:900px;margin:24px auto;background:#fff;padding:24px;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.06)}
    .grid{display:flex;gap:20px;align-items:flex-start}
    .avatar{width:160px;height:160px;border-radius:10px;background:#f0f2f5;display:flex;align-items:center;justify-content:center;overflow:hidden}
    .avatar img{width:100%;height:100%;object-fit:cover}
    .info{flex:1}
    .row{display:flex;gap:10px;margin:8px 0}
    .label{width:140px;color:#6b7280;font-weight:700}
    .value{flex:1}
    .btn{display:inline-block;padding:8px 12px;border-radius:8px;text-decoration:none;font-weight:600}
    .btn-back{background:#e5e7eb;color:#111}
    .btn-edit{background:#f59e0b;color:#111;margin-left:8px}
  </style>
</head>
<body>

<jsp:include page="../common/header.jsp"></jsp:include>

<div class="card">
  <h2>Chi tiết người dùng</h2>

  <c:if test="${not empty error}">
    <p style="color:#ef4444">${error}</p>
  </c:if>

  <c:if test="${not empty userDetail}">
    <div class="grid">
      <div class="avatar">
        <c:choose>
          <c:when test="${not empty userDetail.imageUrl}">
            <img src="${pageContext.request.contextPath}/${userDetail.imageUrl}" alt="avatar">
          </c:when>
          <c:otherwise>
            <img src="${pageContext.request.contextPath}/static/images/default-avatar.png" alt="avatar">
          </c:otherwise>
        </c:choose>
      </div>

      <div class="info">
        <div class="row"><div class="label">ID</div><div class="value">${userDetail.id}</div></div>
        <div class="row"><div class="label">Tên đăng nhập</div><div class="value">${userDetail.username}</div></div>
        <div class="row"><div class="label">Họ tên</div><div class="value">${userDetail.fullName}</div></div>
        <div class="row"><div class="label">Email</div><div class="value">${userDetail.email}</div></div>
        <div class="row"><div class="label">Số điện thoại</div><div class="value">${empty userDetail.phone ? '-' : userDetail.phone}</div></div>
        <div class="row"><div class="label">Vai trò</div><div class="value">${userDetail.role}</div></div>
        <div class="row"><div class="label">Trạng thái</div>
          <div class="value">
            <c:choose>
              <c:when test="${userDetail.status == 'active'}"><span style="color:#10b981;font-weight:700">Hoạt động</span></c:when>
              <c:otherwise><span style="color:#ef4444;font-weight:700">Bị khóa</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="row"><div class="label">Tạo lúc</div><div class="value">${userDetail.createdAt}</div></div>
        <div class="row"><div class="label">Lần đăng nhập cuối</div><div class="value">${userDetail.lastLoginAt}</div></div>

        <div style="margin-top:16px">
          <a href="${pageContext.request.contextPath}/account" class="btn btn-back">Quay lại</a>
          <a href="${pageContext.request.contextPath}/account?action=edit&id=${userDetail.id}" class="btn btn-edit">Sửa</a>
        </div>
      </div>
    </div>
  </c:if>

</div>

<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
