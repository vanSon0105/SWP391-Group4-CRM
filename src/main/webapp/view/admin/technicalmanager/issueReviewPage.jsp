<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Duyet yeu cau ky thuat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        body {
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
        
        .alert-info {
            margin-top: 16px;
            padding: 12px 16px;
            border-radius: 10px;
            background: #e0f2fe;
            color: #0c4a6e;
            font-size: 1.4rem;
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
        
        .modal-overlay {
            display: none; /* Hidden by default */
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
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            width: 90%;
            max-width: 500px;
            position: relative;
        }

        .modal-close {
            color: #aaa;
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <main class="sidebar-main">
    <div class="layout">
        <div class="card">
            <h2>Thông tin yêu cầu</h2>
            <div class="meta">Mã yêu cầu: <strong>${issue.issueCode}</strong></div>
            <div class="meta">ID khách hàng: ${issue.customerId}</div>
            <div class="meta">Tiêu đề: <strong>${issue.title}</strong></div>
            <div class="meta">Mô tả</div>
            <div class="meta">Loại yêu cầu: <strong>
             	<c:choose>
                  <c:when test="${issue.issueType == 'repair'}">Sửa chữa</c:when>
                  <c:otherwise>Bảo hành</c:otherwise>
              </c:choose>
             </strong></div>
            <pre>${issue.description}</pre>
            
            <form id="rejectForm" method="post" action="manager-issues" style="margin:0;">
                <input type="hidden" name="issueId" value="${issue.id}">
                <input type="hidden" name="action" value="reject">
                <label for="rejectReason">Lý do từ chối *</label>
                <textarea id="rejectReason" name="rejectReason" required>${fn:escapeXml(rejectReasonDraft != null ? rejectReasonDraft : '')}</textarea>
                <c:if test="${not empty errorRejectReason}">
                    <div class="form-error">${errorRejectReason}</div>
                </c:if>
                <button type="submit" class="btn btn-danger">Từ chối</button>
            </form>
        </div>

        <div class="card">
            <h2>Thông tin bổ sung từ support staff</h2>
            <c:if test="${issueDetail == null}">
                <p>Chưa có form thông tin từ nhân viên hỗ trợ</p>
            </c:if>
            <c:if test="${issueDetail != null}">
                <label>Tên khách hàng</label>
                <input type="text" value="${issueDetail.customerFullName}" disabled>

                <label>Email liên hệ</label>
                <input type="text" value="${issueDetail.contactEmail}" disabled>

                <label>Số điện thoại</label>
                <input type="text" value="${issueDetail.contactPhone}" disabled>

                <label>Serial thiết bị</label>
                <input type="text" value="${issueDetail.deviceSerial}" disabled>

                <label>Tổng hợp/Ghi chú</label>
                <textarea disabled>${issueDetail.summary}</textarea>
            </c:if>
            
            <c:if test="${empty warrantyInfo && not empty warrantyNotice}">
		        <div class="alert-info">
		            ${warrantyNotice}
		        </div>
		    </c:if>
            

            <div class="actions">
                <a class="btn btn-outline" href="manager-issues">Quay lại</a>
                
                <a class="btn btn-outline" href="manager-issues?action=check_warranty&id=${issue.id}">Kiểm tra bảo hành</a>
                
                <form method="post" action="manager-issues" style="margin:0;">
                    <input type="hidden" name="issueId" value="${issue.id}">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn btn-primary">Chấp thuận task</button>
                </form>
            </div>
        </div>
    </div>
    
    <c:if test="${not empty warrantyInfo}">
        <div id="warrantyModal" class="modal-overlay">
            <div class="modal-content">
                <span class="modal-close">&times;</span>
                <h2>Thông tin bảo hành</h2>
                <div class="meta">ID Thẻ: <strong>${warrantyInfo.id}</strong></div>
                <div class="meta">Ngày bắt đầu: <strong><fmt:formatDate value="${warrantyInfo.start_at}" pattern="dd/MM/yyyy" /></strong></div>
                <div class="meta">Ngày kết thúc: <strong><fmt:formatDate value="${warrantyInfo.end_at}" pattern="dd/MM/yyyy" /></strong></div>
                
                <c:set var="isExpired" value="${warrantyInfo.end_at.time < currentDate.time}" />
                <div class="meta">Trạng thái: 
                    <c:if test="${isExpired}">
                        <strong style="color: #ef4444;">Đã hết hạn</strong>
                    </c:if>
                    <c:if test="${not isExpired}">
                        <strong style="color: #22c55e;">Còn hiệu lực</strong>
                    </c:if>
                </div>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var modal = document.getElementById("warrantyModal");
                if (!modal) return;

                var closeBtn = modal.querySelector(".modal-close");

                modal.style.display = "flex";

                if(closeBtn) {
                    closeBtn.addEventListener('click', function() {
                        modal.style.display = "none";
                    });
                }

                window.addEventListener('click', function(event) {
                    if (event.target == modal) {
                        modal.style.display = "none";
                    }
                });
            });
        </script>
    </c:if>
    </main>
</body>

</html>
