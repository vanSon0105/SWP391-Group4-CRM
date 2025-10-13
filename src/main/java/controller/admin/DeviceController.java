package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;
import model.DeviceSerial;

import java.io.IOException;
import java.util.List;

import dao.DeviceDAO;

/**
 * Servlet implementation class DeviceController
 */
@WebServlet({"/device-show", "/device-view", "/device-serials"})
public class DeviceController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
            case "/device-show":
                showDeviceList(request, response);
                break;
            case "/device-serials":
            	viewDeviceSerialList(request, response);
            	break;
        }
	}
	
	public void showDeviceList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Device> listDevices = dao.findAllDevices();
		request.setAttribute("listDevices", listDevices);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}
	
	public void viewDeviceSerialList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String param = request.getParameter("id");
		int id = 0;
		if(param != null) {
			id = Integer.parseInt(param);			
		}
		List<DeviceSerial> listDeviceSerials = dao.getAllDeviceSerials(id);
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}


}
