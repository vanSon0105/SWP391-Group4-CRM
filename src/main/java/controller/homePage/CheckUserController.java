package controller.homePage;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;


/**
 * Servlet implementation class CheckUserController
 */
@WebServlet("/checkUser")
public class CheckUserController extends HttpServlet {
	 private static final long serialVersionUID = 1L;
	    private UserDAO userDAO = new UserDAO();

	    @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String username = request.getParameter("username");
	        String email = request.getParameter("email");

	        boolean exists = false;

	        if (username != null && !username.isEmpty()) {
	            exists = userDAO.existsByUsername(username);
	        } else if (email != null && !email.isEmpty()) {
	            exists = userDAO.existsByEmail(email);
	        }

	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        response.getWriter().write("{\"exists\": " + exists + "}");
	    }
}
