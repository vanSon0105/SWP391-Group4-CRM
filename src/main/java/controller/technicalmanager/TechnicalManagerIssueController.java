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
import utils.AuthorizationUtils;

import java.io.IOException;
import java.util.List;

import dao.CustomerIssueDAO;
import dao.CustomerIssueDetailDAO;



/**
 * Servlet implementation class TechnicalManagerIssueController
 */
@WebServlet("/manager-issues")
public class TechnicalManagerIssueController extends HttpServlet {

	private CustomerIssueDAO iDao = new CustomerIssueDAO();
	private CustomerIssueDetailDAO dDao = new CustomerIssueDetailDAO();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User manager = getUser(request, response);
		if (manager == null) {
			return;
		}

		String action = request.getParameter("action");
		if ("review".equalsIgnoreCase(action)) {
			showReview(request, response);
			return;
		}

		List<CustomerIssue> pendingIssues = iDao.getIssuesAwaitingManagerReview();
		List<CustomerIssue> approvedIssues = iDao.getIssuesBySupportStatuses(
				new String[] { "manager_approved", "task_created", "tech_in_progress", "resolved" });
		List<CustomerIssue> rejectedIssues = iDao.getIssuesBySupportStatus("manager_rejected");

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

		String status = issue.getSupportStatus();
		if (status == null || (!"submitted".equalsIgnoreCase(status) && !"manager_review".equalsIgnoreCase(status))) {
			resp.sendRedirect("manager-issues?invalid=1");
			return;
		}

		CustomerIssueDetail d = dDao.getByIssueId(issueId);
		req.setAttribute("issue", issue);
		req.setAttribute("issueDetail", d);
		req.getRequestDispatcher("view/admin/technicalmanager/issueReviewPage.jsp").forward(req, resp);
	}
	
	private void handleApprove(HttpServletRequest req, HttpServletResponse resp, int issueId) throws IOException {
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("manager-issues?notfound=1");
			return;
		}

		iDao.updateSupportStatus(issueId, "manager_approved");
		resp.sendRedirect("task-form?issueId=" + issueId + "&fromReview=1");
	}
	
	private void handleReject(HttpServletRequest req, HttpServletResponse resp, int issueId) throws IOException {
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("manager-issues?notfound=1");
			return;
		}

		iDao.updateSupportStatus(issueId, "manager_rejected");
		resp.sendRedirect("manager-issues?rejected=1");
	}
}
