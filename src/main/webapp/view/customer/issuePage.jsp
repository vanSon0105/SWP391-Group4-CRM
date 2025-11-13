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
        body.home-page {
		    display: flex;
		    flex-direction: column;
		}
		
		.home-page main {
			min-width: 1100px;
			max-width: 1200px;
		    flex: 1;
			margin: 40px auto;
			background: #fff;
			padding: 32px !important;
			border-radius: 12px;
			box-shadow: 0 8px 24px rgba(31, 45, 61, 0.1);
		}

        .issue-container {
        	width: 100%;
		    margin: 40px auto;
		    padding: 32px;
        }
        
        .alert-actions{
        	display: flex;
		    width: 100%;
		    margin: 40px auto;
		    padding: 32px;
		    flex-direction: column;
		    justify-content: center;
		    align-items: center;
        }

        h1 {
            margin-top: 0;
            color: #1f2d3d;
        }

        label {
            display: block;
            margin: 16px 0 6px !important;
            font-weight: 600;
            color: #1f2d3d;
            font-size: 1.8rem;
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
            font-size: 2rem;
            transition: all 0.2s ease;
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

        select {
		  background-color: #fff;
		  font-size: 1.8rem;
		  cursor: pointer;
		  transition: all 0.2s ease;
		}

		select:hover,
		input:hover,
		textarea:hover {
		  border-color: #2563eb;
		  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
		}

		select:focus,
		input:focus,
		textarea:focus {
		  border-color: #2563eb;
		  box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
		  outline: none;
		}
		
		option {
		  font-size: 1.7rem;
		  padding: 10px;
		  color: #1f2d3d;
		  background: #fff;
		}
		
		option:disabled {
		  color: #9ca3af;
		  background: #f9fafb;
		}
		
		#warrantySection.disabled {
		  opacity: 0.5;
		  filter: grayscale(0.6);
		}


        #warrantySection.disabled select {
            pointer-events: none;
        }

        .actions .btn {
            padding: 12px 24px;
            border-radius: 8px !important;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 1.5rem;
        }

        .btn-secondary {
            background: #eceff4;
            color: #1f2d3d;
            transition: transform 0.5s ease;
        }
        
        .btn-secondary:hover{
        	transform: scale(1.1);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-top: 16px;
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
        
        option:disabled {
            color: #94a3b8;
        }
        
        input[readonly] {
	        background-color: #eeeeee !important;
	        cursor: not-allowed;
	    }
    </style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main>
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
        <form method="post" action="create-issue" style="margin-top: 10px; width: 100%;">
        	<label for="name">Tên tài khoản</label>
        	<c:if test="${not empty account.username}">
            	<input type="text" id="name" name="name" value="${account.username}" readonly>        	
        	</c:if>
        	<label for="name">Họ tên</label>
        	<c:if test="${not empty account.username}">
            	<input type="text" id="name" name="name" value="${account.fullName}" readonly>        	
        	</c:if>
        	<c:if test="${empty account.username}">
            	<input type="text" id="name" name="name" value="" required>        	
        	</c:if>
            
            <label for="email">Email</label>
            <c:if test="${not empty account.email}">     	
	            <input type="text" id="email" name="email" value="${account.email}" readonly>
        	</c:if>
        	
        	<c:if test="${empty account.email}">     	
	            <input type="text" id="email" name="email" value="" required>
        	</c:if>
            
            <label for="title">Tiêu đề sự cố</label>
            <input type="text" id="title" name="title" value="${param.title}" required>

            <label for="description">Mô tả chi tiết</label>
            <textarea id="description" name="description" required>${param.description}</textarea>
            
            <div>
                <label for="issueType">Loại yêu cầu</label>
                <select id="issueType" name="issueType" required>
                        <option value="warranty">-- Chọn yêu cầu --</option>
                        <option value="warranty"
                            <c:if test="${selectedIssueType ne 'warranty'}">checked</c:if>>
                			Bảo hành
                        </option>
                        
                        <option value="repair"
                            <c:if test="${selectedIssueType eq 'warranty'}">checked</c:if>>
                			Sửa chữa
                        </option>
                        
                        <option value="repair"
                            <c:if test="${selectedIssueType eq 'warranty'}">checked</c:if>>
                			Sửa chữa
                        </option>
                    </select>
            </div>

			<div id="warrantySection">
	            <label for="warrantyCardId">Thiết bị đã mua</label>
                    <select id="warrantyCardId" name="warrantyCardId">
                        <option value="">-- Chọn thiết bị --</option>
                        <c:forEach var="device" items="${list}">
                            <option value="${device.warrantyCardId}"
                                <c:if test="${selectedWarrantyId == device.warrantyCardId}">selected</c:if>
                                <c:if test="${device.hasActiveIssue}">disabled</c:if>>
                                ${device.deviceName} (${device.serialNumber})
                                <c:if test="${device.hasActiveIssue}"> (Đang có yêu cầu xử lý)</c:if>
                            </option>
                        </c:forEach>
                    </select>
            </div>

            <div class="actions">
                <a class="btn btn-secondary" href="issue">Hủy </a>
                <button type="submit" class="btn order-btn">Gửi</button>
          		<a href="external-repair" class="btn order-btn">Sửa ngoài trung tâm</a>
            </div>
        </form>
        </c:if>
        <c:if test="${empty list}">
	        <div class="alert-actions">
	        	<div style="width: 70%; text-align: center;">Tài khoản của bạn hiện không có thiết bị bảo hành/sửa chữa. Vui lòng mua hàng! Hoặc gửi yêu cầu với thiết bị ngoài cửa hàng</div>
	        	<a style="border-radius: 10px; margin-top: 20px;" href="external-repair" class="btn order-btn">Sửa ngoài trung tâm</a>
	        </div>
        </c:if>
    </div>
    </main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>

</html>