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
    <title>Phân quyền - Vai trò</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .tab-switch {
            display: flex;
            gap: 8px;
        }
        .permission-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            gap: 24px;
            margin-top: 24px;
        }
        .role-list {
            border: 1px solid rgba(15,23,42,.08);
            border-radius: 18px;
            padding: 16px;
            background: #fff;
            display: flex;
            flex-direction: column;
            gap: 8px;
            max-height: 70vh;
            overflow: auto;
        }
        .role-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 14px;
            border-radius: 12px;
            text-decoration: none;
            color: #0f172a;
            font-weight: 600;
            border: 1px solid transparent;
        }
        .role-card span {
            font-size: 13px;
            color: #475569;
        }
        .role-card.active {
            border-color: rgba(37,99,235,.4);
            background: rgba(59,130,246,.08);
        }
        .permission-board {
            border: 1px solid rgba(15,23,42,.08);
            border-radius: 18px;
            padding: 20px;
            background: #fff;
        }
        .permission-grid {
            display: grid;
            grid-template-columns: repeat(2	,1fr);
            gap: 12px;
            margin-top: 16px;
        }
        .permission-chip {
            border: 1px solid rgba(15,23,42,.12);
            border-radius: 14px;
            padding: 12px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .permission-chip input {
            width: 18px;
            height: 18px;
        }
        
        .flash {
        	width: max-content;
            margin: 16px 0;
            padding: 12px 16px;
            border-radius: 12px;
            font-weight: 600;
        }
        .flash.success {
            background: rgba(34,197,94,.12);
            color: #166534;
        }
        .flash.error {
            background: rgba(248,113,113,.12);
            color: #b91c1c;
        }
        .permission-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
        }
        
        
    </style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main">
        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Quản lý theo vai trò</h2>
                </div>
                <div class="tab-switch">
                    <a href="permission-management" class="btn btn-add">Theo vai trò</a>
                    <a href="permission-user" class="btn device-btn">Theo người dùng</a>
                </div>
            </div>

            <c:if test="${not empty permissionMessage}">
                <div class="flash ${permissionType}">
                    ${permissionMessage}
                </div>
            </c:if>
            
            <form method="post" action="permission-management">
                <input type="hidden" name="action" value="createPermission">
                <input class="btn device-btn" type="text" name="permissionName" placeholder="Tên quyền mới" required>
                <button class="btn btn-add" type="submit"><i class="fa-solid fa-plus"></i> Thêm quyền</button>
            </form>

            <c:choose>
                <c:when test="${empty roles}">
                    <p class="empty-state">Chưa có vai trò để cập nhật</p>
                </c:when>
                <c:otherwise>
                    <div class="permission-layout">
                        <aside class="role-list">
                            <c:forEach var="role" items="${roles}">
                                <a class="role-card ${role.id == selectedRoleId ? 'active' : ''}"
                                   href="permission-management?roleId=${role.id}">
                                    <div>
                                        <strong>${role.name}</strong>
                                        <span>${role.desc}</span>
                                    </div>
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:forEach>
                        </aside>

                        <div class="permission-board">
                            <c:if test="${selectedRole == null}">
                                <p class="empty-state">Hãy chọn 1 vai trò</p>
                            </c:if>
                            <c:if test="${selectedRole != null}">
                                <div class="board-header">
                                    <h3>${selectedRole.name}</h3>
                                    <p class="text-muted">Danh sách quyền đang cấp cho tài khoản này</p>
                                </div>
                                <form method="post" action="permission-management">
                                    <input type="hidden" name="action" value="updateRole">
                                    <input type="hidden" name="roleId" value="${selectedRole.id}">
                                    <div class="permission-grid">
                                        <c:forEach var="permission" items="${permissions}">
                                            <label class="permission-chip">
                                                <input type="checkbox" name="permissionIds" value="${permission.id}"
                                                       <c:if test="${assignedPermissionIds != null && assignedPermissionIds.contains(permission.id)}">checked</c:if>>
                                                <span>${permission.name}</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <div class="permission-actions">
                                        <button class="btn device-btn" type="submit">Lưu thay đổi</button>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
