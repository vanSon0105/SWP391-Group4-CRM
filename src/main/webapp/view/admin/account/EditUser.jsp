<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa người dùng | NovaCare</title>
  <style>
    body{font-family:system-ui;margin:0;background:#f5f7fb;}
    .container{
      max-width:600px;margin:40px auto;background:#fff;padding:30px;
      border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);
    }
    h2{margin-bottom:20px;text-align:center;}
    form{display:flex;flex-direction:column;gap:14px;}
    label{font-weight:600;}
    input,select{
      padding:10px;border:1px solid #ccc;border-radius:8px;font-size:15px;
    }
    .btn{padding:10px 14px;border:none;border-radius:8px;cursor:pointer;font-weight:600;}
    .btn-primary{background:#2563eb;color:#fff;}
    .btn-primary:hover{background:#1d4ed8;}
    .btn-secondary{background:#6b7280;color:#fff;}
  </style>
</head>
<body>

<jsp:include page="../common/header.jsp"></jsp:include>

<div class="container">
  <h2>Chỉnh sửa thông tin người dùng</h2>
  <form action="${pageContext.request.contextPath}/account" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${user.id}">

    <label>Tên đăng nhập:</label>
    <input type="text" name="username" value="${user.username}" readonly style="background:#f9fafb;">

    <label>Email:</label>
    <input type="email" name="email" value="${user.email}" required>

    <label>Họ tên:</label>
    <input type="text" name="fullName" value="${user.fullName}" required>

    <label>Số điện thoại:</label>
    <input type="text" name="phone" value="${user.phone}">

    <label>Vai trò:</label>
    <select name="roleId" required>
      <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Quản trị viên</option>
      <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Nhân viên</option>
      <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Kỹ thuật viên</option>
      <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Khách hàng</option>
    </select>

    <label>Trạng thái:</label>
    <select name="status">
      <option value="1" ${user.status == 1 ? 'selected' : ''}>Hoạt động</option>
      <option value="0" ${user.status == 0 ? 'selected' : ''}>Bị khóa</option>
    </select>

    <div style="display:flex;justify-content:space-between;margin-top:10px;">
      <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
      <a href="${pageContext.request.contextPath}/account" class="btn btn-secondary">Hủy</a>
    </div>
  </form>
</div>

</body>
</html>
