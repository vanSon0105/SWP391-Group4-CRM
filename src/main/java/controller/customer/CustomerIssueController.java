package controller.customer;

import java.io.IOException;
import java.util.List;

import dao.CustomerIssueDAO;
import dao.CustomerIssueDetailDAO;
import dao.DeviceSerialDAO;
import dao.TaskDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerDevice;
import model.CustomerIssue;
import model.CustomerIssueDetail;
import model.TaskDetail;
import model.User;
import utils.AuthorizationUtils;

@WebServlet({"/issue", "/create-issue", "/issue-fill", "/issue-detail"})
public class CustomerIssueController extends HttpServlet {
	private CustomerIssueDAO ciDao = new CustomerIssueDAO();
	private CustomerIssueDetailDAO dDao = new CustomerIssueDetailDAO();
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	private TaskDetailDAO tdDao = new TaskDetailDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		User u = getUser(req, resp);
		if (u == null) return;
		switch (path) {
		case "/create-issue":
			List<CustomerDevice> list = ciDao.getCustomerDevices(u.getId());
			req.setAttribute("list", list);
			req.getRequestDispatcher("view/customer/issuePage.jsp").forward(req, resp);
			break;
		case "/issue-fill":
			forwardCustomerDetailsFill(req, resp, u);
			break;
		case "/issue-detail":
			forwardCustomerTaskDetails(req, resp, u);
			break;
		default:
			List<CustomerIssue> listIssue = ciDao.getIssuesByUserId(u.getId());
			req.setAttribute("list", listIssue);
			req.getRequestDispatcher("view/customer/issueListPage.jsp").forward(req, resp);
			break;
		}	
	}
	

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User u = getUser(req, resp);
		if (u == null) {
			return;
		}
		String path = req.getServletPath();
		switch (path) {
		case "/create-issue":
			handleCreate(req, resp, u);
			break;
		case "/issue-fill":
			sendCustomerDetails(req, resp, u);
			break;
		default:
			resp.sendRedirect("issue");
			break;
		}
	}
	

	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "CUSTOMER_ISSUES");
	}

	private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User u)
			throws IOException, ServletException {
		String title = req.getParameter("title");
		String description = req.getParameter("description");
		
		if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty()) {
			handleCreateError(req, resp, u, "Vui lòng nhập đầy đủ tiêu đề và mô tả sự cố!");
			return;
		}
		
		if(title.length() >= 100) {
			handleCreateError(req, resp, u, "Tiêu đề không được vượt quá 100 ký tự!");
			return;
		}
		
		if(description.length() >= 1000) {
			handleCreateError(req, resp, u, "Mô tả không được vượt quá 1000 ký tự!");
			return;
		}
		String warrantyCardIdParam = req.getParameter("warrantyCardId");
		String issueType = req.getParameter("issueType");

		int warrantyId = 0;
		if (warrantyCardIdParam != null && !warrantyCardIdParam.trim().isEmpty()) {
			try {
				warrantyId = Integer.parseInt(warrantyCardIdParam.trim());
			} catch (NumberFormatException ex) {
				req.setAttribute("error", "Mã bảo hành không hợp lệ.");
				List<CustomerDevice> list = ciDao.getCustomerDevices(u.getId());
				req.setAttribute("list", list);
				req.getRequestDispatcher("view/customer/issuePage.jsp").forward(req, resp);
				return;
			}
		}

		boolean check = ciDao.createIssue(u.getId(), title.trim(), description.trim(), issueType, warrantyId);
		if (check) {
			resp.sendRedirect("issue?created=1");
		} else {
			req.setAttribute("error", "Không thể gửi yêu cầu. Vui lòng thử lại sau.");
			resp.sendRedirect("issue");
		}
	}
	
	private void forwardCustomerDetailsFill(HttpServletRequest req, HttpServletResponse resp, User customer)
			throws ServletException, IOException {
		String issueIdParam = req.getParameter("id");
		if (issueIdParam == null) {
			resp.sendRedirect("issue");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}

		CustomerIssue issue = ciDao.getIssueById(issueId);
		if (issue == null || issue.getCustomerId() != customer.getId()) {
			resp.sendRedirect("issue?notfound=1");
			return;
		}

		if (issue.getSupportStatus() == null || !"awaiting_customer".equalsIgnoreCase(issue.getSupportStatus())) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}
		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		CustomerIssueDetail d = dDao.getByIssueId(issueId, serialNo);
		if (d == null) {
			d = new CustomerIssueDetail();
		}

		req.setAttribute("issue", issue);
		req.setAttribute("form", d);
		req.getRequestDispatcher("view/customer/issueDetailPage.jsp").forward(req, resp);
	}
	
	private void sendCustomerDetails(HttpServletRequest req, HttpServletResponse resp, User customer)
			throws ServletException, IOException {
		String issueIdParam = req.getParameter("issueId");
		if (issueIdParam == null) {
			resp.sendRedirect("issue");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(issueIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}
		
		CustomerIssue issue = ciDao.getIssueById(issueId);
		if (issue == null || issue.getCustomerId() != customer.getId()) {
			resp.sendRedirect("issue?notfound=1");
			return;
		}

		String status = issue.getSupportStatus();

		if ("1".equals(req.getParameter("cancel"))) {
			ciDao.updateSupportStatus(issueId, "customer_cancelled");
			resp.sendRedirect("issue?cancelled=1");
			return;
		}

		if (status == null || !"awaiting_customer".equalsIgnoreCase(status)) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}

		req.setAttribute("issue", issue);

		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		int staffId = issue.getSupportStaffId();
		if (staffId == 0) {
			req.setAttribute("error", "Yêu cầu chưa được nhân viên hỗ trợ tiếp nhận. Vui lòng thử lại sau.");
			req.setAttribute("issueDetail", dDao.getByIssueId(issueId, serialNo));
			req.getRequestDispatcher("view/customer/issueDetailPage.jsp").forward(req, resp);
			return;
		}

		String customerName = req.getParameter("customerName");
		String contactEmail = req.getParameter("contactEmail");
		String contactPhone = req.getParameter("contactPhone");
		String deviceSerial = req.getParameter("deviceSerial");
		String summary = req.getParameter("summary");

		if (customerName == null || customerName.trim().isEmpty()) {
			req.setAttribute("error", "Vui lòng nhập họ tên khách hàng.");
			CustomerIssueDetail c = dDao.getByIssueId(issueId, serialNo);
			if (c == null) {
				c = new CustomerIssueDetail();
			}
			c.setCustomerFullName(customerName);
			c.setContactEmail(contactEmail);
			c.setContactPhone(contactPhone);
			c.setDeviceSerial(deviceSerial);
			c.setSummary(summary);
			req.setAttribute("issueDetail", c);
			req.getRequestDispatcher("view/customer/issueDetailForm.jsp").forward(req, resp);
			return;
		}

		CustomerIssueDetail d = new CustomerIssueDetail();
		d.setIssueId(issueId);
		d.setSupportStaffId(staffId);
		d.setCustomerFullName(customerName.trim());
		d.setContactEmail(contactEmail != null ? contactEmail.trim() : null);
		d.setContactPhone(contactPhone != null ? contactPhone.trim() : null);
		d.setDeviceSerial(deviceSerial != null ? deviceSerial.trim() : null);
		d.setSummary(summary != null ? summary.trim() : null);
		d.setForwardToManager(false);

		dDao.saveIssueDetail(d);
		ciDao.updateSupportStatus(issueId, staffId, "in_progress");

		resp.sendRedirect("issue?details=1");
	}
	
	
	private void forwardCustomerTaskDetails(HttpServletRequest req, HttpServletResponse resp, User customer)
			throws ServletException, IOException {
		String id = req.getParameter("id");
		String action = req.getParameter("action");
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
		
		CustomerIssue issue = ciDao.getIssueById(issueId);
		if (issue == null || issue.getCustomerId() != customer.getId()) {
			resp.sendRedirect("issue?notfound=1");
			return;
		}
		
		if("1".equalsIgnoreCase(action)) {
			CustomerIssue c = ciDao.getIssueById(issueId);
			req.setAttribute("issueDetail", c);			
		}else {
			TaskDetail t = tdDao.getTaskDetailFromCustomerIssue(issueId);
			req.setAttribute("taskDetail", t);
			
		}		
		List<CustomerIssue> listIssue = ciDao.getIssuesByUserId(customer.getId());
		req.setAttribute("list", listIssue);
		req.getRequestDispatcher("view/customer/issueListPage.jsp").forward(req, resp);
		
	}
	
	private void handleCreateError(HttpServletRequest req, HttpServletResponse resp, User user, String message)
			throws ServletException, IOException {
			req.setAttribute("error", message);
			List<CustomerDevice> list = ciDao.getCustomerDevices(user.getId());
			req.setAttribute("list", list);
			req.getRequestDispatcher("view/customer/issuePage.jsp").forward(req, resp);
		}
	
}
