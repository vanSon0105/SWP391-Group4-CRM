package utils;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import dao.PermissionDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

public class AuthorizationUtils {
	public static final String SESSION_ACCOUNT = "account";
    public static final String SESSION_PERMISSIONS = "permissions";

    private static final PermissionDAO PERMISSION_DAO = new PermissionDAO();

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

    public static User requirePermission(HttpServletRequest request, HttpServletResponse response, String permission)
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

        Set<String> permissions = ensurePermissionsLoaded(session, user.getId());
        if (!permissions.contains(permission)) {
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
