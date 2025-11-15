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
	    display: flex;
	    flex-direction: column;
	}
	
	.home-page main {
		min-width: 1100px;
	    flex: 1;
		margin: 40px auto;
		background: #fff;
		padding: 32px !important;
		border-radius: 12px;
		box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
	}
    
    .page-header {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		gap: 16px;
	}
	
	.page-header h1 {
		margin: 0;
		color: #0f172a;
	}
	
	.page-actions {
		display: flex;
		gap: 10px;
	}

    .alert {
      padding: 12px 16px;
      border-radius: 8px;
      margin-bottom: 16px;
      font-size: 2rem;
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
      font-size: 2rem;
    }

    th {
      background: #f8fafc;
      font-weight: 600;
      color: #475569;
      text-align: center;
      font-size: 1.7rem;
    }

    tr:last-child td {
      border-bottom: none;
    }

    .status-pill {
      display: inline-flex;
      align-items: center;
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 1.5rem;
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
    
    .status-cancelled {
      background: #fee2e2;
      color: #b91c1c;
    }

    .status-in_progress {
      background: #dbeafe;
      color: #1d4ed8;
    }
    
    .status-awaiting_admin {
    background: #fef9c3;
    color: #92400e;
    
	}
	.action-note {
	    display: block;
	    margin-top: 8px;
	    color: #92400e;
	    font-size: 0.95rem;
	}
    
    .status-create_payment {
        background: #fef3c7;
        color: #92400e;
    }
    
    .status-warranty {
      background: #dbeafe;
      color: #1d4ed8;
    }
    
    .status-repair {
      background: #fef3c7;
      color: #b45309;
    }
    
    .status-waiting_payment {
      background: #fef3c7;
      color: #b45309;
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
    
    .status-waiting_confirm {
      background: #fef3c7;
      color: #92400e;
    }
    
    .status-manager_review{
      background: #ecffa3;
      color: #3f3939;
    }

    .status-resolved {
      background: #dcfce7;
      color: #15803d;
    }
    
    .status-completed {
      background: #dcfce7;
      color: #15803d;
    }
  
    .empty-state {
        text-align: center;
        padding: 40px 0;
        color: #475569;
    }

    .action-link {
        padding: 4px;
	    display: inline-block;
	    border-radius: 5px;
	    background: #00ffad;
	    border: 1px solid #f7d3d3;
	    text-decoration: none;
	    color: #0f172a;
	    font-weight: 600;
    }

    .link-button {
        border-radius: 10px;
	    background: #ffd7d7;
	    border: 1px solid red;
	    color: #dc2626;
	    cursor: pointer;
	    font-weight: 600;
	    padding: 4px;
	    margin-left: 12px;
	    transition: all 0.5s ease;
	    font-size: 2rem;
    }

    .action-view{
	    background: transparent;
		border: 1px solid #94a3b8;
		color: #1f2937;
		padding: 4px 10px;
		border-radius: 10px;
		font-weight: 600;
		cursor: pointer;
		text-decoration: none;
		display: inline-flex;
		align-items: center;
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
        width: max-content;
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
        gap: 60px;
    }
    .task-detail-item {
    	display: flex;
        font-size: 2.5rem;
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
    
    .action .btn,
    .page-actions .btn{
		border-radius: 5px !important;
	}	
</style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main>
		<div class="page-header">
			<div>
				<h1>Yêu cầu hỗ trợ của tôi</h1>
			</div>
			<div class="page-actions">
				<a class="btn order-btn" href="create-issue">Gửi yêu cầu mới</a>
				<a class="btn order-btn" href="my-devices">Thiết bị đã mua</a>
			</div>
		</div>

		<c:if test="${param.created == '1'}">
			<div class="alert alert-success">Đã gửi yêu cầu thành công! Bộ
				phận hỗ trợ sẽ liên hệ với bạn sớm nhất</div>
		</c:if>
		<c:if test="${param.details == '1'}">
			<div class="alert alert-success">Đã gửi form thông tin cho nhân
				viên hỗ trợ</div>
		</c:if>
		<c:if test="${param.invalid == '1'}">
			<div class="alert alert-warning">Yêu cầu bổ sung không hợp lệ
				hoặc đã được xử lý</div>
		</c:if>

		<c:if test="${param.cancelled == '1'}">
			<div class="alert alert-success">Bạn đã hủy yêu cầu này. Nếu
				cần hỗ trợ, hãy tạo yêu cầu mới</div>
		</c:if>
		
		<c:if test="${param.feedback_saved == '1'}">
			<div class="alert alert-success">Phản hồi đã được gửi thành công</div>
		</c:if>
		
		<c:if test="${param.payment == '1'}">
			<div class="alert alert-success">Đã thanh toán thành công</div>
		</c:if>

		<c:if test="${param.payment_invalid == '1'}">
			<div class="alert">Lỗi thanh toán. Vui lòng thử lại</div>
		</c:if>

		<c:if test="${param.payment_required == '1'}">
			<div class="alert alert-warning">Bạn cần hoàn tất thanh toán trước khi gửi phản hồi</div>
		</c:if>

		<c:if test="${param.feedback_done == '1'}">
			<div class="alert alert-info">Phản hồi đã được gửi</div>
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
                    <c:set var="payment" value="${issuePayments[s.id]}" />
                    <tr>
                        <td>${s.issueCode}</td>
                        <td class="short-text">${s.title}</td>
                        <td>
                            <fmt:formatDate value="${s.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                        <td>
                            <span class="status-pill status-${status}">
                                <c:choose>
                                    <c:when test="${status == 'awaiting_customer'}">Chờ bổ sung</c:when>
                                    <c:when test="${status == 'submitted'}">Đã chuyển kỹ thuật</c:when>
                                    <c:when test="${status == 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${status == 'manager_rejected'}">Quản lí từ chối! Xem yêu cầu</c:when>
                                    <c:when test="${status == 'customer_cancelled'}">Đã hủy theo yêu cầu khách</c:when>
                                    <c:when test="${status == 'manager_review'}">Đang đợi quản lí duyệt</c:when>
                                    <c:when test="${status == 'manager_approved'}">Đã duyệt tạo task</c:when>
                                    <c:when test="${status == 'task_created'}">Đã tạo task</c:when>
                                    <c:when test="${status == 'tech_in_progress'}">Đang thực hiện</c:when>
                                    <c:when test="${status == 'create_payment'}">Nhân viên đang xử lí</c:when>
                                    <c:when test="${status == 'waiting_payment'}">Vui lòng thanh toán</c:when>
                                    <c:when test="${status == 'completed'}">Xử lí xong vấn đề</c:when>
                                    <c:when test="${status == 'waiting_confirm'}">Chờ admin xác nhận</c:when>
                                    <c:when test="${status == 'resolved'}">Đã hoàn tất</c:when>
                                    <c:when test="${status == 'cancelled'}">Bị từ chối</c:when>
                                    <c:otherwise>Tiếp nhận mới</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:if test="${status == 'awaiting_customer'}">
                                <a class="action-link"
                                   href="issue-fill?id=${s.id}">Bổ sung form</a>
                            </c:if>
                            
                            <c:if test="${status != 'resolved' && status != 'customer_cancelled' && status != 'tech_in_progress' && status != 'completed' && status != 'create_payment' && status != 'waiting_payment'}">
	                             <form method="post" action="issue-fill" style="display:inline;">
	                                 <input type="hidden" name="issueId" value="${s.id}">
	                                 <input type="hidden" name="cancel" value="1">
	                                 <button type="submit" class="link-button" formnovalidate>Hủy yêu cầu</button>
	                             </form>
 							</c:if>
 							
 							<c:if test="${status == 'submitted' || status == 'manager_approved' || status == 'task_created' || status == 'tech_in_progress' || status == 'resolved'}">
	                             <a class="action-view"
                                   href="issue-detail?id=${s.id}">Xem nhiệm vụ</a>
 							</c:if>
                             
                            <a class="action-view" href="issue-detail?id=${s.id}&action=1">Xem vấn đề</a>
                            
                            <c:if test="${status == 'waiting_payment' && payment != null && payment.status == 'awaiting_customer'}">
								<a class="link-button" href="issue-pay?issueId=${s.id}">Thanh toán</a>
							</c:if>
							
							<c:if test="${status == 'waiting_confirm' && payment != null && payment.status == 'awaiting_admin'}">
								<span class="action-note">Đang chờ admin xác nhận thanh toán</span>
							</c:if>

							<c:if test="${status == 'resolved' && payment != null && payment.status == 'paid'}">
								<a class="action-link" href="issue-feedback?id=${s.id}">
									<c:choose>
										<c:when test="${empty s.feedback}">Gửi phản hồi</c:when>
										<c:otherwise>Cập nhật phản hồi</c:otherwise>
									</c:choose>
								</a>
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
				                <span class="status-pill status-${status}">
				                	<c:choose>
										<c:when test="${taskDetail.status == 'in_progress'}">Đang xử lí</c:when>
										<c:when test="${taskDetail.status == 'completed'}">Đã hoàn thành</c:when>
										<c:when test="${taskDetail.status == 'pending'}">Đang chờ</c:when>
										<c:otherwise>
											Đã hủy
										</c:otherwise>
									   </c:choose>
				                </span>
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
				                <span class="status-pill status-${issueDetail.supportStatus}">
                                <c:choose>
                                    <c:when test="${issueDetail.supportStatus == 'awaiting_customer'}">Chờ bổ sung</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'submitted'}">Đã chuyển kỹ thuật</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'manager_rejected'}">Quản lí từ chối! Xem yêu cầu</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'customer_cancelled'}">Đã hủy theo yêu cầu khách</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'manager_review'}">Đang đợi quản lí duyệt</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'manager_approved'}">Đã duyệt tạo task</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'task_created'}">Đã tạo task</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'tech_in_progress'}">Đang thực hiện</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'create_payment'}">Nhân viên đang xử lí</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'completed'}">Xử lí xong vấn đề</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'resolved'}">Đã hoàn tất</c:when>
                                    <c:when test="${issueDetail.supportStatus == 'cancelled'}">Bị từ chối</c:when>
                                    <c:otherwise>Tiếp nhận mới</c:otherwise>
                                </c:choose>
                            </span>
				            </div>
				            <div class="task-detail-item">
				                <strong>Loại yêu cầu:</strong>
				                <span class="status-pill status-${issueDetail.issueType}">
                                <c:if test="${issueDetail.issueType == 'repair'}">Sửa chữa</c:if>
                                <c:if test="${issueDetail.issueType == 'warranty'}">Bảo hành</c:if>
				                </span>
				            </div>
				            
				            <div class="task-detail-item">
				                <strong>Lí do từ chối: </strong>
				                <span>${issueDetail.managerReason}</span>
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