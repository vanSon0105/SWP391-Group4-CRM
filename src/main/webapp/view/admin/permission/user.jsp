<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Phan quyen - Nguoi dung</title>
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
        
        .permission-chip.select-all {
            border: 1px dashed #cbd5f5;
            background: #f8fafc;
        }
        
        .user-layout {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 24px;
            margin-top: 24px;
        }
        .user-list {
            border: 1px solid rgba(15,23,42,.08);
            border-radius: 18px;
            padding: 16px;
            background: #fff;
            max-height: 70vh;
            overflow: auto;
        }
        .user-card {
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 12px 14px;
            border-radius: 12px;
            text-decoration: none;
            color: #0f172a;
            border: 1px solid transparent;
        }
        .user-card small {
            color: #475569;
        }
        .user-card.active {
            border-color: rgba(37,99,235,.4);
            background: rgba(59,130,246,.08);
        }
        .user-panel {
            border: 1px solid rgba(15,23,42,.08);
            border-radius: 18px;
            padding: 20px;
            background: #fff;
        }
        .user-header {
            display: flex;
            flex-direction: column;
            gap: 4px;
            margin-bottom: 18px;
        }
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(37,99,235,.12);
            color: #1d4ed8;
            font-weight: 600;
            font-size: 12px;
        }
        .permission-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill,minmax(240px,1fr));
            gap: 12px;
            margin-top: 16px;
        }
        .permission-card {
            border: 1px solid rgba(15,23,42,.12);
            border-radius: 14px;
            padding: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .permission-card.inherited {
            background: rgba(15,23,42,.02);
        }
        .permission-card strong {
            font-size: 14px;
        }
        .permission-card label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }
        .permission-card input {
            width: 18px;
            height: 18px;
        }
        .tag-cloud {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }
        .tag-cloud span {
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(15,23,42,.06);
            font-size: 12px;
        }
        .permission-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
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
    </style>
</head>
<body class="management-page device-management">
<jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main permission-management">
        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Bổ sung cho người dùng</h2>
                </div>
                <div class="tab-switch">
                    <a href="permission-management" class="btn btn-add">Theo vai trò</a>
                    <a href="permission-user" class="btn device-btn">Theo người dùng</a>
                </div>
            </div>

            <form class="device-search" method="get" action="permission-user">
                <input class="btn device-btn" type="text" name="keyword" placeholder="Tìm theo email hoặc tên"
                       value="${fn:escapeXml(keyword)}">
                <select class="btn device-btn" name="filterRoleId">
                    <option value="0" ${filterRoleId == 0 ? 'selected' : ''}>Tất cả vai trò</option>
                    <c:forEach var="role" items="${roles}">
                        <option value="${role.id}" ${role.id == filterRoleId ? 'selected' : ''}>
                            ${role.name}
                        </option>
                    </c:forEach>
                </select>
                <button class="btn device-btn" type="submit">Lọc</button>
            </form>

            <c:if test="${not empty permissionMessage}">
                <div class="flash ${permissionType}">
                    ${permissionMessage}
                </div>
            </c:if>

            <div class="user-layout">
                <aside class="user-list">
                    <c:choose>
                        <c:when test="${empty users}">
                            <p class="empty-state">Không tìm thấy người dùng phù hợp</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="user" items="${users}">
                                <c:url var="userLink" value="permission-user">
                                    <c:param name="userId" value="${user.id}" />
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}" />
                                    </c:if>
                                    <c:if test="${filterRoleId > 0}">
                                        <c:param name="filterRoleId" value="${filterRoleId}" />
                                    </c:if>
                                </c:url>
                                <a class="user-card ${selectedUser != null && selectedUser.id == user.id ? 'active' : ''}"
                                   href="${userLink}">
                                    <strong>${user.fullName != null ? user.fullName : user.username}</strong>
                                    <small>${user.email}</small>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </aside>

                <div class="user-panel">
                    <c:choose>
                        <c:when test="${selectedUser == null}">
                            <p class="empty-state">Hãy chọn 1 người dùng để cấp quyền</p>
                        </c:when>
                        <c:otherwise>
                            <div class="user-header">
                                <h3>${selectedUser.fullName != null ? selectedUser.fullName : selectedUser.username}</h3>
                                <span class="badge"><i class="fa-solid fa-user-shield"></i> ID #${selectedUser.id}</span>
                                <small>${selectedUser.email}</small>
                            </div>

                            <div class="inherited">
                                <h4>Quyền từ vai trò</h4>
                                <div class="tag-cloud">
                                    <c:forEach var="permission" items="${allPermissions}">
                                        <c:if test="${inheritedPermissionIds != null && inheritedPermissionIds.contains(permission.id)}">
                                            <span>${permission.name}</span>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                            <form method="post" action="permission-user">
                                <input type="hidden" name="action" value="updateUser">
                                <input type="hidden" name="userId" value="${selectedUser.id}">
                                <div class="permission-grid" data-permission-group="user-permissions">
                                    <label class="permission-chip select-all">
                                        <input type="checkbox" data-select-all="user-permissions">
                                        <span>Chọn tất cả</span>
                                    </label>
                                    <c:forEach var="permission" items="${allPermissions}">
                                        <c:set var="inherited" value="${inheritedPermissionIds != null && inheritedPermissionIds.contains(permission.id)}" />
                                        <c:set var="direct" value="${userPermissionIds != null && userPermissionIds.contains(permission.id)}" />
										<div class="permission-card ${inherited ? 'inherited' : ''}">
										    <strong>${permission.name}</strong>
										    <label>
										        <input type="checkbox" name="permissionIds" value="${permission.id}"
										               <c:if test="${direct}">checked</c:if>>
										        Cấp riêng
										    </label>
										    <c:if test="${inherited}">
										        <small>Đã được cấp từ vai trò</small>
										    </c:if>
										</div>
                                    </c:forEach>
                                </div>
                                <div class="permission-actions">
                                    <button class="btn device-btn" type="submit">Lưu quyền bổ sung</button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>
    
</body>
</html>
