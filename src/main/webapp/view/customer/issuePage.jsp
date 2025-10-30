<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechShop</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
        }

        .issue-container {
        	flex: 1;
            width: 720px;
            margin: 40px auto;
            background: #fff;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
        }

        h1 {
            margin-top: 0;
            color: #1f2d3d;
        }

        label {
            display: block;
            margin: 16px 0 6px;
            font-weight: 600;
            color: #1f2d3d;
        }

        input[type="text"],
        textarea,
        select {
        	margin-top: 5px;
            width: 100%;
            padding: 12px !important;
            border-radius: 8px;
            border: 1px solid #cfd5e3;
            box-sizing: border-box;
            background: #fff;
            outline: none;
        }

        textarea {
        	padding: 10px 0 0 10px !important;
            min-height: 140px;
            resize: vertical;
        }

        select:disabled {
            background: #f1f5f9;
            color: #94a3b8;
        }

        .actions {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .radio-group {
            display: flex;
            align-items: center;
            gap: 16px;
            margin: 18px 0;
            flex-wrap: wrap;
        }

        .radio-group span {
            font-weight: 600;
            color: #1f2d3d;
            margin-right: 8px;
        }

        .radio-group label {
            margin: 0;
            font-weight: 500;
            color: #1f2d3d;
        }

        .radio-group input {
            margin-right: 6px;
        }

        #warrantySection.disabled {
            opacity: 0.6;
        }

        #warrantySection.disabled select {
            pointer-events: none;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-secondary {
            background: #eceff4;
            color: #1f2d3d;
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
        }

        .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .hint {
            font-size: 13px;
            color: #64748b;
            margin-top: 6px;
        }
    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
    <div class="issue-container">
		<c:if test="${not empty list}">
        <h1>Gửi yêu cầu hỗ trợ</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <c:set var="selectedWarrantyId"
               value="${not empty selectedWarrantyCardId ? selectedWarrantyCardId : param.warrantyCardId}" />

		<c:set var="selectedIssueType"
		               value="${not empty param.issueType ? param.issueType : (empty selectedWarrantyId ? 'repair' : 'warranty')}" />
        <form method="post" action="create-issue" style="margin-top: 10px;">
        	<label for="name">Họ tên</label>
            <input type="text" id="name" name="name" value="${account.username}" required>
            
            <label for="email">Email</label>
            <input type="text" id="email" name="email" value="${account.email}" required>
            
            <label for="title">Tiêu đề sự cố</label>
            <input type="text" id="title" name="title" value="${param.title}" required>

            <label for="description">Mô tả chi tiết</label>
            <textarea id="description" name="description" required>${param.description}</textarea>
            
            <div class="radio-group">
                <span>Loại yêu cầu</span>
                <label>
                    <input type="radio" name="issueType" value="repair"
                        <c:if test="${selectedIssueType eq 'warranty'}">checked</c:if>>
                    Sửa chữa
                </label>
                <label>
                    <input type="radio" name="issueType" value="warranty"
                        <c:if test="${selectedIssueType ne 'warranty'}">checked</c:if>>
                    Bảo hành
                </label>
            </div>

			<div id="warrantySection">
	            <label for="serialNo">Thiết bị đã mua</label>
                    <select id="warrantyCardId" name="warrantyCardId" required>
                        <option value="">-- Chọn thiết bị --</option>
                        <c:forEach var="device" items="${list}">
                            <option value="${device.warrantyCardId}"
                                <c:if test="${selectedWarrantyId == device.warrantyCardId}">selected</c:if>>
                                ${device.deviceName} (${device.serialNumber})
                            </option>
                        </c:forEach>
                    </select>
            </div>

            <div class="actions">
                <a class="btn btn-secondary" href="issue">Hủy </a>
                <button type="submit" class="btn btn-primary">Gửi</button>
            </div>
        </form>
        </c:if>
        <c:if test="${empty list}">
        	<div style="text-align: center;">Tài khoản của bạn hiện không có thiết bị bảo hành/sửa chữa. Vui lòng mua hàng!</div>
        </c:if>
    </div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>