package controller.customersupportstaff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerIssue;
import model.CustomerIssueDetail;
import model.DeviceSerial;
import model.IssuePayment;
import model.TaskDetail;
import model.User;
import utils.AuthorizationUtils;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import dao.CustomerIssueDAO;
import dao.CustomerIssueDetailDAO;
import dao.DeviceSerialDAO;
import dao.IssuePaymentDAO;
import dao.TaskDetailDAO;
import dao.UserDAO;

/**
 * Servlet implementation class SupportIsssueController
 */
@WebServlet("/support-issues")
public class SupportIsssueController extends HttpServlet {
	private CustomerIssueDAO iDao = new CustomerIssueDAO();
	private CustomerIssueDetailDAO dDao = new CustomerIssueDetailDAO();
	private UserDAO userDao = new UserDAO();
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	private TaskDetailDAO tdDao = new TaskDetailDAO();
	private IssuePaymentDAO paymentDao = new IssuePaymentDAO();
       
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}

		String action = req.getParameter("action");
		if ("review".equalsIgnoreCase(action)) {
			showReviewIssueDetail(req, resp, staff);
			return;
		}
		
		List<CustomerIssue> newIssues = iDao.getUnassignedIssues();
		List<CustomerIssue> myIssues = iDao.getIssuesAssignedToStaff(staff.getId());
		List<CustomerIssue> managerReviewIssues = iDao.getIssuesBySupportStatuses(new String[] { "manager_review", "submitted" });
		List<CustomerIssue> resolvedIssues = iDao.getIssuesBySupportStatuses(new String[] {"resolved"});

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
		
		req.setAttribute("newIssueCount", newIssues.size());
		req.setAttribute("myIssueCount", myIssues.size());
		req.setAttribute("awaitingCustomerCount", awaitingCustomerCount);
		req.setAttribute("inProgressCount", inProgressCount);
		req.setAttribute("managerReviewCount", managerReviewIssues.size());
		req.setAttribute("resolvedIssueCount", resolvedIssues.size());

		req.setAttribute("newIssues", newIssues);
		req.setAttribute("myIssues", myIssues);
		req.getRequestDispatcher("view/admin/supportstaff/issueListPage.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User staff = getUser(request, response);
		if (staff == null) {
			return;
		}

		String action = request.getParameter("action");
		if ("save".equalsIgnoreCase(action)) {
			checkRequest(request, response, staff);
			return;
		}
		
		if ("request_details".equalsIgnoreCase(action)) {
			sendRequestDetails(request, response, staff);
			return;
		}
		
		if ("payment_open".equalsIgnoreCase(action)) {
			openPaymentForCustomer(request, response, staff);
			return;
		}
		response.sendRedirect("support-issues");
	}
	
	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "Trang Nhân Viên Hỗ Trợ");
	}
	
	private void showReviewIssueDetail(HttpServletRequest req, HttpServletResponse resp, User staff)
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

		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		CustomerIssueDetail d = dDao.getByIssueId(issueId, serialNo);
		User customerDetail = userDao.getUserDetailsById(issue.getCustomerId());
		CustomerIssueDetail viewDetail = d != null ? d : new CustomerIssueDetail();
		addWithAccountInfo(viewDetail, customerDetail, serialNo);
		
        
        
		req.setAttribute("issue", issue);
		req.setAttribute("issueDetail", viewDetail);
		IssuePayment payment = paymentDao.getByIssueId(issueId);
		req.setAttribute("issuePayment", payment);
		req.setAttribute("paymentAwaitingSupport", payment != null && payment.isAwaitingSupport());
		req.setAttribute("paymentAwaitingCustomer", payment != null && payment.isAwaitingCustomer());
		req.setAttribute("paymentPaid", payment != null && payment.isPaid());
		
		String status = issue.getSupportStatus();
		boolean managerRejected = "manager_rejected".equalsIgnoreCase(status);
		boolean managerApproved = "manager_approved".equalsIgnoreCase(status);
		boolean managerPending = "manager_review".equalsIgnoreCase(status);
		boolean customerCancelled = "customer_cancelled".equalsIgnoreCase(status);
		boolean taskLocked = isLockedForSupport(status);
		boolean awaitingCustomer = "awaiting_customer".equalsIgnoreCase(status);
		boolean needsCustomerInfo = needsAdditionalCustomerInfo(d, customerDetail);
		TaskDetail t = tdDao.getTaskDetailFromCustomerIssue(issueId);
		
		req.setAttribute("customerCancelled", customerCancelled);
		req.setAttribute("managerRejected", managerRejected);
		req.setAttribute("managerApproved", managerApproved);
		req.setAttribute("managerPending", managerPending);
		req.setAttribute("lockedForSupport", taskLocked);
		req.setAttribute("awaitingCustomer", awaitingCustomer);
		req.setAttribute("needsCustomerInfo", needsCustomerInfo);
		req.setAttribute("taskDetail", t);
		req.getRequestDispatcher("view/admin/supportstaff/issueReviewPage.jsp").forward(req, resp);
	}
	
	private void checkRequest(HttpServletRequest req, HttpServletResponse resp, User staff) throws IOException, ServletException {
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
		
		if (isLockedForSupport(issue.getSupportStatus())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		if (issue.getSupportStaffId() != 0 && issue.getSupportStaffId() != (staff.getId())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}
		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		User customer = userDao.getUserDetailsById(issue.getCustomerId());
		String customerName = req.getParameter("customerName");
		String contactEmail = req.getParameter("contactEmail");
		String contactPhone = req.getParameter("contactPhone");
		String deviceSerial = req.getParameter("deviceSerial");
		String summary = req.getParameter("summary");
		
		boolean forward = "on".equalsIgnoreCase(req.getParameter("forwardToManager"));

		if (customerName == null || customerName.trim().isEmpty()) {
			req.setAttribute("error", "Vui lòng nhập tên khách hàng.");
			req.setAttribute("issue", issue);
			CustomerIssueDetail detail = dDao.getByIssueId(issueId, serialNo);
			if (detail == null) {
				detail = new CustomerIssueDetail();
			}
			detail.setCustomerFullName(customerName);
			detail.setContactEmail(contactEmail);
			detail.setContactPhone(contactPhone);
			detail.setDeviceSerial(deviceSerial);
			detail.setSummary(summary);
			addWithAccountInfo(detail, customer, serialNo);
			boolean awaitingCustomer = "awaiting_customer".equalsIgnoreCase(issue.getSupportStatus());
			
			req.setAttribute("issueDetail", detail);
			req.setAttribute("awaitingCustomer", awaitingCustomer);
			req.setAttribute("needsCustomerInfo", needsAdditionalCustomerInfo(dDao.getByIssueId(issueId, serialNo), customer));
			IssuePayment paymentInfo = paymentDao.getByIssueId(issueId);
			req.setAttribute("issuePayment", paymentInfo);
			req.setAttribute("paymentAwaitingSupport", paymentInfo != null && paymentInfo.isAwaitingSupport());
			req.setAttribute("paymentAwaitingCustomer", paymentInfo != null && paymentInfo.isAwaitingCustomer());
			req.setAttribute("paymentPaid", paymentInfo != null && paymentInfo.isPaid());
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
		String nextStatus = forward ? "manager_review" : "in_progress";
		iDao.updateSupportStatus(issueId, staff.getId(), nextStatus);
		resp.sendRedirect("support-issues?saved=1");
	}
	
	
	private void openPaymentForCustomer(HttpServletRequest req, HttpServletResponse resp, User staff) throws IOException {
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

		if (issue.getSupportStaffId() != 0 && issue.getSupportStaffId() != staff.getId()) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment == null || !payment.isAwaitingSupport()) {
			resp.sendRedirect("support-issues?paymentInvalid=1");
			return;
		}

		boolean ok = paymentDao.approveForCustomer(payment.getId(), staff.getId());
		if (!ok) {
			resp.sendRedirect("support-issues?paymentInvalid=1");
			return;
		}		

		iDao.updateSupportStatus(issueId, "waiting_payment");
		resp.sendRedirect("support-issues?action=review&id=" + issueId + "&paymentReady=1");
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
		
		if (isLockedForSupport(issue.getSupportStatus())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}

		if (issue.getSupportStaffId() == 0) {
			iDao.assignIssueIfAvailable(issueId, staff.getId());
		} else if (issue.getSupportStaffId() != (staff.getId())) {
			resp.sendRedirect("support-issues?locked=1");
			return;
		}
		String serialNo = dsDao.getDeviceSerialByWarrantyId(issue.getWarrantyCardId());
		CustomerIssueDetail detail = dDao.getByIssueId(issueId, serialNo);
		User customer = userDao.getUserDetailsById(issue.getCustomerId());
		boolean managerRejected = "manager_rejected".equalsIgnoreCase(issue.getSupportStatus());
		boolean needsInfo = needsAdditionalCustomerInfo(detail, customer);
		if (!needsInfo && !managerRejected) {
			resp.sendRedirect("support-issues?action=review&id=" + issueId + "&infoComplete=1");
			return;
		}

		iDao.updateSupportStatus(issueId, staff.getId(), "awaiting_customer");
		resp.sendRedirect("support-issues?action=review&id=" + issueId + "&requested=1");
	}
	
	private boolean isLockedForSupport(String status) {
		if (status == null) {
			return false;
		}
		switch (status.toLowerCase()) {
		case "manager_approved":
		case "task_created":
		case "tech_in_progress":
		case "resolved":
		case "customer_cancelled":
		case "completed":
		case "waiting_payment":
		case "create_payment":
			return true;
		default:
			return false;
		}
	}
	
	private boolean needsAdditionalCustomerInfo(CustomerIssueDetail detail, User customer) {
		String name = hasText(detail != null ? detail.getCustomerFullName() : null)
				? detail.getCustomerFullName()
				: (customer != null ? customer.getFullName() : null);
		String email = hasText(detail != null ? detail.getContactEmail() : null)
				? detail.getContactEmail()
				: (customer != null ? customer.getEmail() : null);
		String phone = hasText(detail != null ? detail.getContactPhone() : null)
				? detail.getContactPhone()
				: (customer != null ? customer.getPhone() : null);
		return !hasText(name) || (!hasText(email) && !hasText(phone));
	}
	
	private void addWithAccountInfo(CustomerIssueDetail detail, User customer,  String serialNo) {
		if (detail == null || customer == null) {
			return;
		}
		if (!hasText(detail.getCustomerFullName())) {
			detail.setCustomerFullName(customer.getFullName());
		}
		if (!hasText(detail.getContactEmail())) {
			detail.setContactEmail(customer.getEmail());
		}
		if (!hasText(detail.getContactPhone())) {
			detail.setContactPhone(customer.getPhone());
		}
		if (!hasText(detail.getDeviceSerial())) {
			detail.setDeviceSerial(serialNo);
		}
	}
	
	private boolean hasText(String value) {
		return value != null && !value.trim().isEmpty();
	}
	
	

}
