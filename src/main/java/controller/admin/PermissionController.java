package controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import dao.PermissionDAO;
import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Permission;
import model.Role;
import model.User;
import utils.AuthorizationUtils;

@WebServlet({"/permission-management", "/permission-user"})
public class PermissionController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PermissionDAO permissionDAO = new PermissionDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "VIEW_ACCOUNT");
        if (currentUser == null) {
            return;
        }

        exposeFlash(request);

        String path = request.getServletPath();
        if ("/permission-user".equals(path)) {
            showUserPermissions(request, response);
        } else {
            showRolePermissions(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "UPDATE_ACCOUNT", "CREATE_ACCOUNT");
        if (currentUser == null) {
            return;
        }

        String action = request.getParameter("action");
        if ("updateRole".equals(action)) {
            handleRoleUpdate(request, response);
        } else if ("updateUser".equals(action)) {
            handleUserUpdate(request, response);
        } else if ("createPermission".equals(action)) {
            handleCreatePermission(request, response); 
        }else {
            response.sendRedirect("permission-management");
        }
    }

    private void showRolePermissions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = roleDAO.getAllRoles();
        int selectedRoleId = parseId(request.getParameter("roleId"));
        if (selectedRoleId <= 0 && !roles.isEmpty()) {
            selectedRoleId = roles.get(0).getId();
        }

        Role selectedRole = null;
        for (Role role : roles) {
            if (role.getId() == selectedRoleId) {
                selectedRole = role;
                break;
            }
        }

        List<Permission> permissions = permissionDAO.getAllPermissions();
        List<Integer> assignedPermissionIds = selectedRole != null
                ? new ArrayList<>(permissionDAO.getPermissionIdsByRole(selectedRoleId))
                : Collections.emptyList();

        request.setAttribute("roles", roles);
        request.setAttribute("permissions", permissions);
        request.setAttribute("selectedRole", selectedRole);
        request.setAttribute("selectedRoleId", selectedRoleId);
        request.setAttribute("assignedPermissionIds", assignedPermissionIds);
        request.getRequestDispatcher("/view/admin/permission/role.jsp").forward(request, response);
    }

    private void showUserPermissions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = roleDAO.getAllRoles();
        String keyword = trimToNull(request.getParameter("keyword"));
        int filterRoleId = parseId(request.getParameter("filterRoleId"));

        List<User> userOptions;
        if (filterRoleId > 0) {
            userOptions = userDAO.filterUsersByRole(filterRoleId, 0, 50);
        } else if (keyword != null) {
            userOptions = userDAO.searchUsers(keyword, 0, 50);
        } else {
            userOptions = userDAO.searchUsers("", 0, 20);
        }

        int requestedUserId = parseId(request.getParameter("userId"));
        User selectedUser = requestedUserId > 0 ? userDAO.getUserById(requestedUserId) : null;
        if (selectedUser == null && !userOptions.isEmpty()) {
            selectedUser = userOptions.get(0);
            requestedUserId = selectedUser.getId();
        }

        List<Permission> permissions = permissionDAO.getAllPermissions();
        List<Integer> userPermissionIds = selectedUser != null
                ? new ArrayList<>(permissionDAO.getPermissionIdsByUser(selectedUser.getId()))
                : Collections.emptyList();
        List<Integer> inheritedPermissionIds = selectedUser != null
                ? new ArrayList<>(permissionDAO.getPermissionIdsByRole(selectedUser.getRoleId()))
                : Collections.emptyList();

        request.setAttribute("roles", roles);
        request.setAttribute("users", userOptions);
        request.setAttribute("selectedUser", selectedUser);
        request.setAttribute("permissions", permissions);
        request.setAttribute("userPermissionIds", userPermissionIds);
        request.setAttribute("inheritedPermissionIds", inheritedPermissionIds);
        request.setAttribute("keyword", keyword);
        request.setAttribute("filterRoleId", filterRoleId);

        request.getRequestDispatcher("/view/admin/permission/user.jsp").forward(request, response);
    }

    private void handleRoleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int roleId = parseId(request.getParameter("roleId"));
        String[] permissionValues = request.getParameterValues("permissionIds");
        List<Integer> permissionIds = toIntegerList(permissionValues);

        if (roleId <= 0) {
            setFlash(request, "Vai trò không hợp lệ.", "error");
            response.sendRedirect("permission-management");
            return;
        }

        boolean success = permissionDAO.replaceRolePermissions(roleId, permissionIds);
        if (success) {
            setFlash(request, "Đã cập nhật quyền cho vai trò", "success");
        } else {
            setFlash(request, "Không thể cập nhật quyền. Vui lòng thử lại", "error");
        }
        response.sendRedirect("permission-management?roleId=" + roleId);
    }

    private void handleUserUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = parseId(request.getParameter("userId"));
        String[] permissionValues = request.getParameterValues("permissionIds");
        List<Integer> permissionIds = toIntegerList(permissionValues);

        if (userId <= 0) {
            setFlash(request, "Người dùng không hợp lệ", "error");
            response.sendRedirect("permission-user");
            return;
        }

        boolean success = permissionDAO.replaceUserPermissions(userId, permissionIds);
        if (success) {
        	HttpSession session = request.getSession(false);
            if (session != null) {
                User current = (User) session.getAttribute(AuthorizationUtils.SESSION_ACCOUNT);
                if (current != null && current.getId() == userId) {
                    AuthorizationUtils.reloadPermissions(session, userId);
                }
            }
            setFlash(request, "Đã cập nhật quyền bổ sung cho người dùng", "success");
        } else {
            setFlash(request, "Không thể cập nhật quyền. Vui lòng thử lại", "error");
        }
        response.sendRedirect("permission-user?userId=" + userId);
    }

    private int parseId(String raw) {
        if (raw == null) {
            return 0;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private List<Integer> toIntegerList(String[] values) {
        List<Integer> ids = new ArrayList<>();
        if (values == null) {
            return ids;
        }
        for (String value : values) {
            try {
                int id = Integer.parseInt(value);
                if (id > 0) {
                    ids.add(id);
                }
            } catch (NumberFormatException ignore) {
            	ignore.printStackTrace();
            }
        }
        return ids;
    }
    
    private void handleCreatePermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String permissionName = trimToNull(request.getParameter("permissionName"));
        if (permissionName == null) {
            setFlash(request, "Permission name must not be empty.", "error");
            response.sendRedirect("permission-management");
            return;
        }

        Permission created = permissionDAO.createPermission(permissionName);
        if (created == null) {
            setFlash(request, "Unable to create permission. It might already exist.", "error");
        } else {
            setFlash(request, "Created permission: " + created.getName(), "success");
        }
        response.sendRedirect("permission-management");
    }

    private void setFlash(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("permissionMessage", message);
        session.setAttribute("permissionType", type);
    }

    private void exposeFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object message = session.getAttribute("permissionMessage");
        if (message != null) {
            request.setAttribute("permissionMessage", message);
            request.setAttribute("permissionType", session.getAttribute("permissionType"));
            session.removeAttribute("permissionMessage");
            session.removeAttribute("permissionType");
        }
    }
}
