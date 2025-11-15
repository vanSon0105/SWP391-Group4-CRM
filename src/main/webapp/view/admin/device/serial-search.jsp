<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Device serial lookup</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        .serial-lookup-page .serial-search-header {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 1rem;
        }
        .serial-lookup-page .serial-search-header h2 {
            margin-bottom: .35rem;
        }
        .serial-lookup-page .device-search {
            flex: 1;
            min-width: 280px;
            justify-content: flex-end;
        }
        .serial-lookup-page .device-search input[type="search"] {
            flex: 1;
            min-width: 220px;
        }
        .serial-lookup-table td {
            vertical-align: top;
        }
        .serial-lookup-table .stacked {
            display: flex;
            flex-direction: column;
            gap: .4rem;
        }
        .serial-badge {
            display: inline-flex;
            align-items: center;
            font-size: .85rem;
            text-transform: capitalize;
            border-radius: 999px;
            padding: .15rem .6rem;
            background: #f4f4f5;
            color: #52525b;
        }
        .serial-badge.stock-in_stock { background: #dcfce7; color: #166534; }
        .serial-badge.stock-sold { background: #fee2e2; color: #b91c1c; }
        .serial-badge.stock-in_repair { background: #fef9c3; color: #854d0e; }
        .serial-badge.stock-out_stock { background: #f1f5f9; color: #475569; }
        .serial-badge.serial-status-discontinued { background: #fee2e2; color: #b91c1c; }
        .serial-badge.serial-status-active { background: #dbeafe; color: #1d4ed8; }
        .serial-meta small {
            display: block;
            color: #6b7280;
        }
        .serial-lookup-table .section-title {
            font-weight: 600;
        }
        .serial-lookup-table .link-btn {
            display: inline-flex;
            align-items: center;
            gap: .25rem;
            color: #2563eb;
            font-weight: 500;
            text-decoration: none;
        }
        .serial-lookup-table .link-btn i {
            font-size: .85rem;
        }
        .serial-lookup-page .empty-state {
            text-align: center;
            padding: 2rem 1rem;
            color: #6b7280;
        }
        .serial-lookup-page .table-meta {
            margin-top: 1rem;
            color: #6b7280;
            text-align: right;
        }
        .serial-lookup-page .pagination-pills {
            justify-content: center;
        }
    </style>
</head>
<body class="management-page device-management serial-lookup-page">
    <jsp:include page="../common/sidebar.jsp"></jsp:include>
    <jsp:include page="../common/header.jsp"></jsp:include>
    <main class="sidebar-main">
        <section class="panel">
        	 <div class="device-toolbar">
                <form class="device-search" action="device-serial-search" method="get">
                   <label for="serial-keyword" class="sr-only"></label>
                   <input id="serial-keyword" name="keyword" type="search"
                          value="${fn:escapeXml(keyword)}"
                          placeholder="Search serial, device or customer...">
                    <button class="btn device-btn" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>Tìm kiếm</span>
                    </button>
                    <a href="device-serial-search" class="btn device-btn ghost">Reset</a>
                </form>
             </div>
        </section>

        <section class="panel">
            <c:choose>
                <c:when test="${totalSerials == 0}">
                    <div class="empty-state">
                        <p>Không có seri được tìm thấy</p>
                    </div>
                </c:when>
                <c:otherwise>
                   	<div>
	                    <h2>Tìm kiếm thiết bị seri</h2>
	                </div>
                    <div class="table-wrapper">
                        <table class="device-table serial-lookup-table">
                            <thead>
                                <tr>
                                    <th>Seri</th>
                                    <th>Thiết bị</th>
                                    <th>Khách hàng</th>
                                    <th>Đơn hàng</th>
                                    <th>Thẻ bảo hành</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${results}">
                                    <tr>
                                        <td>
                                            <div class="serial-meta stacked">
                                                <div>
                                                    <div class="section-title"><c:out value="${item.serialNo}" /></div>
                                                    <span class="serial-badge stock-${fn:toLowerCase(item.stockStatus)}"><c:out value="${item.stockStatus}" /></span>
                                                    <span class="serial-badge serial-status-${fn:toLowerCase(item.serialStatus)}"><c:out value="${item.serialStatus}" /></span>
                                                </div>
                                                <small>ID: ${item.serialId}</small>
                                                <small>Ngày nhập:
                                                    <fmt:formatDate value="${item.importDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </small>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="stacked">
                                                <div class="section-title"><c:out value="${item.deviceName}" /></div>
                                                <small>ID: ${item.deviceId}</small>
                                                <c:if test="${not empty item.categoryName}">
                                                    <small>Category: <c:out value="${item.categoryName}" /></small>
                                                </c:if>
                                                <c:if test="${item.devicePrice ne null}">
                                                    <small>Price:
                                                        <fmt:formatNumber value="${item.devicePrice}" type="number" groupingUsed="true" />
                                                    </small>
                                                </c:if>
                                                <c:if test="${item.warrantyMonth ne null}">
                                                    <small>Warranty: ${item.warrantyMonth} months</small>
                                                </c:if>
                                                <a class="link-btn" href="device-delete?id=${item.deviceId}#device-serial">
                                                    <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                    Device details
                                                </a>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.customerId ne null}">
                                                    <div class="stacked">
                                                        <div class="section-title"><c:out value="${item.customerName}" /></div>
                                                        <small>ID: ${item.customerId}</small>
                                                        <small><c:out value="${item.customerEmail}" /></small>
                                                        <small><c:out value="${item.customerPhone}" /></small>
                                                        <a class="link-btn" href="customer-devices?customerId=${item.customerId}">
                                                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                            Customer devices
                                                        </a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="serial-badge">Not sold</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.orderId ne null}">
                                                    <div class="stacked">
                                                        <div class="section-title">#${item.orderId}</div>
                                                        <span class="serial-badge"><c:out value="${item.orderStatus}" /></span>
                                                        <small>
                                                            <fmt:formatDate value="${item.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </small>
                                                        <a class="link-btn" href="order-history-detail?id=${item.orderId}">
                                                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                            Order details
                                                        </a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="serial-badge">No order</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.warrantyCardId ne null}">
                                                    <div class="stacked">
                                                        <div class="section-title">#${item.warrantyCardId}</div>
                                                        <small>Start:
                                                            <fmt:formatDate value="${item.warrantyStartAt}" pattern="dd/MM/yyyy" />
                                                        </small>
                                                        <small>End:
                                                            <fmt:formatDate value="${item.warrantyEndAt}" pattern="dd/MM/yyyy" />
                                                        </small>
                                                        <span class="serial-badge"><c:out value="${item.warrantyStatusLabel}" /></span>
                                                        <a class="link-btn" href="warranty-details?id=${item.warrantyCardId}">
                                                            <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                            Warranty detail
                                                        </a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="serial-badge">Not assigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-pills">
                            <c:url var="prevUrl" value="device-serial-search">
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="page" value="${currentPage - 1}" />
                            </c:url>
                            <a class="${currentPage == 1 ? 'disabled' : ''}" href="${currentPage == 1 ? '#' : prevUrl}">&#10094;</a>

                            <c:set var="startPage" value="${currentPage - 2}" />
                            <c:set var="endPage" value="${currentPage + 2}" />
                            <c:if test="${startPage < 1}">
                                <c:set var="endPage" value="${endPage + (1 - startPage)}" />
                                <c:set var="startPage" value="1" />
                            </c:if>
                            <c:if test="${endPage > totalPages}">
                                <c:set var="startPage" value="${startPage - (endPage - totalPages)}" />
                                <c:set var="endPage" value="${totalPages}" />
                            </c:if>
                            <c:if test="${startPage < 1}">
                                <c:set var="startPage" value="1" />
                            </c:if>

                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <c:url var="pageUrl" value="device-serial-search">
                                    <c:param name="keyword" value="${keyword}" />
                                    <c:param name="page" value="${i}" />
                                </c:url>
                                <a class="${i == currentPage ? 'active' : ''}" href="${pageUrl}">${i}</a>
                            </c:forEach>

                            <c:url var="nextUrl" value="device-serial-search">
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="page" value="${currentPage + 1}" />
                            </c:url>
                            <a class="${currentPage == totalPages ? 'disabled' : ''}" href="${currentPage == totalPages ? '#' : nextUrl}">&#10095;</a>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
