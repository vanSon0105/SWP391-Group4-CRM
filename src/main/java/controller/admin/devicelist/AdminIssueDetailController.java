package controller.admin.devicelist;

import dao.IssueDAO;
import model.Issue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin-issue-detail")
public class AdminIssueDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("error", "Issue ID không hợp lệ!");
            request.getRequestDispatcher("/view/admin/device/customer-issue-detail.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            IssueDAO dao = new IssueDAO();
            Issue issue = dao.getIssueById(id);

            if (issue == null) {
                request.setAttribute("error", "Không tìm thấy Issue với ID: " + id);
            } else {
                request.setAttribute("issue", issue);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Issue ID không hợp lệ!");
        }

        request.getRequestDispatcher("/view/admin/device/customer-issue-detail.jsp").forward(request, response);
    }
}
