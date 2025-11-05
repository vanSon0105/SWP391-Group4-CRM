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
            font-family: 'Segoe UI', sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 40px 24px;
        }

        .container {
            width: 750px;
            margin: 0 auto;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
        }

        h1 {
            margin: 0 0 12px;
            color: #0f172a;
        }

        .meta {
            color: #475569;
            font-size: 2rem;
            margin: 24px 0;
        }

        label {
        	font-size: 2rem;
            display: block;
            font-weight: 600;
            margin-bottom: 8px !important;
            color: #0f172a;
        }

        textarea {
            width: 100%;
            min-height: 180px;
            padding: 12px 14px !important;
            border-radius: 10px;
            border: 1px solid #d4dbe6;
            box-sizing: border-box;
            font-size: 14px;
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
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #0f172a;
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
            margin-top: 8px;
            font-size: 13px;
            color: #64748b;
        }
    </style>
</head>
<body class="home-page">
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main>
        <div class="container">
            <div class="card">
                <h1>Gửi phản hồi</h1>
                <div class="meta">
                    Mã yêu cầu: <strong>${issue.issueCode}</strong><br>
                    Tiêu đề: <strong>${issue.title}</strong>
                </div>

                <c:if test="${not empty feedbackError}">
                    <div class="alert alert-error">${feedbackError}</div>
                </c:if>

                <form method="post" action="issue-feedback">
                    <input type="hidden" name="issueId" value="${issue.id}">

                    <label for="feedback">Nội dung phản hồi</label>
                    <textarea id="feedback" name="feedback" maxlength="1000" required>${feedbackDraft}</textarea>
                    <div class="hint">Tối đa 1000 ký tự</div>

                    <div class="actions">
                        <a class="btn btn-secondary" href="issue">Quay lại</a>
                        <button type="submit" class="btn btn-primary">Lưu phản hồi</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
