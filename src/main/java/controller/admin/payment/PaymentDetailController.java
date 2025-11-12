package controller.admin.payment;

import dao.PaymentDAO;
import model.OrderDetail;
import model.Payment;
import model.User;
import utils.AuthorizationUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/payment-detail")
public class PaymentDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	User currentUser = AuthorizationUtils.requirePermission(req, resp, "Quản Lí Thanh Toán");
        if (currentUser == null) {
            return;
        }
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect("payment-list");
            return;
        }
        
        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            resp.sendRedirect("payment-list");
            return;
        }

        int id = Integer.parseInt(idParam);
        int orderId = Integer.parseInt(orderIdParam);
        PaymentDAO dao = new PaymentDAO();
        Payment payment = dao.getPaymentById(id);
        List<OrderDetail> details = dao.getOrderDetailsByOrderId(orderId);

        req.setAttribute("payment", payment);
        req.setAttribute("details", details);
        req.getRequestDispatcher("/view/admin/paymentmanagement/payment-detail.jsp").forward(req, resp);
    }
}

