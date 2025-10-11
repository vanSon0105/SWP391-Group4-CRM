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

import dao.DeviceDAO;


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
		//Best Selling Device
		String bestSellingPagetring = req.getParameter("bpage");
		int currentBestSellingPage = (bestSellingPagetring != null) ? Integer.parseInt(bestSellingPagetring) : 1;
		int bestSellingOffset = (currentBestSellingPage - 1) * recordsEachPage;
		
		//New Device
		String newPageString = req.getParameter("npage");
		int currentNewPage = (newPageString != null) ? Integer.parseInt(newPageString) : 1;
		int newOffset = (currentNewPage - 1) * recordsEachPage;
		
		//Best Selling Device
		String featuredPageString = req.getParameter("fpage");
		int currentFeaturedPage = (featuredPageString != null) ? Integer.parseInt(featuredPageString) : 1;
		int featuredOffset = (currentFeaturedPage - 1) * recordsEachPage;
		
		
		List<Device> getBestSellingDevicesList = dao.getBestSellingDevicesList(bestSellingOffset, recordsEachPage);
		int totalBestSelling = dao.getTotalBestSellingDevices();
		int totalBestSellingPages = (int) Math.ceil((double) totalBestSelling / recordsEachPage);
		
		List<Device> getNewDevicesList = dao.getNewDevicesList(newOffset, recordsEachPage);
		int totalNew = dao.getTotalNewDevices();
		int totalNewPages = (int) Math.ceil((double) totalNew / recordsEachPage);
		
		List<Device> getFeaturedDevicesList = dao.getFeaturedDevicesList(featuredOffset, recordsEachPage);
		int totalFeaturedDevices = dao.getTotalFeaturedDevices();
		int totalFeaturedDevicesPages = (int) Math.ceil((double) totalFeaturedDevices / recordsEachPage);
		
		req.setAttribute("listFeatured", getFeaturedDevicesList);
		req.setAttribute("currentFeaturedPage", currentFeaturedPage);
        req.setAttribute("totalFeaturedPages", totalFeaturedDevicesPages);
        
		req.setAttribute("listNew", getNewDevicesList);
		req.setAttribute("currentNewPage", currentNewPage);
        req.setAttribute("totalNewPages", totalNewPages);
        
        req.setAttribute("listBestSellingDevices", getBestSellingDevicesList);
		req.setAttribute("currentBestSellingPage", currentBestSellingPage);
        req.setAttribute("totalBestSellingPages", totalBestSellingPages);
        
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
		List<Device> getFeaturedDevicesList = hpd1.getFeaturedDevicesList(1,10);
		for (Device device : getFeaturedDevicesList) {
			System.out.println(device.toString());
		}
	}

}
