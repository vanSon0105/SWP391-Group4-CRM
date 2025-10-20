package controller.admin;

import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import model.User;

@WebServlet("/account")
public class AccountController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("account");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }


        if (currentUser.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                showUserDetail(request, response);
                break;
            case "search":
                searchUsers(request, response);
                break;
            case "filter":
                filterByRole(request, response);
                break;
            default:
                listAllUsers(request, response, currentUser);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void listAllUsers(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        List<User> users = userDAO.getAllUsers();
        request.setAttribute("account", currentUser);
        request.setAttribute("users", users);
        request.setAttribute("total", users.size());

        request.getRequestDispatcher("/view/profile/ViewAccount.jsp").forward(request, response);
    }

	private void showUserDetail(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        String idParam = request.getParameter("id");
	
	        if (idParam == null) {
	            response.sendRedirect("account");
	            return;
	        }
	
	        try {
	            int userId = Integer.parseInt(idParam);
	            User userDetail = userDAO.getUserById(userId);
	
	            if (userDetail == null) {
	                request.setAttribute("error", "Không tìm thấy người dùng!");
	            } else {
	                request.setAttribute("userDetail", userDetail);
	            }
	
	            request.getRequestDispatcher("/view/profile/ViewAccountDetail.jsp").forward(request, response);
	
	        } catch (NumberFormatException e) {
	            response.sendRedirect("account");
	        }
	    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect("account");
            return;
        }

        List<User> allUsers = userDAO.getAllUsers();
        List<User> filtered = new ArrayList<>();

        for (User u : allUsers) {
            if ((u.getUsername() != null && u.getUsername().toLowerCase().contains(keyword.toLowerCase()))
                || (u.getFullName() != null && u.getFullName().toLowerCase().contains(keyword.toLowerCase()))
                || (u.getEmail() != null && u.getEmail().toLowerCase().contains(keyword.toLowerCase()))) {
                filtered.add(u);
            }
        }

        request.setAttribute("users", filtered);
        request.setAttribute("keyword", keyword);
        request.setAttribute("total", filtered.size());
        request.getRequestDispatcher("/view/profile/ViewAccount.jsp").forward(request, response);
    }

    private void filterByRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleParam = request.getParameter("roleId");
        if (roleParam == null) {
            response.sendRedirect("account");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleParam);
            List<User> allUsers = userDAO.getAllUsers();
            List<User> filtered = new ArrayList<>();

            for (User u : allUsers) {
                if (u.getRoleId() == roleId) {
                    filtered.add(u);
                }
            }

            request.setAttribute("users", filtered);
            request.setAttribute("filterRole", roleId);
            request.setAttribute("total", filtered.size());
            request.getRequestDispatcher("/view/profile/ViewAccount.jsp").forward(request, response);
        	} catch (NumberFormatException e) {
        		response.sendRedirect("account");
        }
    }
}