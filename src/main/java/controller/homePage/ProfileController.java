package controller.homePage;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.UserDAO;
import model.User;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
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

        String action = request.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/view/profile/UpdateProfile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/view/profile/ViewProfile.jsp").forward(request, response);
        }
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

        StringBuilder errors = new StringBuilder();

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Họ tên không được để trống. ");
        } else if (fullName.trim().length() < 2 || fullName.trim().length() > 50) {
            errors.append("Họ tên phải từ 2–50 ký tự. ");
        } else if (!Pattern.matches("^[\\p{L} ]+$", fullName.trim())) {
            errors.append("Họ tên chỉ được chứa chữ cái và dấu cách. ");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.append("Số điện thoại không được để trống. ");
        } else if (!Pattern.matches("^0\\d{9,10}$", phone.trim())) {
            errors.append("Số điện thoại không hợp lệ. ");
        }

        if (gender == null || 
            !(gender.equalsIgnoreCase("Male") || gender.equalsIgnoreCase("Female") || gender.equalsIgnoreCase("Other"))) {
            errors.append("Giới tính không hợp lệ. ");
        }

        Date birthday = null;
        if (birthdayStr == null || birthdayStr.trim().isEmpty()) {
            errors.append("Vui lòng chọn ngày sinh. ");
        } else {
            try {
                birthday = Date.valueOf(birthdayStr);
                if (birthday.toLocalDate().isAfter(LocalDate.now())) {
                    errors.append("Ngày sinh không được ở tương lai. ");
                }
            } catch (IllegalArgumentException e) {
                errors.append("Định dạng ngày sinh không hợp lệ. ");
            }
        }

        String imageUrl = currentUser.getImageUrl();
        try {
            Part imagePart = request.getPart("imageUrl");
            if (imagePart != null && imagePart.getSize() > 0) {
                String rawFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString().toLowerCase();
                if (!(rawFileName.endsWith(".jpg") || rawFileName.endsWith(".jpeg") || rawFileName.endsWith(".png"))) {
                    errors.append("Chỉ chấp nhận file JPG hoặc PNG. ");
                } else if (imagePart.getSize() > 5 * 1024 * 1024) {
                    errors.append("Kích thước ảnh vượt quá 5MB. ");
                } else {
                    String fileName = System.currentTimeMillis() + "_" + rawFileName;
                    String uploadPath = getServletContext().getRealPath("/uploads/users");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    imagePart.write(uploadPath + "/" + fileName);
                    imageUrl = "uploads/users/" + fileName;
                }
            }
        } catch (Exception e) {
            errors.append("Lỗi khi tải ảnh lên. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("user", currentUser);
            request.setAttribute("errorMessage", errors.toString());
            request.getRequestDispatcher("/view/profile/ViewProfile.jsp").forward(request, response);
            return;
        }

        currentUser.setFullName(fullName.trim());
        currentUser.setPhone(phone.trim());
        currentUser.setGender(gender.trim());
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
