<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Quản lý nhà cung cấp | NovaCare</title>
  <style>
    :root {
      --primary: #2563eb;
      --primary-hover: #1d4ed8;
      --neutral: #6b7280;
      --bg: #f5f7fb;
      --card: #fff;
      --text: #111827;
      --danger: #ef4444;
      --warning: #f59e0b;
      --info: #0ea5e9;
      --success: #10b981;
      --radius: 10px;
      --shadow: 0 6px 18px rgba(0,0,0,.08);
      --border: #e5e7eb;
    }
    body.view-detail h2 { margin-top: 80px; }
    * { box-sizing: border-box; }
    body { margin: 0; background: var(--bg); color: var(--text); font: 16px/1.5 system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, "Helvetica Neue", Arial, "Noto Sans"; }
    main.sidebar-main { min-height: 100vh; display: flex; justify-content: center; align-items: flex-start; }
    .container-card { background: var(--card); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: var(--shadow); padding: 32px; margin: 80px auto 30px auto; width: 95%; min-width: 1000px; }
    h2 { margin: 0 0 20px; font-size: 24px; font-weight: 700; }
    .btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 14px; border-radius: 8px; border: 1px solid transparent; font-weight: 600; text-decoration: none; cursor: pointer; transition: .15s; background: #e5e7eb; color: #111827; }
    .btn:hover { filter: brightness(.98); }
    .btn-primary { background: var(--primary); color: #fff; }
    .btn-primary:hover { background: var(--primary-hover); }
    .btn-success { background: var(--success); color: #fff; }
    .btn-secondary { background: #374151; color: #fff; }
    .btn-warning { background: var(--warning); color: #111827; }
    .btn-info { background: var(--info); color: #fff; }
    .btn-danger { background: var(--danger); color: #fff; }
    .btn-sm { padding: 6px 10px; font-size: 14px; }
    .filter-section { display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between; margin-bottom: 16px; }
    .inline-form { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }
    .input { height: 38px; padding: 8px 10px; border: 1px solid var(--border); border-radius: 8px; min-width: 260px; outline: none; }
    .input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(37,99,235,.15); }
    .table-wrap { overflow-x: auto; border: 1px solid var(--border); border-radius: var(--radius); min-height: 200px; }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    thead th { position: sticky; top: 0; z-index: 1; background: var(--primary); color: #fff; text-align: center; font-weight: 700; padding: 12px; border-bottom: 1px solid var(--primary); }
    tbody td { padding: 12px; text-align: center; border-bottom: 1px solid var(--border); }
    tbody tr:nth-child(odd) { background: #fafbff; }
    tbody tr:hover { background: #f0f6ff; }
    tbody tr:last-child td { border-bottom: none; }
    .form-box, .detail-box { background: var(--card); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: var(--shadow); padding: 24px 28px; margin-top: 12px; margin-bottom: 24px; }
    .form-box h3, .detail-box h3 { margin-top: 0; margin-bottom: 16px; font-size: 20px; font-weight: 700; }
    .form-box label { font-weight: 600; margin-bottom: 6px; display: block; }
    .form-box .input { width: 100%; margin-top: 4px; }
    .form-actions { display: flex; gap: 10px; margin-top: 14px; }
    .message { color: var(--success); margin-bottom: 8px; }
    .error { color: var(--danger); margin-bottom: 8px; }
    .pagination { display: flex; justify-content: center; padding-left: 0; list-style: none; margin-top: 20px; font-family: Arial, sans-serif; }
    .page-item { margin: 0 5px; }
    .page-link { display: block; padding: 8px 14px; border: 1px solid #ddd; color: #007bff; text-decoration: none; cursor: pointer; border-radius: 4px; transition: background-color 0.3s, color 0.3s; user-select: none; }
    .page-link:hover:not(.disabled):not(.active) { background-color: #e9f5ff; color: #0056b3; }
    .page-item.active .page-link { background-color: #007bff; color: white; border-color: #007bff; cursor: default; }
    .page-item.disabled .page-link { color: #aaa; border-color: #ddd; cursor: default; pointer-events: none; }
    .page-link span { font-size: 16px; font-weight: bold; line-height: 1; }
    @media (max-width: 768px) { .container-main { margin: 16px; padding: 20px; } .input { min-width: unset; width: 100%; } thead th, tbody td { font-size: 14px; } }
  </style>
</head>

<body>
<jsp:include page="../admin/common/header.jsp"></jsp:include>
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>

<main class="sidebar-main">
  <div class="container-card">
    <h2>Quản lý nhà cung cấp</h2>

    <c:if test="${not empty requestScope.message}"><div class="message">${requestScope.message}</div></c:if>
    <c:if test="${not empty requestScope.error}"><div class="error">${requestScope.error}</div></c:if>

    <div class="filter-section">
      <div style="display:flex; gap:10px;">
        <a href="supplier?action=add" class="btn btn-primary">+ Thêm nhà cung cấp</a>
        <a href="supplier?action=trash" class="btn btn-danger">Thùng rác</a>
      </div>
      <form action="supplier" method="get" class="inline-form">
        <input type="hidden" name="action" value="search">
        <input type="text" name="keyword" value="${param.keyword}" class="input" placeholder="Tìm theo tên, email, số điện thoại...">
        <button type="submit" class="btn btn-success btn-sm">Tìm</button>
        <a href="supplier?action=list" class="btn btn-secondary btn-sm">Reset</a>
      </form>
    </div>

    <c:if test="${action == 'add' || action == 'edit'}">
      <div class="form-box">
        <h3><c:out value="${action == 'add' ? 'Thêm mới' : 'Cập nhật'}"/> nhà cung cấp</h3>
        <form action="supplier" method="post" style="display:flex;flex-direction:column;gap:10px;">
          <input type="hidden" name="action" value="${action == 'add' ? 'add' : 'update'}" />
          <c:if test="${action == 'edit'}">
            <input type="hidden" name="id" value="${supplier.id}" />
          </c:if>
          <label>Tên:<input type="text" class="input" name="name" value="${supplier.name}" required></label>
          <label>SĐT:<input type="text" class="input" name="phone" value="${supplier.phone}"></label>
          <label>Email:<input type="email" class="input" name="email" value="${supplier.email}"></label>
          <label>Địa chỉ:<input type="text" class="input" name="address" value="${supplier.address}"></label>
          <div class="form-actions">
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="supplier?action=list" class="btn btn-secondary">Hủy</a>
          </div>
        </form>
      </div>
    </c:if>

    <c:if test="${action == 'list' || action == 'trash'}">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Tên nhà cung cấp</th>
              <th>SĐT</th>
              <th>Email</th>
              <th>Địa chỉ</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty suppliers}">
                <c:forEach var="s" items="${suppliers}">
                  <tr>
                    <td>${s.id}</td>
                    <td>${s.name}</td>
                    <td>${s.phone}</td>
                    <td>${s.email}</td>
                    <td>${s.address}</td>
                    <td>
                      <c:choose>
                        <c:when test="${action == 'trash'}">
                          <a href="supplier?action=restore&id=${s.id}" class="btn btn-info btn-sm">Khôi phục</a>
                          <a href="supplier?action=deletePermanent&id=${s.id}" class="btn btn-danger btn-sm"
                             onclick="return confirm('Xóa vĩnh viễn?');">Xóa vĩnh viễn</a>
                        </c:when>
                        <c:otherwise>
                          <a href="supplier?action=viewHistory&id=${s.id}" class="btn btn-info btn-sm">Xem</a>
                          <a href="supplier?action=edit&id=${s.id}" class="btn btn-warning btn-sm">Sửa</a>
                          <a href="supplier?action=delete&id=${s.id}" class="btn btn-danger btn-sm"
                             onclick="return confirm('Xóa nhà cung cấp này?');">Xóa</a>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr><td colspan="6" style="color:gray;">Không có dữ liệu</td></tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </c:if>

    <c:if test="${(action == 'view' || action == 'viewHistory') && not empty supplier}">
      <div class="detail-wrapper"> 
        <div class="detail-box">
          <h3>Chi tiết nhà cung cấp</h3>
          <p><b>ID:</b> ${supplier.id}</p>
          <p><b>Tên:</b> ${supplier.name}</p>
          <p><b>SĐT:</b> ${supplier.phone}</p>
          <p><b>Email:</b> ${supplier.email}</p>
          <p><b>Địa chỉ:</b> ${supplier.address}</p>
          <a href="supplier?action=list" class="btn btn-secondary">Quay lại</a>
        </div>
        <c:if test="${action == 'viewHistory' && not empty history}">
          <div class="detail-box" style="margin-top: 24px;">
            <h3>Lịch sử cung cấp thiết bị</h3>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Device ID</th>
                    <th>Tên thiết bị</th>
                    <th>Ngày</th>
                    <th>Giá</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="h" items="${history}" varStatus="status">
                    <tr>
                      <td>${status.index + 1}</td>
                      <td>${h.deviceId}</td>
                      <td>${h.deviceName}</td>
                      <td>${h.date}</td>
                      <td>${h.price}</td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </c:if>
      </div>
    </c:if>

    <!-- Tổng số -->
    <p style="margin-top:12px; color:#6b7280">
      Tổng số nhà cung cấp: <strong><c:out value="${fn:length(suppliers)}"/></strong>
    </p>

    <!-- Pagination -->
    <nav aria-label="Page navigation" style="margin-top: 20px;">
      <ul class="pagination justify-content-center">
        <c:choose>
          <c:when test="${currentPage > 1}">
            <li class="page-item">
              <a class="page-link" href="supplier?action=${action}&page=${currentPage - 1}" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="page-item disabled">
              <span class="page-link" aria-hidden="true">&laquo;</span>
            </li>
          </c:otherwise>
        </c:choose>
        <c:forEach var="i" begin="1" end="${totalPages}">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link" href="supplier?action=${action}&page=${i}">${i}</a>
          </li>
        </c:forEach>
        <c:choose>
          <c:when test="${currentPage < totalPages}">
            <li class="page-item">
              <a class="page-link" href="supplier?action=${action}&page=${currentPage + 1}" aria-label="Next">
                <span aria-hidden="true">&raquo;</span>
              </a>
            </li>
          </c:when>
          <c:otherwise>
            <li class="page-item disabled">
              <span class="page-link" aria-hidden="true">&raquo;</span>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>

  </div>
</main>
</body>
</html>
