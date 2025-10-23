package controller.admin;

import dao.SupplierDAO;
import model.Supplier;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/supplier")
public class SupplierController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("account");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
            return;
        }

        if (currentUser.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này!");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSupplier(request, response); 
                break;
            case "restore":
                restoreSupplier(request, response);
                break;
            case "trash":
                listDeletedSuppliers(request, response);
                break;
            case "view":
                viewSupplier(request, response);
                break;
            case "search":
                searchSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();

        int pageSize = 5; 
        String pageParam = request.getParameter("page");
        int page = 1; 
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalSuppliers = suppliers.size();
        int totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);
        if (totalPages == 0) totalPages = 1; 

        if (page > totalPages) {
            page = totalPages;
        }

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalSuppliers);

        List<Supplier> suppliersPage = new ArrayList<>();
        if (totalSuppliers > 0) {
            suppliersPage = suppliers.subList(start, end);
        }

        request.setAttribute("suppliers", suppliersPage);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("action", "list");
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void listDeletedSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getDeletedSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("action", "trash");
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("action", "add");
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(id);
            if (supplier == null) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp!");
            } else {
                request.setAttribute("supplier", supplier);
            }
            request.setAttribute("action", "edit");
        } catch (Exception e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void viewSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(id);
            if (supplier == null) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp!");
            } else {
                request.setAttribute("supplier", supplier);
            }
            request.setAttribute("action", "view");
        } catch (Exception e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void searchSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.replace("+", " ").trim();
        }

        if (keyword == null || keyword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập từ khóa tìm kiếm!");
            listSuppliers(request, response);
            return;
        }
        if (keyword.length() > 50) {
            request.setAttribute("error", "Từ khóa quá dài (tối đa 50 ký tự)!");
            listSuppliers(request, response);
            return;
        }
        if (!keyword.matches("[a-zA-Z0-9@._\\p{L}\\s-]+")) {
            request.setAttribute("error", "Từ khóa chứa ký tự không hợp lệ!");
            listSuppliers(request, response);
            return;
        }

        List<Supplier> all = supplierDAO.getAllSuppliers();
        List<Supplier> result = new ArrayList<>();
        for (Supplier s : all) {
            if ((s.getName() != null && s.getName().toLowerCase().contains(keyword.toLowerCase()))
                    || (s.getEmail() != null && s.getEmail().toLowerCase().contains(keyword.toLowerCase()))
                    || (s.getPhone() != null && s.getPhone().contains(keyword))) {
                result.add(s);
            }
        }

        request.setAttribute("suppliers", result);
        request.setAttribute("keyword", keyword);
        request.setAttribute("action", "list");
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            supplierDAO.deleteSupplier(id); 
            response.sendRedirect("supplier?action=list&message=" +
                    URLEncoder.encode("Đã chuyển vào thùng rác!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect("supplier?action=list&error=" +
                    URLEncoder.encode("Xóa thất bại!", "UTF-8"));
        }
    }

    private void restoreSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            supplierDAO.restoreSupplier(id); 
            response.sendRedirect("supplier?action=trash&message=" +
                    URLEncoder.encode("Khôi phục thành công!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect("supplier?action=trash&error=" +
                    URLEncoder.encode("Khôi phục thất bại!", "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("account") : null;

        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này!");
            return;
        }

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên nhà cung cấp không được để trống!");
            forwardToForm(request, response, action);
            return;
        }
        if (!name.matches("^[\\p{L}0-9\\s.'-]{2,100}$")) {
            request.setAttribute("error", "Tên nhà cung cấp chỉ được chứa chữ, số và ký tự hợp lệ!");
            forwardToForm(request, response, action);
            return;
        }

        if ("add".equals(action)) {
            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("error", "Số điện thoại không được để trống khi thêm mới!");
                forwardToForm(request, response, action);
                return;
            }
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống khi thêm mới!");
                forwardToForm(request, response, action);
                return;
            }
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Địa chỉ không được để trống khi thêm mới!");
                forwardToForm(request, response, action);
                return;
            }
        }

        if (phone != null && !phone.isEmpty() && !phone.matches("^[0-9]{9,11}$")) {
            request.setAttribute("error", "Số điện thoại phải gồm 9–11 chữ số!");
            forwardToForm(request, response, action);
            return;
        }

        if (email != null && !email.isEmpty() && !email.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
            request.setAttribute("error", "Email không hợp lệ!");
            forwardToForm(request, response, action);
            return;
        }

        if (address != null && address.length() > 255) {
            request.setAttribute("error", "Địa chỉ quá dài (tối đa 255 ký tự)!");
            forwardToForm(request, response, action);
            return;
        }

        Supplier supplier = new Supplier();
        supplier.setName(name.trim());
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);

        try {
            if ("add".equals(action)) {
                supplierDAO.addSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Thêm nhà cung cấp thành công!", "UTF-8"));
            } else if ("update".equals(action)) {
                supplier.setId(Integer.parseInt(request.getParameter("id")));
                supplierDAO.updateSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Cập nhật thông tin thành công!", "UTF-8"));
            } else {
                response.sendRedirect("supplier?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier?action=list&error=" +
                    URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        }
    }

    private void forwardToForm(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        request.setAttribute("action", action);
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }
}
