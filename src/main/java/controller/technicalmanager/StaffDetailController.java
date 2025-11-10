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
import model.TaskDetail;
import dao.TaskDetailDAO;

@WebServlet("/staff-detail")
public class StaffDetailController extends HttpServlet {
	TaskDetailDAO tdDao = new TaskDetailDAO();
	UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String staffIdParam = request.getParameter("id");
    	int staffId = Integer.parseInt(staffIdParam);
    	
    	List<TaskDetail> taskDetails = tdDao.getBasicTaskDetailsByStaffId(staffId);
    	User staff = userDao.getTechnicalStaffById(staffId);
        request.setAttribute("staff", staff);

    	request.setAttribute("taskDetails", taskDetails);
    	request.setAttribute("taskCount", taskDetails.size());


        request.getRequestDispatcher("/view/admin/technicalmanager/staffDetail.jsp").forward(request, response);
    }
}
