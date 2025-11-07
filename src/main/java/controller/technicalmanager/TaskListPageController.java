package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import dao.TaskDAO;
import dao.TaskDetailDAO;
import model.Task;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/task-list")
public class TaskListPageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int TASK_PER_PAGE = 6;
	TaskDAO taskDao = new TaskDAO();
    TaskDetailDAO tdDao = new TaskDetailDAO();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		try {
			User staff = getUser(request, response);
			if (staff == null) {
				return;
			}
			String status = request.getParameter("status");
			String search = request.getParameter("search");
			

			int page = 1;
			String pageParam = request.getParameter("page");

			if(pageParam != null) {
			    page = Integer.parseInt(pageParam);
			}

			int offset = TASK_PER_PAGE * (page - 1);
 
			
			int totalTasks = taskDao.getFilteredTasksCount(status, search);
			int totalPages = (int) Math.ceil((double) totalTasks / TASK_PER_PAGE);
			if (totalPages == 0) totalPages = 1;
			int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
			
			List<Task> listTask = taskDao.getFilteredTasksWithStatus(status, search, TASK_PER_PAGE, offset);
			
			request.setAttribute("currentPage", currentPage);
			request.setAttribute("totalTasks", totalTasks);
			request.setAttribute("currentPage", page);
			request.setAttribute("totalPages", totalPages);
			request.setAttribute("listTask", listTask);
			request.getRequestDispatcher("view/admin/technicalmanager/taskListPage.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        int taskId = Integer.parseInt(req.getParameter("taskId"));
        tdDao.cancelTask(taskId);
        resp.sendRedirect("task-list");
    }
	
	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "VIEW_TASK_LIST");
	}
	

}
