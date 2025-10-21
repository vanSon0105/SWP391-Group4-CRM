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

@WebServlet("/task-detail")
public class TaskDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	TaskDAO taskDao = new TaskDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));
		} catch (Exception e) {
			System.out.print("Error");
		}
			
		List<TaskDetail> listTaskDetail = taskDetailDao.getTaskDetail(id);
		Task task = taskDao.getTaskById(id);
		
		request.setAttribute("task", task);
		request.setAttribute("listTaskDetail", listTaskDetail);
		request.getRequestDispatcher("view/admin/technicalmanager/taskDetailPage.jsp").forward(request, response);

	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String taskIdParam = request.getParameter("taskId");
        if(taskIdParam != null) {
            int taskId = Integer.parseInt(taskIdParam);
            taskDetailDao.completeTaskDetails(taskId);
        }
        response.sendRedirect("task-list");
    }

}
