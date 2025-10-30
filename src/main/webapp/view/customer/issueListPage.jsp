<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechShop</title>
<style>
    body.home-page {
      background: #f5f6fa;
    }

    .home-page main {
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

    .status-reason {
      margin-top: 6px;
      font-size: 12px;
      color: #b91c1c;
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

    th, td {
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

    .status-customer_cancelled {
      background: #fee2e2;
      color: #b91c1c;
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

    .link-button {
        border-radius: 5px;
    background: #ffd7d7;
    border: 1px solid red;
    color: #dc2626;
    cursor: pointer;
    font-weight: 600;
    padding: 4px;
    margin-left: 12px;
    transition: all 0.5s ease;
    }

    .action-view{
      display: inline-block;
      border-radius: 5px;
    background: #cdddfc;
    border: 1px solid #f7d3d3;
    color: #0f172a;
    cursor: pointer;
    font-weight: 600;
    padding: 4px;
    margin-left: 12px;
    transition: all 0.5s ease;
    }

    .link-button:hover,
    .action-view:hover {
        transform: scale(1.1);
    }

    .modal-overlay {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.5);
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background-color: #fff;
        margin: auto;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        width: 90%;
        max-width: 600px;
        position: relative;
    }

    .modal-close {
        color: #aaa;
        position: absolute;
        top: -5px;
        right: 5px;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        padding: 10px;
    }

    .modal-content h2 {
        margin-top: 0;
        color: #1f2d3d;
        border-bottom: 1px solid #eef2f6;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    .task-detail-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
    }
    .task-detail-item {
        font-size: 1.6rem;
    }
    .task-detail-item strong {
        display: block;
        color: #475569;
        margin-bottom: 4px;
    }
    .task-detail-item span {
        color: #1f2d3d;
    }
    .task-detail-full {
      grid-column: 1 / -1;
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
			<div class="alert alert-success">Đã gửi yêu cầu thành công! Bộ
				phận hỗ trợ sẽ liên hệ với bạn sớm nhất.</div>
		</c:if>
		<c:if test="${param.details == '1'}">
			<div class="alert alert-success">Đã gửi form thông tin cho nhân
				viên hỗ trợ.</div>
		</c:if>
		<c:if test="${param.invalid == '1'}">
			<div class="alert alert-warning">Yêu cầu bổ sung không hợp lệ
				hoặc đã được xử lý.</div>
		</c:if>

		<c:if test="${param.cancelled == '1'}">
			<div class="alert alert-success">Bạn đã hủy yêu cầu này. Nếu
				cần hỗ trợ, hãy tạo yêu cầu mới.</div>
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
                    <th>Thao tác</th>
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
                                    <c:when test="${status == 'customer_cancelled'}">Đã hủy theo yêu cầu khách</c:when>
                                    <c:when test="${status == 'manager_approved'}">Đã duyệt tạo task</c:when>
                                    <c:when test="${status == 'task_created'}">Đã tạo task</c:when>
                                    <c:when test="${status == 'tech_in_progress'}">Đang thực hiện</c:when>
                                    <c:when test="${status == 'resolved'}">Đã hoàn tất</c:when>
                                    <c:otherwise>Tiếp nhận mới</c:otherwise>
                                </c:choose>
                            </span>
                             <c:if test="${status == 'manager_rejected' && not empty s.feedback}">
                                <div class="status-reason">Lý do: ${s.feedback}</div>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${status == 'awaiting_customer'}">
                                <a class="action-link"
                                   href="issue-fill?id=${s.id}">Bổ sung form</a>
                            </c:if>
                            
                            <c:if test="${status != 'resolved' && status != 'customer_cancelled'}">
	                             <form method="post" action="issue-fill" style="display:inline;">
	                                 <input type="hidden" name="issueId" value="${s.id}">
	                                 <input type="hidden" name="cancel" value="1">
	                                 <button type="submit" class="link-button" formnovalidate>Hủy yêu cầu</button>
	                             </form>
 							</c:if>
 							
 							<c:if test="${status == 'submitted' || status == 'manager_approved' || status == 'task_created' || status == 'tech_in_progress' || status == 'resolved'}">
	                             <a class="action-view"
                                   href="issue-detail?id=${s.id}">Xem Task</a>
 							</c:if>
                             
                             <a class="action-view"
                                   href="issue-detail?id=${s.id}&action=1">Xem Issue</a>
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
	
	<c:if test="${not empty taskDetail or not empty issueDetail}">
	    <div id="taskDetailModal" class="modal-overlay">
	    <c:if test="${not empty taskDetail}">
	        <div class="modal-content">
	            <a class="modal-close" href="issue">&times;</a>
	            <h2>Chi tiết công việc cho yêu cầu: ${taskDetail.issueCode}</h2>
		        <c:choose>
		            <c:when test="${taskDetail.id > 0}">
				        <div class="task-detail-grid">
				            <div class="task-detail-item">
				                <strong>Tiêu đề công việc:</strong>
				                <span>${taskDetail.taskTitle}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Trạng thái:</strong>
				                <span>${taskDetail.status}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Nhân viên kỹ thuật:</strong>
				                <span>${taskDetail.technicalStaffName}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Ngày cập nhật cuối:</strong>
				                <span><fmt:formatDate value="${taskDetail.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
				            </div>
				            <div class="task-detail-item task-detail-full">
				                <strong>Mô tả công việc:</strong>
				                <span>${taskDetail.taskDescription}</span>
				            </div>
				            <div class="task-detail-item task-detail-full">
				                <strong>Ghi chú của kỹ thuật viên:</strong>
				                <span>${not empty taskDetail.note ? taskDetail.note : 'Chưa có ghi chú'}</span>
				            </div>
				        </div>
		            </c:when>
		            <c:otherwise>
		            	<p>Chưa có thông tin chi tiết về công việc cho yêu cầu này. Vui lòng chờ quản lý kỹ thuật tạo và giao việc.</p>
		            </c:otherwise>
		        </c:choose>
	        </div>
	        </c:if>
	        
	        <c:if test="${not empty issueDetail}">
	        <div class="modal-content">
	            <a class="modal-close" href="issue">&times;</a>
	            <h2>Chi tiết vấn đề yêu cầu</h2>
		        <c:choose>
		            <c:when test="${issueDetail.id > 0}">
				        <div class="task-detail-grid">
				        	<div class="task-detail-item">
				                <strong>Issue Code:</strong>
				                <span>${issueDetail.issueCode}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Tiêu đề:</strong>
				                <span>${issueDetail.title}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Mô tả:</strong>
				                <span>${issueDetail.description}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Trạng thái:</strong>
				                <span>${issueDetail.supportStatus}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Loại yêu cầu:</strong>
				                <span>${issueDetail.issueType}</span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Ngày tạo:</strong>
				                <span><fmt:formatDate value="${issueDetail.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
				            </div>
				        </div>
		            </c:when>
		            <c:otherwise>
		            	<p>Chưa có thông tin chi tiết về công việc cho yêu cầu này. Vui lòng chờ quản lý kỹ thuật tạo và giao việc.</p>
		            </c:otherwise>
		        </c:choose>
	        </div>
	    </div>
	    </c:if>
	    
	    <script>
	    	document.addEventListener("DOMContentLoaded", function() {
			    var modal = document.getElementById("taskDetailModal");
			    if (!modal) {
			        return;
			    }
				modal.style.display = "flex";
	
				window.addEventListener('click', function(event) {
				    if (event.target == modal) {
				        modal.style.display = "none";
				    }
				});
			});
		</script>
	</c:if>

	</main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>