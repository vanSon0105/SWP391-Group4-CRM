package controller.authentication;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.PasswordUtils;

@WebServlet("/verify-otp")
public class VerifyOTPController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

       
        String enteredOTP = request.getParameter("otp");
        String sentOTP = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");
        String otpPurpose = (String) session.getAttribute("otpPurpose"); 

        
        if (sentOTP != null && otpTime != null
                && sentOTP.equals(enteredOTP)
                && System.currentTimeMillis() - otpTime <= 5 * 60 * 1000) {

            UserDAO dao = new UserDAO();
            
            System.out.println("OTP Purpose: " + otpPurpose);
            System.out.println("OTP Email: " + session.getAttribute("otpEmail"));
            
            if ("register".equalsIgnoreCase(otpPurpose)) {

                User tempUser = (User) session.getAttribute("tempUser");
                String otpEmail = (String) session.getAttribute("otpEmail");

                if (tempUser == null || otpEmail == null) {
                    request.setAttribute("error", "Thông tin đăng ký không hợp lệ. Vui lòng thử lại!");
                    request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
                    return;
                }

                tempUser.setEmail(otpEmail);

                boolean success = dao.registerUser(tempUser);
                if (success) {
                    clearSession(session);
                    session.setAttribute("success", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
                    response.sendRedirect("login");
                } else {
                    request.setAttribute("error", "Đăng ký thất bại. Email hoặc tên đăng nhập đã tồn tại!");
                    request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
                }

            }
            
            else if ("reset".equalsIgnoreCase(otpPurpose)) {

                String email = (String) session.getAttribute("otpEmail");
                String newPassword = request.getParameter("newPassword");

                if (email == null) {
                    request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng thử lại!");
                    request.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(request, response);
                    return;
                }

                if (newPassword == null || newPassword.trim().isEmpty()) {
                    request.setAttribute("error", "Vui lòng nhập mật khẩu mới!");
                    request.getRequestDispatcher("/view/authentication/verifyOTP.jsp").forward(request, response);
                    return;
                }

            
                String hashedPassword = PasswordUtils.hashPassword(newPassword);
                boolean updated = dao.updatePassword(email, hashedPassword);

                if (updated) {
                    clearSession(session);
                    session.setAttribute("success", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập.");
                    response.sendRedirect("login");
                } else {
                    request.setAttribute("error", "Không thể cập nhật mật khẩu. Email không tồn tại!");
                    request.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Không xác định được yêu cầu xác minh. Vui lòng thử lại!");
                request.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
            request.getRequestDispatcher("/view/authentication/verifyotp.jsp").forward(request, response);
        }
    }

 
    private void clearSession(HttpSession session) {
        session.removeAttribute("otp");
        session.removeAttribute("otpEmail");
        session.removeAttribute("otpTime");
        session.removeAttribute("tempUser");
        session.removeAttribute("otpPurpose");
    }
}
