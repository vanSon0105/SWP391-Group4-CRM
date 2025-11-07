package controller.admin;

import dao.PaymentDAO;
import model.OrderDetail;
import model.Payment;

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
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect("payment-list");
            return;
        }

        int id = Integer.parseInt(idParam);
        PaymentDAO dao = new PaymentDAO();
        Payment payment = dao.getPaymentById(id);
        List<OrderDetail> details = dao.getOrderDetailsByOrderId(id);

        req.setAttribute("payment", payment);
        req.setAttribute("details", details);
        req.getRequestDispatcher("/view/admin/paymentmanagement/payment-detail.jsp").forward(req, resp);
    }
}

