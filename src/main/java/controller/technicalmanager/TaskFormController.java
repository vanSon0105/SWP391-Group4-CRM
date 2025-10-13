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
import model.Task;
import model.TaskDetail;

@WebServlet("/task-form")
public class TaskFormController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	TaskDAO taskDao = new TaskDAO();
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			int id = Integer.parseInt(request.getParameter("id"));
			
			List<TaskDetail> listTaskDetail = taskDetailDao.getTaskDetail(id);
			Task task = taskDao.getTaskById(id);
			
			request.setAttribute("task", task);
			request.setAttribute("listTaskDetail", listTaskDetail);
			request.getRequestDispatcher("view/technicalmanager/taskForm.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}

}
