package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import dao.TaskDAO;
import model.Task;

@WebServlet("/task-list")
public class TaskListPageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDAO taskDao = new TaskDAO();
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			String status = request.getParameter("status");
			String search = request.getParameter("search");

			List<Task> listTask = taskDao.getFilteredTasksWithStatus(status, search);
			
			
			request.setAttribute("listTask", listTask);
			request.getRequestDispatcher("view/admin/technicalmanager/taskListPage.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}

}
