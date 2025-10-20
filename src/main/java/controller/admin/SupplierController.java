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
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("action", "list");
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("action", "add");
        request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
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
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
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
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.setAttribute("action", "view");
        } catch (Exception e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        request.getRequestDispatcher("/view/profile/supplier.jsp").forward(request, response);
    }

    private void searchSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Supplier> all = supplierDAO.getAllSuppliers();
        List<Supplier> result = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            for (Supplier s : all) {
                if ((s.getName() != null && s.getName().toLowerCase().contains(keyword.toLowerCase()))
                        || (s.getEmail() != null && s.getEmail().toLowerCase().contains(keyword.toLowerCase()))
                        || (s.getPhone() != null && s.getPhone().contains(keyword))) {
                    result.add(s);
                }
            }
        } else {
            result = all;
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
                    URLEncoder.encode("Xóa thành công!", "UTF-8"));
        } catch (Exception e) {
            response.sendRedirect("supplier?action=list&error=" +
                    URLEncoder.encode("Xóa thất bại!", "UTF-8"));
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
            request.setAttribute("error", "Tên không được để trống!");
            listSuppliers(request, response);
            return;
        }
        if (email != null && !email.isEmpty() && !email.matches("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
            request.setAttribute("error", "Email không hợp lệ!");
            listSuppliers(request, response);
            return;
        }
        if (phone != null && !phone.isEmpty() && !phone.matches("^[0-9]{9,11}$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            listSuppliers(request, response);
            return;
        }

        Supplier supplier = new Supplier();
        supplier.setName(name);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);

        try {
            if ("add".equals(action)) {
                supplierDAO.addSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Thêm thành công!", "UTF-8"));
            } else if ("update".equals(action)) {
                supplier.setId(Integer.parseInt(request.getParameter("id")));
                supplierDAO.updateSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Cập nhật thành công!", "UTF-8"));
            } else {
                response.sendRedirect("supplier?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier?action=list&error=" +
                    URLEncoder.encode("Lỗi: " + e.getMessage(), "UTF-8"));
        }
    }
}
