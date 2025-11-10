package controller.admin;

import java.io.IOException;

import dao.CustomerIssueDAO;
import dao.IssuePaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.IssuePayment;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/issue-payment-detail")
public class IssuePaymentDetailController extends HttpServlet {
    private final IssuePaymentDAO paymentDAO = new IssuePaymentDAO();
    private final CustomerIssueDAO issueDAO = new CustomerIssueDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User admin = AuthorizationUtils.requirePermission(request, response, "PAYMENT_REPORTS");
        if (admin == null) {
            return;
        }

        applyFlash(request);

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("issue-payments");
            return;
        }

        int paymentId;
        try {
            paymentId = Integer.parseInt(idParam);
        } catch (NumberFormatException ex) {
            response.sendRedirect("issue-payments");
            return;
        }

        IssuePayment payment = paymentDAO.getById(paymentId);
        if (payment == null) {
            request.setAttribute("error", "Không tìm thấy thanh toán!");
        } else {
            request.setAttribute("payment", payment);
        }

        request.getRequestDispatcher("/view/admin/paymentmanagement/issuePaymentDetail.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User admin = AuthorizationUtils.requirePermission(request, response, "PAYMENT_REPORTS");
        if (admin == null) {
            return;
        }

        String action = request.getParameter("action");
        String paymentIdParam = request.getParameter("paymentId");
        if (action == null || paymentIdParam == null) {
            response.sendRedirect("issue-payments");
            return;
        }

        int paymentId;
        try {
            paymentId = Integer.parseInt(paymentIdParam);
        } catch (NumberFormatException ex) {
            response.sendRedirect("issue-payments");
            return;
        }

        IssuePayment payment = paymentDAO.getById(paymentId);
        if (payment == null) {
            setFlash(request, "error", "Thanh toán không tồn tại hoặc đã bị xóa.");
            response.sendRedirect("issue-payments");
            return;
        }

        if ("confirm".equalsIgnoreCase(action)) {
            if (!payment.isAwaitingAdmin()) {
                setFlash(request, "error", "Thanh toán không ở trạng thái chờ xác nhận.");
                response.sendRedirect("issue-payment-detail?id=" + paymentId);
                return;
            }

            boolean confirmed = paymentDAO.confirmPaymentByAdmin(payment.getId(), admin.getId());
            if (!confirmed) {
                setFlash(request, "error", "Không thể xác nhận thanh toán. Vui lòng thử lại.");
                response.sendRedirect("issue-payment-detail?id=" + paymentId);
                return;
            }

            issueDAO.updateSupportStatus(payment.getIssueId(), "resolved");
            setFlash(request, "success", "Đã xác nhận thanh toán #" + payment.getId());
            response.sendRedirect("issue-payment-detail?id=" + paymentId);
            return;
        }

        response.sendRedirect("issue-payment-detail?id=" + paymentId);
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("issuePaymentFlashType", type);
        session.setAttribute("issuePaymentFlashMessage", message);
    }

    private void applyFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object message = session.getAttribute("issuePaymentFlashMessage");
        if (message != null) {
            request.setAttribute("flashMessage", message);
            request.setAttribute("flashType", session.getAttribute("issuePaymentFlashType"));
            session.removeAttribute("issuePaymentFlashMessage");
            session.removeAttribute("issuePaymentFlashType");
        }
    }
}
