package controller.technicalstaff;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import dao.CustomerIssueDao;
import dao.TaskDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TaskDetail;
import model.User;

@WebServlet(urlPatterns = { "/technical-issues" })
public class TechnicalStaffController extends HttpServlet {
	private TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	private CustomerIssueDao issueDao = new CustomerIssueDao();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getUser(req, resp);
		if (staff == null) {
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

		String assignmentIdParam = req.getParameter("assignmentId");
		String status = req.getParameter("status");
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

		boolean updated = taskDetailDao.updateAssignmentStatus(assignmentId, staff.getId(), status);
		if (updated) {
			syncIssueStatus(assignment.getTaskId(), assignment.getCustomerIssueId(), status);
			resp.sendRedirect("technical-issues?updated=1");
		} else {
			resp.sendRedirect("technical-issues?error=1");
		}
	}

	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		HttpSession session = req.getSession(false);
		if(session == null) {
			resp.sendRedirect("login");
			return null;
		}
		User user = (User) session.getAttribute("account");
		if (user == null || user.getRoleId() != 3) {
			resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
			return null;
		}
		return user;
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

	private void syncIssueStatus(int taskId, Integer issueId, String latestStatus) {
		if (issueId == null) {
			return;
		}

		List<TaskDetail> details = taskDetailDao.getTaskDetail(taskId);
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

		if (allCompleted && !details.isEmpty()) {
			issueDao.updateSupportStatus(issueId, "resolved");
		} else if (anyInProgress || "in_progress".equalsIgnoreCase(latestStatus)) {
			issueDao.updateSupportStatus(issueId, "tech_in_progress");
		} else {
			issueDao.updateSupportStatus(issueId, "task_created");
		}
	}
	
	public static void main(String[] args) {
		TaskDetailDAO taskDetailDao = new TaskDetailDAO();
		List<TaskDetail> assignments = taskDetailDao.getAssignmentsForStaff(3);
		for (TaskDetail taskDetail : assignments) {
			System.out.println(taskDetail.toString());
		}
	}
}
