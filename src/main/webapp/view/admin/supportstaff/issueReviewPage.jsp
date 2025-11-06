<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page isELIgnored="false" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
        
    <style>
         body {
             font-family: 'Segoe UI', sans-serif;
             background: #f4f6fb;
             margin: 0;
             padding: 40px;
         }

         .layout {
             display: grid;
		     grid-template-columns: 1fr 1fr;
		     gap: 24px;
		     max-width: 1100px;
		     margin: 0 auto;
         }

         .card-div {
             background: #fff;
             border-radius: 12px;
             padding: 24px;
             box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
         }

         .card-div h2 {
             margin-top: 0;
             color: #0f172a;
             width: 490px;
         }

         .meta {
             font-size: 1.6rem;
             color: #475569;
             margin-bottom: 16px;
         }

         label {
             display: block;
             font-weight: 600;
             margin-top: 16px;
             color: #0f172a;
         }

         input[type="text"],
         textarea {
             width: 100%;
             padding: 10px 12px;
             border-radius: 8px;
             border: 1px solid #d4dbe6;
             box-sizing: border-box;
         }

         textarea {
             min-height: 140px;
             resize: vertical;
         }

         .actions {
             margin-top: 24px;
             display: flex;
             justify-content: flex-end;
             gap: 12px;
         }

         .btn {
             padding: 10px 18px;
             border-radius: 6px;
             border: none;
             cursor: pointer;
             font-weight: 600;
         }

         .btn-secondary {
             background: #e2e8f0;
             color: #0f172a;
         }
         
         .btn-success {
	         background: #a1f6a4;             
             color: #0f172a;
         }

         .btn-primary {
             background: #2563eb;
             color: #fff;
         }

         .forward {
             margin-top: 20px;
             display: flex;
             align-items: center;
             gap: 10px;
         }

         .forward input {
             width: auto;
         }

         .alert {
             padding: 12px 16px;
             border-radius: 8px;
             margin-bottom: 16px;
             font-size: 1.4rem;
             background: #fee2e2;
             color: #b91c1c;
         }
         
         .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .alert-info {
            background: #e0f2fe;
            color: #0c4a6e;
        }
        
        .alert-warning {
            background: #fef3c7;
            color: #b45309;
        }

        pre {
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .readonly-block {
		    margin-top: 16px;
		    background: #f8fafc;
		    border-radius: 10px;
		    padding: 16px;
		    border: 1px dashed #cbd5f5;
        }

        .readonly-block h3 {
            margin-top: 0;
            color: #1e293b;
        }

        .readonly-block p {
            margin: 8px 0;
            color: #475569;
        }
        
        .status-badge {
		    display: inline-block;
		    white-space: nowrap;
		    padding: 4px 10px;
		    border-radius: 12px;
		    font-weight: 600;
		    font-size: 14px;
		    text-align: center;
		}
		
		.status-pending {
		    background: #fef3c7;
		    color: #92400e;
		}
		
		.status-inprogress {
		    background: #dbeafe;
		    color: #1d4ed8;
		}
		
		.status-completed {
		    background: #dcfce7;
		    color: #166534;
		}
		
		.status-cancelled {
		    background: #fee2e2;
		    color: #991b1b;
		}
		
		.summary-text{
			line-height: 1.5;
		    overflow-wrap: anywhere;
		    word-break: break-word;
		}
    </style>
</head>

	<jsp:include page="../common/sidebar.jsp"></jsp:include>
	<jsp:include page="../common/header.jsp"></jsp:include>
<body >
    <main class="sidebar-main" style="height: max-content;">
         <div class="layout">
                <div class="card-div">
                	<div class="readonly-block">
                        <h3>Thông tin yêu cầu</h3>
                        <p>Mã yêu cầu: <strong>${issue.issueCode}</strong></p>
                        <p>Khách hàng ID: <strong>${issue.customerId}</strong></p>
                        <p>Tiêu đề: <strong>${issue.title}</strong></p>
                        <p>Loại yêu cầu:<strong>
                        	<c:choose>
		                        <c:when test="${issue.issueType == 'repair'}">Sửa chữa</c:when>
		                        <c:otherwise>Bảo hành</c:otherwise>
		                    </c:choose>
		                    </strong>
                        </p>
                        <p>Mô tả: <strong>${issue.description}</strong></p>
                    </div>
                    
                    <c:if test="${not empty taskDetail}">
	                    <div class="readonly-block">
	                        <h3>Thông tin task</h3>
	                        <p>Tên nhân viên sửa: <strong>${taskDetail.technicalStaffName}</strong></p>
	                        <p>Ngày giao: <strong><fmt:formatDate value="${taskDetail.assignedAt}" pattern="dd/MM/yyyy HH:mm" /></strong></p>
	                        <p>Deadline: <strong><fmt:formatDate value="${taskDetail.deadline}" pattern="dd/MM/yyyy HH:mm" /></strong></p>
	                        <p>Note: <strong>${taskDetail.note}</strong></p>
	                        <p>Trạng thái:
	                        	<c:choose>
									<c:when test="${taskDetail.status == 'pending'}">
										<span class="status-badge status-pending">Đang chờ xử
											lý</span>
									</c:when>
									<c:when test="${taskDetail.status == 'in_progress'}">
										<span class="status-badge status-inprogress">Đang
											thực hiện</span>
									</c:when>
									<c:when test="${taskDetail.status == 'completed'}">
										<span class="status-badge status-completed">Hoàn
											thành</span>
									</c:when>
									<c:when test="${taskDetail.status == 'cancelled'}">
										<span class="status-badge status-cancelled">Đã hủy</span>
									</c:when>
									<c:otherwise>
										<span class="status-badge">Không xác định</span>
									</c:otherwise>
								</c:choose>
	                        </p>
	                        <p>Cập nhật lúc: <strong><fmt:formatDate value="${taskDetail.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></strong></p>
	                    </div>
	                </c:if>
	                
	                <c:if test="${empty taskDetail}">
	                	<div style="margin-top: 20px;" class="alert">Yêu cầu chưa được tạo task!</div>
	                </c:if>
                </div>

                <div class="card-div">
                    <h2>Thông tin khách hàng</h2>

                    <c:if test="${not empty error}">
                        <div class="alert">${error}</div>
                    </c:if>
                    
                    <c:if test="${param.requested == '1'}">
		                <div class="alert alert-info">Đã gửi yêu cầu. Vui lòng chờ khách hàng bổ sung thông tin</div>
		            </c:if>
		            
		            <c:if test="${param.infoComplete == '1'}">
                        <div class="alert alert-info">Hồ sơ khách hàng đã có thông tin liên hệ cần thiết - không có lời nhắc nào được gửi đi</div>
                    </c:if>
		            
		            <c:if test="${awaitingCustomer}">
		                <div class="alert alert-info">Đang chờ khách hàng phản hồi. Bạn có thể gửi lại form nếu cân nhắc</div>
		            </c:if>
		            
		            <c:if test="${param.paymentReady == '1'}">
					    <div class="alert alert-info">Đã mở bill thanh toán thành công</div>
					</c:if>
					
					<c:if test="${param.paymentInvalid == '1'}">
					    <div class="alert alert-error">Không thể cập nhật trạng thái thanh toán. Vui lòng thử lại</div>
					</c:if>
		            
		            <c:if test="${managerRejected}">
					    <div class="alert alert-warning">Quản lý kỹ thuật đã từ chối yêu cầu. Bạn hãy bổ sung thông tin và gửi lại
					        <c:if test="${not empty issue.feedback}">
					            <br/>Lý do: ${issue.feedback}
					        </c:if>
					    </div>
					</c:if>
					
					<c:if test="${customerCancelled}">
                        <div class="alert alert-warning">Khách hàng đã hủy yêu cầu. Vui lòng liên hệ lại nếu cần mở lại hồ sơ</div>
                    </c:if>
                    
					<c:if test="${managerApproved}">
					    <div class="alert alert-info">Quản lý kỹ thuật đã chấp thuận thông tin. Đang chờ tạo task kỹ thuật</div>
					</c:if>
					
					<c:if test="${issuePayment != null && paymentAwaitingCustomer}">
					    <div class="alert alert-info">Bill đã gửi cho khách. Đang chờ thanh toán</div>
					</c:if>
					
					<c:if test="${issuePayment != null && paymentPaid}">
					    <div class="alert alert-info">Khách đã thanh toán. Đang chờ khách gửi phản hồi</div>
					</c:if>

				
					<c:if test="${lockedForSupport}">
					    <div classD="alert alert-info">Task kỹ thuật đã được tạo. Bạn chỉ có thể xem thông tin đã gửi.</div>
					</c:if>

					<div class="readonly-block">
					    <h3>Thanh toán dịch vụ</h3>
					    <c:choose>
					        <c:when test="${issuePayment == null}">
					            <p>Chưa có bill từ kỹ thuật viên.</p>
					        </c:when>
					        <c:otherwise>
					            <p>Số tiền: 
					                <strong>
					                    <fmt:formatNumber value="${issuePayment.amount}" type="number" maxFractionDigits="0"/>
					                </strong>
					            </p>
					            <p>Trạng thái bill: <strong>${issuePayment.status}</strong></p>
					            <c:if test="${not empty issuePayment.note}">
					                <p>Ghi chú: <strong>${issuePayment.note}</strong></p>
					            </c:if>
					            <c:if test="${issuePayment.paidAt != null}">
					                <p>Thanh toán lúc: 
					                    <strong>
					                        <fmt:formatDate value="${issuePayment.paidAt}" pattern="dd/MM/yyyy HH:mm"/>
					                    </strong>
					                </p>
					            </c:if>
					        </c:otherwise>
					    </c:choose>
					</div>
					
		
		            <c:if test="${not lockedForSupport and (needsCustomerInfo or awaitingCustomer or managerRejected)}">
	                    <form method="post" action="support-issues">
	                        <input type="hidden" name="action" value="request_details">
	                        <input type="hidden" name="issueId" value="${issue.id}">
	                        <button type="submit" class="btn btn-secondary">
			                    <c:choose>
			                        <c:when test="${awaitingCustomer}">Gửi lại yêu cầu</c:when>
			                        <c:otherwise>Gửi yêu cầu cho khách hàng</c:otherwise>
			                    </c:choose>
			                </button>
			            </form>
		            </c:if>

                    <c:if test="${lockedForSupport}">
		                <c:if test="${issueDetail != null}">
		                    <div class="readonly-block">
		                        <h3>Thông tin đã gửi</h3>
		                        <p>Tên khách hàng: <strong>${issueDetail.customerFullName}</strong></p>
		                        <p>Email: <strong>${issueDetail.contactEmail}</strong></p>
		                        <p>Số điện thoại: <strong>${issueDetail.contactPhone}</strong></p>
		                        <p>Serial thiết bị: <strong>${issueDetail.deviceSerial}</strong></p>
		                        <p class="summary-text">Tổng hợp: <strong>${issueDetail.summary}</strong></p>
		                    </div>
		                </c:if>
		                <div class="actions">
		                    <c:if test="${taskDetail.status == 'completed' and issue.supportStatus == 'tech_in_progress'}">
		                    	<a class="btn btn-success" href="support-issues?action=updateStatus&id=${taskDetail.customerIssueId}">Cập nhật trạng thái</a>
		                    </c:if>
		                    <a class="btn btn-secondary" href="support-issues">Quay lại</a>
		                </div>
		            </c:if>
		
		            <c:if test="${not lockedForSupport and (not awaitingCustomer or not empty issueDetail)}">
					    <form method="post" action="support-issues">
					        <input type="hidden" name="action" value="save">
					        <input type="hidden" name="issueId" value="${issue.id}">
					
					        <label for="customerName">Tên khách hàng *</label>
					        <input type="text" id="customerName" name="customerName"
					               value="${issueDetail.customerFullName}" required>
					
					        <label for="contactEmail">Email liên hệ</label>
					        <input type="text" id="contactEmail" name="contactEmail"
					               value="${issueDetail.contactEmail}">
					
					        <label for="contactPhone">Số điện thoại</label>
					        <input type="text" id="contactPhone" name="contactPhone"
					               value="${issueDetail.contactPhone}">
					
					        <label for="deviceSerial">Serial thiết bị</label>
					        <input type="text" id="deviceSerial" name="deviceSerial"
					               value="${issueDetail.deviceSerial}">
					
					        <label for="summary">Ghi chú tổng hợp</label>
					        <textarea id="summary" name="summary">${issueDetail.summary}</textarea>
					
					        <div class="forward">
					            <input type="checkbox" id="forwardToManager" name="forwardToManager"
					                   <c:if test="${issueDetail.forwardToManager}">checked</c:if>>
					            <label for="forwardToManager" style="margin-top:0;">Gửi cho quản lý kỹ thuật</label>
					        </div>
					
					        <div class="actions">
					            <a class="btn btn-secondary" href="support-issues">Quay lại</a>
					            <button type="submit" class="btn btn-primary">Lưu thông tin</button>
					            
					        </div>
					    </form>
					</c:if>
					
					<div class="actions">
			            <c:if test="${paymentAwaitingSupport}">
						    <form method="post" action="support-issues" style="margin-top:12px;">
						        <input type="hidden" name="action" value="payment_open">
						        <input type="hidden" name="issueId" value="${issue.id}">
						        <button style="padding: 12.8px 18px;" type="submit" class="btn btn-primary">Mở cho khách thanh toán</button>
						    </form>
						</c:if>
					</div>
              </div>
         </div>
    </main>
</body>
</html>