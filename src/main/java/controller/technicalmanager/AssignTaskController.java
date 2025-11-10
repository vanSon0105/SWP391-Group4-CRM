package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import dao.TaskDAO;
import dao.TaskDetailDAO;
import dao.UserDAO;
import model.Task;
import model.User;
import utils.AuthorizationUtils;
import model.TaskDetail;

@WebServlet(urlPatterns = {"/assign-task"})
public class AssignTaskController extends HttpServlet {

    private TaskDAO taskDAO = new TaskDAO();
    private UserDAO userDAO = new UserDAO();
    private TaskDetailDAO taskDetailDAO = new TaskDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	User manager = getManager(request, response);
		if (manager == null) {
			return;
		}
        String staffIdStr = request.getParameter("staffId");

        if(staffIdStr == null){
            response.sendRedirect("staff-list");
            return;
        }

        int staffId = Integer.parseInt(staffIdStr);
 
        User selectedStaff = userDAO.getTechnicalStaffById(staffId);
        List<Task> taskList = taskDAO.getAvailableTasksForStaff(staffId);

        request.setAttribute("selectedStaff", selectedStaff);
        request.setAttribute("taskList", taskList);

        request.getRequestDispatcher("/view/admin/technicalmanager/assignTaskPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User manager = getManager(request, response);
		if (manager == null) {
			return;
		}
        int taskId = Integer.parseInt(request.getParameter("task_id"));
        int staffId = Integer.parseInt(request.getParameter("technical_staff_id"));
        String note = request.getParameter("note");
        String deadlineStr = request.getParameter("deadline");

        if (note != null && note.length() > 300) {
            request.setAttribute("errorNote", "Ghi chú không được vượt quá 300 ký tự");
            forwardToAssignForm(request, response);
            return;
        }
        
        Timestamp deadline = null;
        if (deadlineStr == null || deadlineStr.isEmpty()) {
            request.setAttribute("errorDeadline", "Deadline không được để trống");
            forwardToAssignForm(request, response);
            return;
        } else {
            try {
                deadline = Timestamp.valueOf(deadlineStr.replace("T", " ") + ":00");
                Timestamp now = new Timestamp(System.currentTimeMillis());
                if (!deadline.after(now)) {
                    request.setAttribute("errorDeadline", "Deadline phải sau thời gian hiện tại");
                    forwardToAssignForm(request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorDeadline", "Deadline không hợp lệ");
                forwardToAssignForm(request, response);
                return;
            }
        }

        TaskDetail taskDetail = new TaskDetail();
        taskDetail.setTaskId(taskId);
        taskDetail.setTechnicalStaffId(staffId);
        taskDetail.setNote(note);
        taskDetail.setStatus("pending");
        taskDetail.setDeadline(deadline);

        taskDetailDAO.insert(taskDetail);

        response.sendRedirect("staff-list");
    }
    
    private void forwardToAssignForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int staffId = 0;
        try {
            staffId = Integer.parseInt(request.getParameter("technical_staff_id"));
        } catch (Exception ignored) {}

        User selectedStaff = userDAO.getTechnicalStaffById(staffId);
        List<Task> taskList = taskDAO.getAvailableTasksForStaff(staffId);

        request.setAttribute("selectedStaff", selectedStaff);
        request.setAttribute("taskList", taskList);

        request.getRequestDispatcher("/view/admin/technicalmanager/assignTaskPage.jsp")
               .forward(request, response);
    }
    
    private User getManager(HttpServletRequest request, HttpServletResponse response) throws IOException {

	    return AuthorizationUtils.requirePermission(request, response, "ASSIGN_TASK");

	}
}
