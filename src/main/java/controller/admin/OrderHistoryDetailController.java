package controller.admin;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Order;
import model.OrderDetail;
import model.User;
import utils.AuthorizationUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-history-detail")
public class OrderHistoryDetailController extends HttpServlet {

	 private OrderDAO orderDAO = new OrderDAO();
	 private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	User currentUser = AuthorizationUtils.requirePermission(request, response, "Quản Lí Đặt Hàng");
        if (currentUser == null) {
            return; 
        }
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));

            
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);

            if (order == null) {
                request.setAttribute("errorMessage", "Đơn hàng không tồn tại!");
                request.getRequestDispatcher("/view/admin/orderhistory/order-history-detail.jsp").forward(request, response);
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);

            request.getRequestDispatcher("/view/admin/orderhistory/order-history-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("order-tracking");
        }
    }
}
