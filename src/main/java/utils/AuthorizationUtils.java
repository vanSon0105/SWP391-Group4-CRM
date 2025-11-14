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

    public static Set<String> ensurePermissionsLoaded(HttpSession session, User user) {
        Set<String> permissions = (Set<String>) session.getAttribute(SESSION_PERMISSIONS);
        if (permissions == null) {
            User freshUser = USER_DAO.getUserById(user.getId());
            permissions = calculateEffectivePermissions(freshUser);
            session.setAttribute(SESSION_PERMISSIONS, permissions);
        }
        return permissions;
    }
    
    private static Set<String> calculateEffectivePermissions(User user) {
        if (user == null) {
            return Collections.emptySet();
        }
        if (user.isPermissionOver()) {
            return PERMISSION_DAO.getDirectPermissionNamesByUser(user.getId());
        } else {
            return PERMISSION_DAO.getPermissionNamesByRole(user.getRoleId());
        }
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
         
        Set<String> permissions = ensurePermissionsLoaded(session, user);
        
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
    
    public static void reloadPermissions(HttpSession session, int userId) {
        if (session == null) {
            return;
        }
        User user = USER_DAO.getUserById(userId);
        if (user == null) {
            clearPermissions(session);
            return;
        }
        Set<String> effectivePermissions = calculateEffectivePermissions(user);
        storePermissions(session, effectivePermissions);
    }

    public static void clearPermissions(HttpSession session) {
        if (session != null) {
            session.removeAttribute(SESSION_PERMISSIONS);
        }
    }
}
