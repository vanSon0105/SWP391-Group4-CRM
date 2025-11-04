package controller.authentication;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@WebServlet("/send-otp")
public class SendOTPController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); // "register" hoặc "forgot"
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email!");
            forward(request, response, action);
            return;
        }

        User user = userDAO.getUserByEmail(email);

        if ("register".equals(action) && user != null) {
            request.setAttribute("error", "Email đã được đăng ký!");
            forward(request, response, action);
            return;
        }
        if ("forgot".equals(action) && user == null) {
            request.setAttribute("error", "Email chưa được đăng ký!");
            forward(request, response, action);
            return;
        }

        HttpSession session = request.getSession();

        // Nếu đăng ký, lưu tempUser vào session
        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

            User tempUser = new User();
            tempUser.setFullName(name);
            tempUser.setUsername(username);
            tempUser.setEmail(email);
            tempUser.setPhone(phone);
            tempUser.setPassword(password); // lưu tạm

            session.setAttribute("tempUser", tempUser);
            session.setAttribute("otpSent", true);
        }

        // Tạo OTP và lưu session
        String otp = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setMaxInactiveInterval(5 * 60);

        // Gửi email
        final String from = "techshop.corporation@gmail.com";
        final String pass = "uvatgwuvzzutcohc";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));

            if ("register".equals(action)) {
                message.setSubject("NovaCare - Mã xác thực đăng ký tài khoản");
                message.setText("Xin chào,\n\nMã OTP để đăng ký tài khoản của bạn là: " + otp
                        + "\nMã này có hiệu lực trong 5 phút.\n\nTrân trọng,\nNovaCare");
            } else {
                message.setSubject("NovaCare - Mã OTP đặt lại mật khẩu");
                message.setText("Xin chào " + user.getFullName() + ",\nMã OTP đặt lại mật khẩu: " + otp);
            }

            Transport.send(message);

            request.setAttribute("mss", "Đã gửi mã OTP đến email của bạn.");
            if ("register".equals(action)) {
                request.getRequestDispatcher("/view/authentication/verifyRegisterOTP.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/authentication/verifyOTP.jsp").forward(request, response);
            }

        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
            forward(request, response, action);
        }
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        if ("register".equals(action)) {
            request.getRequestDispatcher("/view/authentication/register.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/view/authentication/forgotPassword.jsp").forward(request, response);
        }
    }
}

