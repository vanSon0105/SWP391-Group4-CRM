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
import model.CustomerIssue;
import model.WarrantyCard;
import dao.WarrantyCardDAO;
import dao.CustomerIssueDAO;
import utils.AuthorizationUtils;
import dao.WarrantyCardDAO;
import java.net.URLEncoder;

@WebServlet("/task-detail")
public class TaskDetailController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TaskDetailDAO taskDetailDao = new TaskDetailDAO();
	TaskDAO taskDao = new TaskDAO();
	WarrantyCardDAO wcDao = new WarrantyCardDAO();
	CustomerIssueDAO ciDao = new CustomerIssueDAO();
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

		Task task = taskDao.getTaskById(id);

		List<TaskDetail> listTaskDetail = taskDetailDao.getTaskDetail(id);
		for (TaskDetail td : listTaskDetail) {
		    CustomerIssue issue = ciDao.getIssueById(task.getCustomerIssueId());
		    if (issue != null) {
		        WarrantyCard wc = wcDao.getById(issue.getWarrantyCardId());
		        td.setWarrantyCard(wc);
		    }
		}
		
		String message = (String) request.getSession().getAttribute("message");
		String error = (String) request.getSession().getAttribute("error");

		if (message != null) {
		    request.setAttribute("message", message);
		    request.getSession().removeAttribute("message");
		}

		if (error != null) {
		    request.setAttribute("error", error);
		    request.getSession().removeAttribute("error");
		}


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

                request.getSession().setAttribute("message", "Hủy giao nhiệm vụ thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Hủy giao nhiệm vụ thất bại!");
            }
        }

        if ("cancelWarranty".equals(action)) {
            String warrantyCardIdParam = request.getParameter("warrantyCardId");
            if (warrantyCardIdParam != null) {
                try {
                    int warrantyCardId = Integer.parseInt(warrantyCardIdParam);
                    wcDao.cancelWarranty(warrantyCardId); 
                    request.getSession().setAttribute("message", "Hủy bảo hành thành công!");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("error", "Hủy bảo hành thất bại!");
                }
            }
        }

        response.sendRedirect("task-detail?id=" + taskIdParam);

    }
	private User getUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    return AuthorizationUtils.requirePermission(request, response, "Trang Quản Lí Kỹ Thuật");
	}

}
