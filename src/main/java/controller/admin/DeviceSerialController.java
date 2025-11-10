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
	private static final int SERIALS_PER_PAGE = 10;
	public DeviceDAO dao = new DeviceDAO();
	public DeviceSerialDAO dsdao = new DeviceSerialDAO();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = Integer.parseInt(request.getParameter("id"));

        int requestedPage = 1;
        try {
            requestedPage = Integer.parseInt(request.getParameter("page"));
            if (requestedPage < 1) {
                requestedPage = 1;
            }
        } catch (NumberFormatException ignored) {
        }

        int totalSerials = dsdao.getTotalDeviceSerials(id, null, null, null);
        int totalPages = (int) Math.ceil((double) totalSerials / SERIALS_PER_PAGE);
        if (totalPages == 0) {
            totalPages = 0;
            requestedPage = 1;
        } else if (requestedPage > totalPages) {
            requestedPage = totalPages;
        }
        int offset = (requestedPage - 1) * SERIALS_PER_PAGE;

        List<DeviceSerial> listDeviceSerials = dsdao.getDeviceSerialsByPage(id, null, offset, SERIALS_PER_PAGE, null, null);
        Device getDevice = dao.getDeviceById(id);

        request.setAttribute("device", getDevice);
        request.setAttribute("deviceId", id);
        request.setAttribute("listDeviceSerials", listDeviceSerials);
        request.setAttribute("serialCurrentPage", requestedPage);
        request.setAttribute("serialTotalPages", totalPages);
        request.setAttribute("serialTotal", totalSerials);
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
