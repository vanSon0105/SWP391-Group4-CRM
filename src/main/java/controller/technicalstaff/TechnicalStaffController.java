package controller.technicalstaff;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import dao.CustomerIssueDAO;
import dao.IssuePaymentDAO;
import dao.TaskDetailDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerIssue;
import model.IssuePayment;
import model.TaskDetail;
import model.User;
import utils.AuthorizationUtils;

@WebServlet(urlPatterns = { "/technical-issues" })
public class TechnicalStaffController extends HttpServlet {
	private TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	private CustomerIssueDAO issueDao = new CustomerIssueDAO();
	private UserDAO userDao = new UserDAO();
	private IssuePaymentDAO paymentDao = new IssuePaymentDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}
		
		HttpSession session = req.getSession();
		Object availabilityMsg = session.getAttribute("availabilityMessage");
		if (availabilityMsg != null) {
			req.setAttribute("availabilityMessage", availabilityMsg);
			session.removeAttribute("availabilityMessage");
		}
		Object availabilityType = session.getAttribute("availabilityMessageType");
		if (availabilityType != null) {
			req.setAttribute("availabilityMessageType", availabilityType);
			session.removeAttribute("availabilityMessageType");
		}
		
		Object techAlertMessage = session.getAttribute("techAlertMessage");
		if (techAlertMessage != null) {
			req.setAttribute("techAlertMessage", techAlertMessage);
			Object techAlertType = session.getAttribute("techAlertType");
			if (techAlertType != null) {
				req.setAttribute("techAlertType", techAlertType);
			}
			session.removeAttribute("techAlertMessage");
			session.removeAttribute("techAlertType");
		}
		
		req.setAttribute("staffAvailable", staff.isAvailable());
		
		String detailParam = req.getParameter("id");
		if (detailParam != null) {
			handleDetailView(req, resp, staff, detailParam);
			return;
		}

		List<TaskDetail> assignments = taskDetailDao.getAssignmentsForStaff(staff.getId());
		req.setAttribute("assignments", assignments);
		req.getRequestDispatcher("view/admin/technicalstaff/taskListPage.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
			return;
		}
		
		String action = req.getParameter("action");
		if ("toggleAvailability".equals(action)) {
			handleAvailabilityToggle(req, resp, staff);
			return;
		}

		String assignmentIdParam = req.getParameter("assignmentId");
		String status = req.getParameter("status");
		String summary = req.getParameter("summary");
		if (assignmentIdParam == null || status == null) {
			resp.sendRedirect("technical-issues");
			return;
		}

		int assignmentId;
		try {
			assignmentId = Integer.parseInt(assignmentIdParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}

		TaskDetail assignment = taskDetailDao.getAssignmentForStaff(assignmentId, staff.getId());
		if (assignment == null) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}

		if (!isValidStatus(status)) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}
		
		if ("completed".equals(status) || "cancelled".equals(status)) {
			if (summary == null || summary.trim().isEmpty()) {
				resp.sendRedirect("technical-issues?invalid=1");
				return;
			}
			summary = summary.trim();
		} else {
			summary = null;
		}

		boolean updated = taskDetailDao.updateAssignmentStatus(assignmentId, staff.getId(), status, summary);
		if (updated) {
			syncIssueStatus(assignment.getTaskId(), assignment.getCustomerIssueId(), status, staff.getId());
			resp.sendRedirect("technical-issues?updated=1");
		} else {
			resp.sendRedirect("technical-issues?error=1");
		}
	}

	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "Trang Nhân Viên Kỹ Thuật");
	}

	private boolean isValidStatus(String status) {
		switch (status) {
		case "pending":
		case "in_progress":
		case "completed":
		case "cancelled":
			return true;
		default:
			return false;
		}
	}

	private String syncIssueStatus(int taskId, Integer issueId, String latestStatus, int initiatingStaffId) {
		if (issueId == null) {
			return null;
		}

		List<TaskDetail> details = taskDetailDao.getTaskDetail(taskId);
		if (details == null || details.isEmpty()) {
			return null;
		}
		if ("cancelled".equalsIgnoreCase(latestStatus)) {
			for (TaskDetail detail : details) {
				if (detail.getTechnicalStaffId() != initiatingStaffId && !"cancelled".equalsIgnoreCase(detail.getStatus())) {
					
					taskDetailDao.updateAssignmentStatus(detail.getId(), detail.getTechnicalStaffId(), "cancelled", null);
				}
			}
			issueDao.updateSupportStatus(issueId, "cancelled");
			return "cancelled";
		}

		details = taskDetailDao.getTaskDetail(taskId);

		boolean allCompleted = true;
		boolean anyInProgress = false;

		for (TaskDetail detail : details) {
			String status = detail.getStatus();
			
			if (!"completed".equalsIgnoreCase(status)) {
				allCompleted = false;
			}
			if ("in_progress".equalsIgnoreCase(status)) {
				anyInProgress = true;
			}
		}

		if (allCompleted) {
			issueDao.updateSupportStatus(issueId, "completed");
			return "tech_in_progress";
		} else if (anyInProgress) {
			issueDao.updateSupportStatus(issueId, "tech_in_progress");
			return "tech_in_progress";
		} else {
			issueDao.updateSupportStatus(issueId, "task_created");
			return "task_created";
		}
	}
	
	private void handleDetailView(HttpServletRequest req, HttpServletResponse resp, User staff, String detailParam) throws ServletException, IOException {
		int detailId;
		try {
			detailId = Integer.parseInt(detailParam);
		} catch (NumberFormatException ex) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}
		
		TaskDetail detail = taskDetailDao.getAssignmentDetailForStaff(detailId, staff.getId());
		if (detail == null) {
			resp.sendRedirect("technical-issues?invalid=1");
			return;
		}
		
		List<TaskDetail> teammates = taskDetailDao.getStaffInfoWithTaskDetailId(detail.getTaskId());
		CustomerIssue issue = null;
		if (detail.getCustomerIssueId() != null) {
			issue = issueDao.getIssueById(detail.getCustomerIssueId());
		}
		
		req.setAttribute("assignmentDetail", detail);
		req.setAttribute("teamAssignments", teammates);
		req.setAttribute("issueDetail", issue);
		req.getRequestDispatcher("view/admin/technicalstaff/taskDetail.jsp").forward(req, resp);
	}
	
	private void handleAvailabilityToggle(HttpServletRequest req, HttpServletResponse resp, User staff) throws IOException {
		String availableParam = req.getParameter("available");
		boolean desiredAvailable;
		if (availableParam == null) {
			desiredAvailable = !staff.isAvailable();
		} else {
			desiredAvailable = Boolean.parseBoolean(availableParam);
		}
		
		boolean updated = userDao.updateStaffAvailability(staff.getId(), desiredAvailable);
		HttpSession session = req.getSession();
		
		if (updated) {
			staff.setAvailable(desiredAvailable);
			session.setAttribute(AuthorizationUtils.SESSION_ACCOUNT, staff);
			session.setAttribute("availabilityMessage",
					desiredAvailable ? "Trạng thái đã chuyển 'Rảnh'" : "Trạng thái đã chuyển sang 'Bận'");
			session.setAttribute("availabilityMessageType", "success");
		} else {
			session.setAttribute("availabilityMessage", "Không thể cập nhật trạng thái. Vui lòng thử lại");
			session.setAttribute("availabilityMessageType", "error");
		}
		resp.sendRedirect("technical-issues");
	}
	
}