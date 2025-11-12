<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
             margin: 0;
             padding: 32px;
             background: #f4f6fb;
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

         .section {
             background: #fff;
             border-radius: 12px;
             box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
             margin-bottom: 28px;
             padding: 20px 24px;
         }

         .section h2 {
             margin: 0;
             color: #1e293b;
         }

         table {
             width: 100%;
             border-collapse: collapse;
             margin-top: 16px;
         }

         th,
         td {
             padding: 12px 16px;
             text-align: left;
             border-bottom: 1px solid #e2e8f0;
             font-size: 14px;
         }

         th {
             background: #f8fafc;
             color: #475569;
             font-weight: 600;
         }

         tr:last-child td {
             border-bottom: none;
         }

         .btn-link {
             display: inline-flex;
             padding: 8px 14px;
             border-radius: 6px;
             background: #2563eb;
             color: #fff;
             text-decoration: none;
             font-weight: 600;
         }

         .badge {
             display: inline-flex;
             align-items: center;
             padding: 4px 10px;
             border-radius: 999px;
             font-size: 12px;
             font-weight: 600;
         }

         .badge-submitted {
             background: #bfdbfe;
             color: #1d4ed8;
         }

         .badge-manager_approved {
             background: #bbf7d0;
             color: #047857;
         }

         .badge-manager_rejected {
             background: #fee2e2;
             color: #b91c1c;
         }

         .badge-task_created {
             background: #ede9fe;
             color: #7c3aed;
         }

         .badge-tech_in_progress {
             background: #fde68a;
             color: #92400e;
         }

         .badge-resolved {
             background: #dcfce7;
             color: #15803d;
         }
     </style>
</head>

<body>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main class="sidebar-main" style="padding: 32px; font-size: 1.5rem;">
        <h1>Quản lý yêu cầu kĩ thuật</h1>
         <c:if test="${param.invalid == '1'}">
             <div class="alert alert-warning">Trạng thái yêu cầu không hợp lệ để xem.</div>
         </c:if>
         <c:if test="${param.rejected == '1'}">
             <div class="alert alert-success">Đã từ chối yêu cầu và thông báo về bộ phận kĩ thuật.</div>
         </c:if>

         <div class="section">
             <h2>Chờ duyệt</h2>
             <c:choose>
                 <c:when test="${not empty pendingIssues}">
                     <table>
                         <thead>
                             <tr>
                                 <th>Mã</th>
                                 <th>Tiêu đề</th>
                                 <th>Khách hàng</th>
                                 <th>Ngày gửi</th>
                                 <th>Trạng thái</th>
                                 <th>Thao tác</th>
                             </tr>
                         </thead>
                         <tbody>
                             <c:forEach items="${pendingIssues}" var="issue">
                                 <tr>
                                     <td>${issue.issueCode}</td>
                                     <td>${issue.title}</td>
                                     <td>${issue.customerId}</td>
                                     <td>
                                         <fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                     </td>
                                     <td>
                                         <span class="badge badge-submitted">Chờ duyệt</span>
                                     </td>
                                     <td>
                                         <a class="btn-link"
                                             href="manager-issues?action=review&id=${issue.id}">Xem chi
                                             tiết</a>
                                     </td>
                                 </tr>
                             </c:forEach>
                         </tbody>
                     </table>
                 </c:when>
                 <c:otherwise>
                     <p>Không có yêu cầu nào đang chờ duyệt.</p>
                 </c:otherwise>
             </c:choose>
         </div>

         <div class="section">
             <h2>Đã xử lý</h2>
             <c:choose>
                 <c:when test="${not empty approvedIssues}">
                     <table>
                         <thead>
                             <tr>
                                 <th>Mã</th>
                                 <th>Tiêu đề</th>
                                 <th>Trạng thái</th>
                                 <th>Cập nhật</th>
                             </tr>
                         </thead>
                         <tbody>
                             <c:forEach items="${approvedIssues}" var="issue">
                                 <c:set var="status" value="${issue.supportStatus}" />
                                 <tr>
                                     <td>${issue.issueCode}</td>
                                     <td>${issue.title}</td>
                                     <td>
                                         <span class="badge badge-${status}">
                                             <c:choose>
                                                 <c:when test="${status == 'manager_approved'}">Đã được chấp
                                                     thuận</c:when>
                                                 <c:when test="${status == 'task_created'}">Đã tạo task
                                                 </c:when>
                                                 <c:when test="${status == 'tech_in_progress'}">Đang thực thi
                                                 </c:when>
                                                 <c:when test="${status == 'resolved'}">Đã hoàn tất</c:when>
                                                 <c:otherwise></c:otherwise>
                                             </c:choose>
                                         </span>
                                     </td>
                                     <td>
                                         <fmt:formatDate value="${issue.createdAt}"
                                             pattern="dd/MM/yyyy HH:mm" />
                                     </td>
                                 </tr>
                             </c:forEach>
                         </tbody>
                     </table>
                 </c:when>
                 <c:otherwise>
                     <p>Chưa có yêu cầu nào được chấp thuận</p>
                 </c:otherwise>
             </c:choose>
         </div>

         <div class="section">
             <h2>Đã từ chối</h2>
             <c:choose>
                 <c:when test="${not empty rejectedIssues}">
                     <table>
                         <thead>
                             <tr>
                                 <th>Mã</th>
                                 <th>Tiêu đề</th>
                                 <th>Khách hàng</th>
                                 <th>Lí do</th>
                                 <th>Trạng thái</th>
                                 <th>Ngày gửi</th>
                             </tr>
                         </thead>
                         <tbody>
                             <c:forEach items="${rejectedIssues}" var="issue">
                                 <tr>
                                     <td>${issue.issueCode}</td>
                                     <td>${issue.title}</td>
                                     <td>${issue.customerId}</td>
                                     <td>${empty issue.feedback ? '-' : issue.feedback}</td>
                                     <td>
                                     	<span class="badge badge-manager_rejected">
	                                         <c:choose>
	                                             <c:when
	                                                 test="${issue.supportStatus == 'customer_cancelled'}">
	                                                 Khách hủy</c:when>
	                                             <c:otherwise>Quản lý từ chối</c:otherwise>
	                                         </c:choose>
                                         </span>
                                     </td>
                                     <td>
                                         <fmt:formatDate value="${issue.createdAt}"
                                             pattern="dd/MM/yyyy HH:mm" />
                                     </td>
                                 </tr>
                             </c:forEach>
                         </tbody>
                     </table>
                 </c:when>
                 <c:otherwise>
                     <p>Chưa có yêu cầu nào bị từ chối</p>
                 </c:otherwise>
             </c:choose>
         </div>
    </main>
</body>

</html>