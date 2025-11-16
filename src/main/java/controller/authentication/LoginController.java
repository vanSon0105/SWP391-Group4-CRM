package controller.authentication;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import dao.PermissionDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.AuthorizationUtils;

@WebServlet({ "/login", "/logout", "/forgot-password"})
public class LoginController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private PermissionDAO permissionDAO = new PermissionDAO();
    private static final int SESSION_TIMEOUT_SECONDS = 4 * 60 * 60;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	String path = req.getServletPath();
    	HttpSession session = req.getSession();
    	Object successMessage = session.getAttribute("success");
        if (successMessage != null) {
            req.setAttribute("success", successMessage);
            session.removeAttribute("success");
        }

        Object errorMessage = session.getAttribute("error");
        if (errorMessage != null) {
            req.setAttribute("error", errorMessage);
            session.removeAttribute("error");
        }
    	
    	if ("/logout".equals(path)) {
    		logoutPage(req, resp);
    		return;
    	}

    	Object alertMessage = session.getAttribute("loginAlertMessage");
    	if (alertMessage != null) {
    		req.setAttribute("loginAlertMessage", alertMessage);
    		Object alertType = session.getAttribute("loginAlertType");
    		if (alertType != null) {
    			req.setAttribute("loginAlertType", alertType);
    		}
    		session.removeAttribute("loginAlertMessage");
    		session.removeAttribute("loginAlertType");
    	}

        switch (path) {
            case "/forgot-password":
            	req.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(req, resp);  
                break;
            default:
            	req.getRequestDispatcher("/view/authentication/login.jsp").forward(req, resp);            
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
    	String path = req.getServletPath();
        switch (path) {
            case "/login":
                loginPage(req, resp);
                break;
            case "/logout":
            	logoutPage(req, resp);
            	break;
            default:
            	resp.sendRedirect(req.getContextPath() + "/home");
        }  
    }
    
    private void logoutPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
        if (session != null) {
        	AuthorizationUtils.clearPermissions(session);
            session.invalidate(); 
        }
        response.sendRedirect("home"); 	
    }
    
    private void loginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);

    	String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userDAO.getUserByLogin(email, password);

        if (user == null) {
            request.setAttribute("loginAlertType", "error");
            request.setAttribute("loginAlertMessage", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/view/authentication/login.jsp").forward(request, response);
            return;
        }

        if (!"active".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("loginAlertType", "error");
            request.setAttribute("loginAlertMessage", "Tài khoản của bạn đã bị khóa.");
            request.getRequestDispatcher("/view/authentication/login.jsp").forward(request, response);
            return;
        }

    	userDAO.updateLastLoginAt(user.getId());
    	session.setAttribute("account", user);
    	AuthorizationUtils.reloadPermissions(session, user.getId());
        response.sendRedirect("home");
    }
}