<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tạo Đơn Nhập/Xuất Kho</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
body.management-page {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: #f9fafb;
	color: #111827;
	margin: 0;
	padding: 0;
}

h2 {
	font-size: 24px;
	font-weight: 700;
	margin-bottom: 20px;
}

section.panel {
	background: #ffffff;
	padding: 30px 25px;
	border: 1px solid #d1d5db; /* Vuông, nhẹ */
	border-radius: 0; /* Vuông hẳn */
	max-width: 850px;
	margin: 25px auto;
	box-shadow: none; /* Không bóng */
}

.device-form label {
	font-weight: 600;
	display: block;
	margin-bottom: 4px;
	color: #374151;
}

.device-form select, .device-form input[type="number"], .device-form input[type="datetime-local"],
	.device-form textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #9ca3af;
	background-color: #f9fafb;
	font-size: 14px;
	border-radius: 0; /* Vuông hẳn */
	box-sizing: border-box;
}

.device-form textarea {
	min-height: 70px;
	resize: vertical;
}

.btn {
	padding: 10px 16px;
	font-weight: 600;
	cursor: pointer;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	border: none;
	border-radius: 0;
}

.btn-add {
	background-color: #10b981;
	color: #fff;
}

.btn-add:hover {
	background-color: #059669;
}

.btn-remove {
	background-color: #ef4444;
	color: #fff;
}

.btn-remove:hover {
	background-color: #b91c1c;
}

.btn-submit {
	background-color: #3b82f6;
	color: #fff;
}

.btn-submit:hover {
	background-color: #2563eb;
}

.btn-secondary {
	background-color: #6b7280;
	color: #fff;
}

.btn-secondary:hover {
	background-color: #4b5563;
}

.message {
	background-color: #d1fae5;
	color: #065f46;
	font-weight: 600;
	padding: 10px;
	border-left: 4px solid #10b981;
	margin-bottom: 15px;
}

.error {
	background-color: #fee2e2;
	color: #b91c1c;
	font-weight: 600;
	padding: 10px;
	border-left: 4px solid #ef4444;
	margin-bottom: 15px;
}

.device-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
	border: 1px solid #d1d5db;
}

.device-table th, .device-table td {
	border: 1px solid #d1d5db; 
	text-align: center;
	padding: 10px;
	font-size: 14px;
}

.device-table th {
	background-color: #f3f4f6;
	font-weight: 600;
}

.stock-info {
	font-weight: 500;
	color: #3b82f6;
}

.table-wrapper {
	overflow-x: auto;
	margin-top: 20px;
}

.form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 20px;
}

