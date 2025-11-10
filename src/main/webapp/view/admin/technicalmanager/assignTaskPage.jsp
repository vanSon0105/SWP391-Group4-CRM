<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.Task, model.User" %>
<%@ page import="java.util.List" %>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Giao Task</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<style>
.panel {
	width: 990px;
}

.management-page.device-management .sidebar-main{
    display: flex;
    align-items: center;   
    justify-content: center; 
}

</style>
<body class="management-page device-management">
<jsp:include page="../common/sidebar.jsp"></jsp:include>
<jsp:include page="../common/header.jsp"></jsp:include>

<main class="sidebar-main">
    <section class="panel">
        <a class="btn device-btn" href="staff-list"><i class="fa-solid fa-arrow-left"></i><span>Về danh sách</span></a>
        <h2>Giao Task cho nhân viên</h2>

        <c:if test="${not empty selectedStaff}">
            <form class="device-form" action="assign-task" method="post">
                <input type="hidden" name="technical_staff_id" value="${selectedStaff.id}"/>

                <div class="form-grid">
                    <div class="form-field">
                        <label>Nhân viên kỹ thuật</label>
                        <input type="text" value="${selectedStaff.fullName} (${selectedStaff.username})" readonly/>
                    </div>

                    <div class="form-field">
                        <label>Chọn Task</label>
                        <select name="task_id" required>
                            <c:forEach items="${taskList}" var="task">
                                <option value="${task.id}">${task.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-field">
                        <label>Deadline</label>
                        <input type="datetime-local" name="deadline"/> 
                    </div>

                    <div class="form-field">
                        <label>Ghi chú</label>
                        <textarea name="note" placeholder="Nhập ghi chú nếu cần"></textarea>
                         
                    </div>
                </div>
                        <small style="color:red">${errorDeadline}</small>
				<small style="color:red">${errorNote}</small>
                <div class="form-actions form-actions--spread">
                    <div>
                        <a href="staff-list" class="btn ghost">Hủy</a>
                    </div>
                    <div>
                        <button type="submit" class="btn primary">Giao Task</button>
                    </div>
                </div>
            </form>
        </c:if>

        <c:if test="${empty selectedStaff}">
            <p>Không tìm thấy nhân viên</p>
        </c:if>
    </section>
</main>
</body>
</html>
