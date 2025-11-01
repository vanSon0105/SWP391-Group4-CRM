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
        	case "activate":
            activateUser(request, response);
            break;
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
            case "delete":
                softDelete(request, response);
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
        int pageSize = 10; 
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && pageParam.matches("\\d+")) {
            page = Integer.parseInt(pageParam);
        }

        int totalUsers = users.size();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalUsers);

        List<User> pageList = users.subList(start, end);

        request.setAttribute("account", currentUser);
        request.setAttribute("users", pageList);
        request.setAttribute("total", totalUsers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

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
            String email = request.getParameter("email").trim();
            String fullName = request.getParameter("fullName").trim();
            String phone = request.getParameter("phone").trim();
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String status = request.getParameter("status");

            StringBuilder errors = new StringBuilder();

            if (email.isEmpty()) {
                errors.append("Email không được để trống.<br>");
            } else if (!email.matches("^\\S+@\\S+\\.\\S+$")) {
                errors.append("Email không hợp lệ.<br>");
            } else if (userDAO.existsByEmail(email) && !userDAO.isEmailOfUser(email, id)) {
                errors.append("Email đã tồn tại.<br>");
            }

            if (fullName.isEmpty()) {
                errors.append("Họ tên không được để trống.<br>");
            } else if (!fullName.matches("^[a-zA-Z\\s]{2,50}$")) {
                errors.append("Họ tên chỉ gồm chữ và khoảng trắng.<br>");
            }

            if (!phone.isEmpty() && !phone.matches("^\\d{9,12}$")) {
                errors.append("Số điện thoại không hợp lệ (9-12 chữ số).<br>");
            }

            if (errors.length() > 0) {
                User user = new User();
                user.setId(id);
                user.setEmail(email);
                user.setFullName(fullName);
                user.setPhone(phone);
                user.setRoleId(roleId);
                user.setStatus(status);

                request.setAttribute("errorMessage", errors.toString());
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
                return;
            }

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
                request.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình cập nhật.");
            request.getRequestDispatcher("/view/admin/account/EditUser.jsp").forward(request, response);
        }
    }


    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        if (keyword != null) {
            keyword = keyword.replace("+", " ").trim();
        }

        if (keyword == null || keyword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập từ khóa tìm kiếm!");
            listAllUsers(request, response, (User) request.getSession().getAttribute("account"));
            return;
        }

        if (keyword.length() > 50) {
            request.setAttribute("error", "Từ khóa quá dài (tối đa 50 ký tự)!");
            listAllUsers(request, response, (User) request.getSession().getAttribute("account"));
            return;
        }
        if (!keyword.matches("[a-zA-Z0-9@._\\p{L}\\s]+")) {
            request.setAttribute("error", "Từ khóa chứa ký tự không hợp lệ!");
            listAllUsers(request, response, (User) request.getSession().getAttribute("account"));
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
            String username = request.getParameter("username").trim();
            String email = request.getParameter("email").trim();
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName").trim();
            String phone = request.getParameter("phone").trim();
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String status = request.getParameter("status");

            StringBuilder errors = new StringBuilder();

            if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
                errors.append("Tên đăng nhập không hợp lệ.<br>");
            }
            if (!email.matches("^\\S+@\\S+\\.\\S+$")) {
                errors.append("Email không hợp lệ.<br>");
            }
            if (!password.matches("^(?=.*[a-zA-Z])(?=.*\\d).{6,}$")) {
                errors.append("Mật khẩu phải ít nhất 6 ký tự và bao gồm chữ và số.<br>");
            }
            if (!fullName.matches("^[a-zA-Z\\s]{2,50}$")) {
                errors.append("Họ tên không hợp lệ.<br>");
            }
            if (!phone.isEmpty() && !phone.matches("^\\d{9,12}$")) {
                errors.append("Số điện thoại không hợp lệ.<br>");
            }

            if (userDAO.existsByUsername(username)) {
                errors.append("Tên đăng nhập đã tồn tại.<br>");
            }
            if (userDAO.existsByEmail(email)) {
                errors.append("Email đã tồn tại.<br>");
            }

            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                request.getRequestDispatcher("/view/admin/account/AddUser.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setRoleId(roleId);
            user.setStatus(status);

            try {
                userDAO.addUser(user);
                response.sendRedirect("account?msg=add_success");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc email đã tồn tại!");
                request.getRequestDispatcher("/view/admin/account/AddUser.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Thêm người dùng thất bại!");
            request.getRequestDispatcher("/view/admin/account/AddUser.jsp").forward(request, response);
        }
    }

    
    private void softDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User currentUser = (User) request.getSession().getAttribute("account");
            int id = Integer.parseInt(request.getParameter("id"));

            User targetUser = userDAO.getUserById(id);
            if (targetUser == null) {
                request.setAttribute("mess", "Người dùng không tồn tại!");
                listAllUsers(request, response, currentUser);
                return;
            }

            if (currentUser.getId() == targetUser.getId()) {
                request.setAttribute("mess", "Bạn không thể khóa chính mình!");
                listAllUsers(request, response, currentUser);
                return;
            }

            if (currentUser.getRoleId() == 1 && targetUser.getRoleId() == 1) {
                request.setAttribute("mess", "Admin không thể khóa admin khác!");
                listAllUsers(request, response, currentUser);
                return;
            }

            boolean success = userDAO.softDeleteUser(id);
            if (success) {
                request.setAttribute("mess", "Đã khóa người dùng thành công!");
            } else {
                request.setAttribute("mess", "Không thể khóa người dùng!");
            }

            listAllUsers(request, response, currentUser);

        } catch (Exception e) {
            e.printStackTrace();
            User currentUser = (User) request.getSession().getAttribute("account");
            request.setAttribute("mess", "Đã xảy ra lỗi trong quá trình khóa người dùng!");
            listAllUsers(request, response, currentUser);
        }
    }

    private void activateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = userDAO.activateUser(id);

        if (success) {
            request.setAttribute("mess", "Đã mở khóa tài khoản thành công!");
        } else {
            request.setAttribute("mess", "Không thể mở khóa tài khoản!");
        }

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("account");

        listAllUsers(request, response, currentUser);
    }

    
}


