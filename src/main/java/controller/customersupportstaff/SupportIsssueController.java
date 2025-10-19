package controller.customersupportstaff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerIssue;
import model.CustomerIssueDetail;
import model.User;

import java.io.IOException;
import java.util.List;

import dao.CustomerIssueDao;
import dao.CustomerIssueDetailDao;

/**
 * Servlet implementation class SupportIsssueController
 */
@WebServlet("/support-issues")
public class SupportIsssueController extends HttpServlet {
	private CustomerIssueDao iDao = new CustomerIssueDao();
	private CustomerIssueDetailDao dDao = new CustomerIssueDetailDao();
       
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}

		String action = req.getParameter("action");
		if ("review".equalsIgnoreCase(action)) {
			showReviewDetail(req, resp, staff);
			return;
		}
		List<CustomerIssue> newIssues = iDao.getUnassignedIssues();
		List<CustomerIssue> myIssues = iDao.getIssuesAssignedToStaff(staff.getId());

		req.setAttribute("newIssues", newIssues);
		req.setAttribute("myIssues", myIssues);
		req.getRequestDispatcher("view/admin/supportstaff/issueListPage.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User staff = getUser(request, response);
		if (staff == null) {
			return;
		}

		String action = request.getParameter("action");
		if ("save".equalsIgnoreCase(action)) {
			checkRequest(request, response, staff);
			return;
		} else if ("request_details".equalsIgnoreCase(action)) {
			sendRequestDetails(request, response, staff);
			return;
		}
		response.sendRedirect("support-issues");
	}
	
	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		if(session == null) {
			resp.sendRedirect("login");
			return null;
		}
		User user = (User) session.getAttribute("account");
		if (user == null || user.getRoleId() != 4) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
			return null;
		}
		return user;
	}
	
	private void showReviewDetail(HttpServletRequest req, HttpServletResponse resp, User staff)
			throws ServletException, IOException {
		String id = req.getParameter("id");
		if (id == null) {
			resp.sendRedirect("support-issues");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(id);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("support-issues?notfound=1");
			return;
		}
		
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("support-issues?notfound=1");
			return;
		}

		if (issue.getSupportStaffId() == 0) {
			iDao.assignIssueIfAvailable(issueId, staff.getId());
			issue = iDao.getIssueById(issueId);
		} else if (issue.getSupportStaffId() != staff.getId()) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		CustomerIssueDetail d = dDao.getByIssueId(issueId);
		req.setAttribute("issue", issue);
		req.setAttribute("issueDetail", d);
		req.setAttribute("awaitingCustomer", "awaiting_customer".equalsIgnoreCase(issue.getSupportStatus()));
		req.getRequestDispatcher("view/admin/supportstaff/issueReviewPage.jsp").forward(req, resp);
	}
	
	private void checkRequest(HttpServletRequest req, HttpServletResponse resp, User staff) throws IOException, ServletException {
		String issueIdParam = req.getParameter("issueId");
		if (issueIdParam == null) {
			resp.sendRedirect("support-issues");
			return;
		}

		int issueId = Integer.parseInt(issueIdParam);
		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("support-issues?notfound=1");
			return;
		}

		if (issue.getSupportStaffId() != 0 && issue.getSupportStaffId() != (staff.getId())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		String customerName = req.getParameter("customerName");
		String contactEmail = req.getParameter("contactEmail");
		String contactPhone = req.getParameter("contactPhone");
		String deviceSerial = req.getParameter("deviceSerial");
		String summary = req.getParameter("summary");
		boolean forward = "on".equalsIgnoreCase(req.getParameter("forwardToManager"));

		if (customerName == null || customerName.trim().isEmpty()) {
			req.setAttribute("error", "Vui lòng nhập tên khách hàng.");
			req.setAttribute("issue", issue);
			req.setAttribute("issueDetail", dDao.getByIssueId(issueId));
			req.setAttribute("awaitingCustomer", "awaiting_customer".equalsIgnoreCase(issue.getSupportStatus()));
			req.getRequestDispatcher("view/admin/supportstaff/issueReviewPage.jsp").forward(req, resp);
			return;
		}

		CustomerIssueDetail d = new CustomerIssueDetail();
		d.setIssueId(issueId);
		d.setSupportStaffId(staff.getId());
		d.setCustomerFullName(customerName.trim());
		d.setContactEmail(contactEmail != null ? contactEmail.trim() : null);
		d.setContactPhone(contactPhone != null ? contactPhone.trim() : null);
		d.setDeviceSerial(deviceSerial != null ? deviceSerial.trim() : null);
		d.setSummary(summary != null ? summary.trim() : null);
		d.setForwardToManager(forward);

		dDao.saveIssueDetail(d);
		iDao.updateSupportStatus(issueId, staff.getId(), forward ? "submitted" : "in_progress");
		resp.sendRedirect("support-issues?saved=1");
	}
	
	private void sendRequestDetails(HttpServletRequest req, HttpServletResponse resp, User staff)
			throws IOException {
		String issueIdParam = req.getParameter("issueId");
		if (issueIdParam == null) {
			resp.sendRedirect("support-issues");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("support-issues?notfound=1");
			return;
		}

		CustomerIssue issue = iDao.getIssueById(issueId);
		if (issue == null) {
			resp.sendRedirect("support-issues?notfound=1");
			return;
		}

		if (issue.getSupportStaffId() == 0) {
			iDao.assignIssueIfAvailable(issueId, staff.getId());
		} else if (issue.getSupportStaffId() != (staff.getId())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		iDao.updateSupportStatus(issueId, staff.getId(), "awaiting_customer");
		resp.sendRedirect("support-issues?action=review&id=" + issueId + "&requested=1");
	}

}
