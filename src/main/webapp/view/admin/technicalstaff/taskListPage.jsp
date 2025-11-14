<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<style>
    body {
        margin: 0;
        background: #f8fafc;
    }

    .page-container {
        padding: 32px;
    }

    h1 {
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
    
    .btn-link {
         display: inline-flex;
         padding: 8px 14px;
         border-radius: 6px;
         background: #2563eb;
         color: #fff;
         text-decoration: none;
         font-weight: 600;
     }

    th,
    td {
        padding: 12px 16px;
        border-bottom: 1px solid #e2e8f0;
        font-size: 14px;
        text-align: center;
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
    
    .hidden {
        display: none;
    }

    .summary-modal-overlay {
        position: fixed;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(15, 23, 42, 0.45);
        z-index: 999;
    }
    
    .summary-modal-overlay.hidden {
        display: none;
    }

    .summary-modal {
        width: min(480px, 90%);
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 24px 48px rgba(15, 23, 42, 0.18);
        padding: 24px;
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .summary-modal h2 {
        margin: 0;
        font-size: 18px;
        color: #0f172a;
    }

    .summary-modal textarea {
        resize: vertical;
        min-height: 120px;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #cbd5f5;
        font-family: inherit;
        font-size: 14px;
        color: #0f172a;
    }

    .summary-modal textarea:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
    }

    .summary-modal-actions {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
    }

    .btn-secondary {
        background: #e2e8f0;
        color: #0f172a;
    }
    
    .sidebar-toggle{
    	color: black;
    }
    
    .availability-card {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #fff;
        border-radius: 12px;
        padding: 16px 20px;
        box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
        margin-bottom: 20px;
    }

    .availability-info {
        display: flex;
        align-items: center;
        gap: 12px;
        color: #0f172a;
        font-size: 15px;
        font-weight: 600;
    }

    .availability-pill {
        display: inline-flex;
        align-items: center;
        padding: 6px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .availability-pill.available {
        background: #bbf7d0;
        color: #047857;
    }

    .availability-pill.busy {
        background: #fee2e2;
        color: #b91c1c;
    }

    .availability-form button {
        background: linear-gradient(90deg, #2563eb, #1d4ed8);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .availability-form button.busy-action {
        background: linear-gradient(90deg, #f97316, #fb7185);
    }
    
    #cancel-reason-container {
    display: none;
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
        
        <c:if test="${param.billLocked == '1'}">
            <div class="alert alert-warning">Khách hàng đã thanh toán. Không thể tạo/sửa bill</div>
        </c:if>
        
        <c:if test="${not empty techAlertMessage}">
            <div class="alert ${techAlertType eq 'error' ? 'alert-error' : 'alert-success'}">
                ${techAlertMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty availabilityMessage}">
            <div class="alert ${availabilityMessageType eq 'error' ? 'alert-error' : 'alert-success'}">
                ${availabilityMessage}
            </div>
        </c:if>
        
        <c:if test="${param.forbidden == '1'}">
		    <div class="alert alert-warning">Bạn không có quyền thao tác bill cho yêu cầu này</div>
		</c:if>
        
        <div class="availability-card">
            <div class="availability-info">
                <span>Trạng thái hiện tại:</span>
                <span class="availability-pill ${staffAvailable ? 'available' : 'busy'}">
                    ${staffAvailable ? 'Rảnh' : 'Đang bận'}
                </span>
            </div>
            <form class="availability-form" method="post" action="technical-issues">
                <input type="hidden" name="action" value="toggleAvailability" />
                <input type="hidden" name="available" value="${staffAvailable ? 'false' : 'true'}" />
                <button type="submit" class="${staffAvailable ? 'busy-action' : ''}">
                    ${staffAvailable ? 'Bận' : 'Rảnh'}
                </button>
            </form>
        </div>

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
                                    <div>Mã: ${assignment.issueCode}</div>
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
                                    <form method="post" action="technical-issues" style="display:flex; gap:8px; align-items:center; justify-content: center;" class="assignment-form" data-existing-summary="${assignment.note != null ? fn:escapeXml(assignment.note) : ''}">
                                        <input type="hidden" name="assignmentId" value="${assignment.id}">
                                        
                                        <c:if test="${assignment.support_status != 'create_payment' and assignment.support_status != 'waiting_payment' and assignment.support_status != 'resolved'}">
	                                        <input type="hidden" name="summary" value="">
	                                        <select name="status">
	                                            <option value="pending" ${assignment.status == 'pending' ? 'selected' : ''}>Chưa bắt đầu</option>
	                                            <option value="in_progress" ${assignment.status == 'in_progress' ? 'selected' : ''}>Đang thực hiện</option>
	                                            <option value="completed" ${assignment.status == 'completed' ? 'selected' : ''}>Đã hoàn tất</option>
	                                            <option value="cancelled" ${assignment.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
	                                        </select>
	                                        <button type="submit">Lưu</button>
                                        </c:if>
                                        
                                        <a class="btn-link" href="technical-issues?id=${assignment.id}">Xem</a>                                    
	                                    <c:if test="${assignment.status == 'cancelled'}">
		                                    <button type="button" class="btn-show-reason" data-reason="${fn:escapeXml(assignment.note)}">Hiển thị lý do</button>
		                                </c:if>
		                                
	                                    <c:if test="${assignment.customerIssueId != null and (assignment.support_status == 'completed' or assignment.support_status == 'create_payment')}">
                                            <a class="btn-link" style="background:#0f766e;" href="technical-billing?issueId=${assignment.customerIssueId}">Tạo bill</a>
	                                    </c:if>
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
    
    <div id="summary-modal" class="summary-modal-overlay hidden">
        <div class="summary-modal">
            <h2>Nhập tóm tắt công việc</h2>
            <p id="summary-modal-message" style="margin:0; color:#475569; font-size:14px;"></p>
            <textarea id="summary-modal-textarea" placeholder="Ghi lại những hạng mục đã xử lý hoặc lý do hủy..."></textarea>
            <%-- <div id="cancel-reason-container">
            	<input type="checkbox" id="invalid-warranty" name="cancelReason" value="invalid_warranty">
    			<label for="invalid-warranty">Tem bảo hành không hợp lệ</label>	
            </div>--%>
            <div class="summary-modal-actions">
                <button type="button" class="btn-secondary" id="summary-modal-cancel">Hủy</button>
                <button type="button" id="summary-modal-confirm">Xác nhận</button>
            </div>
        </div>
    </div>
    
    <div id="reason-modal" class="summary-modal-overlay hidden">
	    <div class="summary-modal">
	        <h2>Lý do hủy</h2>
	        <p id="reason-modal-message" style="margin:0; color:#475569; font-size:14px;"></p>
	        <div class="summary-modal-actions">
	            <button type="button" class="btn-secondary" id="reason-modal-close">Đóng</button>
	        </div>
	    </div>
	</div>
    
    <script>
        (function () {
            var forms = document.querySelectorAll('.assignment-form');
            var modalOverlay = document.getElementById('summary-modal');
            var modalMessage = document.getElementById('summary-modal-message');
            var modalTextarea = document.getElementById('summary-modal-textarea');
            var confirmButton = document.getElementById('summary-modal-confirm');
            var cancelButton = document.getElementById('summary-modal-cancel');
            var activeForm = null;
            var reasonModalOverlay = document.getElementById('reason-modal');
            var reasonMessage = document.getElementById('reason-modal-message');
            var closeReasonModal = document.getElementById('reason-modal-close');

            forms.forEach(function (form) {
                var statusSelect = form.querySelector('select[name="status"]');
                var summaryInput = form.querySelector('input[name="summary"]');
                if (!statusSelect || !summaryInput) {
                    return;
                }

                form.addEventListener('submit', function (event) {
                    var status = statusSelect.value;
                    if (status === 'completed' || status === 'cancelled') {
                        event.preventDefault();
                        activeForm = form;
                        var existingSummary = summaryInput.value || form.getAttribute('data-existing-summary') || '';
                        modalTextarea.value = existingSummary;
                        modalMessage.textContent = status === 'completed'
                            ? 'Nhập tóm tắt những hạng mục đã sửa trước khi hoàn tất.'
                            : 'Nhập tóm tắt những hạng mục hoặc lý do trước khi hủy.';
                        modalOverlay.classList.remove('hidden');
                        var cancelReasonContainer = document.getElementById('cancel-reason-container');
                        if (status === 'cancelled') {
                            cancelReasonContainer.style.display = 'block';
                        } else {
                            cancelReasonContainer.style.display = 'none';
                        }
                        setTimeout(function () {
                            modalTextarea.focus();
                            modalTextarea.select();
                        }, 0);
                    } else {
                        summaryInput.value = '';
                    }
                });
            });

            confirmButton.addEventListener('click', function () {
                if (!activeForm) {
                    return;
                }
                var summaryText = modalTextarea.value.trim();
                if (!summaryText) {
                    modalTextarea.focus();
                    return;
                }
                var summaryInput = activeForm.querySelector('input[name="summary"]');
                summaryInput.value = summaryText;
                
                var cancelReasonCheckbox = document.getElementById('invalid-warranty');
                var hiddenCancelReason = activeForm.querySelector('input[name="cancelReasonHidden"]');
                if (!hiddenCancelReason) {
                    hiddenCancelReason = document.createElement('input');
                    hiddenCancelReason.type = 'hidden';
                    hiddenCancelReason.name = 'cancelReason';
                    activeForm.appendChild(hiddenCancelReason);
                }
                hiddenCancelReason.value = cancelReasonCheckbox.checked ? cancelReasonCheckbox.value : '';
                modalOverlay.classList.add('hidden');
                activeForm.submit();
                activeForm = null;
            });

            cancelButton.addEventListener('click', function () {
                modalOverlay.classList.add('hidden');
                activeForm = null;
            });
            
            closeReasonModal.addEventListener('click', function () {
                reasonModalOverlay.classList.add('hidden');
            });

            modalOverlay.addEventListener('click', function (event) {
                if (event.target === modalOverlay) {
                    modalOverlay.classList.add('hidden');
                    activeForm = null;
                }
            });
            
            var showReasonButtons = document.querySelectorAll('.btn-show-reason');
            showReasonButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    var reason = button.getAttribute('data-reason');
                    reasonMessage.textContent = reason || 'Không có lý do hủy.';
                    reasonModalOverlay.classList.remove('hidden');
                });
            });

            reasonModalOverlay.addEventListener('click', function (event) {
                if (event.target === reasonModalOverlay) {
                    reasonModalOverlay.classList.add('hidden');
                }
            });
        })();
    </script>
</body>

</html>
