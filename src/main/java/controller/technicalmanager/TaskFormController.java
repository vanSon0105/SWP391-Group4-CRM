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
		// TODO Auto-generated method stub
		try {
			String idParam = request.getParameter("id");
			Task task = null;
//			Set<Integer> assignedStaffIds = null;
			List<TaskDetail> taskDetail = new ArrayList<>();
			if (idParam != null && !idParam.isEmpty()) {
	            int taskId = Integer.parseInt(idParam);
	            task = taskDao.getTaskById(taskId);
	            taskDetail = taskDetailDao.getTaskDetail(taskId);
//	            assignedStaffIds = taskDao.getAssignedStaffIds(taskId);
	        }
			
			List<CustomerIssue> issueList = issueDao.getAllIssues();
		    List<User> staffList = userDao.getAllTechnicalStaff();
			
			request.setAttribute("task", task);
	        request.setAttribute("customerIssues", issueList);
	        request.setAttribute("technicalStaffList", staffList);
	        request.setAttribute("taskDetail", taskDetail);
//	        request.setAttribute("assignedStaffIds", assignedStaffIds);
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
			int staffId = 0;
			Timestamp deadline = null;
			String deadlineStr = request.getParameter("deadline");
			deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");
			int managerId = 2;
			String status = "pending";
			
			Task task = new Task();
			task.setTitle(title);
			task.setDescription(description);
			task.setManagerId(managerId);
			task.setCustomerIssueId(customerIssueId);
			int taskId = taskDao.addNewTask(task);
			for (String staff : staffs) { 
				staffId = Integer.parseInt(staff);
				taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
			}
			res.sendRedirect("task-list");;
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
			
			taskDao.updateTask(taskId, title, description, managerId, customerIssueId);
			
			Set<Integer> newStaffSet = new HashSet<>();
			
			if(newStaffs != null) {
				for (String staff : newStaffs) {
					newStaffSet.add(Integer.parseInt(staff));
				}
			}
			
			Set<Integer> oldStaffSet = taskDao.getAssignedStaffIds(taskId);
			
			for (Integer staffId : newStaffSet) {
				if(!oldStaffSet.contains(staffId)) {
					taskDetailDao.insertStaffToTask(taskId, staffId, deadline);
				}
					
			}
			
			for (Integer staffId : oldStaffSet) {
				if(!newStaffSet.contains(staffId)) {
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
