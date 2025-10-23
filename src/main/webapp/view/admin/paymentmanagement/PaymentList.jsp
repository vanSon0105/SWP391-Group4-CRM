<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
	.device-btn{
	    color: black !important;
	}
	.device-management .pagination-pills {
	    display: flex;
	    justify-content: center;
	    gap: 10px;
	}
	
	.device-management .pagination-pills a {
		display: inline-flex;
		justify-content: center;
		align-items: center;
		text-decoration: none;
	    width: 44px;
	    height: 44px;
	    padding: 0;
	    border-radius: 16px;
	    border: 1px solid rgba(15, 23, 42, 0.15);
	    background: rgba(255, 255, 255, 0.9);
	    color: #1f2937;
	    font-weight: 600;
	    cursor: pointer;
	    transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
	}
	
	.device-management .pagination-pills a.active {
	    background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
	    color: #f8fafc;
	    border-color: transparent;
	    box-shadow: 0 16px 32px rgba(59, 130, 246, 0.28);
	}
	
	.device-management .pagination-pills a:hover {
	    transform: translateY(-2px);
	}

	body .panel h2{
		margin-bottom: 0 !important;
	}
	
	button {
         padding: 6px 12px;
         background-color: #28a745;
         color: white;
         border: none;
         border-radius: 4px;
         cursor: pointer;
         font-size: 14px;
     }

     button:hover {
         background-color: #218838;
     }

     button {
         padding: 10px 12px !important;
     }

     .container-paging {
         margin-top: 10px;
         margin-left: 45%;
     }

     .container-paging a {
         padding: 6px 12px;
         text-decoration: none;
         border: none;
         color: white !important;
         background: #3b82f6;
         border-radius: 10px;
     }
     
     th, td{
     	 padding: 14px 5px !important;
     	 font-size: 1.3rem !important;
     }
     
     button {
     	width: 80px;
     	font-size: 1rem !important;
     }
</style>
</head>
<body class="management-page device-management">
	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
	 <main class="sidebar-main">
            <%-- <section class="panel">
                <div class="device-toolbar">
                </div>
            </section>--%>

            <section class="panel" id="table-panel">
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
	                <h2>Danh sách thanh toán</h2>   
            	</div>
                <div class="table-wrapper">
                    <c:if test="${not empty paymentList}"> 
	                    <table class="device-table">
	                        <thead>
	                            <tr>
                                    <th>ID</th>
                                    <th>FullName</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Method</th>
                                    <th>DeliveryTime</th>
                                    <th>Note</th>
                                    <th>Status</th>
                                    <th>CreatedAt</th>
                                    <th>PaidAt</th>
                                    <th>Action</th>
                                </tr>
	                        </thead>
	                        <tbody>
	                        	<c:forEach items="${paymentList}" var="p">
		                            <tr>
		                            	<td>${p.id}</td>
                                        <td>${p.fullName}</td>
                                        <td>${p.phone}</td>
                                        <td>${p.address}</td>
                                        <td>${p.paymentMethod}</td>
                                        <td>${p.deliveryTime}</td>
                                        <td>${p.technicalNote}</td>
                                        <td>${p.status}</td>
                                        <td>${p.createdAt}</td>
                                        <td>${p.paidAt}</td>
                                        <form action="payment-list" method="post">
	                                        <td style="display: flex; gap: 3px;">
	                                        	<input type="hidden" name="paymentId" value="${p.id}" />
	                                        	
                                                <button style="background-color: #1976D2" name="action"
                                                    type="submit" value="success">Confirm</button>
                                                    
                                                <button style="background-color: #E70043" name="action"
                                                    type="submit" value="failed">Deny</button>
	                                        </td>
                                        </form>
		                            </tr>
		                          </c:forEach>
	                        </tbody>
	                    </table>
                   </c:if>
                   
                   <c:if test="${empty paymentList}">
	                   <table class="device-table"> 
	                   		<tbody>
		                   		<tr>
							        <td colspan="7" style="text-align: center; border: none;">
							            Không tìm thấy payment
							        </td>
							    </tr>
						    </tbody>
						</table>
                   </c:if>
                   
                </div>
             </section>
             
             <div class="container-paging">
                 <c:forEach var="i" begin="1" end="${totalPages}">
                     <a class="pagination ${(param.page == null && i == 1) || param.page == i ? 'active' : ''}"
                         href="payment-list?page=${i}">${i}</a>
                 </c:forEach>
             </div>
        </main>
</body>
</html>
