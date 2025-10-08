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
import model.Supplier;
import dao.DeviceDAO;
import dao.CategoryDAO;
import dao.SupplierDAO;

@WebServlet("/device-page")
public class DevicePageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static final int DEVICE_PER_PAGE = 6;
	DeviceDAO deviceDao = new DeviceDAO();
	CategoryDAO categoryDao = new CategoryDAO();
	SupplierDAO supplierDao = new SupplierDAO();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			List<Device> listDevice = deviceDao.getAllDevices();
			List<Category> listCategory = categoryDao.getAllCategories();
			List<Supplier> listSupplier = supplierDao.getAllSuppliers();

			String search = request.getParameter("search") == null ? null : request.getParameter("search");
			String category = request.getParameter("category");
			if(category == null || category.equals("all")) {
				category = null;
			}
			
			if(category == null ) {
				request.setAttribute("listDevice", listDevice);
			} else {
				listDevice = deviceDao.getDevicesByCategory(Integer.parseInt(category));
				request.setAttribute("listDevice", listDevice);
			}
			
			request.setAttribute("listSupplier", listSupplier);
			
			request.setAttribute("listCategory", listCategory);

			request.getRequestDispatcher("view/homepage/devicePage.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}

}
