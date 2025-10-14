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
import model.Device;
import model.Category;

@WebServlet("/device-detail")
public class DeviceDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DeviceDAO deviceDao = new DeviceDAO();
    private CategoryDAO categoryDao = new CategoryDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int deviceId = Integer.parseInt(request.getParameter("id"));

        Device device = deviceDao.getDeviceById(deviceId);
        request.setAttribute("device", device);

        Category category = categoryDao.getCategoryById(device.getCategory().getId());
        request.setAttribute("category", category);
        

        List<Device> relatedDevices = deviceDao.getRelatedDevices(deviceId, device.getCategory().getId(), 4);
        request.setAttribute("relatedDevices", relatedDevices);

        request.getRequestDispatcher("/view/homepage/device-detailPage.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
