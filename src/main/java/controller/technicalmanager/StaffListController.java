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

@WebServlet("/staff-list")
public class StaffListController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final int PAGE_SIZE = 10; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	User manager = getManager(request, response);
		if (manager == null) {
			return;
		}
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception ignored) {}

        int totalRecords = userDAO.countTechnicalStaff(search, status);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        int offset = (page - 1) * PAGE_SIZE;
        List<User> staffList = userDAO.getTechnicalStaff(search, status, offset, PAGE_SIZE);

        request.setAttribute("staffList", staffList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/view/admin/technicalmanager/staffList.jsp").forward(request, response);
    }
    

    private User getManager(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    return AuthorizationUtils.requirePermission(request, response, "Trang Quản Lí Kỹ Thuật");
	}
}
