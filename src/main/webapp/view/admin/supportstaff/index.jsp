<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng tổng kết hỗ trợ khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }
        .summary-card {
            background: #fff;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 16px 32px rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.08);
        }
        .summary-card h3 {
            margin: 0;
            font-size: 15px;
            font-weight: 600;
            color: #475569;
        }
        .summary-card strong {
            display: block;
            font-size: 30px;
            margin: 12px 0 6px;
            color: #1e3a8a;
        }
        .summary-card span {
            font-size: 13px;
            color: #64748b;
        }
        .panel {
            background: #fff;
            padding: 22px;
            border-radius: 16px;
            margin-bottom: 26px;
            box-shadow: 0 18px 34px rgba(15, 23, 42, 0.12);
        }
        .panel h2 {
            margin-top: 0;
            font-size: 20px;
            color: #0f172a;
        }
        table.support-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        table.support-table th,
        table.support-table td {
            padding: 12px 16px;
            text-align: left;
        }
        table.support-table th {
            background: #eef2ff;
            color: #1e3a8a;
            font-weight: 600;
            font-size: 14px;
        }
        table.support-table tr:nth-child(every) {
            background: #f8fafc;
        }
        table.support-table tr:nth-child(odd) {
            background: #ffffff;
        }
        table.support-table tr:hover {
            background: #f1f5f9;
        }
        .status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-new { background: #e0f2fe; color: #0369a1; }
        .status-awaiting { background: #fef3c7; color: #b45309; }
        .status-progress { background: #dcfce7; color: #166534; }
        .status-review { background: #ede9fe; color: #5b21b6; }
        .status-resolved { background: #f3f4f6; color: #475569; }
        .empty {
            color: #64748b;
            font-style: italic;
        }
    </style>
</head>
<body class="management-page dashboard">
<jsp:include page="../common/sidebar.jsp"/>
<jsp:include page="../common/header.jsp"/>

<main class="sidebar-main">
    <section class="panel">
        <h2>Tổng kết nhanh</h2>
        <div class="summary-grid">
            <div class="summary-card">
                <h3>Yêu cầu mới</h3>
                <strong>${newIssueCount}</strong>
                <span>Chưa có nhân viên tiếp nhận</span>
            </div>
            <div class="summary-card">
                <h3>Đang xử lý của tôi</h3>
                <strong>${inProgressCount}</strong>
                <span>Đã tiếp nhận và đang xử lý</span>
            </div>
            <div class="summary-card">
                <h3>Chờ khách hàng phản hồi</h3>
                <strong>${awaitingCustomerCount}</strong>
                <span>Cần nhắc khách bổ sung thông tin</span>
            </div>
            <div class="summary-card">
                <h3>Đang chờ duyệt/đã kết thúc</h3>
                <strong>${managerReviewCount + resolvedIssueCount}</strong>
                <span>${managerReviewCount} chờ duyệt · ${resolvedIssueCount} đã xong</span>
            </div>
        </div>
    </section>

    <section class="panel">
        <h2>Yêu cầu mới nhất</h2>
        <c:choose>
            <c:when test="${empty newIssuesPreview}">
                <p class="empty">Hiện không có yêu cầu mới nào.</p>
            </c:when>
            <c:otherwise>
                <table class="support-table">
                    <thead>
                        <tr>
                            <th>Mã yêu cầu</th>
                            <th>Tiêu đề</th>
                            <th>Khách hàng</th>
                            <th>Thời gian tạo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issue" items="${newIssuesPreview}">
                            <tr>
                                <td>${issue.issueCode}</td>
                                <td>${issue.title}</td>
                                <td>#${issue.customerId}</td>
                                <td><fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="panel">
        <h2>Yêu cầu của tôi</h2>
        <c:choose>
            <c:when test="${empty myIssuesPreview}">
                <p class="empty">Bạn chưa tiếp nhận yêu cầu nào.</p>
            </c:when>
            <c:otherwise>
                <table class="support-table">
                    <thead>
                        <tr>
                            <th>Mã yêu cầu</th>
                            <th>Tiêu đề</th>
                            <th>Trạng thái</th>
                            <th>Cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issue" items="${myIssuesPreview}">
                            <tr>
                                <td>${issue.issueCode}</td>
                                <td>${issue.title}</td>
                                <td>
                                    <c:set var="status" value="${issue.supportStatus}" />
                                    <c:choose>
                                        <c:when test="${status eq 'awaiting_customer'}">
                                            <span class="status status-awaiting">Chờ khách</span>
                                        </c:when>
                                        <c:when test="${status eq 'in_progress'}">
                                            <span class="status status-progress">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${status eq 'manager_review'}">
                                            <span class="status status-review">Chờ duyệt</span>
                                        </c:when>
                                        <c:when test="${status eq 'resolved'}">
                                            <span class="status status-resolved">Hoàn tất</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-new">${status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="panel">
        <h2>Đang chờ khách hàng bổ sung</h2>
        <c:choose>
            <c:when test="${empty awaitingCustomerPreview}">
                <p class="empty">Không có yêu cầu nào đang chờ khách hàng.</p>
            </c:when>
            <c:otherwise>
                <table class="support-table">
                    <thead>
                        <tr>
                            <th>Mã yêu cầu</th>
                            <th>Tiêu đề</th>
                            <th>Nhân viên phụ trách</th>
                            <th>Ngày gửi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="issue" items="${awaitingCustomerPreview}">
                            <tr>
                                <td>${issue.issueCode}</td>
                                <td>${issue.title}</td>
                                <td>#${issue.supportStaffId}</td>
                                <td><fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
