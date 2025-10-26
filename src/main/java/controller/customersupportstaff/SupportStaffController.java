package controller.customersupportstaff;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CustomerIssueDAO;
import model.CustomerIssue;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/support-staff")
public class SupportStaffController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = AuthorizationUtils.requirePermission(req, resp, "CUSTOMER_ISSUES_RESPONDING");
		if (staff == null) {
			return;
		}

		HttpSession session = req.getSession(false);
		Set<String> permissions = AuthorizationUtils.ensurePermissionsLoaded(session, staff.getId());

		CustomerIssueDAO issueDAO = new CustomerIssueDAO();

		List<CustomerIssue> newIssues = issueDAO.getUnassignedIssues();
		List<CustomerIssue> myIssues = issueDAO.getIssuesAssignedToStaff(staff.getId());
		List<CustomerIssue> awaitingCustomerIssues = issueDAO.getIssuesBySupportStatus("awaiting_customer");
		List<CustomerIssue> managerReviewIssues = issueDAO
				.getIssuesBySupportStatuses(new String[] { "manager_review", "submitted" });
		List<CustomerIssue> resolvedIssues = issueDAO.getIssuesBySupportStatus("resolved");

		int awaitingCustomerCount = 0;
		int inProgressCount = 0;

		for (CustomerIssue i : myIssues) {
		    String s = i.getSupportStatus();
		    if ("awaiting_customer".equalsIgnoreCase(s)) {
		    	awaitingCustomerCount++;
		    }else if ("in_progress".equalsIgnoreCase(s)) {
		    	inProgressCount++;
		    }
		}


		req.setAttribute("account", staff);
		req.setAttribute("permissions", permissions);
		req.setAttribute("newIssueCount", newIssues.size());
		req.setAttribute("myIssueCount", myIssues.size());
		req.setAttribute("awaitingCustomerCount", awaitingCustomerCount);
		req.setAttribute("inProgressCount", inProgressCount);
		req.setAttribute("managerReviewCount", managerReviewIssues.size());
		req.setAttribute("resolvedIssueCount", resolvedIssues.size());

		req.setAttribute("newIssuesPreview", newIssues.stream().limit(5).collect(Collectors.toList()));
		req.setAttribute("myIssuesPreview", myIssues.stream().limit(5).collect(Collectors.toList()));
		req.setAttribute("awaitingCustomerPreview",
				awaitingCustomerIssues.stream().limit(5).collect(Collectors.toList()));

		req.getRequestDispatcher("view/admin/supportstaff/index.jsp").forward(req, resp);
	}
}
