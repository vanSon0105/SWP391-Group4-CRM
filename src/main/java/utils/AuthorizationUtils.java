package utils;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import dao.PermissionDAO;
import dao.UserDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

public class AuthorizationUtils {
	public static final String SESSION_ACCOUNT = "account";
    public static final String SESSION_PERMISSIONS = "permissions";

    private static final PermissionDAO PERMISSION_DAO = new PermissionDAO();
    private static final UserDAO USER_DAO = new UserDAO();

    private AuthorizationUtils() {
    }

    public static Set<String> ensurePermissionsLoaded(HttpSession session, int userId) {
        Set<String> permissions = (Set<String>) session.getAttribute(SESSION_PERMISSIONS);
        if (permissions == null) {
            permissions = new HashSet<>(PERMISSION_DAO.getPermissionsForUser(userId));
            session.setAttribute(SESSION_PERMISSIONS, permissions);
        }
        return permissions;
    }

    public static Set<String> getPermissions(HttpSession session) {
        Set<String> permissions = (Set<String>) session.getAttribute(SESSION_PERMISSIONS);
        if (permissions == null) {
            return Collections.emptySet();
        }
        return permissions;
    }

    public static boolean hasPermission(HttpSession session, String permission) {
        return getPermissions(session).contains(permission);
    }

    public static User requirePermission(HttpServletRequest request, HttpServletResponse response, String... requiredPermissions)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return null;
        }

        User user = (User) session.getAttribute(SESSION_ACCOUNT);
        if (user == null) {
            response.sendRedirect("login");
            return null;
        }
        
        String status = USER_DAO.getUserStatus(user.getId());
        if (status == null) {
            status = user.getStatus();
        } else if (user.getStatus() == null || !status.equals(user.getStatus())) {
            user.setStatus(status);
            session.setAttribute(SESSION_ACCOUNT, user);
        }

        if (status == null || !"active".equalsIgnoreCase(status)) {
            clearPermissions(session);
            session.removeAttribute(SESSION_ACCOUNT);
            session.setAttribute("loginAlertType", "error");
            session.setAttribute("loginAlertMessage", "Tài khoản của bạn đã bị khóa.");
            response.sendRedirect("login");
            return null;
        }

        Set<String> permissions = ensurePermissionsLoaded(session, user.getId());
        boolean hasPermission = false;
        for (String permission : requiredPermissions) {
            if (permissions.contains(permission)) {
                hasPermission = true;
                break;
            }
        }

        if (!hasPermission) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }

        return user;
    }

    public static void storePermissions(HttpSession session, Set<String> permissions) {
        if (session == null) {
            return;
        }
        session.setAttribute(SESSION_PERMISSIONS, new HashSet<>(permissions));
    }

    public static void clearPermissions(HttpSession session) {
        if (session != null) {
            session.removeAttribute(SESSION_PERMISSIONS);
        }
    }
}
