<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechShop</title>
<%-- <link rel="stylesheet"
	href="<%=request.getContextPath()%>/assets/css/shop.css"> --%>


<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
body {
	display: flex;
	box-sizing: border-box;
	font-family: 'Segoe UI', Tahoma, sans-serif;
	margin: 0;
	padding: 0;
	background: linear-gradient(135deg, #f0fdfa, #eff6ff 45%, #fff5f5 100%);
}

.side-bar {
	width: 15%;
	height: 100vh;
	color: white;
	background-color: #4E74CA;
}

.side-bar a:hover {
	cursor: pointer;
	background: #2B90C6;
}

.side-bar a {
	width: 80%;
	border-radius: 8px;
	padding: 8px 10px;
	color: white;
	text-decoration: none;
}

.side-bar a.active {
	background: #2B90C6;
}

    .container {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
    }
    .head {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .task-box {
        background: white;
        padding: 18px;
        margin-top: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .task-title {
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 10px;
    }
    .task-meta {
        color: #555;
        line-height: 1.6;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 18px;
    }
    th, td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: center;
    }
    th {
        background: #f3f4f6;
    }
    .btn {
        padding: 6px 12px;
        border: none;
        background: #2563eb;
        color: white;
        border-radius: 4px;
        cursor: pointer;
        text-decoration: none;
    }
    .btn-secondary {
        background: #6b7280;
    }
</style>
</head>
<body>
<section class="side-bar">
		<div style="border-bottom: thin solid white; padding: 8px 10px">
			<h1 style="font-weight: 500;">TechShop</h1>
		</div>

		<div
			style="width: 100%; display: flex; flex-direction: column; gap: 14px; margin-top: 20px; align-items: center">
			<a href="task-list-page" class="active">Task List</a>
			<a>Staff List</a>
			<a>Device List</a>
			<a>Report</a>
		</div>

	</section>
<div class="container">

    <div class="head">
        <h2>Task Detail</h2>
        <a href="task-list" class="btn btn-secondary">Quay lại</a>
    </div>


    <div class="task-box">
        <div class="task-title">#${task.id} - ${task.title}</div>
        <div class="task-meta">
            <b>Mô tả:</b> ${task.description}<br>
            <b>Manager:</b> ${task.managerId}<br>
            <b>Customer Issue:</b> Issue #${task.customerIssueId}<br>
            <b>Số nhân viên tham gia:</b> 1<br>
            <b>Trạng thái chung:</b> <span style="color: #0ea5e9">Đang xử lý</span>
        </div>
    </div>


    <div style="margin-top: 14px; display:flex; gap:10px;">
        <button class="btn">+ Thêm nhân viên</button>
        <button class="btn btn-secondary">Đánh dấu hoàn thành Task</button>
    </div>


    <table>
        <thead>
            <tr>
            	<th>ID</th>
                <th>Staff</th>
                <th>Assigned At</th>
                <th>Deadline</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <c:forEach var="taskDetail" items="${listTaskDetail}">
        	<tbody>
            <tr>
            	<td>${taskDetail.id}</td>
                <td>${taskDetail.technicalStaffId}</td>
                <td>${taskDetail.assignedAt}</td>
                <td>${taskDetail.deadline}</td>
                <td>${taskDetail.status}</td>
                <td><button class="btn btn-secondary">Cập nhật</button></td>
            </tr>
        </tbody>
        </c:forEach>
        
    </table>

</div>

</body>
</html>
