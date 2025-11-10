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
import dao.CustomerIssueDAO;
import model.Task;
import model.CustomerIssue;
import model.User;
import utils.AuthorizationUtils;
import model.TaskDetail;

@WebServlet("/task-form")
public class TaskFormController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	private TaskDAO taskDao = new TaskDAO();
	private UserDAO userDao = new UserDAO();
	private CustomerIssueDAO issueDao = new CustomerIssueDAO();
	private static final int MAX_ACTIVE_TASKS_PER_STAFF = 3;
	private static final int MAX_TITLE_LENGTH = 100;
	private static final int MAX_DESCRIPTION_LENGTH = 500;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		User manager = getManager(request, response);
		if (manager == null) {
			return;
		}
		applyReviewNotice(request);
		forwardToForm(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User manager = getManager(req, resp);
		if (manager == null) {
			return;
		}
		
		String id = req.getParameter("id");
		if (id != null && !id.isEmpty()) {
			updateTask(req, resp, manager);
		} else {
			addNewTask(req, resp, manager);
		}
	}

	private void loadData(HttpServletRequest request, HttpServletResponse response) {
		try {
			String idParam = request.getParameter("id");
			String issueIdParam = request.getParameter("issueId");
			
			Task task = null;
			
			Set<Integer> assignedStaffIds = null;
			List<TaskDetail> taskDetail = new ArrayList<>();
			
			int issueIdFromParam = 0;
			
			if (idParam != null && !idParam.isEmpty()) {
				int taskId = Integer.parseInt(idParam);
				task = taskDao.getTaskById(taskId);
				taskDetail = taskDetailDao.getTaskDetail(taskId);
				assignedStaffIds = taskDao.getAssignedStaffIds(taskId);
				if (task != null) {
					issueIdFromParam = task.getCustomerIssueId();
				}
			}

			if (issueIdFromParam == 0 && issueIdParam != null && !issueIdParam.trim().isEmpty()) {
				try {
					issueIdFromParam = Integer.parseInt(issueIdParam.trim());
				} catch (NumberFormatException ignored) {
				}
			}

			if (task == null && issueIdFromParam != 0) {
				task = taskDao.getTaskByIssueId(issueIdFromParam);
				if (task != null) {
					taskDetail = taskDetailDao.getTaskDetail(task.getId());
					assignedStaffIds = taskDao.getAssignedStaffIds(task.getId());
					issueIdFromParam = task.getCustomerIssueId();
				} 
			}

			 List<CustomerIssue> issueList;
		        if (issueIdFromParam != 0) {
		            issueList = issueDao.getIssuesForTask(issueIdFromParam);
		        } else {
		            issueList = issueDao.getIssuesWithoutTask();
		        }

		        List<User> staffList = userDao.getAllTechnicalStaff();

		        CustomerIssue currentIssue = null;
		        if (issueIdFromParam != 0) {
		            for (CustomerIssue ci : issueList) {
		                if (ci.getId() == issueIdFromParam) {
		                    currentIssue = ci;
		                    break;
		                }
		            }
		            if (currentIssue == null) {
		                currentIssue = issueDao.getIssueById(issueIdFromParam);
		            }
		        }

			request.setAttribute("task", task);
			request.setAttribute("taskDetail", taskDetail);
			request.setAttribute("customerIssues", issueList);
			request.setAttribute("technicalStaffList", staffList);
			if (currentIssue != null) {
				request.setAttribute("currentIssue", currentIssue);
			}

			if (request.getAttribute("assignedStaffIds") == null) {
				request.setAttribute("assignedStaffIds",
						assignedStaffIds != null ? assignedStaffIds : Collections.emptySet());
			}

			if (request.getAttribute("selectedIssueId") == null) {
				if (issueIdFromParam != 0) {
					request.setAttribute("selectedIssueId", issueIdFromParam);
				}
			}

		} catch (Exception e) {
			System.out.print("Error");
		}
	}


	private void addNewTask(HttpServletRequest request, HttpServletResponse res, User manager) {
		try {
			String title = request.getParameter("title"); 
			String description = request.getParameter("description");
			String customerIssueIdStr = request.getParameter("customerIssueId");
			int customerIssueId;
			try {
				customerIssueId = Integer.parseInt(customerIssueIdStr);
			} catch (NumberFormatException ex) {
				res.sendRedirect("task-list?invalid=1");
				return;
			}
			
//			Set<Integer> selectedStaffs = extractStaffIds(request.getParameterValues("technicalStaffIds"));
			request.setAttribute("selectedIssueId", customerIssueId);
//			request.setAttribute("assignedStaffIds", selectedStaffs);

//			Timestamp deadline = null;
//			String deadlineStr = request.getParameter("deadline");
//			deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");
			
			int managerId = manager.getId();
			Timestamp now = new Timestamp(System.currentTimeMillis());

			if (title == null || title.trim().isEmpty()) {
				request.setAttribute("errorTitle", "Không được để trống trường này");
				forwardToForm(request, res);
				return;
			}
			
			if (title.length() > MAX_TITLE_LENGTH) {
			    request.setAttribute("errorTitle", "Tiêu đề không được vượt quá " + MAX_TITLE_LENGTH + " ký tự");
			    forwardToForm(request, res);
			    return;
			}
			
			if (description != null && description.length() > MAX_DESCRIPTION_LENGTH) {
			    request.setAttribute("errorDescription", "Ghi chú không được vượt quá " + MAX_DESCRIPTION_LENGTH + " ký tự");
			    forwardToForm(request, res);
			    return;
			}

//			if (deadline.before(now) || deadline.equals(now)) {
//				request.setAttribute("errorDeadline", "Deadline phải hơn ngày hôm nay");
//				forwardToForm(request, res);
//				return;
//			}
			
//			for (Integer staffId : selectedStaffs) {
//				if (!userDao.isTechnicalStaffAvailable(staffId)) {
//					request.setAttribute("errorStaffAvailability",
//							"Kỹ thuật viên " + resolveStaffLabel(staffId) + " đang bận.");
//					forwardToForm(request, res);
//					return;
//				}
//				int activeTasks = taskDetailDao.countActiveTasksForStaff(staffId);
//				if (activeTasks >= MAX_ACTIVE_TASKS_PER_STAFF) {
//					request.setAttribute("errorStaffLimit",
//							"Technical staff " + resolveStaffLabel(staffId) + " đã nhận đủ "
//									+ MAX_ACTIVE_TASKS_PER_STAFF + " tasks");
//					forwardToForm(request, res);
//					return;
//				}
//			}

			Task task = new Task();
			task.setTitle(title);
			task.setDescription(description);
			task.setManagerId(managerId);
			task.setCustomerIssueId(customerIssueId);
			
			int taskId = taskDao.addNewTask(task);
			if (taskId <= 0) {
				request.setAttribute("errorGeneral", "Không thể tạo task. Vui lòng thử lại");
				forwardToForm(request, res);
				return;
			}
			
			issueDao.updateSupportStatus(customerIssueId, "task_created");
			
//			for (Integer staffId : selectedStaffs) {
//				taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
//			}

			res.sendRedirect("assign-task");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void updateTask(HttpServletRequest req, HttpServletResponse res, User manager) {
		try {
			int taskId = Integer.parseInt(req.getParameter("id"));
			
			String title = req.getParameter("title");
			String description = req.getParameter("description");
			String customerIssueIdStr = req.getParameter("customerIssueId");
			int customerIssueId = Integer.parseInt(customerIssueIdStr);
			
			Set<Integer> newStaffIds = extractStaffIds(req.getParameterValues("technicalStaffIds"));
			req.setAttribute("assignedStaffIds", newStaffIds);
			req.setAttribute("selectedIssueId", customerIssueId);
			
			int managerId = manager.getId();
			Timestamp deadline = null;
			String deadlineStr = req.getParameter("deadline");
			deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");

			if (title == null || title.trim().isEmpty()) {
				req.setAttribute("errorTitle", "Không được để trống trường này");
				forwardToForm(req, res);
				return;
			}
			
			Set<Integer> existingStaffIds = taskDao.getAssignedStaffIds(taskId);
			if (existingStaffIds == null) {
				existingStaffIds = new HashSet<>();
			}
			
			for (Integer staffId : newStaffIds) {
				if (!existingStaffIds.contains(staffId)) {
					if (!userDao.isTechnicalStaffAvailable(staffId)) {
						req.setAttribute("errorStaffAvailability",
								"Kỹ thuật viên " + resolveStaffLabel(staffId) + " đang bận.");
						forwardToForm(req, res);
						return;
					}
					int activeTasks = taskDetailDao.countActiveTasksForStaff(staffId);
					if (activeTasks >= MAX_ACTIVE_TASKS_PER_STAFF) {
						req.setAttribute("errorStaffLimit",
								"Technical staff " + resolveStaffLabel(staffId) + " đã được giao đủ "
										+ MAX_ACTIVE_TASKS_PER_STAFF + " tasks.");
						forwardToForm(req, res);
						return;
					}
				}
			}

			taskDao.updateTask(taskId, title, description, managerId, customerIssueId);

			for (Integer staffId : newStaffIds) {
				if (!existingStaffIds.contains(staffId)) {
					taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
				}
			}
			
			issueDao.updateSupportStatus(customerIssueId, "task_created");

			for (Integer staffId : existingStaffIds) {
				if (!newStaffIds.contains(staffId)) {
					taskDetailDao.deleteStaffFromTask(taskId, staffId);
				}
			}

			taskDetailDao.updateDeadlineForTask(taskId, deadline);

			res.sendRedirect("task-list");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private Set<Integer> extractStaffIds(String[] staffParams) {
		if (staffParams == null || staffParams.length == 0) {
			return new LinkedHashSet<>();
		}
		Set<Integer> ids = new LinkedHashSet<>();
		for (String staffIdStr : staffParams) {
			if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
				continue;
			}
			try {
				ids.add(Integer.parseInt(staffIdStr));
			} catch (NumberFormatException ignored) {
			}
		}
		return ids;
	}
	
	private String resolveStaffLabel(int staffId) {
		User staff = userDao.getUserById(staffId);
		if (staff == null) {
			return "#" + staffId;
		}
		String fullName = staff.getFullName();
		if (fullName != null && !fullName.trim().isEmpty()) {
			return fullName.trim();
		}
		String username = staff.getUsername();
		return (username != null && !username.trim().isEmpty()) ? username.trim() : ("#" + staffId);
	}	
	
	private void forwardToForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		applyReviewNotice(request);
		loadData(request, response);
		request.getRequestDispatcher("view/admin/technicalmanager/taskForm.jsp").forward(request, response);
	}
	
	private User getManager(HttpServletRequest request, HttpServletResponse response) throws IOException {
		return AuthorizationUtils.requirePermission(request, response, "CUSTOMER_ISSUES_MANAGEMENT");
	}
	
	private void applyReviewNotice(HttpServletRequest request) {
		if (request.getAttribute("fromReviewNotice") != null) {
			return;
		}
		String fromReview = request.getParameter("fromReview");
		if (fromReview != null && ("1".equals(fromReview) || "true".equalsIgnoreCase(fromReview))) {
			request.setAttribute("fromReviewNotice", Boolean.TRUE);
		}
	}

}
