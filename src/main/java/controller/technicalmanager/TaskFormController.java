package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
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
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
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
			request.getRequestDispatcher("view/technicalmanager/taskForm.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doPost(req, resp);
	}

}
