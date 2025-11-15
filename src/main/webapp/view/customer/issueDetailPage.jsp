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
        body {
            background: #f5f6fa;
            margin: 0;
            padding: 40px 24px;
        }

        .container {
            max-width: 720px;
            margin: 0 auto;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
        }

        h1 {
            margin: 0 0 16px;
            color: #0f172a;
        }

        .meta {
            color: #475569;
            font-size: 14px;
            margin-bottom: 24px;
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
            padding: 12px 14px;
            border-radius: 10px;
            border: 1px solid #d4dbe6;
            box-sizing: border-box;
            font-size: 14px;
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
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-secondary {
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

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
            background: #fee2e2;
            color: #b91c1c;
        }
        
        .alert-warning {
            background: #fef3c7;
            color: #92400e;
        }
        
        #summary{
        	padding: 10px;
        }
        
        .field-error {
            color: #dc2626;
            font-size: 13px;
            margin-top: 4px;
        }
    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <div class="container">
        <div class="card">
            <h1>Bổ sung thông tin yêu cầu</h1>
            <div class="meta">
                Mã yêu cầu: <strong>${issue.issueCode}</strong><br>
                Tiêu đề: <strong>${issue.title}</strong>
            </div>
            
            <c:if test="${not empty issue.managerReason}">
                <div class="alert alert-warning">
                    Ghi chú từ quản lý: ${issue.managerReason}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert">${error}</div>
            </c:if>

            <form method="post" action="issue-fill">
                <input type="hidden" name="issueId" value="${issue.id}">

                <label for="customerName">Họ và tên *</label>
                <input type="text" id="customerName" name="customerName" value="${issueDetail.customerFullName}" required>
				<c:if test="${not empty errorContactEmail}">
                    <div class="field-error">${errorName}</div>
                </c:if>
				
                <label for="contactEmail">Email liên hệ</label>
                <input type="text" id="contactEmail" name="contactEmail" value="${issueDetail.contactEmail}">
				<c:if test="${not empty errorContactEmail}">
                    <div class="field-error">${errorContactEmail}</div>
                </c:if>
                
                <label for="contactPhone">Số điện thoại</label>
                <input type="text" id="contactPhone" name="contactPhone" value="${issueDetail.contactPhone}">
				<c:if test="${not empty errorContactPhone}">
                    <div class="field-error">${errorContactPhone}</div>
                </c:if>
                
                <label for="deviceSerial">Serial thiết bị (nếu có)</label>
                <input type="text" id="deviceSerial" name="deviceSerial" value="${issueDetail.deviceSerial}">

                <label for="summary">Ghi chú bổ sung</label>
                <textarea id="summary" name="summary">${issueDetail.summary}</textarea>

                <div class="actions">
                    <a class="btn btn-secondary" href="issue">Hủy</a>
                    <button type="submit" name="cancel" value="1" class="btn btn-danger" formnovalidate>Từ chối yêu cầu</button>
                    <button type="submit" class="btn btn-primary">Gửi nhân viên hỗ trợ</button>
                </div>
            </form>
        </div>
    </div>
    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>