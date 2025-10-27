<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background: #f4f6fb;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 24px;
            height: 100% !important;
        }
        
        main{
        	height: 100% !important;
        }

        h1 {
            color: #0f172a;
        }

        h2 {
            color: #1e293b;
        }

        .section {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        th,
        td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
        }

        th {
            background: #f8fafc;
            color: #475569;
        }

        tr:last-child td {
            border-bottom: none;
        }

        a.btn {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .reason-note {
            margin-top: 6px;
            font-size: 12px;
            color: #b45309;
        }

        .badge-new {
            background: #e2e8f0;
            color: #0f172a;
        }

        .badge-in_progress {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .badge-submitted {
            background: #bbf7d0;
            color: #047857;
        }
        
        .badge-manager_rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .badge-manager_approved {
            background: #cffafe;
            color: #0f766e;
        }

        .badge-task_created {
            background: #ede9fe;
            color: #6d28d9;
        }

        .badge-tech_in_progress {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-resolved {
            background: #dcfce7;
            color: #15803d;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
        }

        .alert-success {
            background: #dcfce7;
            color: #047857;
        }

        .alert-warning {
            background: #fef3c7;
            color: #b45309;
        }

        .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty {
            text-align: center;
            padding: 24px 0;
            color: #475569;
            font-style: italic;
        }
        
        .badge-customer_cancelled {
            background: #fecaca;
            color: #991b1b;
        }
    </style>
</head>

<body class="management-page dashboard">
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main class="sidebar-main">
        <h1>Yêu cầu khách hàng</h1>

        <c:if test="${param.saved == '1'}">
            <div class="alert alert-success">Đã lưu thông tin khách hàng và cập nhật trạng thái thành công.
            </div>
        </c:if>
        <c:if test="${param.locked == '1'}">
            <div class="alert alert-warning">Yêu cầu đã được một nhân viên hỗ trợ khác xử lý.</div>
        </c:if>
        <c:if test="${param.notfound == '1'}">
            <div class="alert alert-error">Không tìm thấy yêu cầu cần xử lý.</div>
        </c:if>

        <div class="section">
            <h2>Yêu cầu mới</h2>
            <c:choose>
                <c:when test="${not empty newIssues}">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Khách hàng</th>
                                <th>Tiêu đề</th>
                                <th>Ngày gửi</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="issue" items="${newIssues}">
                                <tr>
                                    <td>${issue.issueCode}</td>
                                    <td>${issue.customerId}</td>
                                    <td>${issue.title}</td>
                                    <td>
                                        <fmt:formatDate value="${issue.createdAt}"
                                            pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <a class="btn btn-primary"
                                            href="support-issues?action=review&id=${issue.id}">Tiếp
                                            nhận</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty">Không có yêu cầu mới.</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="section">
            <h2>Yêu cầu của tôi</h2>
            <c:choose>
                <c:when test="${not empty myIssues}">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Cập nhật</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="issue" items="${myIssues}">
                                <c:set var="status"
                                    value="${empty issue.supportStatus ? 'new' : issue.supportStatus}" />
                                <tr>
                                    <td>${issue.issueCode}</td>
                                    <td>${issue.title}</td>
                                    <td>
                                        <span class="badge badge-${status}">
                                            <c:choose>
                                                <c:when test="${status == 'submitted'}">Đã gửi quản lý
                                                </c:when>
                                                <c:when test="${status == 'awaiting_customer'}">Chờ khách
                                                    phản hồi</c:when>
                                                <c:when test="${status == 'in_progress'}">Đang thu thập
                                                </c:when>
                                                <c:when test="${status == 'customer_cancelled'}">Khách hủy yêu cầu</c:when>
                                                <c:when test="${status == 'manager_rejected'}">Quản lý từ chối</c:when>
	                                            <c:when test="${status == 'manager_approved'}">Quản lý đã duyệt</c:when>
	                                            <c:when test="${status == 'task_created'}">Đã tạo task</c:when>
	                                            <c:when test="${status == 'tech_in_progress'}">Đang xử lí kỹ thuật</c:when>
	                                            <c:when test="${status == 'resolved'}">Đã hoàn tất</c:when>
                                                <c:otherwise>Chưa tiếp nhận</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${status == 'manager_rejected' && not empty issue.feedback}">
	                                        <div class="reason-note">Ly do: ${issue.feedback}</div>
	                                    </c:if>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${issue.createdAt}"
                                            pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <a class="btn btn-primary"
                                            href="support-issues?action=review&id=${issue.id}">Cập
                                            nhật</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty">Bạn chưa tiếp nhận yêu cầu nào.</div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</body>

</html>