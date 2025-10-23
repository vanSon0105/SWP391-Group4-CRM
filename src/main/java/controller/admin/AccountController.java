package controller.admin;

import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.UserDAO;
import model.User;
import utils.AuthorizationUtils;

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

    	 User currentUser = AuthorizationUtils.requirePermission(request, response, "VIEW_ACCOUNT");
         if (currentUser == null) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
        	action = "list";
        }

        switch (action) {
            case "detail":
                showUserDetail(request, response);
                break;
            case "edit":
                showEditForm(request, response);
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

    	User currentUser = AuthorizationUtils.requirePermission(request, response, "VIEW_ACCOUNT");
        if (currentUser == null) {
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else {
            doGet(request, response);
        }
    }

    
    private void listAllUsers(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("account", currentUser);
        request.setAttribute("users", users);
        request.setAttribute("total", users.size());

        request.getRequestDispatcher("/view/admin/account/ViewAccount.jsp").forward(request, response);
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
            User userDetail = userDAO.getUserDetailsById(userId);

            if (userDetail == null) {
                request.setAttribute("error", "Không tìm thấy người dùng!");
            } else {
                request.setAttribute("userDetail", userDetail);
            }

            request.getRequestDispatcher("/view/admin/account/ViewAccountDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("account");
        }
    }

   
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	if (!AuthorizationUtils.hasPermission(request.getSession(false), "UPDATE_ACCOUNT")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
    	
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect("account");
            return;
        }

        try {
            int userId = Integer.parseInt(idParam);
            User user = userDAO.getUserById(userId);

            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng.");
                listAllUsers(request, response, (User) request.getSession().getAttribute("account"));
            } else {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("account");
        }
    }

    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	if (!AuthorizationUtils.hasPermission(request.getSession(false), "UPDATE_ACCOUNT")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
    	
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String status = request.getParameter("status"); 


            User user = new User();
            user.setId(id);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setRoleId(roleId);
            user.setStatus(status);

            boolean success = userDAO.updateUser(user);

            if (success) {
                response.sendRedirect("account?msg=update_success");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình cập nhật.");
            request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
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
        request.getRequestDispatcher("/view/admin/account/ViewAccount.jsp").forward(request, response);
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
            request.getRequestDispatcher("/view/admin/account/ViewAccount.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("account");
        }
    }


    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	if (!AuthorizationUtils.hasPermission(request.getSession(false), "CREATE_ACCOUNT")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
    	
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String status = request.getParameter("status");

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setRoleId(roleId);
            user.setStatus(status);

            userDAO.addUser(user);
            response.sendRedirect("account");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Thêm người dùng thất bại!");
            listAllUsers(request, response, (User) request.getSession().getAttribute("account"));
        }
    }
}
