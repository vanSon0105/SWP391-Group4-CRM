<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<%
    model.User currentUser = (model.User) request.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng | NovaCare</title>

    <!-- CSS Bootstrap & DataTables -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <style>
        body {
            background: #f5f5f5;
            font-family: Arial, sans-serif;
        }

        .profile-container {
            display: flex;
            max-width: 1200px;
            margin: 30px auto;
        }

        /* Sidebar */
        .profile-sidebar {
            width: 280px;
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-right: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .profile-card {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 16px;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }

        .profile-avatar {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            overflow: hidden;
            background: #e5e7eb;
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-meta h3 {
            margin: 0;
            font-size: 16px;
        }

        .profile-meta span {
            font-size: 13px;
            color: #666;
        }

        .profile-menu .menu-group {
            margin-bottom: 16px;
        }

        .profile-menu .menu-title {
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .profile-menu .menu-title i {
            margin-right: 8px;
            color: #2563eb;
        }

        .profile-content {
            flex: 1;
        }

        .container-table {
            background: #fff;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background-color: #ee4d2d;
            border: none;
        }

        .btn-primary:hover {
            background-color: #d73211;
        }

        footer {
            background-color: #000;
            color: #fff;
            padding: 20px 0;
            text-align: center;
            font-size: 14px;
            margin-top: 40px;
        }

        footer a {
            color: #fff;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<jsp:include page="../common/header.jsp"></jsp:include>

<body>
<div class="profile-container">
    <section class="profile-content">
        <div class="container-table">
            <h2>Danh sách người dùng</h2>
            <a href="${pageContext.request.contextPath}/admin/user/add" class="btn btn-primary mb-3">+ Thêm người dùng mới</a>
            <table id="usersTable" class="table table-striped table-bordered">
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
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.username}</td>
                        <td>${u.email}</td>
                        <td>${u.fullName}</td>
                        <td>${u.phone != null ? u.phone : "-"}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.roleId == 1}">Quản trị viên</c:when>
                                <c:when test="${u.roleId == 2}">Nhân viên</c:when>
                                <c:when test="${u.roleId == 3}">Kỹ thuật viên</c:when>
                                <c:otherwise>Khách hàng</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status == 'active'}">Hoạt động</c:when>
                                <c:otherwise>Bị khóa</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/user/view?id=${u.id}" class="btn btn-sm btn-info">Xem</a>
                            <a href="${pageContext.request.contextPath}/admin/user/edit?id=${u.id}" class="btn btn-sm btn-warning">Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/user/delete?id=${u.id}" class="btn btn-sm btn-danger"
                               onclick="return confirm('Xóa người dùng này?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</div>

<jsp:include page="../common/footer.jsp"></jsp:include>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
        $('#usersTable').DataTable({
            "language": {
                "lengthMenu": "Hiển thị _MENU_ người dùng mỗi trang",
                "zeroRecords": "Không tìm thấy kết quả",
                "info": "Trang _PAGE_ / _PAGES_",
                "infoEmpty": "Không có dữ liệu",
                "infoFiltered": "(lọc từ _MAX_ người dùng)",
                "search": "Tìm kiếm:",
                "paginate": { "next": "Tiếp", "previous": "Trước" }
            }
        });
    });
</script>
</body>
</html>
