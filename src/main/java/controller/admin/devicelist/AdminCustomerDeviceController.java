package controller.admin.devicelist;

import dao.UserDAO;
import dao.DeviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Customer;
import model.CustomerDeviceView;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/customer-devices")
public class AdminCustomerDeviceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	User currentUser = AuthorizationUtils.requirePermission(request, response, "Quản Lí Thiết Bị");
        if (currentUser == null) {
            return; 
        }
        

        String customerIdStr = request.getParameter("customerId");

        UserDAO userDAO = new UserDAO();
        DeviceDAO deviceDAO = new DeviceDAO();

        
        List<User> users = userDAO.getAllCustomers();
        request.setAttribute("customers", users);

        List<CustomerDeviceView> devices = null;

        if (customerIdStr != null && !customerIdStr.isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdStr);

                devices = deviceDAO.getDevicesByCustomerId(customerId); 
                request.setAttribute("devices", devices);

                User selected = userDAO.getUserById(customerId);
                request.setAttribute("selectedCustomer", selected);

            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "ID khách hàng không hợp lệ!");
            }
        }

        // debug
        System.out.println("Number of customers: " + users.size());
        System.out.println("CustomerIdStr: " + customerIdStr);
        if (devices != null) System.out.println("Devices count: " + devices.size());

        request.getRequestDispatcher("/view/admin/device/customer-device.jsp").forward(request, response);
    }
}
