package controller.homePage;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.DeviceDAO;
import dao.UserDAO;
import model.User;

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20)
public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private DeviceDAO dao = new DeviceDAO();

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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("account");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
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
            !(gender.equalsIgnoreCase("male") || gender.equalsIgnoreCase("female") || gender.equalsIgnoreCase("other"))) {
            errors.append("Giới tính không hợp lệ. ");
        }

        Timestamp birthday = null;
        if (birthdayStr == null || birthdayStr.trim().isEmpty()) {
            errors.append("Vui lòng chọn ngày sinh. ");
        } else {
            try {
                LocalDate date = LocalDate.parse(birthdayStr);
                if (date.isAfter(LocalDate.now())) {
                    errors.append("Ngày sinh không được ở tương lai. ");
                } else {
                    birthday = Timestamp.valueOf(date.atStartOfDay());
                }
            } catch (DateTimeParseException e) {
                errors.append("Định dạng ngày sinh không hợp lệ. ");
            }
        }
        
        if (email == null || email.trim().isEmpty()) {
            errors.append("Email không được để trống. ");
        } else if (!Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email.trim())) {
            errors.append("Email không hợp lệ. ");
        }
        
        String imageUrl = currentUser.getImageUrl();
        try {
            Part imagePart = request.getPart("imageUrl");
            if (imagePart != null && imagePart.getSize() > 0) {
                String submittedName = imagePart.getSubmittedFileName();
                String rawFileName = submittedName != null
                        ? Paths.get(submittedName).getFileName().toString().toLowerCase()
                        : "";

                if (!(rawFileName.endsWith(".jpg") || rawFileName.endsWith(".jpeg") || rawFileName.endsWith(".png"))) {
                    errors.append("Chỉ chấp nhận file JPG hoặc PNG. ");
                } else if (imagePart.getSize() > 5 * 1024 * 1024) {
                    errors.append("Kích thước ảnh vượt quá 5MB. ");
                } else {
                    String savedName = dao.saveUploadFile(imagePart, "user", getServletContext());
                    if (savedName == null || savedName.isEmpty()) {
                        errors.append("Không thể lưu ảnh tải lên. ");
                    } else {
                        if (imageUrl != null && !imageUrl.trim().isEmpty() && imageUrl.startsWith("assets/img/users/")) {
                            java.io.File oldFile = new java.io.File(getServletContext().getRealPath("/") + imageUrl);
                            if (oldFile.exists()) {
                                oldFile.delete();
                            }
                        }
                        imageUrl = savedName;
                    }
                }
            }
        } catch (Exception e) {
            errors.append("Lỗi khi tải ảnh lên. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("user", currentUser);
            request.setAttribute("errorMessage", errors.toString());
            request.getRequestDispatcher("/view/profile/UpdateProfile.jsp").forward(request, response);
            return;
        }

        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email.trim());
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

        response.sendRedirect("profile");
    }
}
