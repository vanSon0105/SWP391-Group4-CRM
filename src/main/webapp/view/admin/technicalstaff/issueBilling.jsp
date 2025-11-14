<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Tao bill thanh toan</title>
	<style>
		body {
			font-family: 'Segoe UI', sans-serif;
			margin: 0;
			background: #f8fafc;
		}

		.wrapper {
			max-width: 720px;
			margin: 48px auto;
			background: #fff;
			border-radius: 16px;
			padding: 32px 36px;
			box-shadow: 0 24px 48px rgba(15, 23, 42, 0.12);
		}

		h1 {
			margin: 0 0 16px;
			color: #0f172a;
			font-size: 28px;
		}

		.meta {
			background: #eff6ff;
			border-radius: 12px;
			padding: 16px;
			margin-bottom: 24px;
			color: #1e3a8a;
			font-size: 14px;
		}

		label {
			display: block;
			font-weight: 600;
			margin-bottom: 8px;
			color: #0f172a;
		}

		input[type="number"],
		textarea {
			width: 100%;
			padding: 12px 14px;
			border: 1px solid #d4dbe6;
			border-radius: 10px;
			box-sizing: border-box;
			font-size: 14px;
		}

		textarea {
			min-height: 140px;
			resize: vertical;
		}

		.actions {
			margin-top: 28px;
			display: flex;
			justify-content: flex-end;
			gap: 12px;
		}

		.btn {
			padding: 10px 22px;
			border-radius: 8px;
			border: none;
			cursor: pointer;
			font-weight: 600;
		}

		.btn-secondary {
			background: #e2e8f0;
			color: #0f172a;
			text-decoration: none;
			display: inline-flex;
			align-items: center;
			justify-content: center;
		}

		.btn-primary {
			background: #2563eb;
			color: #fff;
		}

		.alert {
			padding: 12px 16px;
			border-radius: 8px;
			margin-bottom: 18px;
			font-size: 14px;
			background: #fee2e2;
			color: #b91c1c;
		}
		
		.note {
			margin-bottom: 10px;
			font-size: 12px;
			color: #64748b;
		}
	</style>
</head>
<body>
	<div class="wrapper">
		<h1>Tạo bill thanh toán</h1>
		<div class="meta">
			<div><strong>Mã yêu cầu:</strong> ${issue.issueCode}</div>
			<div><strong>Tiêu đề:</strong> ${issue.title}</div>
			<c:if test="${not empty payment}">
				<div><strong>Trạng thái bill hiện tại:</strong> ${payment.status}</div>
			</c:if>
		</div>

		<c:if test="${not empty error}">
			<div class="alert">${error}</div>
		</c:if>

		<form method="post" action="technical-billing">
			<input type="hidden" name="issueId" value="${issue.id}">

			<label for="amount">Số tiền</label>
			<input type="number" id="amount" name="amount" min="0" step="50000"
				value="<c:out value='${not empty payment ? payment.amount : (warrantyIssue ? 0 : "")}'/>"
				<c:if test="${warrantyIssue}">readonly</c:if> required>
			<div class="note">
				<c:if test="${warrantyIssue}">
					Yêu cầu bảo hành: số tiền mặc định 0 VNĐ
				</c:if>
			</div>

			<label for="note">Ghi chú</label>
			<textarea id="note" name="note" maxlength="500"><c:out value='${not empty payment ? payment.note : ""}'/></textarea>

			<div class="actions">
				<a class="btn btn-secondary" href="technical-issues">Hủy</a>
				<button type="submit" class="btn btn-primary">Lưu</button>
			</div>
		</form>
	</div>
</body>
</html>
