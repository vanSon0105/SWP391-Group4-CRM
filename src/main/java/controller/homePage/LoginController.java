package controller.homePage;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebServlet({"/login","/logout"})
public class LoginController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final int SESSION_TIMEOUT_SECONDS = 4 * 60 * 60;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/view/authentication/login.jsp").forward(req, resp);
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
            session.invalidate(); 
        }
        response.sendRedirect(request.getContextPath() + "/home"); 	
    }
    
    private void loginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
    	String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userDAO.getUserByLogin(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            if (user.getRoleId() == 1) {
                response.sendRedirect(request.getContextPath() + "/account");
                response.sendRedirect(request.getContextPath() + "/supplier");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }

		    session.setAttribute("account", user);
		    response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/view/authentication/login.jsp").forward(request, response);
        }
    }
}
