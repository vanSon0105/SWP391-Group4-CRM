package controller.homePage;

import dao.UserDAO;
import model.User;
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
		req.getRequestDispatcher("view/authentication/register.jsp").forward(req, resp);
	}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        session.setAttribute("mss", "Đăng Ký Tài Khoản Thành Công");
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        int roleId = 1;

//        int roleId;
//        switch (role) {
//            case "Doanh nghiệp":
//                roleId = 2;
//                break;
//            case "Đăng ký dịch vụ sửa chữa":
//                roleId = 3;
//                break;
//            default:
//                roleId = 1;
//                break;
//        }

        User user = new User();
        user.setFullName(name);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setRoleId(roleId);
        user.setStatus("active");
        user.setImageUrl("/assets/images/default-avatar.png");

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(user);

        if (success) {
        	session.setAttribute("mss", "Đăng Ký Tài Khoản Thành Công");
            response.sendRedirect("login");
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
            response.sendRedirect("register");
        }
    }
}
