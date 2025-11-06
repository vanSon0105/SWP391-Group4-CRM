package controller.technicalstaff;

import java.io.IOException;

import dao.CustomerIssueDAO;
import dao.IssuePaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CustomerIssue;
import model.IssuePayment;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/technical-billing")
public class TechnicalBillingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IssuePaymentDAO paymentDao = new IssuePaymentDAO();
	private CustomerIssueDAO issueDao = new CustomerIssueDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}

		Integer issueId = parseIssueId(req, resp);
		if (issueId == null) {
			return;
		}

		CustomerIssue issue = issueDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("technical-issues?notfound=1");
			return;
		}

		boolean warrantyIssue = "warranty".equalsIgnoreCase(issue.getIssueType());

		if (!paymentDao.hasStaffOwnership(issueId, staff.getId())) {
			resp.sendRedirect("technical-issues?forbidden=1");
			return;
		}

		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment != null && !payment.isAwaitingSupport()) {
			resp.sendRedirect("technical-issues?billLocked=1");
			return;
		}

		req.setAttribute("issue", issue);
		req.setAttribute("warrantyIssue", warrantyIssue);
		req.setAttribute("payment", payment);
		req.getRequestDispatcher("view/admin/technicalstaff/issueBilling.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}

		Integer issueId = parseIssueId(req, resp);
		if (issueId == null) {
			return;
		}

		CustomerIssue issue = issueDao.getIssueById(issueId);
		if (issue == null ) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}
		
		boolean warrantyIssue = "warranty".equalsIgnoreCase(issue.getIssueType());

		if (!paymentDao.hasStaffOwnership(issueId, staff.getId())) {
			resp.sendRedirect("technical-issues?forbidden=1");
			return;
		}

		String amountRaw = req.getParameter("amount");
		String note = req.getParameter("note");

		double amount;
		if (warrantyIssue) {
			amount = 0.0;
		} else {
			try {
				amount = Double.parseDouble(amountRaw);
			} catch (NumberFormatException ex) {
				req.setAttribute("error", "Giá trị thanh toán không hợp lệ");
				req.setAttribute("issue", issue);
				req.setAttribute("warrantyIssue", warrantyIssue);
				req.setAttribute("payment", paymentDao.getByIssueId(issueId));
				req.getRequestDispatcher("view/admin/technicalstaff/issueBilling.jsp").forward(req, resp);
				return;
			}
	
			if (amount <= 0) {
				req.setAttribute("error", "Số tiền phải lớn hơn 0");
				req.setAttribute("issue", issue);
				req.setAttribute("warrantyIssue", warrantyIssue);
				req.setAttribute("payment", paymentDao.getByIssueId(issueId));
				req.getRequestDispatcher("view/admin/technicalstaff/issueBilling.jsp").forward(req, resp);
				return;
			}
		}

		if (note != null && note.length() > 500) {
			req.setAttribute("error", "Ghi chú không được vượt quá 500 ký tự");
			req.setAttribute("warrantyIssue", warrantyIssue);
			req.setAttribute("issue", issue);
			req.setAttribute("payment", paymentDao.getByIssueId(issueId));
			req.getRequestDispatcher("view/admin/technicalstaff/issueBilling.jsp").forward(req, resp);
			return;
		}

		IssuePayment updated = paymentDao.createOrUpdateDraft(issueId, staff.getId(), amount, note != null ? note.trim() : null);
		if (updated == null) {
			req.setAttribute("error", "Lưu thất bại. Vui lòng thử lại");
			req.setAttribute("issue", issue);
			req.setAttribute("warrantyIssue", warrantyIssue);
			req.setAttribute("payment", paymentDao.getByIssueId(issueId));
			req.getRequestDispatcher("view/admin/technicalstaff/issueBilling.jsp").forward(req, resp);
			return;
		}

		resp.sendRedirect("technical-issues?billCreated=1");
	}

	private Integer parseIssueId(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String issueIdParam = req.getParameter("issueId");
		if (issueIdParam == null) {
			resp.sendRedirect("technical-issues");
			return null;
		}
		try {
			return Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("technical-issues?invalid=1");
			return null;
		}
	}

	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "PROCESS_TASK");
	}
}
