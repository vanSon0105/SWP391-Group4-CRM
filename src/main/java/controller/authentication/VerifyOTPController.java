package controller.authentication;

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

	    	HttpSession session = request.getSession();
	    	session.removeAttribute("mss");
	    	
	        String enteredOTP = request.getParameter("otp");
	        String newPassword = request.getParameter("newPassword");

	        String sentOTP = (String) session.getAttribute("otp");
	        String email = (String) session.getAttribute("email");

	        if (sentOTP != null && sentOTP.equals(enteredOTP)) {
	            UserDAO dao = new UserDAO();
	            dao.updatePassword(email, newPassword);

	            session.removeAttribute("otp");
	            session.removeAttribute("email");
	            session.setAttribute("mss", "Đổi mật khẩu thành công");
	            response.sendRedirect("login");
	        } else {
	            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
	            request.getRequestDispatcher("/view/authentication/verifyOTP.jsp").forward(request, response);
	        }
	    }

}
