package controller.homePage;

import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.UserDAO;
import model.User;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB
public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("account");
        User freshUser = userDAO.getUserById(currentUser.getId());

        if (freshUser != null) {
            session.setAttribute("account", freshUser); 
            request.setAttribute("user", freshUser);
        } else {
            request.setAttribute("user", currentUser);
        }

        String message = (String) session.getAttribute("profileMessage");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("profileMessage");
        }

        request.getRequestDispatcher("/view/profile/ViewProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("account");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender"); 
        String birthdayStr = request.getParameter("birthday");

        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
        }

        String imageUrl = currentUser.getImageUrl();
        try {
            Part imagePart = request.getPart("imageUrl");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/uploads/users");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                imagePart.write(uploadPath + "/" + fileName);
                imageUrl = "uploads/users/" + fileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setGender(gender);
        currentUser.setBirthday(birthday);
        currentUser.setImageUrl(imageUrl);

        boolean success = userDAO.updateUserProfile(currentUser);

        User updatedUser = userDAO.getUserById(currentUser.getId());
        if (updatedUser != null) {
            session.setAttribute("account", updatedUser);
        }

        if (success) {
            session.setAttribute("profileMessage", "Cập nhật hồ sơ thành công!");
        } else {
            session.setAttribute("profileMessage", "Cập nhật hồ sơ thất bại.");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
