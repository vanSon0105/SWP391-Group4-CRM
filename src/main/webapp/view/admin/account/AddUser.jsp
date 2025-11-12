<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Thêm người dùng | TechShop</title>
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
  <h2>Thêm người dùng mới</h2>
  <form action="${pageContext.request.contextPath}/account" method="post">
    <input type="hidden" name="action" value="add">

    <label>Tên đăng nhập:</label>
    <input type="text" name="username" required>

    <label>Email:</label>
    <input type="email" name="email" required>

    <label>Mật khẩu:</label>
    <input type="password" name="password" required>

    <label>Họ tên:</label>
    <input type="text" name="fullName" required>

    <label>Số điện thoại:</label>
    <input type="text" name="phone">

    <label>Vai trò:</label>
    <select name="roleId" required>
      <option value="1">Quản trị viên</option>
      <option value="2">Nhân viên</option>
      <option value="3">Kỹ thuật viên</option>
      <option value="4">Khách hàng</option>
    </select>

    <label>Trạng thái:</label>
    <select name="status">
      <option value="1">Hoạt động</option>
      <option value="0">Bị khóa</option>
    </select>

    <div style="display:flex;justify-content:space-between;margin-top:10px;">
      <button type="submit" class="btn btn-primary">Lưu</button>
      <a href="${pageContext.request.contextPath}/account" class="btn btn-secondary">Hủy</a>
    </div>
  </form>
</div>

<script>
const contextPath = '${pageContext.request.contextPath}';

document.querySelectorAll('input, select').forEach(input => {
    const errorSpan = document.createElement('span');
    errorSpan.style.color = 'red';
    errorSpan.style.fontSize = '13px';
    errorSpan.style.display = 'block';
    errorSpan.style.marginTop = '3px';
    input.parentNode.insertBefore(errorSpan, input.nextSibling);
    input.errorSpan = errorSpan;
});

function validateField(input) {
    const name = input.name;
    const value = input.value.trim();
    let message = '';

    switch(name) {
        case 'username':
            if (!/^[a-zA-Z0-9_]{3,20}$/.test(value)) {
                message = 'Tên đăng nhập: 3-20 ký tự, chỉ chữ, số, dấu _';
            }
            break;
        case 'email':
            if (!/^\S+@\S+\.\S+$/.test(value)) {
                message = 'Email không hợp lệ';
            }
            break;
        case 'password':
            if (!/^(?=.*[a-zA-Z])(?=.*\d).{6,}$/.test(value)) {
                message = 'Mật khẩu: ít nhất 6 ký tự, bao gồm chữ và số';
            }
            break;
        case 'fullName':
            if (!/^[a-zA-Z\s]{2,50}$/.test(value)) {
                message = 'Họ tên chỉ gồm chữ và khoảng trắng';
            }
            break;
        case 'phone':
            if (value && !/^\d{9,12}$/.test(value)) {
                message = 'Số điện thoại: 9-12 chữ số';
            }
            break;
        default:
            message = '';
    }

    input.errorSpan.textContent = message;
    input.style.borderColor = message ? 'red' : '#4ade80';
    return message === '';
}

async function checkDuplicate(input) {
    const name = input.name;
    const value = input.value.trim();
    if (!value) return;

    if (name === 'username' || name === 'email') {
        const params = new URLSearchParams();
        params.append(name, value);

        try {
            const res = await fetch(`${contextPath}/checkDuplicate?${params.toString()}`);
            const text = await res.text();

            if (text === 'USERNAME_EXISTS') {
                input.errorSpan.textContent = 'Tên đăng nhập đã tồn tại!';
                input.style.borderColor = 'red';
            } else if (text === 'EMAIL_EXISTS') {
                input.errorSpan.textContent = 'Email đã tồn tại!';
                input.style.borderColor = 'red';
            } else {
                if (validateField(input)) {
                    input.errorSpan.textContent = '';
                    input.style.borderColor = '#4ade80';
                }
            }
        } catch (err) {
            console.error(err);
        }
    }
}

document.querySelectorAll('input, select').forEach(input => {
    input.addEventListener('input', () => {
        validateField(input);
        checkDuplicate(input);
    });
});

const form = document.querySelector('form');
form.addEventListener('submit', function(e) {
    let valid = true;
    document.querySelectorAll('input, select').forEach(input => {
        if (!validateField(input)) {
            valid = false;
        }
    });
    if (!valid) e.preventDefault();
});
</script>
</body>
</html>
