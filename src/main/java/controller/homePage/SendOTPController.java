package controller.homePage;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;

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
/**
 * Servlet implementation class SendOTPController
 */
@WebServlet("/SendOTPController")
public class SendOTPController extends HttpServlet {
	 private static final long serialVersionUID = 1L;

	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String email = request.getParameter("email");
	        String otp = String.format("%06d", new Random().nextInt(999999));

	        HttpSession session = request.getSession();
	        session.setAttribute("otp", otp);
	        session.setAttribute("email", email);
	        session.setMaxInactiveInterval(5 * 60); // 5 phút

	        final String from = "techshop.corporation@gmail.com";  // thay bằng Gmail bạn
	        final String pass = "uvatgwuvzzutcohc";         // App password Gmail
	        

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
	            message.setSubject("NovaCare - Mã OTP đặt lại mật khẩu");
	            message.setText("Xin chào,\n\nMã OTP đặt lại mật khẩu của bạn là: " + otp +
	                    "\nMã này có hiệu lực trong 5 phút.\n\nTrân trọng,\nĐội ngũ TechShop");

	            Transport.send(message);
	            request.getRequestDispatcher("/view/authentication/verifyOTP.jsp").forward(request, response);
	        } catch (MessagingException e) {
	            e.printStackTrace();
	            response.getWriter().println("Không thể gửi email: " + e.getMessage());
	        }
	    }

}
