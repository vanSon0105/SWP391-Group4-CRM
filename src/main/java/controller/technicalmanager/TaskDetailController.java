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
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/task-detail")
public class TaskDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	TaskDAO taskDao = new TaskDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		User manager = getUser(request, response);
		if (manager == null) {
			return;
		}
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
	
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		User manager = getUser(request, response);
		if (manager == null) {
			return;
		}
        String action = request.getParameter("action");
        String taskIdParam = request.getParameter("taskId");
        String staffIdParam = request.getParameter("staffId");

        if ("cancel".equals(action) && taskIdParam != null && staffIdParam != null) {
            try {
                int taskId = Integer.parseInt(taskIdParam);
                int staffId = Integer.parseInt(staffIdParam);
                taskDetailDao.deleteByTaskIdAndStaffId(taskId, staffId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("task-detail?id=" + taskIdParam);
    }
	private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "VIEW_TASK_LIST");
	}

}
