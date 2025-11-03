<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Import / Export Transaction</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.device-form label {
    font-weight: 600;
    display: inline-block;
    width: 180px;
}

.device-form select, 
.device-form input[type="number"], 
.device-form textarea {
    width: 300px;
    padding: 7px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin: 6px 0;
}

textarea { height: 70px; resize: vertical; }

.stock-info {
    color: #007bff;
    font-size: 13px;
}

.table-wrapper {
    overflow-x: auto;
    margin-top: 20px;
}

.message {
    color: green;
    font-weight: bold;
    margin-bottom: 10px;
}

.error {
    color: red;
    font-weight: bold;
    margin-bottom: 10px;
}

.btn {
    padding: 8px 16px;
    border-radius: 8px;
    cursor: pointer;
    text-decoration: none;
    font-weight: 600;
}

.btn-add { background-color: #28a745; color: #fff; }
.btn-remove { background-color: #dc3545; color: #fff; }
.btn-submit { background-color: #007bff; color: #fff; margin-top: 15px; }

.device-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

.device-table th, .device-table td {
    border: 1px solid #ddd;
    text-align: center;
    padding: 8px;
}

.device-table th { background-color: #f7f7f7; }
</style>
</head>
<body class="management-page device-management sidebar-collapsed">
<jsp:include page="../admin/common/sidebar.jsp"></jsp:include>
<jsp:include page="../admin/common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <h2>Tạo Đơn Xuất/Nhập Kho</h2>

        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form id="transactionForm" class="device-form" action="${pageContext.request.contextPath}/create-transaction" method="post">
            <div class="form-group">
                <label for="storekeeperId">Storekeeper:</label>
                <select name="storekeeperId" id="storekeeperId" required>
                    <option value="">-- Select Storekeeper --</option>
                    <c:forEach var="u" items="${userList}">
                        <option value="${u.id}">${u.fullName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="type">Transaction Type:</label>
                <select name="type" id="type" onchange="toggleFields()" required>
                    <option value="import">Import</option>
                    <option value="export">Export</option>
                </select>
            </div>

            <div id="supplierSection" class="form-group">
                <label for="supplierId">Supplier:</label>
                <select name="supplierId" id="supplierId">
                    <option value="">-- Select Supplier --</option>
                    <c:forEach var="s" items="${supplierList}">
                        <option value="${s.id}">${s.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div id="userSection" class="form-group" style="display:none;">
                <label for="userId">User:</label>
                <select name="userId" id="userId">
                    <option value="">-- Select User --</option>
                    <c:forEach var="u" items="${userList}">
                        <option value="${u.id}">${u.fullName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="note">Note:</label>
                <textarea name="note" id="note" placeholder="Enter notes (optional)..."></textarea>
            </div>

            <h3>Device List</h3>
            <button type="button" class="btn btn-add" onclick="addRow()">+ Add Device</button>
            <div class="table-wrapper">
                <table class="device-table" id="deviceTable">
                    <thead>
                        <tr>
                            <th>Device</th>
                            <th>Quantity</th>
                            <th>Current Stock</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="deviceBody">
                        <tr>
                            <td>
                                <select name="deviceIds[]" onchange="updateStock(this)" required>
                                    <option value="">-- Select Device --</option>
                                    <c:forEach var="d" items="${deviceList}">
                                        <option value="${d.id}" data-stock="${d.currentStock}">${d.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>
                                <input type="number" name="quantities[]" min="1" value="1" oninput="checkQuantity(this)" required>
                            </td>
                            <td><span class="stock-info">0</span></td>
                            <td><button type="button" class="btn btn-remove" onclick="removeRow(this)">-</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <button type="submit" class="btn btn-submit">Create Transaction</button>
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
        alert("At least one device is required.");
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
        alert("Quantity exceeds current stock (" + stock + ")");
        input.value = stock;
    }
}

toggleFields();
</script>
</body>
</html>
