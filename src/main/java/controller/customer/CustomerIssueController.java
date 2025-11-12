package controller.customer;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import dao.CustomerIssueDAO;
import dao.CustomerIssueDetailDAO;
import dao.DeviceSerialDAO;
import dao.IssuePaymentDAO;
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
import model.IssuePayment;
import model.TaskDetail;
import model.User;
import utils.AuthorizationUtils;

@WebServlet({"/issue", "/create-issue", "/issue-fill", "/issue-detail", "/issue-feedback", "/issue-pay"})
public class CustomerIssueController extends HttpServlet {
	private CustomerIssueDAO ciDao = new CustomerIssueDAO();
	private CustomerIssueDetailDAO dDao = new CustomerIssueDetailDAO();
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	private TaskDetailDAO tdDao = new TaskDetailDAO();
	private IssuePaymentDAO paymentDao = new IssuePaymentDAO();
	final int ADDRESS_MAX_LENGTH = 255;
	final int NOTE_MAX_LENGTH = 500;

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
		case "/issue-pay":
			forwardIssueCheckout(req, resp, u);
			break;
		case "/issue-feedback":
			forwardFeedbackForm(req, resp, u);
			break;
		case "/issue-detail":
			forwardCustomerTaskDetails(req, resp, u);
			break;
		default:
			List<CustomerIssue> listIssue = ciDao.getIssuesByUserId(u.getId());
			List<Integer> issueIds = listIssue.stream().map(CustomerIssue::getId).collect(Collectors.toList());
			req.setAttribute("issuePayments", paymentDao.getByIssueIds(issueIds));
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
		case "/issue-pay":
			handlePaymentConfirm(req, resp, u);
			break;
		case "/issue-feedback":
			handleFeedbackSubmit(req, resp, u);
			break;
		default:
			resp.sendRedirect("issue");
			break;
		}
	}
	

	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "Gửi Vấn Đề");
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
		
		IssuePayment payment = paymentDao.getByIssueId(issueId);
		req.setAttribute("issuePayment", payment);
		
		if("1".equalsIgnoreCase(action)) {
			CustomerIssue c = ciDao.getIssueById(issueId);
			req.setAttribute("issueDetail", c);			
		}else {
			TaskDetail t = tdDao.getTaskDetailFromCustomerIssue(issueId);
			req.setAttribute("taskDetail", t);
			
		}		
		List<CustomerIssue> listIssue = ciDao.getIssuesByUserId(customer.getId());
		List<Integer> issueIds = listIssue.stream().map(CustomerIssue::getId).collect(Collectors.toList());
		req.setAttribute("issuePayments", paymentDao.getByIssueIds(issueIds));
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
	
	private void handlePaymentConfirm(HttpServletRequest req, HttpServletResponse resp, User customer) throws ServletException, IOException {
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

		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment == null || (!payment.isAwaitingCustomer() && !payment.isAwaitingAdmin())) {
			resp.sendRedirect("issue?payment_invalid=1");
			return;
		}

		String fullNameRaw = req.getParameter("fullName");
		String phoneRaw = req.getParameter("phone");
		String addressRaw = req.getParameter("address");
		String shippingNoteRaw = req.getParameter("shippingNote");

		String fullName = fullNameRaw != null ? fullNameRaw.trim() : null;
		String phone = phoneRaw != null ? phoneRaw.trim() : null;
		String address = addressRaw != null ? addressRaw.trim() : null;
		String shippingNote = shippingNoteRaw != null ? shippingNoteRaw.trim() : null;

		boolean hasError = false;

		if (fullName == null || fullName.isEmpty()) {
			req.setAttribute("errorFullName", "Vui lòng nhập họ tên người nhận");
			hasError = true;
		} else {
			String namePattern = "^[\\p{L}\\s]+$";
			if (!fullName.matches(namePattern)) {
				req.setAttribute("errorFullName", "Họ tên không được chứa ký tự đặc biệt hoặc số");
				hasError = true;
			} else if (fullName.length() > 100) {
				req.setAttribute("errorFullName", "Họ tên không được vượt quá 180 ký tự");
				hasError = true;
			}
		}

		if (phone == null || phone.isEmpty()) {
			req.setAttribute("errorPhone", "Vui lòng nhập số điện thoại liên hệ");
			hasError = true;
		} else {
			String phonePattern = "^[0-9]{10}$";
			if (!phone.matches(phonePattern)) {
				req.setAttribute("errorPhone", "Số điện thoại không hợp lệ");
				hasError = true;
			}
		}

		if (address == null || address.isEmpty()) {
			req.setAttribute("errorAddress", "Vui lòng nhập địa chỉ giao nhận");
			hasError = true;
		} else if (address.length() > ADDRESS_MAX_LENGTH) {
			req.setAttribute("errorAddress", "Địa chỉ không được vượt quá " + ADDRESS_MAX_LENGTH + " ký tự");
			hasError = true;
		}

		if (shippingNote != null && shippingNote.length() > NOTE_MAX_LENGTH) {
			req.setAttribute("errorNote", "Ghi chú không được vượt quá " + NOTE_MAX_LENGTH + " ký tự");
			hasError = true;
		}

		if (hasError) {
			req.setAttribute("formFullName", fullName);
			req.setAttribute("formPhone", phone);
			req.setAttribute("formAddress", address);
			req.setAttribute("formNote", shippingNote);
			req.setAttribute("issue", issue);
			req.setAttribute("payment", payment);
			req.setAttribute("finalPrice", payment.getAmount());
			try {
				req.getRequestDispatcher("view/customer/issueCheckout.jsp").forward(req, resp);
			} catch (ServletException e) {
				throw new IOException(e);
			}
			return;
		}
		
		boolean isWarrantyIssue = "warranty".equalsIgnoreCase(issue.getIssueType()) || payment.getAmount() <= 0;
		
		if (isWarrantyIssue) {
			boolean updated = paymentDao.markPaidByCustomer(payment.getId(), customer.getId(), fullName, phone, address,
					shippingNote);
			if (!updated) {
				resp.sendRedirect("issue?payment_invalid=1");
				return;
			}
			ciDao.updateSupportStatus(issueId, "resolved");
			resp.sendRedirect("issue?payment=1");
			return;
		}
		
		boolean updatedShipping = paymentDao.updateCustomerShippingInfo(payment.getId(), fullName, phone, address, shippingNote);
		if (!updatedShipping) {
			resp.sendRedirect("issue?payment_invalid=1");
			return;
		}
		
		boolean awaitingAdmin = paymentDao.markAwaitingAdminConfirmation(payment.getId());
		if (!awaitingAdmin) {
			resp.sendRedirect("issue?payment_invalid=1");
			return;
		}
		
		payment.setShippingFullName(fullName);
		payment.setShippingPhone(phone);
		payment.setShippingAddress(address);
		payment.setShippingNote(shippingNote);
		
		req.setAttribute("issue", issue);
		req.setAttribute("payment", payment);
		req.setAttribute("finalPrice", payment.getAmount());
		req.setAttribute("bankingContext", "issue");
		req.setAttribute("bankingIssueCode", issue.getIssueCode());
		req.setAttribute("bankingRecipientName", payment.getShippingFullName());
		req.setAttribute("bankingRecipientPhone", payment.getShippingPhone());
		req.setAttribute("bankingRecipientAddress", payment.getShippingAddress());
		req.setAttribute("bankingShippingNote", payment.getShippingNote());
		ciDao.updateSupportStatus(issueId, "waiting_confirm");
		req.getRequestDispatcher("view/homepage/banking.jsp").forward(req, resp);
	}
	
	private void forwardIssueCheckout(HttpServletRequest req, HttpServletResponse resp, User customer)
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

		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment == null || (!payment.isAwaitingCustomer() && !payment.isAwaitingAdmin())) {
			resp.sendRedirect("issue?payment_invalid=1");
			return;
		}

		req.setAttribute("issue", issue);
		req.setAttribute("payment", payment);
		req.setAttribute("finalPrice", payment.getAmount());
		req.setAttribute("awaitingAdminConfirm", payment.isAwaitingAdmin());

		if (req.getAttribute("formFullName") == null) {
			String fullName = payment.getShippingFullName();
			if (fullName == null || fullName.trim().isEmpty()) {
				fullName = customer.getFullName();
			}
			req.setAttribute("formFullName", fullName);
		}
		if (req.getAttribute("formPhone") == null) {
			String phone = payment.getShippingPhone();
			if (phone == null || phone.trim().isEmpty()) {
				phone = customer.getPhone();
			}
			req.setAttribute("formPhone", phone);
		}
		if (req.getAttribute("formAddress") == null) {
			req.setAttribute("formAddress", payment.getShippingAddress());
		}
		if (req.getAttribute("formNote") == null) {
			req.setAttribute("formNote", payment.getShippingNote());
		}

		req.getRequestDispatcher("view/customer/issueCheckout.jsp").forward(req, resp);
	}
	
	private void forwardFeedbackForm(HttpServletRequest req, HttpServletResponse resp, User customer)
			throws ServletException, IOException {
		String idParam = req.getParameter("id");
		if (idParam == null) {
			resp.sendRedirect("issue");
			return;
		}

		int issueId;
		try {
			issueId = Integer.parseInt(idParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}

		CustomerIssue issue = ciDao.getIssueById(issueId);
		if (issue == null || issue.getCustomerId() != customer.getId()) {
			resp.sendRedirect("issue?notfound=1");
			return;
		}
		
		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment == null || (!payment.isPaid() && !payment.isClosed())) {
			resp.sendRedirect("issue?payment_required=1");
			return;
		}

		String existingFeedback = issue.getFeedback();
		if (payment.isClosed() && existingFeedback != null && !existingFeedback.trim().isEmpty()) {
			resp.sendRedirect("issue?feedback_done=1");
			return;
		}

		String status = issue.getSupportStatus();
		if (status == null || !"resolved".equalsIgnoreCase(status)) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}

		req.setAttribute("issue", issue);
		req.setAttribute("issuePayment", payment);
		if (req.getAttribute("feedbackDraft") == null) {
			req.setAttribute("feedbackDraft", issue.getFeedback());
		}
		req.getRequestDispatcher("view/customer/issueFeedbackPage.jsp").forward(req, resp);
	}

	private void handleFeedbackSubmit(HttpServletRequest req, HttpServletResponse resp, User customer)
			throws ServletException, IOException {
		final int FEEDBACK_MAX_LENGTH = 1000;

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
		
		IssuePayment payment = paymentDao.getByIssueId(issueId);
		if (payment == null || (!payment.isPaid() && !payment.isClosed())) {
			resp.sendRedirect("issue?payment_required=1");
			return;
		}

		String status = issue.getSupportStatus();
		if (status == null || !"resolved".equalsIgnoreCase(status)) {
			resp.sendRedirect("issue?invalid=1");
			return;
		}

		String feedbackRaw = req.getParameter("feedback");
		String feedback = feedbackRaw != null ? feedbackRaw.trim() : null;

		if (feedback == null || feedback.isEmpty()) {
			req.setAttribute("issue", issue);
			req.setAttribute("issuePayment", payment);
			req.setAttribute("feedbackDraft", feedbackRaw);
			req.setAttribute("feedbackError", "Vui lòng nhập nội dung phản hồi");
			req.getRequestDispatcher("view/customer/issueFeedbackPage.jsp").forward(req, resp);
			return;
		}

		if (feedback.length() > FEEDBACK_MAX_LENGTH) {
			req.setAttribute("issue", issue);
			req.setAttribute("issuePayment", payment);
			req.setAttribute("feedbackDraft", feedbackRaw);
			req.setAttribute("feedbackError",
					"Phản hồi không được vượt quá " + FEEDBACK_MAX_LENGTH + " ký tự");
			req.getRequestDispatcher("view/customer/issueFeedbackPage.jsp").forward(req, resp);
			return;
		}

		boolean updated = ciDao.updateFeedback(issueId, feedback);
		if (!updated) {
			req.setAttribute("issue", issue);
			req.setAttribute("issuePayment", payment);
			req.setAttribute("feedbackDraft", feedbackRaw);
			req.setAttribute("feedbackError", "Không thể gửi phản hồi. Vui lòng thử lại");
			req.getRequestDispatcher("view/customer/issueFeedbackPage.jsp").forward(req, resp);
			return;
		}
		
		if (payment.isPaid()) {
			paymentDao.closeAfterFeedback(payment.getId());
		}

		resp.sendRedirect("issue?feedback_saved=1");
	}
	
	private boolean isLockedForCustomer(String status) {
		if (status == null) {
			return false;
		}
		switch (status.toLowerCase()) {
		case "manager_approved":
		case "task_created":
		case "tech_in_progress":
		case "resolved":
		case "completed":
		case "waiting_payment":
			return true;
		default:
			return false;
		}
	}
	
}
