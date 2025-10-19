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
        }

        .issue-container {
            max-width: 720px;
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
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #cfd5e3;
            box-sizing: border-box;
            background: #fff;
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
        <h1>Gửi yêu cầu hỗ trợ</h1>
        <p>Vui lòng mô tả chi tiết vấn đề bạn gặp phải. Đội hỗ trợ sẽ liên hệ để xác nhận thông tin.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <c:set var="selectedWarrantyId"
               value="${not empty selectedWarrantyCardId ? selectedWarrantyCardId : param.warrantyCardId}" />

        <form method="post" action="create-issue">
            <label for="title">Tiêu đề sự cố *</label>
            <input type="text" id="title" name="title" value="${param.title}" required>

            <label for="description">Mô tả chi tiết *</label>
            <textarea id="description" name="description" required>${param.description}</textarea>

            <label for="warrantyCardId">Thiết bị đã mua</label>
            <c:choose>
                <c:when test="${not empty list}">
                    <select id="warrantyCardId" name="warrantyCardId">
                        <option value="">-- Chọn thiết bị --</option>
                        <c:forEach var="device" items="${list}">
                            <option value="${device.warrantyCardId}"
                                <c:if test="${selectedWarrantyId == device.warrantyCardId}">selected</c:if>>
                                ${device.deviceName} (${device.serialNumber})
                            </option>
                        </c:forEach>
                    </select>
                    <div class="hint">Nếu sản phẩm không xuất hiện, hãy liên hệ bộ phận chăm sóc khách hàng.</div>
                </c:when>
                <c:otherwise>
                    <select id="warrantyCardId" name="warrantyCardId" disabled>
                        <option>Chưa có thiết bị được kích hoạt bảo hành</option>
                    </select>
                </c:otherwise>
            </c:choose>

            <div class="actions">
                <a class="btn btn-secondary" href="customer-issues">Hủy </a>
                <button type="submit" class="btn btn-primary">Gửi</button>
            </div>
        </form>
    </div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>