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
			String keyword = request.getParameter("key");
			List<Category> listCategory = categoryDao.getAllCategories();
			List<Supplier> listSupplier = supplierDao.getAllSuppliers();
			
			String search = request.getParameter("search");
			String category = request.getParameter("category");
			String supplier = request.getParameter("supplier");
			String price = request.getParameter("price");
			String sortPrice = request.getParameter("sortPrice");
			String pageParam = request.getParameter("page");
			
			
			Integer categoryId = null;
			Integer supplierId = null;
			
			try {
				if (category != null && !category.isEmpty()) {
					categoryId = Integer.parseInt(category);
				}
			} catch (NumberFormatException e) {
				categoryId = null;
			}

			try {
				if (supplier != null && !supplier.isEmpty()) {
					supplierId = Integer.parseInt(supplier);
				}
			} catch (NumberFormatException e) {
				supplierId = null;
			}
			
			int page = 1;
			
			if(pageParam != null) {
				page = Integer.parseInt(pageParam);
			}
			
			int totalDevices = deviceDao.getFilteredDevicesCount(categoryId, supplierId, price);
			int totalPages = (int) Math.ceil((double) totalDevices / DEVICE_PER_PAGE);
			int offset = (page - 1) * DEVICE_PER_PAGE;
			
			page = Math.max(1, Math.min(page, totalPages));
			
			int maxPagesToShow = 3; 
            int startPage = 1;  
            int endPage = 1;
            if (totalPages > 0) {
                startPage = Math.max(1, page - 1);
                endPage = Math.min(totalPages, page + 1);
                if (endPage - startPage + 1 < maxPagesToShow) {
                    if (startPage == 1) {
                        endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);
                    } else if (endPage == totalPages) {
                        startPage = Math.max(1, totalPages - maxPagesToShow + 1);
                    }
                }
            }
			
			List<Device> listDevice = null;
			if(keyword != null) {
				listDevice = deviceDao.searchDevice(keyword);
			}else {
				listDevice = deviceDao.getFilteredDevices(categoryId, supplierId, price, sortPrice, offset, DEVICE_PER_PAGE);				
			}
			
			request.setAttribute("startPage", startPage);
			request.setAttribute("endPage", endPage);
			request.setAttribute("totalPages", totalPages);
			request.setAttribute("currentPage", page);
			request.setAttribute("totalDevices", totalDevices);
			request.setAttribute("key", keyword);
			request.setAttribute("listDevice", listDevice);
			request.setAttribute("listSupplier", listSupplier);
			request.setAttribute("listCategory", listCategory);

			request.getRequestDispatcher("view/homepage/devicePage.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}
}