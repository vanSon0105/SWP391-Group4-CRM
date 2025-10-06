package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;

import java.io.IOException;
import java.util.List;

import dal.dao.HomePageDAO;

/**
 * Servlet implementation class HomePageController
 */
@WebServlet("/home")
public class HomePageController extends HttpServlet {
	public HomePageDAO hpd = new HomePageDAO();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<Device> listFeaturedDevices = hpd.listFeaturedDevices();
		List<Device> listNewDevices = hpd.listNewDevices();
		req.setAttribute("list", listFeaturedDevices);
		req.setAttribute("listNew", listNewDevices);
		req.getRequestDispatcher("view/homepage/homePage.jsp").forward(req, resp);
	}
	
	public static void main(String[] args) {
		HomePageDAO hpd1 = new HomePageDAO();
		List<Device> listFeaturedDevices = hpd1.listFeaturedDevices();
		for (Device device : listFeaturedDevices) {
			System.out.println(device.getDesc());
		}
	}

}
