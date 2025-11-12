package controller.storekeeper;

import dao.TransactionDAO;
import dao.TransactionDetailDAO;
import model.Transaction;
import model.TransactionDetail;
import model.User;
import utils.AuthorizationUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/transactions")
public class TransactionListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final TransactionDetailDAO detailDAO = new TransactionDetailDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = AuthorizationUtils.requirePermission(request, response, "Quản Lí Giao Dịch");
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

        for (Transaction t : transactions) {
            List<TransactionDetail> details = detailDAO.getTransactionDetailsByTransactionId(t.getId());
            List<TransactionDetail> mergedDetails = new ArrayList<>();
            for (TransactionDetail d : details) {
                boolean found = false;
                for (TransactionDetail md : mergedDetails) {
                    if (md.getDeviceName() != null && md.getDeviceName().equals(d.getDeviceName())) {
                        md.setQuantity(md.getQuantity() + d.getQuantity());
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    TransactionDetail td = new TransactionDetail();
                    td.setDeviceName(d.getDeviceName());
                    td.setQuantity(d.getQuantity());
                    mergedDetails.add(td);
                }
            }

            t.setDetails(mergedDetails);
        }

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