package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.UserDAO;
import java.util.List;
import model.User;
import utils.AuthorizationUtils;
import model.TaskDetail;
import dao.TaskDetailDAO;

@WebServlet("/staff-detail")
public class StaffDetailController extends HttpServlet {
	TaskDetailDAO tdDao = new TaskDetailDAO();
	UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	User manager = getManager(request, response);
		if (manager == null) {
			return;
		}
    	String staffIdParam = request.getParameter("id");
    	int staffId = Integer.parseInt(staffIdParam);
    	
    	List<TaskDetail> taskDetails = tdDao.getBasicTaskDetailsByStaffId(staffId);
    	User staff = userDao.getTechnicalStaffById(staffId);
        request.setAttribute("staff", staff);

    	request.setAttribute("taskDetails", taskDetails);
    	request.setAttribute("taskCount", taskDetails.size());


        request.getRequestDispatcher("/view/admin/technicalmanager/staffDetail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User manager = getManager(request, response);
		if (manager == null) {
			return;
		}

        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            tdDao.deleteByTaskIdAndStaffId(taskId, staffId);;

            response.sendRedirect("staff-detail?id=" + staffId);
        }
    }
    
    private User getManager(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    return AuthorizationUtils.requirePermission(request, response, "Trang Quản Lí Kỹ Thuật");
	}
}
