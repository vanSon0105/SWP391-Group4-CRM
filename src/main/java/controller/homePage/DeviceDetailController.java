package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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
        int page = 1;
        int pageSize = 4; 

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        Device device = deviceDao.getDeviceById(deviceId);
        request.setAttribute("device", device);

        Category category = categoryDao.getCategoryById(device.getCategory().getId());
        request.setAttribute("category", category);

        List<Device> relatedDevices = deviceDao.getRelatedDevices(deviceId, device.getCategory().getId(), 50);
        int totalDevices = relatedDevices.size();
        int totalPages = (int) Math.ceil((double) totalDevices / pageSize);

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalDevices);
        List<Device> paginatedList = relatedDevices.subList(start, end);

        request.setAttribute("relatedDevices", paginatedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/view/homepage/device-detailPage.jsp").forward(request, response);
    }
}
