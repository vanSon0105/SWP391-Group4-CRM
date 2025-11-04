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

@WebServlet("/verify-otp")
public class VerifyOTPController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String enteredOTP = request.getParameter("otp");
        String sentOTP = (String) session.getAttribute("otp");

        if (sentOTP != null && sentOTP.equals(enteredOTP)) {
            // Lấy thông tin người dùng từ session
            User tempUser = (User) session.getAttribute("tempUser");
            if (tempUser == null) {
                request.setAttribute("error", "Thông tin đăng ký không hợp lệ. Vui lòng thử lại!");
                request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
                return;
            }

            // Tạo tài khoản mới
            UserDAO dao = new UserDAO();
            boolean success = dao.registerUser(tempUser);
            if (success) {
                // Xóa session
                session.removeAttribute("otp");
                session.removeAttribute("tempUser");
                session.setAttribute("success", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect("login");
            } else {
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
                request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
            request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
        }
    }
}
