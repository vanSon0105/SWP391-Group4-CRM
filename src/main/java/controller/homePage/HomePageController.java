package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Device;

import java.io.IOException;
import java.util.List;

import dal.dao.DeviceDAO;


@WebServlet(name="HomePageController", urlPatterns = {"/home", "/search"})
public class HomePageController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	private final int recordsEachPage = 4;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
        switch (path) {
            case "/search":
                searchDevices(req, resp);
                break;
            case "/home":
            	listDevices(req, resp);
            	break;

        }
	}
	
	private void listDevices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String featuredPageString = req.getParameter("fpage");
		int featuredPage = (featuredPageString != null) ? Integer.parseInt(featuredPageString) : 1;
		int featuredOffset = (featuredPage - 1) * recordsEachPage;
		
		String newPageString = req.getParameter("npage");
		int newPage = (newPageString != null) ? Integer.parseInt(newPageString) : 1;
		int newOffset = (newPage - 1) * recordsEachPage;
		
		List<Device> getFeaturedDevicesList = dao.getFeaturedDevicesList(featuredOffset, recordsEachPage);
		int totalFeatured = dao.getTotalFeaturedDevices();
		int totalFeaturedPages = (int) Math.ceil((double) totalFeatured / recordsEachPage);
		
		List<Device> getNewDevicesList = dao.getNewDevicesList(newOffset, recordsEachPage);
		int totalNew = dao.getTotalNewDevices();
		int totalNewPages = (int) Math.ceil((double) totalNew / recordsEachPage);
		
		req.setAttribute("listFeatured", getFeaturedDevicesList);
		req.setAttribute("currentFeaturedPage", featuredPage);
        req.setAttribute("totalFeaturedPages", totalFeaturedPages);
        
		req.setAttribute("listNew", getNewDevicesList);
		req.setAttribute("currentNewPage", newPage);
        req.setAttribute("totalNewPages", totalNewPages);
		req.getRequestDispatcher("view/homepage/homePage.jsp").forward(req, resp);
	}
	
	private void searchDevices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		HttpSession session = req.getSession();
		String key = req.getParameter("keyword");
		
		if(key != null && !key.trim().isEmpty()) {
			List<Device> listSearchDevices = dao.searchDevice(key);
			session.setAttribute("listSearchDevices", listSearchDevices);
			session.setAttribute("keyword", key);
			resp.sendRedirect("");
		}
	}
	
	public static void main(String[] args) {
		DeviceDAO hpd1 = new DeviceDAO();
		List<Device> getFeaturedDevicesList = hpd1.getFeaturedDevicesList(1,5);
		for (Device device : getFeaturedDevicesList) {
			System.out.println(device.toString());
		}
	}

}
