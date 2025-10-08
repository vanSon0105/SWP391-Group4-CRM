package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import model.Device;
import model.Category;
import dao.DeviceDAO;
import dao.CategoryDAO;

@WebServlet("/device-page")
public class DevicePageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public static final int DEVICE_PER_PAGE = 6;
    DeviceDAO deviceDao = new DeviceDAO();
    CategoryDAO categoryDao = new CategoryDAO();
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<Device> listDevice = deviceDao.getAllDevices();
		List<Category> listCategory = categoryDao.getAllCategories();
		
		request.setAttribute("listDevice", listDevice);
		request.setAttribute("listCategory", listCategory);
		
		request.getRequestDispatcher("view/homepage/devicePage.jsp").forward(request, response);

	}



}
