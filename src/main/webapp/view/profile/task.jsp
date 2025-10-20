<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Assign/Unassign Tasks</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f0f2f5; padding: 20px; }
    h2 { text-align: center; margin-bottom: 20px; }
    .filter-form { display: flex; flex-wrap: wrap; gap:10px; justify-content:center; margin-bottom:20px; }
    .filter-form select, .filter-form input[type=text], .filter-form input[type=date] { padding:5px; border-radius:4px; border:1px solid #ccc; }
    .filter-form button { padding:5px 10px; border:none; border-radius:4px; cursor:pointer; }
    table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
    th, td { padding: 10px; border:1px solid #ddd; text-align:center; }
    th { background:#3498db; color:white; }
    tr:hover { background:#f2f2f2; }
    .assign-btn { background:#2980b9; color:white; padding:5px 10px; border:none; border-radius:4px; cursor:pointer; margin-bottom:3px; }
    .unassign-btn { background:#e74c3c; color:white; padding:5px 10px; border:none; border-radius:4px; cursor:pointer; }
</style>
</head>
<jsp:include page="../common/header.jsp"></jsp:include>
<body>

<h2>PHÂN CÔNG / HỦY PHÂN CÔNG NHIỆM VỤ</h2>

<form class="filter-form" method="get" action="tasks">
    <select name="status">
        <option value="">Tất cả trạng thái</option>
        <option value="pending" <c:if test="${param.status=='pending'}">selected</c:if>>pending</option>
        <option value="in_progress" <c:if test="${param.status=='in_progress'}">selected</c:if>>in_progress</option>
        <option value="completed" <c:if test="${param.status=='completed'}">selected</c:if>>completed</option>
        <option value="cancelled" <c:if test="${param.status=='cancelled'}">selected</c:if>>cancelled</option>
    </select>

    <select name="priority">
        <option value="">Tất cả ưu tiên</option>
        <option value="Low" <c:if test="${param.priority=='Low'}">selected</c:if>>Low</option>
        <option value="Medium" <c:if test="${param.priority=='Medium'}">selected</c:if>>Medium</option>
        <option value="High" <c:if test="${param.priority=='High'}">selected</c:if>>High</option>
    </select>

    <select name="technicianId">
        <option value="">Chọn kỹ thuật viên</option>
        <c:forEach var="tech" items="${technicians}">
            <option value="${tech.id}" <c:if test="${param.technicianId == tech.id}">selected</c:if>>${tech.fullName}</option>
        </c:forEach>
    </select>

    <input type="date" name="fromDate" value="${param.fromDate}" />
    <input type="date" name="toDate" value="${param.toDate}" />
    <input type="text" name="searchText" placeholder="IS/Nhiệm vụ/tiêu đề/mô tả" value="${param.searchText}" />

    <button type="submit" style="background:#4CAF50; color:white;">Lọc</button>
    <button type="reset" onclick="document.getElementsByClassName('filter-form')[0].reset();">Xóa lọc</button>
</form>

<!-- Task Table -->
<table>
<thead>
<tr>
    <th>WO</th>
    <th>Tiêu đề</th>
    <th>Mô tả</th>
    <th>Trạng thái</th>
    <th>Ưu tiên</th>
    <th>Nhân viên</th>
    <th>Người giao</th>
    <th>Ngày giao</th>
    <th>Deadline</th>
    <th>Tiến độ</th>
    <th>Ghi chú</th>
    <th>Cập nhật</th>
    <th>Thao tác</th>
</tr>
</thead>
<tbody>
<c:forEach var="task" items="${tasks}">
    <c:choose>
        <c:when test="${empty task.details}">
            <!-- Task chưa được assign -->
            <tr>
                <td>${task.wo}</td>
                <td>${task.title}</td>
                <td>${task.description}</td>
                <td>-</td>
                <td>-</td>
                <td>Chưa phân công</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>0%</td>
                <td>-</td>
                <td>-</td>
                <td>
                    <form method="post" action="tasks">
                        <input type="hidden" name="taskId" value="${task.id}"/>
                        <input type="hidden" name="action" value="assign"/>
                        <input type="date" name="deadline" required/>
                        <select name="staffId" required>
                            <option value="" disabled selected>Chọn nhân viên</option>
                            <c:forEach var="tech" items="${technicians}">
                                <c:if test="${not task.assignedStaffIds.contains(tech.id)}">
                                    <option value="${tech.id}">${tech.fullName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <button type="submit" class="assign-btn">Assign</button>
                    </form>
                </td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="detail" items="${task.details}">
                <tr>
                    <td>${task.wo}</td>
                    <td>${task.title}</td>
                    <td>${task.description}</td>
                    <td>${detail.status}</td>
                    <td>${detail.priority}</td>
                    <td>${detail.technicalStaffName}</td>
                    <td>${detail.assignedByName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty detail.assignedAt}">
                                <fmt:formatDate value="${detail.assignedAt}" pattern="yyyy-MM-dd"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty detail.deadline}">
                                <fmt:formatDate value="${detail.deadline}" pattern="yyyy-MM-dd"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${detail.progress}%</td>
                    <td>${detail.note}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty detail.updatedAt}">
                                <fmt:formatDate value="${detail.updatedAt}" pattern="yyyy-MM-dd"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form method="post" action="tasks" style="margin-bottom:5px;">
                            <input type="hidden" name="taskId" value="${task.id}"/>
                            <input type="hidden" name="action" value="assign"/>
                            <input type="date" name="deadline" required/>
                            <select name="staffId" required>
                                <option value="" disabled selected>Chọn nhân viên</option>
                                <c:forEach var="tech" items="${technicians}">
                                    <c:if test="${not task.assignedStaffIds.contains(tech.id)}">
                                        <option value="${tech.id}">${tech.fullName}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <button type="submit" class="assign-btn">Assign</button>
                        </form>

                        <form method="post" action="tasks">
                            <input type="hidden" name="taskId" value="${task.id}"/>
                            <input type="hidden" name="staffId" value="${detail.technicalStaffId}"/>
                            <input type="hidden" name="action" value="unassign"/>
                            <button type="submit" class="unassign-btn">Unassign</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</c:forEach>
</tbody>
</table>
 <jsp:include page="../common/footer.jsp"></jsp:include>
</body>
</html>
