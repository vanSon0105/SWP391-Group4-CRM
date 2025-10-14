package controller.homePage;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class VerifyOTPController
 */
@WebServlet("/VerifyOTPController")
public class VerifyOTPController extends HttpServlet {
	 private static final long serialVersionUID = 1L;

	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String enteredOTP = request.getParameter("otp");
	        String newPassword = request.getParameter("newPassword");

	        HttpSession session = request.getSession();
	        String sentOTP = (String) session.getAttribute("otp");
	        String email = (String) session.getAttribute("email");

	        if (sentOTP != null && sentOTP.equals(enteredOTP)) {
	            UserDAO dao = new UserDAO();
	            dao.updatePassword(email, newPassword);

	            session.removeAttribute("otp");
	            session.removeAttribute("email");

	            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
	        } else {
	            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
	            request.getRequestDispatcher("verifyOTP.jsp").forward(request, response);
	        }
	    }

}
