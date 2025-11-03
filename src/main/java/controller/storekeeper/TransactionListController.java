package controller.storekeeper;

import dao.TransactionDAO;
import model.Transaction;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/transactions")
public class TransactionListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = AuthorizationUtils.requirePermission(request, response, "WAREHOUSE_TRANSACTION_MANAGEMENT");
        if (currentUser == null) return;

        String typeFilter = request.getParameter("type");
        String statusFilter = request.getParameter("status");
        String keyword = request.getParameter("keyword");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<Transaction> transactions = transactionDAO.getTransactions(typeFilter, statusFilter, keyword, offset, PAGE_SIZE);
        if (transactions == null) transactions = new ArrayList<>();

        int totalRecords = transactionDAO.countTransactions(typeFilter, statusFilter, keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("transactions", transactions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "");
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.setAttribute("keyword", keyword != null ? keyword : "");

        request.getRequestDispatcher("/view/transaction/listTransaction.jsp").forward(request, response);
    }
}
