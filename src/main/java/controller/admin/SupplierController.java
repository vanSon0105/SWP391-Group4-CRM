package controller.admin;

import dao.SupplierDAO;
import dao.SupplierDetailDAO;
import model.Supplier;
import model.SupplierDetail;
import model.User;
import utils.AuthorizationUtils;
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
    private SupplierDetailDAO detailDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
        detailDAO = new SupplierDetailDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "SUPPLIER_INFORMATION_MANAGEMENT");
        if (currentUser == null) return;

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        switch (action) {
            case "add":
                checkPermission(request, response, "CRUD_SUPPLIER");
                showAddForm(request, response);
                break;
            case "edit":
                checkPermission(request, response, "CRUD_SUPPLIER");
                showEditForm(request, response);
                break;
            case "delete":
                checkPermission(request, response, "CRUD_SUPPLIER");
                deleteSupplier(request, response);
                break;
            case "restore":
                restoreSupplier(request, response);
                break;
            case "trash":
                listDeletedSuppliers(request, response);
                break;
            case "viewHistory":
                viewSupplierWithOptionalHistory(request, response, action);
                break;
            case "search":
                searchSuppliers(request, response);
                break;
            case "filter":
                filterSuppliers(request, response);
                break;
            default:
                searchSuppliers(request, response);
        }
    }

    private void checkPermission(HttpServletRequest request, HttpServletResponse response, String permission) throws IOException {
        if (!AuthorizationUtils.hasPermission(request.getSession(false), permission)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("action", "add");
        request.getRequestDispatcher("/view/admin/supplier/AddSupplier.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(id);
            if (supplier == null) request.setAttribute("error", "Không tìm thấy nhà cung cấp!");
            else request.setAttribute("supplier", supplier);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        request.setAttribute("action", "edit");
        request.getRequestDispatcher("/view/admin/supplier/EditSupplier.jsp").forward(request, response);
    }

    private void searchSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword != null) keyword = keyword.replace("+", " ").trim();
        else keyword = "";

        int page = parsePageParam(request.getParameter("page"));
        int pageSize = 5;
        int totalSuppliers = supplierDAO.countSuppliersByKeyword(keyword);
        int totalPages = calculateTotalPages(totalSuppliers, pageSize, page);

        List<Supplier> suppliersPage = supplierDAO.searchSuppliersWithPaging(keyword, page, pageSize);

        request.setAttribute("suppliers", suppliersPage);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("action", "list");
        request.getRequestDispatcher("/view/admin/supplier/ListSupplier.jsp").forward(request, response);
    }

    private void filterSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String addressFilter = request.getParameter("address");
        if (addressFilter != null) addressFilter = addressFilter.trim().toLowerCase();

        int page = parsePageParam(request.getParameter("page"));
        int pageSize = 5;
        int totalSuppliers = supplierDAO.countSuppliersByFilter(statusFilter, addressFilter);
        int totalPages = calculateTotalPages(totalSuppliers, pageSize, page);

        List<Supplier> suppliersPage = supplierDAO.filterSuppliers(statusFilter, addressFilter, page, pageSize);

        request.setAttribute("suppliers", suppliersPage);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("addressFilter", addressFilter);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("action", "filter");
        request.getRequestDispatcher("/view/admin/supplier/ListSupplier.jsp").forward(request, response);
    }

    private void listDeletedSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getDeletedSuppliers();
        if (suppliers == null) suppliers = new ArrayList<>();
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("action", "trash");
        request.getRequestDispatcher("/view/admin/supplier/ListSupplier.jsp").forward(request, response);
    }

    private void viewSupplierWithOptionalHistory(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(id);
            if (supplier == null) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp!");
            } else {
                request.setAttribute("supplier", supplier);
                if ("viewHistory".equals(action)) {
                    List<SupplierDetail> history = detailDAO.getDetailsBySupplierId(id);
                    request.setAttribute("history", history);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        request.setAttribute("action", action);
        request.getRequestDispatcher("/view/admin/supplier/ListSupplier.jsp").forward(request, response);
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
        User currentUser = AuthorizationUtils.requirePermission(request, response, "CRUD_SUPPLIER");
        if (currentUser == null) return;

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Integer id = null;
        if ("update".equals(action)) {
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException ignored) {}
        }

        String error = validateSupplierInput(action, name, phone, email, address, id);
        if (error != null) {
            Supplier supplier = new Supplier();
            if (id != null) supplier.setId(id);
            supplier.setName(name);
            supplier.setPhone(phone);
            supplier.setEmail(email);
            supplier.setAddress(address);

            request.setAttribute("error", error);
            request.setAttribute("supplier", supplier);
            request.setAttribute("action", "add".equals(action) ? "add" : "edit");

            request.getRequestDispatcher("/view/admin/supplier/" +
                    ("add".equals(action) ? "AddSupplier.jsp" : "EditSupplier.jsp")).forward(request, response);
            return;
        }

        Supplier supplier = new Supplier();
        if (id != null) supplier.setId(id);
        supplier.setName(name.trim());
        supplier.setPhone(phone.trim());
        supplier.setEmail(email.trim());
        supplier.setAddress(address.trim());
        supplier.setStatus(1);

        try {
            if ("add".equals(action)) {
                supplierDAO.addSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Thêm nhà cung cấp thành công!", "UTF-8"));
            } else if ("update".equals(action)) {
                supplierDAO.updateSupplier(supplier);
                response.sendRedirect("supplier?action=list&message=" +
                        URLEncoder.encode("Cập nhật thông tin thành công!", "UTF-8"));
            } else {
                response.sendRedirect("supplier?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private int parsePageParam(String pageParam) {
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        return page;
    }

    private int calculateTotalPages(int totalItems, int pageSize, int currentPage) {
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;
        return totalPages;
    }

    private String validateSupplierInput(String action, String name, String phone, String email, String address, Integer id) {
        if (name != null) name = name.trim();
        if (phone != null) phone = phone.trim();
        if (email != null) email = email.trim();
        if (address != null) address = address.trim();

        if (name == null || name.isEmpty())
            return "Tên nhà cung cấp không được để trống!";
        if (!name.matches("^[\\p{L}0-9\\s.'-]{2,100}$"))
            return "Tên nhà cung cấp chỉ được chứa chữ, số và ký tự hợp lệ (2-100 ký tự)!";

        if (phone == null || phone.isEmpty())
            return "Số điện thoại không được để trống!";
        if (!phone.matches("^[0-9]{9,10}$"))
            return "Số điện thoại phải gồm 9–10 chữ số!";
        try {
            if (supplierDAO.existsPhone(phone, id))
                return "Số điện thoại đã tồn tại!";
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        if (email == null || email.isEmpty())
            return "Email không được để trống!";
        if (!email.matches("^[\\w.%+-]+@[\\w.-]+\\.com$"))
            return "Email không hợp lệ! Chỉ cho phép đuôi .com";
        try {
            if (supplierDAO.existsEmail(email, id))
                return "Email đã tồn tại!";
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        if (address == null || address.isEmpty())
            return "Địa chỉ không được để trống!";
        if (address.length() > 255)
            return "Địa chỉ quá dài (tối đa 255 ký tự)!";
        if (!address.matches("^[\\p{L}0-9\\s.,'\\-/]+$"))
            return "Địa chỉ chỉ được chứa chữ, số và ký tự cơ bản (.,'-/)!";

        return null;
    }
}
