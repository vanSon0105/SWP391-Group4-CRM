<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Duyet yeu cau ky thuat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6fb;
            margin: 0;
            padding: 40px;
        }

        .layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            max-width: 1100px;
            margin: 0 auto;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
        }

        .card h2 {
            margin-top: 0;
            color: #0f172a;
        }

        .meta {
            font-size: 14px;
            color: #475569;
            margin-bottom: 16px;
        }

        pre {
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            white-space: pre-wrap;
        }

        label {
            display: block;
            font-weight: 600;
            color: #0f172a;
            margin-top: 16px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #d4dbe6;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            min-height: 140px;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .btn {
        	height: 100%;
            padding: 10px 18px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-outline {
            background: #e2e8f0;
            color: #0f172a;
        }

        .btn-danger {
            background: #ef4444;
            color: #fff;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
        }
    </style>
</head>

<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main">
    <div class="layout">
        <div class="card">
            <h2>Thong tin yeu cau</h2>
            <div class="meta">Mã yêu cầu: <strong>${issue.issueCode}</strong></div>
            <div class="meta">ID khách hàng: ${issue.customerId}</div>
            <div class="meta">Tiêu đề: <strong>${issue.title}</strong></div>
            <div class="meta">Mô tả</div>
            <pre>${issue.description}</pre>
        </div>

        <div class="card">
            <h2>Thông tin bổ sung từ support staff</h2>
            <c:if test="${issueDetail == null}">
                <p>Chưa có form thông tin từ nhân viên hỗ trợ</p>
            </c:if>
            <c:if test="${issueDetail != null}">
                <label>Tên khách hàng</label>
                <input type="text" value="${issueDetail.customerFullName}" readonly>

                <label>Email liên hệ</label>
                <input type="text" value="${issueDetail.contactEmail}" readonly>

                <label>Số điện thoại</label>
                <input type="text" value="${issueDetail.contactPhone}" readonly>

                <label>Serial thiết bị</label>
                <input type="text" value="${issueDetail.deviceSerial}" readonly>

                <label>Tổng hợp/Ghi chú</label>
                <textarea readonly>${issueDetail.summary}</textarea>
            </c:if>

            <div class="actions">
                <a class="btn btn-outline" href="manager-issues">Quay lai</a>
                <form method="post" action="manager-issues" style="margin:0;">
                    <input type="hidden" name="issueId" value="${issue.id}">
                    <input type="hidden" name="action" value="reject">
                    <button type="submit" class="btn btn-danger">Từ chối</button>
                </form>
                <form method="post" action="manager-issues" style="margin:0;">
                    <input type="hidden" name="issueId" value="${issue.id}">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn btn-primary">Chấp thuận task</button>
                </form>
            </div>
        </div>
    </div>
    </main>
</body>

</html>
