<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechShop</title>
    <style>
        body.home-page {
            background: #f5f6fa;
        }
        
        .home-page main{
        	padding: 36px 24px !important;
        }

        .issue-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .issue-header h1 {
            margin: 0;
            color: #1f2d3d;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
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

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
        }

        th,
        td {
            padding: 14px 16px !important;
            text-align: left;
            border-bottom: 1px solid #eef2f6;
            font-size: 14px;
        }

        th {
            background: #f8fafc;
            font-weight: 600;
            color: #475569;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .04em;
        }

        .status-new {
            background: #e2e8f0;
            color: #1e293b;
        }

        .status-in_progress {
            background: #dbeafe;
            color: #1d4ed8;
        }
        
        .status-awaiting_customer {
            background: #fef3c7;
            color: #b45309;
        }

        .status-submitted {
            background: #dcfce7;
            color: #047857;
        }
        
        .status-manager_rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-manager_approved {
            background: #cffafe;
            color: #0f766e;
        }

        .status-task_created {
            background: #ede9fe;
            color: #6d28d9;
        }

        .status-tech_in_progress {
            background: #fef3c7;
            color: #92400e;
        }

        .status-resolved {
            background: #dcfce7;
            color: #15803d;
        }
        

        .empty-state {
            text-align: center;
            padding: 40px 0;
            color: #475569;
        }
        
        .action-link {
            text-decoration: none;
            color: #2563eb;
            font-weight: 600;
        }
    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <div class="issue-header">
    <h1>Yêu cầu hỗ trợ của tôi</h1>
    <a class="btn-primary" href="create-issue">Gửi yêu cầu mới</a>
</div>

<c:if test="${param.created == '1'}">
    <div class="alert alert-success">Đã gửi yêu cầu thành công! Bộ phận hỗ trợ sẽ liên hệ với bạn sớm nhất.</div>
</c:if>
<c:if test="${param.details == '1'}">
    <div class="alert alert-success">Đã gửi form thông tin cho nhân viên hỗ trợ.</div>
</c:if>
<c:if test="${param.invalid == '1'}">
    <div class="alert alert-warning">Yêu cầu bổ sung không hợp lệ hoặc đã được xử lý.</div>
</c:if>

<c:choose>
    <c:when test="${not empty list}">
        <table>
            <thead>
                <tr>
                    <th>Mã yêu cầu</th>
                    <th>Tiêu đề</th>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${list}">
                    <c:set var="status" value="${empty s.supportStatus ? 'new' : s.supportStatus}" />
                    <tr>
                        <td>${s.issueCode}</td>
                        <td>${s.title}</td>
                        <td>
                            <fmt:formatDate value="${s.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                        <td>
                            <span class="status-pill status-${status}">
                                <c:choose>
                                    <c:when test="${status == 'awaiting_customer'}">Chờ bổ sung</c:when>
                                    <c:when test="${status == 'submitted'}">Đã chuyển kỹ thuật</c:when>
                                    <c:when test="${status == 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${status == 'manager_rejected'}">Cần bổ sung thông tin</c:when>
                                    <c:when test="${status == 'manager_approved'}">Đã duyệt tạo task</c:when>
                                    <c:when test="${status == 'task_created'}">Đã tạo task</c:when>
                                    <c:when test="${status == 'tech_in_progress'}">Đang thực hiện</c:when>
                                    <c:when test="${status == 'resolved'}">Đã hoàn tất</c:when>
                                    <c:otherwise>Tiếp nhận mới</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:if test="${status == 'awaiting_customer'}">
                                <a class="action-link"
                                   href="issue-fill?id=${s.id}">Bổ sung form</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <div class="empty-state">
            Bạn chưa có yêu cầu nào. Nhấn "Gửi yêu cầu mới" để mô tả vấn đề bạn gặp phải.
        </div>
    </c:otherwise>
</c:choose>

    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>