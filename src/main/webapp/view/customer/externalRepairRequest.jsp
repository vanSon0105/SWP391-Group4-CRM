<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Gửi máy sửa chữa ngoài cửa hàng</title>
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

		h1 {
			margin-top: 0;
			font-size: 2.4rem;
			color: #0f172a;
		}

		p.page-intro {
			color: #475569;
			line-height: 1.6;
			margin-bottom: 28px;
		}

		.form-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit,minmax(260px,1fr));
			gap: 18px 24px;
		}

		label {
			display: block;
			font-weight: 600;
			color: #0f172a;
			margin-bottom: 6px;
			font-size: 1.5rem;
		}

		input[type="text"],
		input[type="tel"],
		input[type="email"],
		textarea,
		select {
			width: 100%;
			padding: 10px 12px !important;
			border-radius: 10px;
			border: 2px solid #e2e8f0;
			font-size: 1.5rem;
			transition: border-color 0.2s, box-shadow 0.2s;
			background: #fff;
		}

		input:focus,
		textarea:focus,
		select:focus {
			border-color: #2563eb;
			box-shadow: 0 0 0 4px rgba(37,99,235,0.12);
			outline: none;
		}

		textarea {
			min-height: 130px;
			resize: vertical;
		}

		.field-error {
			margin-top: 6px;
			color: #b91c1c;
			font-size: 1.3rem;
		}

		.form-section {
			margin-bottom: 28px;
		}

		.section-title {
			font-size: 1.9rem;
			font-weight: 600;
			color: #0f172a;
			margin-bottom: 12px;
		}

		.actions {
			display: flex;
			justify-content: flex-end;
			gap: 12px;
			margin-top: 30px;
		}

		.btn-outline {
			border: 1px solid #cdcdcd !important;
			background: transparent !important;
			border: 1px solid #cbd5f5;
			color: #0f172a !important;
		}

		.btn-primary {
			background: linear-gradient(90deg,#2563eb,#3b82f6);
			color: #fff;
			box-shadow: 0 10px 20px rgba(37,99,235,0.25);
		}

		.alert-error {
			background: #fee2e2;
			color: #b91c1c;
			padding: 14px 16px;
			border-radius: 12px;
			margin-bottom: 20px;
			font-size: 1.4rem;
		}
	</style>
</head>
<body class="home-page">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<main>
		<h1>Gửi máy sửa chữa ngoài cửa hàng</h1>
		<p class="page-intro">
			Vui lòng điền thông tin thiết bị và mô tả sự cố
		</p>

		<c:if test="${not empty formError}">
			<div class="alert-error">${formError}</div>
		</c:if>

		<form method="post" action="external-repair">
			<div class="form-section">
				<div class="section-title">Thông tin liên hệ</div>
				<div class="form-grid">
					<div>
						<label for="contactName">Họ tên người gửi *</label>
						<input type="text" id="contactName" name="contactName"
							   value="${fn:escapeXml(formContactName)}" maxlength="120" required
							   <c:if test="${not empty formContactName}">readonly</c:if>>
						<c:if test="${not empty errorContactName}">
							<div class="field-error">${errorContactName}</div>
						</c:if>
					</div>

					<div>
						<label for="contactPhone">Số điện thoại *</label>
						<input type="tel" id="contactPhone" name="contactPhone"
							    value="${fn:escapeXml(formContactPhone)}" maxlength="11" required
							   <c:if test="${not empty formContactPhone}">readonly</c:if>>
						<c:if test="${not empty errorContactPhone}">
							<div class="field-error">${errorContactPhone}</div>
						</c:if>
					</div>

					<div>
						<label for="contactEmail">Email</label>
						<input type="email" id="contactEmail" name="contactEmail"
							   value="${fn:escapeXml(formContactEmail)}" maxlength="120"
							   <c:if test="${not empty formContactEmail}">readonly</c:if>>
						<c:if test="${not empty errorContactEmail}">
							<div class="field-error">${errorContactEmail}</div>
						</c:if>
					</div>
				</div>
			</div>
			
			<div class="form-section">
				<div class="section-title">Thông tin thiết bị</div>
				<div class="form-grid">
					<div>
						<label for="deviceName">Tên thiết bị *</label>
						<input type="text" id="deviceName" name="deviceName"
							   value="${fn:escapeXml(formDeviceName)}" maxlength="150" required>
						<c:if test="${not empty errorDeviceName}">
							<div class="field-error">${errorDeviceName}</div>
						</c:if>
					</div>

					<div>
						<label for="deviceSerial">Mã/Serial</label>
						<input class="filter-select" type="text" id="deviceSerial" name="deviceSerial"
							   value="${fn:escapeXml(formDeviceSerial)}" maxlength="120">
					</div>

					<div>
						<label for="deviceCondition">Tình trạng khi gửi</label>
						<select id="deviceCondition" name="deviceCondition">
							<c:set var="cond" value="${formDeviceCondition}" />
							<option value="">-- Chọn tình trạng --</option>
							<option value="Máy hoạt động nhưng lỗi tính năng" <c:if test="${cond == 'Máy hoạt động nhưng lỗi tính năng'}">selected</c:if>>
								Máy hoạt động nhưng lỗi tính năng
							</option>
							<option value="Máy không lên nguồn" <c:if test="${cond == 'Máy không lên nguồn'}">selected</c:if>>
								Máy không lên nguồn
							</option>
							<option value="Vỡ bể, hư hỏng vật lý" <c:if test="${cond == 'Vỡ bể, hư hỏng vật lý'}">selected</c:if>>
								Vỡ bể, hư hỏng vật lý
							</option>
							<option value="Khác" <c:if test="${cond == 'Khác'}">selected</c:if>>Khác</option>
						</select>
					</div>

					<div>
						<label for="includedItems">Phụ kiện kèm theo</label>
						<input type="text" id="includedItems" name="includedItems"
							   value="${fn:escapeXml(formIncludedItems)}" maxlength="255"
							   placeholder="Ví dụ: Sạc, cáp, ốp lưng...">
					</div>
				</div>
			</div>

			<div class="form-section">
				<div class="section-title">Mô tả vấn đề</div>
				<div class="form-grid">
					<div>
						<label for="title">Tóm tắt sự cố *</label>
						<input type="text" id="title" name="title" maxlength="80"
							   value="${fn:escapeXml(formTitle)}" required>
						<c:if test="${not empty errorTitle}">
							<div class="field-error">${errorTitle}</div>
						</c:if>
					</div>
				</div>
				<label for="desc">Chi tiết tình trạng *</label>
				<textarea id="desc" name="desc" maxlength="1200" required>${fn:escapeXml(formDesc)}</textarea>
				<c:if test="${not empty errorDesc}">
					<div class="field-error">${errorDesc}</div>
				</c:if>

				<label for="dropoffNote" style="margin-top:18px;">Ghi chú thêm</label>
				<textarea id="dropoffNote" name="dropoffNote" maxlength="500"
						  placeholder="Thông tin bổ sung khi bạn gửi máy đến trung tâm">${fn:escapeXml(formDropoffNote)}</textarea>
			</div>

			<div class="actions">
				<a class="btn order-btn btn-outline" href="device-page">Hủy</a>
				<button type="submit" class="btn order-btn">Gửi yêu cầu</button>
			</div>
		</form>
	</main>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
