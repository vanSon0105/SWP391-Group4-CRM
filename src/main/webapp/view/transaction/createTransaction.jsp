<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Import / Export Transaction</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            background-color: #ffde59;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 25px;
        }
        label { font-weight: bold; display: inline-block; width: 180px; }
        select, input[type="number"], textarea {
            width: 300px;
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin: 6px 0;
        }
        textarea { height: 70px; resize: vertical; }
        .btn {
            border: none; color: white; padding: 8px 16px;
            border-radius: 5px; cursor: pointer; font-weight: bold;
            transition: background 0.2s;
        }
        .btn-add { background-color: #28a745; }
        .btn-remove { background-color: #dc3545; }
        .btn-submit { background-color: #007bff; margin-top: 15px; }
        .btn:hover { opacity: 0.9; }
        .message { color: green; font-weight: bold; margin-bottom: 10px; }
        .error { color: red; font-weight: bold; margin-bottom: 10px; }
        .stock-info { color: #007bff; font-size: 13px; }
        table {
            width: 100%; border-collapse: collapse; margin-top: 15px;
        }
        th, td {
            border: 1px solid #ddd; text-align: center;
            padding: 8px;
        }
        th { background-color: #f7f7f7; }
        .note { font-size: 13px; color: gray; }
    </style>
</head>
<body>
<div class="container">
    <h2>Tạo Đơn Xuất/Nhập Kho</h2>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form id="transactionForm" action="${pageContext.request.contextPath}/create-transaction" method="post">
        <div class="form-group">
            <label for="storekeeperId">Storekeeper:</label>
            <select name="storekeeperId" id="storekeeperId" required>
                <option value="">-- Select Storekeeper --</option>
                <c:forEach var="u" items="${userList}">
                    <option value="${u.id}">${u.fullName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Type -->
        <div class="form-group">
            <label for="type">Transaction Type:</label>
            <select name="type" id="type" onchange="toggleFields()" required>
                <option value="import">Import</option>
                <option value="export">Export</option>
            </select>
        </div>

        <!-- Supplier / User -->
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

        <!-- Note -->
        <div class="form-group">
            <label for="note">Note:</label>
            <textarea name="note" id="note" placeholder="Enter notes (optional)..."></textarea>
        </div>

        <!-- Device Table -->
        <h3>Device List</h3>
        <button type="button" class="btn btn-add" onclick="addRow()">+ Add Device</button>
        <table id="deviceTable">
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
                                <option value="${d.id}" data-stock="${d.currentStock}">
                                    ${d.name}
                                </option>
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

        <p class="note">* For export, quantity must not exceed current stock.</p>

        <!-- Submit -->
        <button type="submit" class="btn btn-submit">Create Transaction</button>
    </form>
</div>

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
