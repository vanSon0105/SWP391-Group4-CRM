package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dao.OrderDAO;
import model.Order;
import model.User;

@WebServlet("/order-tracking")
public class OrderTrackingController extends HttpServlet {
    private static final int PAGE_SIZE = 5;
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        int customerId = user.getId();

        String status = request.getParameter("status");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");
        String pageParam = request.getParameter("page");

        int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<Order> orders = orderDAO.getOrdersByCustomerWithFilter(customerId, status, sortField, PAGE_SIZE, offset);
        int totalOrders = orderDAO.countOrdersByCustomerWithFilter(customerId, status);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);
        int overallOrderCount = orderDAO.countOrdersByCustomerWithFilter(customerId, null);
        int totalPurchasedDevices = orderDAO.getTotalDevicesPurchasedByCustomer(customerId);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("overallOrderCount", overallOrderCount);
        request.setAttribute("totalPurchasedDevices", totalPurchasedDevices);
        request.setAttribute("status", status);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("view/homepage/order-tracking.jsp").forward(request, response);
    }
}
