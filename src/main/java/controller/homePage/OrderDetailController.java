package controller.homePage;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Order;
import model.OrderDetail;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("order-tracking");
            return;
        }

        int orderId = Integer.parseInt(idStr);

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            request.setAttribute("error", "Đơn hàng không tồn tại");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        List<OrderDetail> items = orderDetailDAO.getOrderDetailsByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("items", items);

        request.getRequestDispatcher("view/homepage/orderDetail.jsp").forward(request, response);
    }
}