package controller.admin;

import dao.TaskDAO;
import dao.TaskDetailDAO;
import dao.UserDAO;
import model.Task;
import model.TaskDetail;
import model.User;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/tasks")
public class TaskController extends HttpServlet {

    private TaskDAO taskDAO;
    private TaskDetailDAO taskDetailDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        taskDetailDAO = new TaskDetailDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "assign":
                showAssignForm(req, resp);
                break;
            case "list":
            default:
                showTaskList(req, resp);
                break;
        }
    }

    private void showTaskList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Task> tasks = taskDAO.getAllTasks();
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/view/profile/task_list.jsp").forward(req, resp);
    }

    private void showAssignForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            Task task = taskDAO.getTaskById(taskId);
            if (task == null) {
                req.setAttribute("error", "Task không tồn tại");
                showTaskList(req, resp);
                return;
            }

            List<TaskDetail> assignedDetails = taskDetailDAO.getTaskDetailsWithStaffInfo(taskId);
            Set<Integer> assignedTechIds = new HashSet<>();
            for (TaskDetail td : assignedDetails) {
                assignedTechIds.add(td.getTechnicalStaffId());
            }

            List<User> technicians = userDAO.getUsersByRole(3); // roleId 3 = kỹ thuật viên

            req.setAttribute("task", task);
            req.setAttribute("assignedDetails", assignedDetails);
            req.setAttribute("assignedTechIds", assignedTechIds);
            req.setAttribute("technicians", technicians);
            req.getRequestDispatcher("/view/profile/task_assign.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi lấy thông tin task");
            showTaskList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            int taskId = Integer.parseInt(req.getParameter("taskId"));

            if ("assign".equals(action)) {
                int staffId = Integer.parseInt(req.getParameter("staffId"));
                String deadlineStr = req.getParameter("deadline");
                Timestamp deadline = null;
                if (deadlineStr != null && !deadlineStr.isEmpty()) {
                    // Chuyển String "yyyy-MM-dd" sang Timestamp bắt đầu ngày đó
                    deadline = Timestamp.valueOf(deadlineStr + " 00:00:00");
                }

                TaskDetail newDetail = new TaskDetail();
                newDetail.setTaskId(taskId);
                newDetail.setTechnicalStaffId(staffId);
                newDetail.setAssignedAt(new Timestamp(System.currentTimeMillis()));
                newDetail.setDeadline(deadline);
                newDetail.setStatus("pending");
                newDetail.setProgress(0);

                taskDetailDAO.add(newDetail);

                resp.sendRedirect(req.getContextPath() + "/tasks?action=assign&taskId=" + taskId);

            } else if ("unassign".equals(action)) {
                int staffId = Integer.parseInt(req.getParameter("staffId"));
                taskDetailDAO.deleteByTaskIdAndStaffId(taskId, staffId);

                resp.sendRedirect(req.getContextPath() + "/tasks?action=assign&taskId=" + taskId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/tasks");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xử lý phân công nhiệm vụ: " + e.getMessage());
            showTaskList(req, resp);
        }
    }
}
