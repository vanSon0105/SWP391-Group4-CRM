<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết task</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        body {
            margin: 0;
            background: #f8fafc;
        }

        .page-container {
            padding: 32px;
            display: grid;
            gap: 24px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .detail-card,
        .issue-card,
        .team-card {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 18px 32px rgba(15, 23, 42, 0.08);
            padding: 24px 28px;
        }

        .detail-header {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
        }

        .detail-title {
            font-size: 24px;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }

        .detail-subtitle {
            margin: 12px 0 0;
            color: #475569;
            line-height: 1.6;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .info-item {
            display: grid;
            gap: 4px;
            color: #334155;
        }

        .info-item span:first-child {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
        }

        .info-item span:last-child {
            font-weight: 600;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 6px 14px;
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

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 12px;
        }

        .issue-card p {
            margin: 6px 0;
            color: #475569;
            line-height: 1.6;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
            font-size: 14px;
            color: #334155;
        }

        th {
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .highlight-row {
            background: rgba(14, 165, 233, 0.08);
        }

        .note-badge {
            display: inline-flex;
            padding: 6px 12px;
            border-radius: 999px;
            background: rgba(14, 165, 233, 0.12);
            color: #0f172a;
            font-size: 12px;
            font-weight: 600;
        }
        
        .return{
        	width: max-content;
		    display: inline-flex;
		    align-items: center;
		    gap: 8px;
		    padding: 10px 16px;
		    border-radius: 12px;
		    border: 1px solid rgba(14, 165, 233, 0.28);
		    background: rgba(255, 255, 255, 0.85);
		    color: #1d4ed8;
		    font-weight: 600;
		    text-decoration: none;
		    transition: all 0.2s ease;
		    cursor: pointer;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main">
        <div class="page-container">
            <a href="technical-issues" class="return">&larr; Về danh sách</a>

            <c:set var="detail" value="${assignmentDetail}" />

            <section class="detail-card">
                <div class="detail-header">
                    <div>
                        <h1 class="detail-title">${detail.taskTitle}</h1>
                        <p class="detail-subtitle">${detail.taskDescription}</p>
                    </div>
                    <span class="status-pill status-${detail.status}">
                        <c:choose>
                            <c:when test="${detail.status == 'pending'}">Chưa bắt đầu</c:when>
                            <c:when test="${detail.status == 'in_progress'}">Đang thực hiện</c:when>
                            <c:when test="${detail.status == 'completed'}">Đã hoàn tất</c:when>
                            <c:otherwise>Đã hủy</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <span>Mã task</span>
                        <span>#${detail.taskId}</span>
                    </div>
                    <div class="info-item">
                        <span>Ngày giao</span>
                        <span>
                            <c:choose>
                                <c:when test="${detail.assignedAt != null}">
                                    <fmt:formatDate value="${detail.assignedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>Không có</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span>Deadline</span>
                        <span>
                            <c:choose>
                                <c:when test="${detail.deadline != null}">
                                    <fmt:formatDate value="${detail.deadline}" pattern="dd/MM/yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>Chưa đặt</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span>Người giao</span>
                        <span>
                            <c:choose>
                                <c:when test="${not empty detail.assignedByName}">
                                    ${detail.assignedByName}
                                </c:when>
                                <c:otherwise>Hệ thống</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span>Cập nhật cuối</span>
                        <span>
                            <c:choose>
                                <c:when test="${detail.updatedAt != null}">
                                    <fmt:formatDate value="${detail.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>---</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span>Ghi chú của bạn</span>
                        <span>
                            <c:choose>
                                <c:when test="${not empty detail.note}">
                                    ${detail.note}
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </section>

            <c:if test="${not empty issueDetail}">
                <c:set var="issue" value="${issueDetail}" />
                <section class="issue-card">
                    <div class="section-title">Thông tin yêu cầu liên quan</div>
                    <p><strong>Mã yêu cầu:</strong> ${issue.issueCode}</p>
                    <p><strong>Tiêu đề:</strong> ${issue.title}</p>
                    <p><strong>Mô tả:</strong> <br>${issue.description}</p>
                    <p><strong>Trạng thái hỗ trợ:</strong>
                    	<c:choose>
                             <c:when test="${issue.supportStatus == 'customer_cancelled'}">Đã hủy theo yêu cầu khách</c:when>
                             <c:when test="${issue.supportStatus == 'task_created'}">Đã tạo task</c:when>
                             <c:when test="${issue.supportStatus == 'tech_in_progress'}">Đang thực hiện</c:when>
                             <c:when test="${issue.supportStatus == 'resolved'}">Đã hoàn tất</c:when>
                             <c:otherwise>Đang xử lý</c:otherwise>
                         </c:choose>
                    </p>
                    <p><strong>Loại yêu cầu:</strong> ${issue.issueType}</p>
                </section>
            </c:if>

            <section class="team-card">
                <div class="section-title">Nhóm thực hiện</div>
                <c:choose>
                    <c:when test="${not empty teamAssignments}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Nhân viên</th>
                                    <th>Ngày giao</th>
                                    <th>Deadline</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${teamAssignments}" var="member">
                                    <tr class="${member.id == detail.id ? 'highlight-row' : ''}">
                                        <td>
                                            <div><strong>${member.technicalStaffName != null ? member.technicalStaffName : member.technicalStaffId}</strong></div>
                                            <div style="color:#64748b; font-size:12px;">${member.staffEmail}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${member.assignedAt != null}">
                                                    <fmt:formatDate value="${member.assignedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>---</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${member.deadline != null}">
                                                    <fmt:formatDate value="${member.deadline}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>---</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-pill status-${member.status}">
                                                <c:choose>
                                                    <c:when test="${member.status == 'pending'}">Chưa bắt đầu</c:when>
                                                    <c:when test="${member.status == 'in_progress'}">Đang thực hiện</c:when>
                                                    <c:when test="${member.status == 'completed'}">Đã hoàn tất</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty member.note}">
                                                    <span class="note-badge">${member.note}</span>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p style="color:#475569;">Không có thông tin nhóm.</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</body>
</html>
