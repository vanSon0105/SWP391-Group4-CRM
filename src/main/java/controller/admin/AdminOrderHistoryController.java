package controller.admin;

import dao.OrderDAO;
import model.OrderHistory;
import model.User;
import utils.AuthorizationUtils;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/order-history")
public class AdminOrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "Quản Lí Đặt Hàng");
        if (currentUser == null) {
            return; 
        }
        try {
            OrderDAO orderDAO = new OrderDAO();
            List<OrderHistory> allOrders = orderDAO.getAllOrderHistories();

            String statusFilter = request.getParameter("status");
            List<OrderHistory> filteredOrders = allOrders;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                filteredOrders = filteredOrders.stream()
                        .filter(o -> statusFilter.equalsIgnoreCase(o.getStatus()))
                        .collect(Collectors.toList());
            }

            String customerName = request.getParameter("customerName");
            if (customerName != null && !customerName.isEmpty()) {
                filteredOrders = filteredOrders.stream()
                        .filter(o -> o.getCustomerName().toLowerCase().contains(customerName.toLowerCase()))
                        .collect(Collectors.toList());
            }

            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            final LocalDate fromDate = (fromDateStr != null && !fromDateStr.isEmpty()) ? LocalDate.parse(fromDateStr, formatter) : null;
            final LocalDate toDate = (toDateStr != null && !toDateStr.isEmpty()) ? LocalDate.parse(toDateStr, formatter) : null;

            if (fromDate != null || toDate != null) {
                filteredOrders = filteredOrders.stream()
                    .filter(o -> {
                        Timestamp orderDateObj = o.getDate(); 
                        LocalDate orderDate = orderDateObj.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

                        boolean afterFrom = fromDate == null || !orderDate.isBefore(fromDate);
                        boolean beforeTo = toDate == null || !orderDate.isAfter(toDate);
                        return afterFrom && beforeTo;
                    })
                    .collect(Collectors.toList());
            }

           
            String sortAmount = request.getParameter("sortAmount");
            if (sortAmount != null && !sortAmount.isEmpty()) {
                Comparator<OrderHistory> amountComparator = Comparator.comparing(OrderHistory::getTotalAmount);
                if (sortAmount.equalsIgnoreCase("desc")) {
                    amountComparator = amountComparator.reversed();
                }
                filteredOrders = filteredOrders.stream()
                        .sorted(amountComparator)
                        .collect(Collectors.toList());
            }

            int page = 1;
            int pageSize = 10;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int totalOrders = filteredOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalOrders);
            List<OrderHistory> ordersPage = filteredOrders.subList(start, end);

            request.setAttribute("orderList", ordersPage);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);

            request.getRequestDispatcher("/view/admin/orderhistory/order-history.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy lịch sử đặt hàng");
        }
    }
}
