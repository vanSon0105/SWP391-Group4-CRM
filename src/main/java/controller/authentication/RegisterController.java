package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        if (session.getAttribute("tempUser") == null) {
            session.setAttribute("error", "Bạn phải xác thực email trước khi đăng ký!");
            req.getRequestDispatcher("/view/authentication/register.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/view/authentication/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("tempUser") == null) {
            session.setAttribute("error", "Bạn phải xác thực email trước khi đăng ký!");
            resp.sendRedirect(req.getContextPath() + "/view/authentication/verifyRegisterOTP.jsp");
            return;
        }


        resp.sendRedirect(req.getContextPath() + "/verifyRegisterOTP"); 
    }
}

