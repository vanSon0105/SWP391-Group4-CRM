package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.sql.Timestamp;
import dao.TaskDetailDAO;
import dao.TaskDAO;
import dao.UserDAO;
import dao.CustomerIssueDao;
import model.Task;
import model.CustomerIssue;
import model.User;
import model.TaskDetail;

@WebServlet("/task-form")
public class TaskFormController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	TaskDAO taskDao = new TaskDAO();
	UserDAO userDao = new UserDAO();
	CustomerIssueDao issueDao = new CustomerIssueDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		loadData(request, response);

	}

	private void loadData(HttpServletRequest request, HttpServletResponse response) {
		try {
			String idParam = request.getParameter("id");
			String issueIdParam = request.getParameter("issueId");
			Task task = null;
			Set<Integer> assignedStaffIds = null;
			List<TaskDetail> taskDetail = new ArrayList<>();
			if (idParam != null && !idParam.isEmpty()) {
				int taskId = Integer.parseInt(idParam);
				task = taskDao.getTaskById(taskId);
				taskDetail = taskDetailDao.getTaskDetail(taskId);
				assignedStaffIds = taskDao.getAssignedStaffIds(taskId);
			}

			List<CustomerIssue> issueList = issueDao.getAllIssues();
			List<User> staffList = userDao.getAllTechnicalStaff();

			request.setAttribute("task", task);
			request.setAttribute("customerIssues", issueList);
			request.setAttribute("technicalStaffList", staffList);
			request.setAttribute("taskDetail", taskDetail);
			request.setAttribute("assignedStaffIds", assignedStaffIds);
			request.getRequestDispatcher("view/admin/technicalmanager/taskForm.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}
	}

	private void addNewTask(HttpServletRequest request, HttpServletResponse res) {
		try {
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			String customerIssueIdStr = request.getParameter("customerIssueId");
			int customerIssueId = Integer.parseInt(customerIssueIdStr);
			String[] staffs = request.getParameterValues("technicalStaffIds");

			Timestamp deadline = null;
			String deadlineStr = request.getParameter("deadline");
			deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");
			int managerId = 2;
			Timestamp now = new Timestamp(System.currentTimeMillis());

			if (title == null || title.trim().isEmpty()) {
				request.setAttribute("errorTitle", "Không được để trống trường này");
				loadData(request, res);
				request.getRequestDispatcher("view/admin/technicalmanager/taskForm.jsp").forward(request, res);
				return;
			}

			if (deadline.before(now) || deadline.equals(now)) {
				request.setAttribute("errorDeadline", "Deadline phải hơn ngày hôm nay");
				loadData(request, res);
				request.getRequestDispatcher("view/admin/technicalmanager/taskForm.jsp").forward(request, res);
				return;
			}

			Task task = new Task();
			task.setTitle(title);
			task.setDescription(description);
			task.setManagerId(managerId);
			task.setCustomerIssueId(customerIssueId);
			int taskId = taskDao.addNewTask(task);
			if (staffs != null && staffs.length != 0) {
				for (String staff : staffs) {
					int staffId = Integer.parseInt(staff);
					taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
				}
			}

			res.sendRedirect("task-list");
			;
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	private void updateTask(HttpServletRequest req, HttpServletResponse res) {
		try {
			int taskId = Integer.parseInt(req.getParameter("id"));
			String title = req.getParameter("title");
			String description = req.getParameter("description");
			String customerIssueIdStr = req.getParameter("customerIssueId");
			int customerIssueId = Integer.parseInt(customerIssueIdStr);
			String[] newStaffs = req.getParameterValues("technicalStaffIds");
			int managerId = 2;
			Timestamp deadline = null;
			String deadlineStr = req.getParameter("deadline");
			deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");

			if (title == null || title.trim().isEmpty()) {
				req.setAttribute("errorTitle", "Không được để trống trường này");
				loadData(req, res);
				req.getRequestDispatcher("view/admin/technicalmanager/taskForm.jsp").forward(req, res);
				return;
			}

			taskDao.updateTask(taskId, title, description, managerId, customerIssueId);

			Set<Integer> oldStaffSet = taskDao.getAssignedStaffIds(taskId);

			if (newStaffs != null && newStaffs.length > 0) {
			    Set<Integer> newStaffSet = new HashSet<>();
			    for (String staff : newStaffs) {
			        newStaffSet.add(Integer.parseInt(staff));
			    }

			    for (Integer staffId : newStaffSet) {
			        if (!oldStaffSet.contains(staffId)) {
			            taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
			        }
			    }

			    for (Integer staffId : oldStaffSet) {
			        if (!newStaffSet.contains(staffId)) {
			            taskDetailDao.deleteStaffFromTask(taskId, staffId);
			        }
			    }

			} else {
			    for (Integer staffId : oldStaffSet) {
			        taskDetailDao.deleteStaffFromTask(taskId, staffId);
			    }
			}

			String deadlineStr2 = req.getParameter("deadline");
			if (deadlineStr2 != null && !deadlineStr2.isEmpty()) {
				Timestamp newDeadline = Timestamp.valueOf(deadlineStr2 + " 00:00:00");
				taskDetailDao.updateDeadlineForTask(taskId, newDeadline);
			}
			res.sendRedirect("task-list");

		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("id");
		if (id != null && !id.isEmpty()) {
			updateTask(req, resp);
		} else {
			addNewTask(req, resp);
		}
	}

}
