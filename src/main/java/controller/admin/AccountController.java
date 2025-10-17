package controller.admin;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/account")
public class AccountController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
    	if (session == null || session.getAttribute("account") == null) {
    	    response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
    	    return;
    	}

    	User currentUser = (User) session.getAttribute("account");

    	if (currentUser.getRoleId() != 1) {
    	    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
    	    return;
    	}

    	List<User> users = userDAO.getAllUsers();
    	request.setAttribute("users", users);
    	request.setAttribute("currentUser", currentUser);

        String message = (String) session.getAttribute("accountMessage");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("accountMessage");
        }

        request.getRequestDispatcher("/view/profile/ViewAccount.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
