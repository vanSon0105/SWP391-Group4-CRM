<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi tiết Warranty</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
    crossorigin="anonymous"/>
<style>
    .panel {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        max-width: 700px;
        margin: 20px auto;
    }
    .panel h2 {
        margin-bottom: 20px;
        color: #333;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .warranty-info {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .warranty-info p {
        font-size: 16px;
        line-height: 1.5;
        margin: 0;
    }
    .warranty-info b {
        width: 150px;
        display: inline-block;
        color: #555;
    }
    .alert {
        padding: 10px 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }
    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .device-btn {
        display: inline-block;
        padding: 8px 16px;
        background-color: #1e90ff;
        color: #fff;
        text-decoration: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
    }
    .device-btn:hover {
        background-color: #0066cc;
    }
</style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<main class="sidebar-main">
    <section class="panel">
        <h2>
            Chi tiết Warranty
           <a href="${pageContext.request.contextPath}/customer-devices?customerId=${warranty.customer.id}" class="device-btn">Quay lại</a>

        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <c:if test="${not empty warranty}">
            <div class="warranty-info">
                <p><b>Serial:</b> ${warranty.device_serial.serial_no}</p>
                <p><b>Thiết bị:</b> ${device.name}</p>
                <p><b>Khách hàng:</b> ${warranty.customer.full_name}</p>
                <p><b>Email:</b> ${warranty.customer.email}</p>
                <p><b>Ngày bắt đầu:</b> ${warranty.start_at}</p>
                <p><b>Ngày kết thúc:</b> ${warranty.end_at}</p>
            </div>
        </c:if>
    </section>
</main>
</body>
</html>
