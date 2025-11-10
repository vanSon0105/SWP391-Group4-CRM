package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import dao.IssuePaymentDAO;
import model.IssuePayment;


@WebServlet("/issue-payment-detail")
public class IssuePaymentDetailController extends HttpServlet {
    private IssuePaymentDAO paymentDAO = new IssuePaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("issue-payments");
            return;
        }

        int id = Integer.parseInt(idParam);
        IssuePayment payment = paymentDAO.getByIssueId(id);
        if (payment == null) {
            request.setAttribute("error", "Không tìm thấy thanh toán!");
        } else {
            request.setAttribute("payment", payment);
        }

        request.getRequestDispatcher("/view/admin/paymentmanagement/issuePaymentDetail.jsp")
               .forward(request, response);
    }
}
