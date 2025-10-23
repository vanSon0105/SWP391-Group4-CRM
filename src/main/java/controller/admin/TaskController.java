package controller.admin;

import dao.TaskDAO;
import dao.TaskDetailDAO;
import dao.UserDAO;
import dao.CustomerIssueDAO;
import model.CustomerIssue;
import model.Task;
import model.TaskDetail;
import model.User;

import java.io.IOException;
import java.sql.Timestamp;
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
    private CustomerIssueDAO issueDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        taskDetailDAO = new TaskDetailDAO();
        userDAO = new UserDAO();
        issueDAO = new CustomerIssueDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                default:
                    listTasks(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void listTasks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Task> tasks = taskDAO.getAllTasks();
        List<User> technicians = userDAO.getUsersByRole(3);
        List<CustomerIssue> issues = issueDAO.getAllIssues();

        for (Task task : tasks) {
            Set<Integer> assignedIds = taskDAO.getAssignedStaffIds(task.getId());
            task.setAssignedStaffIds(assignedIds);
            List<TaskDetail> details = taskDetailDAO.getTaskDetailsWithStaffInfo(task.getId());
            task.setDetails(details);
        }

        req.setAttribute("tasks", tasks);
        req.setAttribute("technicians", technicians);
        req.setAttribute("issues", issues);
        req.getRequestDispatcher("/view/profile/task.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        try {
            switch (action) {
                case "assign":
                    assignStaff(req, resp);
                    break;
                case "unassign":
                    unassignStaff(req, resp);
                    break;
                default:
                    resp.sendRedirect("tasks");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void assignStaff(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int taskId = Integer.parseInt(req.getParameter("taskId"));
        int staffId = Integer.parseInt(req.getParameter("staffId"));
        Integer assignedBy = 1;
        Timestamp deadline = Timestamp.valueOf(req.getParameter("deadline") + " 00:00:00");

        if (!taskDetailDAO.isStaffAssignedToTask(taskId, staffId)) {
            taskDetailDAO.assignStaffToTask(taskId, staffId, assignedBy, deadline);
        }

        resp.sendRedirect("tasks");
    }

    private void unassignStaff(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int taskId = Integer.parseInt(req.getParameter("taskId"));
        int staffId = Integer.parseInt(req.getParameter("staffId"));

        taskDetailDAO.unassignStaffFromTask(taskId, staffId);
        resp.sendRedirect("tasks");
    }
}
