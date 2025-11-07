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

        String action = request.getParameter("action"); 
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

        if ("register".equals(action)) {
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

            if(password == null || password.isEmpty()) {
                request.setAttribute("error", "Mật khẩu không được để trống!");
                forward(request, response, action);
                return;
            }

            User tempUser = new User();
            tempUser.setFullName(name);
            tempUser.setUsername(username);
            tempUser.setEmail(email);
            tempUser.setPhone(phone);
            tempUser.setPassword(password); // lưu tạm
            session.setAttribute("tempUser", tempUser);
        }

    
        String otp = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("otp", otp);
        session.setAttribute("otpEmail", email);
        session.setAttribute("otpTime", System.currentTimeMillis());
        session.setMaxInactiveInterval(5 * 60);

      
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
                
                session.setAttribute("otpPurpose", "register");

                message.setSubject("NovaCare - Mã xác thực đăng ký tài khoản");
                message.setText("Xin chào,\n\nMã OTP để đăng ký tài khoản của bạn là: " + otp
                        + "\nMã này có hiệu lực trong 5 phút.\n\nTrân trọng,\nTechShop");

                Transport.send(message);
                request.setAttribute("mss", "Đã gửi mã OTP đến email của bạn.");
                request.getRequestDispatcher("/view/authentication/verifyRegisterOTP.jsp").forward(request, response);

            } else if ("forgot".equals(action)) {
              
                session.setAttribute("otpPurpose", "reset");

                message.setSubject("NovaCare - Mã OTP đặt lại mật khẩu");
                message.setText("Xin chào " + user.getFullName() + ",\nMã OTP đặt lại mật khẩu: " + otp
                        + "\nMã này có hiệu lực trong 5 phút.\n\nTrân trọng,\nNovaCare");

                Transport.send(message);
                request.setAttribute("mss", "Đã gửi mã OTP đến email của bạn.");
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
            request.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(request, response);
        }
    }
}
