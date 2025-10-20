<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        body {
            margin: 0;
            background: #f8fafc;
            font-family: 'Segoe UI', sans-serif;
        }

        .page-container {
            padding: 32px;
        }

        h1 {
            margin-top: 0;
            color: #0f172a;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
        }

        th,
        td {
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            text-align: left;
        }

        th {
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-pending {
            background: #e2e8f0;
            color: #0f172a;
        }

        .status-in_progress {
            background: #bfdbfe;
            color: #1d4ed8;
        }

        .status-completed {
            background: #bbf7d0;
            color: #047857;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 16px;
        }

        .alert-success {
            background: #dcfce7;
            color: #15803d;
        }

        .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .alert-warning {
            background: #fef3c7;
            color: #b45309;
        }

        select {
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #cbd5f5;
        }

        button {
            padding: 8px 14px;
            border-radius: 6px;
            border: none;
            background: #2563eb;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
        }

        .empty {
            padding: 32px;
            text-align: center;
            color: #475569;
        }
    </style>
</head>

<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main page-container">
        <h1>Trang kỹ thuật</h1>

        <c:if test="${param.updated == '1'}">
            <div class="alert alert-success">Đã cập nhật trạng thái task</div>
        </c:if>
        <c:if test="${param.error == '1'}">
            <div class="alert alert-error">Cập nhật thất bại - Hãy thử lại</div>
        </c:if>
        <c:if test="${param.invalid == '1'}">
            <div class="alert alert-warning">Yêu cầu không hợp lệ</div>
        </c:if>

        <c:choose>
            <c:when test="${not empty assignments}">
                <table>
                    <thead>
                        <tr>
                            <th>Task</th>
                            <th>Yêu cầu</th>
                            <th>Deadline</th>
                            <th>Trạng thái</th>
                            <th>Cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${assignments}" var="assignment">
                            <tr>
                                <td>
                                    <div><strong>${assignment.taskTitle}</strong></div>
                                    <div style="color:#64748b;">${assignment.taskDescription}</div>
                                </td>
                                <td>
                                    <div>Ma: ${assignment.issueCode}</div>
                                    <div>Tiêu đề: ${assignment.issueTitle}</div>
                                </td>
                                <td>
                                    <c:if test="${assignment.deadline != null}">
                                        <fmt:formatDate value="${assignment.deadline}" pattern="dd/MM/yyyy" />
                                    </c:if>
                                    <c:if test="${assignment.deadline == null}">
                                        Chưa có
                                    </c:if>
                                </td>
                                <td>
                                    <span class="status-pill status-${assignment.status}">
                                        <c:choose>
                                            <c:when test="${assignment.status == 'pending'}">Chưa bắt đầu</c:when>
                                            <c:when test="${assignment.status == 'in_progress'}">Đang thực hiện</c:when>
                                            <c:when test="${assignment.status == 'completed'}">Đã hoàn tất</c:when>
                                            <c:otherwise>Đã hủy</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <form method="post" action="technical-issues" style="display:flex; gap:8px; align-items:center;">
                                        <input type="hidden" name="assignmentId" value="${assignment.id}">
                                        <select name="status">
                                            <option value="pending" ${assignment.status == 'pending' ? 'selected' : ''}>Chưa bắt đầu</option>
                                            <option value="in_progress" ${assignment.status == 'in_progress' ? 'selected' : ''}>Đang thực hiện</option>
                                            <option value="completed" ${assignment.status == 'completed' ? 'selected' : ''}>Đã hoàn tất</option>
                                            <option value="cancelled" ${assignment.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                        <button type="submit">Lưu</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty">Chưa có task</div>
            </c:otherwise>
        </c:choose>
    </main>
</body>

</html>
