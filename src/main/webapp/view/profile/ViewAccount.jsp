<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Quản lý người dùng | NovaCare</title>

  <style>
    :root{
      --primary:#2563eb; --primary-hover:#1d4ed8;
      --neutral:#6b7280; --bg:#f5f7fb; --card:#fff; --text:#111827;
      --danger:#ef4444; --warning:#f59e0b; --info:#0ea5e9; --success:#10b981;
      --radius:10px; --shadow:0 6px 18px rgba(0,0,0,.08);
      --border:#e5e7eb;
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font:16px/1.5 system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Cantarell,"Helvetica Neue",Arial,"Noto Sans","Apple Color Emoji","Segoe UI Emoji";
    }

    .container-main{
      max-width:1200px; margin:30px auto; background:var(--card);
      border-radius:var(--radius); box-shadow:var(--shadow); padding:32px;
    }
    h2{margin:0 0 20px; font-size:24px; font-weight:700}

    /* Buttons */
    .btn{
      display:inline-flex; align-items:center; gap:8px;
      padding:10px 14px; border-radius:8px; border:1px solid transparent;
      font-weight:600; text-decoration:none; cursor:pointer; transition:.15s;
      background:#e5e7eb; color:#111827;
    }
    .btn:hover{filter:brightness(.98)}
    .btn-primary{background:var(--primary); color:#fff}
    .btn-primary:hover{background:var(--primary-hover)}
    .btn-success{background:var(--success); color:#fff}
    .btn-secondary{background:#374151; color:#fff}
    .btn-warning{background:var(--warning); color:#111827}
    .btn-info{background:var(--info); color:#fff}
    .btn-danger{background:var(--danger); color:#fff}
    .btn-sm{padding:6px 10px; font-size:14px}

    /* Filter bar */
    .filter-section{
      display:flex; flex-wrap:wrap; gap:12px; align-items:center;
      justify-content:space-between; margin-bottom:16px;
    }
    .inline-form{display:flex; flex-wrap:wrap; gap:10px; align-items:center}
    .input, .select{
      height:38px; padding:8px 10px; border:1px solid var(--border);
      border-radius:8px; min-width:260px; outline:none;
    }
    .input:focus, .select:focus{border-color:var(--primary); box-shadow:0 0 0 3px rgba(37,99,235,.15)}

    /* Table (thuần CSS) */
    .table-wrap{overflow:auto; border:1px solid var(--border); border-radius:10px}
    table{width:100%; border-collapse:separate; border-spacing:0}
    thead th{
      position:sticky; top:0; z-index:1;
      background:var(--primary); color:#fff; text-align:center; font-weight:700;
      padding:12px; border-bottom:1px solid var(--primary);
    }
    tbody td{padding:12px; text-align:center; border-bottom:1px solid var(--border)}
    tbody tr:nth-child(odd){background:#fafbff}
    tbody tr:hover{background:#f0f6ff}

    /* Status */
    .status-active{color:var(--success); font-weight:700}
    .status-inactive{color:var(--danger); font-weight:700}

    /* Pagination */
    .pager{
      display:flex; gap:6px; align-items:center; justify-content:flex-end;
      margin-top:12px; flex-wrap:wrap;
    }
    .pager .page-btn{
      min-width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center;
      border:1px solid var(--border); border-radius:8px; background:#fff; cursor:pointer;
    }
    .pager .page-btn[disabled]{opacity:.5; cursor:not-allowed}
    .pager .active{background:var(--primary); color:#fff; border-color:var(--primary)}
    .pager .info{margin-right:auto; color:var(--neutral)}

    @media (max-width:768px){
      .container-main{margin:16px; padding:20px}
      .input,.select{min-width:unset; width:100%}
      .inline-form{width:100%}
      thead th{font-size:14px}
      tbody td{font-size:14px}
    }
  </style>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>

<div class="container-main">
  <h2>Quản lý người dùng</h2>

  <div class="filter-section">
    <a href="${pageContext.request.contextPath}/view/profile/AddUser.jsp" class="btn btn-primary">+ Thêm người dùng mới</a>

    <!-- Tìm kiếm (server-side, giữ nguyên hành vi của bạn) -->
    <form action="${pageContext.request.contextPath}/account" method="get" class="inline-form">
      <input type="hidden" name="action" value="search">
      <input type="text" name="keyword" value="${param.keyword}" class="input" placeholder="Tìm theo tên, email, username...">
      <button type="submit" class="btn btn-success">Tìm</button>
    </form>

    <!-- Lọc vai trò (server-side) -->
    <form action="${pageContext.request.contextPath}/account" method="get" class="inline-form">
      <input type="hidden" name="action" value="filter">
      <select name="roleId" class="select">
        <option value="">-- Lọc vai trò --</option>
        <option value="1" ${filterRole == 1 ? 'selected' : ''}>Quản trị viên</option>
        <option value="2" ${filterRole == 2 ? 'selected' : ''}>Nhân viên</option>
        <option value="3" ${filterRole == 3 ? 'selected' : ''}>Kỹ thuật viên</option>
        <option value="4" ${filterRole == 4 ? 'selected' : ''}>Khách hàng</option>
      </select>
      <button type="submit" class="btn btn-secondary">Lọc</button>
    </form>
  </div>

  <div class="table-wrap">
    <table id="usersTable">
      <thead>
        <tr>
          <th>ID</th>
          <th>Tên đăng nhập</th>
          <th>Email</th>
          <th>Họ tên</th>
          <th>Số điện thoại</th>
          <th>Vai trò</th>
          <th>Trạng thái</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody id="usersBody">
        <c:forEach var="u" items="${users}">
          <tr>
            <td>${u.id}</td>
            <td>${u.username}</td>
            <td>${u.email}</td>
            <td>${u.fullName}</td>
            <td>${empty u.phone ? '-' : u.phone}</td>
            <td>
              <c:choose>
                <c:when test="${u.roleId == 1}">Quản trị viên</c:when>
                <c:when test="${u.roleId == 2}">Nhân viên</c:when>
                <c:when test="${u.roleId == 3}">Kỹ thuật viên</c:when>
                <c:otherwise>Khách hàng</c:otherwise>
              </c:choose>
            </td>
            <td>
              <span class="${u.status == 'active' || u.status == 1 ? 'status-active' : 'status-inactive'}">
                ${u.status == 'active' || u.status == 1 ? 'Hoạt động' : 'Bị khóa'}
              </span>
            </td>
            <td>
              <a href="${pageContext.request.contextPath}/account?action=detail&id=${u.id}" class="btn btn-sm btn-info">Xem</a>
              <a href="${pageContext.request.contextPath}/account?action=edit&id=${u.id}" class="btn btn-sm btn-warning">Sửa</a>
              <a href="${pageContext.request.contextPath}/account?action=delete&id=${u.id}"
                 class="btn btn-sm btn-danger"
                 onclick="return confirm('Bạn có chắc muốn xóa người dùng này?');">
                Xóa
              </a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <p style="margin-top:12px; color:#6b7280">Tổng số người dùng: <strong>${total}</strong></p>
</div>

<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
