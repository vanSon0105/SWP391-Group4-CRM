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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/transaction-detail")
public class TransactionDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final TransactionDetailDAO detailDAO = new TransactionDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = AuthorizationUtils.requirePermission(request, response, "Quản Lí Giao Dịch");
        if (currentUser == null) return;

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/transactions");
            return;
        }

        int transactionId;
        try {
            transactionId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/transactions");
            return;
        }

        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        if (transaction == null) {
            request.setAttribute("error", "Giao dịch không tồn tại!");
            request.getRequestDispatcher("/view/transaction/listTransaction.jsp").forward(request, response);
            return;
        }

        List<TransactionDetail> details = detailDAO.getTransactionDetailsByTransactionId(transactionId);

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

        transaction.setDetails(mergedDetails);

        request.setAttribute("transaction", transaction);
        request.getRequestDispatcher("/view/transaction/viewTransaction.jsp").forward(request, response);
    }
}
