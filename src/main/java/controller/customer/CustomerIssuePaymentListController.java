package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.IssuePaymentDAO;
import model.IssuePayment;
import model.User;

@WebServlet("/customer/issue-payments")
public class CustomerIssuePaymentListController extends HttpServlet {
    private IssuePaymentDAO dao = new IssuePaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("account");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String status = req.getParameter("status");
            String keyword = req.getParameter("keyword");
            int page = 1;
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }

            List<IssuePayment> payments = dao.getPaymentsByCustomer(currentUser.getId(), status, keyword, page);
            int totalCount = dao.countPaymentsByCustomer(currentUser.getId(), status, keyword);
            int totalPages = (int) Math.ceil(totalCount / 10.0);

            req.setAttribute("payments", payments);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("status", status);
            req.setAttribute("keyword", keyword);

            req.getRequestDispatcher("/view/customer/issuePaymentList.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi server: " + e.getMessage());
        }
    }
}
