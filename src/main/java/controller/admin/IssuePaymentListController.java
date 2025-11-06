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

@WebServlet("/issue-payments")
public class IssuePaymentListController extends HttpServlet {
    private IssuePaymentDAO dao = new IssuePaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String status = req.getParameter("status");
            String sortField = req.getParameter("sortField");
            String search = req.getParameter("search");
            int page = 1;
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }

            List<IssuePayment> payments = dao.getPayments(status, sortField, page, search);
            int totalCount = dao.countPayments(status, search);
            int totalPages = (int) Math.ceil(totalCount / 10.0);
            
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("payments", payments);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("status", status);
            req.setAttribute("sortField", sortField);
            req.setAttribute("search", search);

            req.getRequestDispatcher("view/admin/paymentmanagement/issuePaymentListPage.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi server: " + e.getMessage());
        }
    }
}
