<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
        
    <style>
         body {
             font-family: 'Segoe UI', sans-serif;
             background: #f4f6fb;
             margin: 0;
             padding: 40px;
         }

         .layout {
             max-width: 960px;
             margin: 0 auto;
             display: grid;
             grid-template-columns: 1fr 1fr;
             gap: 24px;
         }

         .card-div {
             background: #fff;
             border-radius: 12px;
             padding: 24px;
             box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
         }

         .card-div h2 {
             margin-top: 0;
             color: #0f172a;
         }

         .meta {
             font-size: 1.4rem;
             color: #475569;
             margin-bottom: 16px;
         }

         label {
             display: block;
             font-weight: 600;
             margin-top: 16px;
             color: #0f172a;
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
             min-height: 140px;
             resize: vertical;
         }

         .actions {
             margin-top: 24px;
             display: flex;
             justify-content: flex-end;
             gap: 12px;
         }

         .btn {
             padding: 10px 18px;
             border-radius: 6px;
             border: none;
             cursor: pointer;
             font-weight: 600;
         }

         .btn-secondary {
             background: #e2e8f0;
             color: #0f172a;
         }

         .btn-primary {
             background: #2563eb;
             color: #fff;
         }

         .forward {
             margin-top: 20px;
             display: flex;
             align-items: center;
             gap: 10px;
         }

         .forward input {
             width: auto;
         }

         .alert {
             padding: 12px 16px;
             border-radius: 8px;
             margin-bottom: 16px;
             font-size: 1.4rem;
             background: #fee2e2;
             color: #b91c1c;
         }
         
         .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .alert-info {
            background: #e0f2fe;
            color: #0c4a6e;
        }

        pre {
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>

	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
<body class="management-page dashboard">
    <main class="sidebar-main">
         <div class="layout">
                <div class="card-div">
                    <h2>Thông tin yêu cầu</h2>
                    <div class="meta">Mã yêu cầu: <strong>${issue.issueCode}</strong></div>
                    <div class="meta">Khách hàng ID: ${issue.customerId}</div>
                    <div class="meta">Tiêu đề: <strong>${issue.title}</strong></div>
                    <div class="meta">Mô tả</div>
                    <pre>${issue.description}</pre>
                </div>

                <div class="card-div">
                    <h2>Thông tin khách hàng</h2>

                    <c:if test="${not empty error}">
                        <div class="alert">${error}</div>
                    </c:if>
                    
                    <c:if test="${param.requested == '1'}">
		                <div class="alert alert-info">Đã gửi yêu cầu. Vui lòng chờ khách hàng bổ sung thông tin.</div>
		            </c:if>
		            
		            <c:if test="${awaitingCustomer}">
		                <div class="alert alert-info">Đang chờ khách hàng phản hồi. Bạn có thể gửi lại form nếu cân nhắc.</div>
		            </c:if>

                    <form method="post" action="support-issues">
                        <input type="hidden" name="action" value="request_details">
                        <input type="hidden" name="issueId" value="${issue.id}">
                        <button type="submit" class="btn btn-secondary">
		                    <c:choose>
		                        <c:when test="${awaitingCustomer}">Gửi lại yêu cầu</c:when>
		                        <c:otherwise>Gửi yêu cầu cho khách hàng</c:otherwise>
		                    </c:choose>
		                </button>
		            </form>

                    <c:if test="${not awaitingCustomer or not empty issueDetail}">
					    <form method="post" action="support-issues">
					        <input type="hidden" name="action" value="save">
					        <input type="hidden" name="issueId" value="${issue.id}">
					
					        <label for="customerName">Tên khách hàng *</label>
					        <input type="text" id="customerName" name="customerName"
					               value="${issueDetail.customerFullName}" required>
					
					        <label for="contactEmail">Email liên hệ</label>
					        <input type="text" id="contactEmail" name="contactEmail"
					               value="${issueDetail.contactEmail}">
					
					        <label for="contactPhone">Số điện thoại</label>
					        <input type="text" id="contactPhone" name="contactPhone"
					               value="${issueDetail.contactPhone}">
					
					        <label for="deviceSerial">Serial thiết bị</label>
					        <input type="text" id="deviceSerial" name="deviceSerial"
					               value="${issueDetail.deviceSerial}">
					
					        <label for="summary">Ghi chú tổng hợp</label>
					        <textarea id="summary" name="summary">${issueDetail.summary}</textarea>
					
					        <div class="forward">
					            <input type="checkbox" id="forwardToManager" name="forwardToManager"
					                   <c:if test="${issueDetail.forwardToManager}">checked</c:if>>
					            <label for="forwardToManager" style="margin-top:0;">Gửi cho quản lý kỹ thuật</label>
					        </div>
					
					        <div class="actions">
					            <a class="btn btn-secondary" href="support-issues">Quay lại</a>
					            <button type="submit" class="btn btn-primary">Lưu thông tin</button>
					        </div>
					    </form>
					</c:if>
					
					<c:if test="${awaitingCustomer and empty form}">
					    <div class="actions">
					        <a class="btn btn-secondary" href="support-issues">Quay lại</a>
					    </div>
					</c:if>
              </div>
         </div>
    </main>
</body>
</html>