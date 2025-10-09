package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dao.DeviceDAO;
import dao.CategoryDAO;
import dao.SupplierDAO;
import model.Device;
import model.Category;
import model.Supplier;

@WebServlet("/device-detail")
public class DeviceDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DeviceDAO deviceDao = new DeviceDAO();
    private CategoryDAO categoryDao = new CategoryDAO();
    private SupplierDAO supplierDao = new SupplierDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	   int deviceId = Integer.parseInt(request.getParameter("id"));
           
           
           DeviceDAO deviceDAO = new DeviceDAO();
           Device device = deviceDAO.getDeviceById(deviceId); 

           request.setAttribute("device", device);
           
    
           request.getRequestDispatcher("/view/homepage/device-detailPage.jsp").forward(request, response);
       }
    

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
