package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Device;
import model.DeviceSerial;

import java.io.IOException;
import java.util.List;

import dao.DeviceDAO;
import dao.DeviceSerialDAO;

/**
 * Servlet implementation class DeviceSerialController
 */
@WebServlet({"/device-serials", "/device-serials-active"})
public class DeviceSerialController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	public DeviceSerialDAO dsdao = new DeviceSerialDAO();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		int id = Integer.parseInt(request.getParameter("id"));			

		Device getDevice = dao.getDeviceById(id);
		List<DeviceSerial> listDeviceSerials = dsdao.getAllDeviceSerials(getDevice.getId());
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			

		
		boolean check = dsdao.statusSerial(id, "discontinued");
		String mess = check ? "Xóa serial thành công" : "Xóa serial thất bại";
		int deviceId = Integer.parseInt(request.getParameter("deviceId"));

	    HttpSession session = request.getSession();
	    session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-delete?id=" + deviceId + "#device-serial");
		
	}
	
	public void activeDeviceSerials(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		int serialId = Integer.parseInt(request.getParameter("sid"));
		int deviceId = Integer.parseInt(request.getParameter("id"));
		
		boolean check = dsdao.statusSerial(serialId, "active");
		String mess = check ? "Active serial thành công" : "Active serial thất bại";
		
	    session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-delete?id=" + deviceId + "#device-serial");
	}
}
