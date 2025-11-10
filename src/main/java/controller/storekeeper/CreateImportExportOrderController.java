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
    private final DeviceSerialDAO deviceSerialDAO = new DeviceSerialDAO();

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
                supplierId = Integer.parseInt(sParam);
                if (supplierDAO.getSupplierById(supplierId) == null) {
                    request.setAttribute("error", "Nhà cung cấp không tồn tại!");
                    doGet(request, response);
                    return;
                }
            } else {
                String uParam = request.getParameter("userId");
                if (uParam == null || uParam.isEmpty()) {
                    request.setAttribute("error", "Chưa chọn người dùng!");
                    doGet(request, response);
                    return;
                }
                userId = Integer.parseInt(uParam);
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

            List<Integer> deviceIdList = new ArrayList<>();
            List<Integer> quantityList = new ArrayList<>();
            List<String> deviceNameList = new ArrayList<>();
            List<Device> selectedDevices = new ArrayList<>();

            for (int i = 0; i < deviceIds.length; i++) {
                int deviceId;
                int quantity;

                try {
                    deviceId = Integer.parseInt(deviceIds[i]);
                    quantity = Integer.parseInt(quantities[i]);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID hoặc số lượng tại vị trí " + (i + 1) + " không hợp lệ!");
                    doGet(request, response);
                    return;
                }

                if (deviceIdList.contains(deviceId)) {
                	request.setAttribute("error", "Thiết bị ID " + deviceId + " bị chọn trùng!");
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

                if ("export".equalsIgnoreCase(type) && deviceNameList.contains(device.getName())) {
                    request.setAttribute("error", "Người nhận đã chọn 2 sản phẩm cùng tên: " + device.getName());
                    doGet(request, response);
                    return;
                }

                deviceIdList.add(deviceId);
                quantityList.add(quantity);
                deviceNameList.add(device.getName());
                selectedDevices.add(device);
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

            for (int i = 0; i < deviceIdList.size(); i++) {
                int deviceId = deviceIdList.get(i);
                int quantity = quantityList.get(i);
                Device device = selectedDevices.get(i);
                if (device == null) {
                    device = deviceDAO.getDeviceById(deviceId);
                }
                if (device == null) {
                    request.setAttribute("error", "Không tìm thấy thiết bị ID: " + deviceId + " để ghi nhận giao dịch.");
                    doGet(request, response);
                    return;
                }

                if ("import".equalsIgnoreCase(type)) {
                    boolean serialInserted = deviceSerialDAO.insertDeviceSerials(device, quantity);
                    if (!serialInserted) {
                        request.setAttribute("error", "Không thể tạo serial cho thiết bị " + device.getName() + ". Giao dịch đã bị hủy.");
                        doGet(request, response);
                        return;
                    }
                }

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
                        request.setAttribute("error", "Tồn kho không đủ để xuất thiết bị ID: " + deviceId);
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