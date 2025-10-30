package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerIssue;
import model.CustomerIssueDetail;
import model.User;
import model.WarrantyCard;
import utils.AuthorizationUtils;

import java.io.IOException;
import java.util.List;

import dao.CustomerIssueDAO;
import dao.CustomerIssueDetailDAO;
import dao.DeviceSerialDAO;
import dao.WarrantyCardDAO;



/**
 * Servlet implementation class TechnicalManagerIssueController
 */
@WebServlet("/manager-issues")
public class TechnicalManagerIssueController extends HttpServlet {
	private CustomerIssueDAO iDao = new CustomerIssueDAO();
	private CustomerIssueDetailDAO dDao = new CustomerIssueDetailDAO();
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	private WarrantyCardDAO wDao = new WarrantyCardDAO();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User manager = getUser(request, response);
		if (manager == null) {
			return;
		}

		String action = request.getParameter("action");
		if ("review".equalsIgnoreCase(action)) {
			showReview(request, response);
			return;
		}else if ("check_warranty".equalsIgnoreCase(action)) {
			showWarranty(request, response);
			return;
		}

		List<CustomerIssue> pendingIssues = iDao.getIssuesBySupportStatuses(new String[] { "submitted", "manager_review" });
		List<CustomerIssue> approvedIssues = iDao.getIssuesBySupportStatuses(
				new String[] { "manager_approved", "task_created", "tech_in_progress", "resolved" });
		List<CustomerIssue> rejectedIssues = iDao.getIssuesBySupportStatuses(
                new String[] { "manager_rejected", "customer_cancelled" });

		request.setAttribute("pendingIssues", pendingIssues);
		request.setAttribute("approvedIssues", approvedIssues);
		request.setAttribute("rejectedIssues", rejectedIssues);
		request.getRequestDispatcher("view/admin/technicalmanager/issueListPage.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User manager = getUser(request, response);
		if (manager == null) {
			return;
		}

		String action = request.getParameter("action");
		String issueIdParam = request.getParameter("issueId");
		if (issueIdParam == null) {
			response.sendRedirect("manager-issues");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			response.sendRedirect("manager-issues?invalid=1");
			return;
		}

		if ("approve".equalsIgnoreCase(action)) {
			handleApprove(request, response, issueId);
			return;
		} else if ("reject".equalsIgnoreCase(action)) {
			handleReject(request, response, issueId);
			return;
		}

		response.sendRedirect("manager-issues");
	}
	
	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "CUSTOMER_ISSUES_MANAGEMENT");
	}
	
	private void showWarranty(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String issueIdParam = req.getParameter("id");
		if (issueIdParam == null) {
			resp.sendRedirect("manager-issues");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("manager-issues?invalid=1");
			return;
		}

		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue != null && issue.getWarrantyCardId() > 0) {
			WarrantyCard warranty = wDao.getById(issue.getWarrantyCardId());
			req.setAttribute("warrantyInfo", warranty);
			req.setAttribute("currentDate", new java.util.Date());
		}

		showReview(req, resp);
	}
	
	private void showReview(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String issueIdParam = req.getParameter("id");
		if (issueIdParam == null) {
			resp.sendRedirect("manager-issues");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("manager-issues?invalid=1");
			return;
		}

		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("manager-issues?notfound=1");
			return;
		}

		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		String status = issue.getSupportStatus();
		if (status == null || (!"submitted".equalsIgnoreCase(status) && !"manager_review".equalsIgnoreCase(status))) {
			resp.sendRedirect("manager-issues?invalid=1");
			return;
		}

		CustomerIssueDetail d = dDao.getByIssueId(issueId, serialNo);
		req.setAttribute("issue", issue);
		req.setAttribute("issueDetail", d);
		if (req.getAttribute("rejectReasonDraft") == null) {
			req.setAttribute("rejectReasonDraft", issue.getFeedback());
		}
		req.getRequestDispatcher("view/admin/technicalmanager/issueReviewPage.jsp").forward(req, resp);
	}
	
	private void handleApprove(HttpServletRequest req, HttpServletResponse resp, int issueId) throws IOException {
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("manager-issues?notfound=1");
			return;
		}

		iDao.updateFeedback(issueId, null);
		iDao.updateSupportStatus(issueId, "manager_approved");
		resp.sendRedirect("task-form?issueId=" + issue.getId());
	}
	
	private void handleReject(HttpServletRequest req, HttpServletResponse resp, int issueId) throws ServletException, IOException {
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("manager-issues?notfound=1");
			return;
		}
		String reason = req.getParameter("rejectReason");
		String feedBack = reason != null ? reason.trim() : null;
		if (feedBack == null || feedBack.isEmpty()) {
			req.setAttribute("errorRejectReason", "Vui lòng nhập lý do từ chối.");
			req.setAttribute("rejectReasonDraft", reason);
			req.setAttribute("issueId", issueId);
			showReview(req, resp);
			return;
		}

		iDao.updateFeedback(issueId, feedBack);
		iDao.updateSupportStatus(issueId, "manager_rejected");
		resp.sendRedirect("manager-issues?rejected=1");
	}
}
