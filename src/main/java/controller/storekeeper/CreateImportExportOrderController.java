package controller.storekeeper;

import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import model.*;
import utils.AuthorizationUtils;

@WebServlet("/create-transaction")
public class CreateImportExportOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final DeviceDAO deviceDAO = new DeviceDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final UserDAO userDAO = new UserDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final TransactionDetailDAO detailDAO = new TransactionDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = AuthorizationUtils.requirePermission(request, response, "TRANSACTION_MANAGEMENT");
        if (currentUser == null) return;

        List<Device> deviceList = deviceDAO.getAllDevices();
        List<Supplier> supplierList = supplierDAO.getAllSuppliers();
        List<User> userList = userDAO.getAllUsers();

        for (Device d : deviceList) {
            Inventory inv = inventoryDAO.getInventoryByDevice(d.getId());
            d.setCurrentStock(inv != null ? inv.getQuantity() : 0);
        }

        request.setAttribute("deviceList", deviceList);
        request.setAttribute("supplierList", supplierList);
        request.setAttribute("userList", userList);
        request.setAttribute("now", new java.util.Date());
        request.getRequestDispatcher("/view/transaction/createTransaction.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User currentUser = AuthorizationUtils.requirePermission(request, response, "CREATE_TRANSACTION");
        if (currentUser == null) return;

        try {
            int storekeeperId = currentUser.getId();
            String type = request.getParameter("type");
            String note = request.getParameter("note");

            if (type == null || type.isEmpty()) {
                request.setAttribute("error", "Loại giao dịch không được để trống!");
                doGet(request, response);
                return;
            }
            if (!"import".equalsIgnoreCase(type) && !"export".equalsIgnoreCase(type)) {
                request.setAttribute("error", "Loại giao dịch không hợp lệ!");
                doGet(request, response);
                return;
            }

            if (note != null && note.length() > 500) {
                request.setAttribute("error", "Ghi chú không được vượt quá 500 ký tự!");
                doGet(request, response);
                return;
            }

            Integer supplierId = null;
            Integer userId = null;

            if ("import".equalsIgnoreCase(type)) {
                String sParam = request.getParameter("supplierId");
                if (sParam == null || sParam.isEmpty()) {
                    request.setAttribute("error", "Chưa chọn nhà cung cấp!");
                    doGet(request, response);
                    return;
                }
                try {
                    supplierId = Integer.parseInt(sParam);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID nhà cung cấp không hợp lệ!");
                    doGet(request, response);
                    return;
                }
                if (supplierDAO.getSupplierById(supplierId) == null) {
                    request.setAttribute("error", "Nhà cung cấp không tồn tại!");
                    doGet(request, response);
                    return;
                }
            } else if ("export".equalsIgnoreCase(type)) {
                String uParam = request.getParameter("userId");
                if (uParam == null || uParam.isEmpty()) {
                    request.setAttribute("error", "Chưa chọn người dùng!");
                    doGet(request, response);
                    return;
                }
                try {
                    userId = Integer.parseInt(uParam);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID người dùng không hợp lệ!");
                    doGet(request, response);
                    return;
                }
                if (userDAO.getUserById(userId) == null) {
                    request.setAttribute("error", "Người dùng không tồn tại!");
                    doGet(request, response);
                    return;
                }
            }

            String[] deviceIds = request.getParameterValues("deviceIds[]");
            String[] quantities = request.getParameterValues("quantities[]");

            if (deviceIds == null || deviceIds.length == 0) {
                request.setAttribute("error", "Chưa chọn thiết bị nào!");
                doGet(request, response);
                return;
            }
            if (quantities == null || quantities.length != deviceIds.length) {
                request.setAttribute("error", "Số lượng không khớp với danh sách thiết bị!");
                doGet(request, response);
                return;
            }

            Map<Integer, Integer> deviceQuantityMap = new HashMap<>();
            Set<Integer> seenDevices = new HashSet<>();
            Set<String> deviceNamesForExport = new HashSet<>(); // validate trùng tên khi export

            for (int i = 0; i < deviceIds.length; i++) {
                int deviceId;
                int quantity;

                try {
                    deviceId = Integer.parseInt(deviceIds[i]);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID thiết bị tại vị trí " + (i + 1) + " không hợp lệ!");
                    doGet(request, response);
                    return;
                }

                if (seenDevices.contains(deviceId)) {
                    request.setAttribute("error", "Thiết bị ID " + deviceId + " đã được chọn trùng!");
                    doGet(request, response);
                    return;
                }
                seenDevices.add(deviceId);

                try {
                    quantity = Integer.parseInt(quantities[i]);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Số lượng tại vị trí " + (i + 1) + " không hợp lệ!");
                    doGet(request, response);
                    return;
                }

                if (quantity <= 0) {
                    request.setAttribute("error", "Số lượng phải lớn hơn 0 cho thiết bị ID: " + deviceId);
                    doGet(request, response);
                    return;
                }

                Device device = deviceDAO.getDeviceById(deviceId);
                if (device == null) {
                    request.setAttribute("error", "Thiết bị ID " + deviceId + " không tồn tại!");
                    doGet(request, response);
                    return;
                }

                if ("export".equalsIgnoreCase(type) && userId != null) {
                    String deviceName = device.getName();
                    if (deviceNamesForExport.contains(deviceName)) {
                        request.setAttribute("duplicateNameError",
                            "Người nhận đã chọn 2 sản phẩm cùng tên: " + deviceName);
                        doGet(request, response);
                        return;
                    }
                    deviceNamesForExport.add(deviceName);
                }

                deviceQuantityMap.put(deviceId, quantity);
            }

            Transaction transaction = new Transaction();
            transaction.setStorekeeperId(storekeeperId);
            transaction.setSupplierId(supplierId);
            transaction.setUserId(userId);
            transaction.setType(type);
            transaction.setStatus("confirmed");
            transaction.setNote(note);

            int transactionId = transactionDAO.createTransaction(transaction);
            if (transactionId <= 0) {
                request.setAttribute("error", "Tạo đơn thất bại!");
                doGet(request, response);
                return;
            }

            for (Map.Entry<Integer, Integer> entry : deviceQuantityMap.entrySet()) {
                int deviceId = entry.getKey();
                int quantity = entry.getValue();

                TransactionDetail detail = new TransactionDetail();
                detail.setTransactionId(transactionId);
                detail.setDeviceId(deviceId);
                detail.setQuantity(quantity);
                detailDAO.addTransactionDetail(detail, type);

                Inventory inv = inventoryDAO.getInventoryByDeviceAndStorekeeper(deviceId, storekeeperId);

                if ("import".equalsIgnoreCase(type)) {
                    if (inv == null) {
                        Inventory newInv = new Inventory();
                        newInv.setDeviceId(deviceId);
                        newInv.setStorekeeperId(storekeeperId);
                        newInv.setQuantity(quantity);
                        inventoryDAO.addInventory(newInv);
                    } else {
                        inventoryDAO.adjustQuantity(deviceId, storekeeperId, quantity);
                    }
                } else {
                    if (inv == null || inv.getQuantity() < quantity) {
                        request.setAttribute("error", "Tồn kho không đủ để xuất thiết bị ID: " + deviceId
                                + ". Hiện tại: " + (inv != null ? inv.getQuantity() : 0));
                        doGet(request, response);
                        return;
                    }
                    inventoryDAO.adjustQuantity(deviceId, storekeeperId, -quantity);
                }
            }

            request.getSession().setAttribute("message", "Tạo đơn " + type + " thành công!");
            response.sendRedirect(request.getContextPath() + "/create-transaction");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}