@media ( max-width : 768px) {
	section.panel {
		padding: 20px 15px;
	}
}
</style>
</head>
<body class="management-page device-management sidebar-collapsed">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<main class="sidebar-main">
		<section class="panel">
			<h2>Tạo Đơn Nhập/Xuất Kho</h2>

			<c:if test="${not empty message}">
				<div class="message">${message}</div>
			</c:if>
			<c:if test="${not empty error}">
				<div class="error">${error}</div>
			</c:if>
			<c:if test="${not empty duplicateNameError}">
				<div class="error">${duplicateNameError}</div>
			</c:if>

			<form id="transactionForm" class="device-form"
				action="${pageContext.request.contextPath}/create-transaction"
				method="post">
				<div class="form-group">
					<label for="storekeeperId">Nhân viên kho:</label> <select
						name="storekeeperId" id="storekeeperId" required>
						<option value="">-- Chọn nhân viên kho --</option>
						<c:forEach var="u" items="${userList}">
							<c:if test="${u.role eq 'storekeeper'}">
								<option value="${u.id}">${u.fullName}(Role:${u.role})</option>
							</c:if>
						</c:forEach>
					</select>
				</div>

				<div class="form-group">
					<label for="date">Ngày tạo:</label> <input type="datetime-local"
						name="date" id="date" required
						value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd\'T\'HH:mm'/>">
				</div>

				<div class="form-group">
					<label for="type">Loại giao dịch:</label> <select name="type"
						id="type" onchange="toggleFields()" required>
						<option value="import">Nhập kho</option>
						<option value="export">Xuất kho</option>
					</select>
				</div>

				<div id="supplierSection" class="form-group">
					<label for="supplierId">Nhà cung cấp:</label> <select
						name="supplierId" id="supplierId">
						<option value="">-- Chọn nhà cung cấp --</option>
						<c:forEach var="s" items="${supplierList}">
							<option value="${s.id}">${s.name}</option>
						</c:forEach>
					</select>
				</div>

				<div id="userSection" class="form-group" style="display: none;">
					<label for="userId">Người nhận:</label> <select name="userId"
						id="userId">
						<option value="">-- Chọn người nhận --</option>
						<c:forEach var="u" items="${userList}">
							<c:if test="${u.role eq 'customer'}">
								<option value="${u.id}">${u.fullName}(Role:${u.role})</option>
							</c:if>
						</c:forEach>
					</select>
				</div>

				<div class="form-group">
					<label for="note">Ghi chú:</label>
					<textarea name="note" id="note"
						placeholder="Nhập ghi chú (tùy chọn)..."></textarea>
				</div>

				<h3>Danh sách thiết bị</h3>
				<button type="button" class="btn btn-add" onclick="addRow()">+
					Thêm thiết bị</button>
				<div class="table-wrapper">
					<table class="device-table" id="deviceTable">
						<thead>
							<tr>
								<th>Thiết bị</th>
								<th>Số lượng</th>
								<th>Tồn kho hiện tại</th>
								<th>Hành động</th>
							</tr>
						</thead>
						<tbody id="deviceBody">
							<tr>
								<td><select name="deviceIds[]" onchange="updateStock(this)"
									required>
										<option value="">-- Chọn thiết bị --</option>
										<c:forEach var="d" items="${deviceList}">
											<option value="${d.id}" data-stock="${d.currentStock}">${d.name}</option>
										</c:forEach>
								</select></td>
								<td><input type="number" name="quantities[]" min="1"
									value="1" oninput="checkQuantity(this)" required></td>
								<td><span class="stock-info">0</span></td>
								<td><button type="button" class="btn btn-remove"
										onclick="removeRow(this)">-</button></td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="form-actions">
					<button type="submit" class="btn btn-submit">Tạo giao dịch</button>
					<a href="transactions" class="btn btn-secondary">Quay lại danh
						sách</a>
				</div>
			</form>
		</section>
	</main>

	<script>
function toggleFields() {
    const type = document.getElementById("type").value;
    document.getElementById("supplierSection").style.display = (type === "import") ? "block" : "none";
    document.getElementById("userSection").style.display = (type === "export") ? "block" : "none";
}

function addRow() {
    const tableBody = document.getElementById("deviceBody");
    const newRow = tableBody.rows[0].cloneNode(true);
    newRow.querySelector("select").value = "";
    newRow.querySelector("input").value = 1;
    newRow.querySelector(".stock-info").textContent = "0";
    tableBody.appendChild(newRow);
}

function removeRow(btn) {
    const tableBody = document.getElementById("deviceBody");
    if (tableBody.rows.length > 1) {
        btn.closest("tr").remove();
    } else {
        alert("Phải có ít nhất một thiết bị.");
    }
}

function updateStock(select) {
    const stock = select.selectedOptions[0].getAttribute("data-stock") || 0;
    const row = select.closest("tr");
    row.querySelector(".stock-info").textContent = stock;
}

function checkQuantity(input) {
    const type = document.getElementById("type").value;
    const row = input.closest("tr");
    const stock = parseInt(row.querySelector(".stock-info").textContent);
    let qty = parseInt(input.value);
    if (qty < 1) input.value = 1;
    if (type === "export" && qty > stock) {
        alert("Số lượng vượt quá tồn kho hiện tại (" + stock + ")");
        input.value = stock;
    }
}

toggleFields();
</script>
</body>
</html>
