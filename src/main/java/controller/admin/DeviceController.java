package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Category;
import model.Device;
import model.DeviceSerial;
import model.User;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import dao.CategoryDAO;
import dao.DeviceDAO;
import dao.DeviceSerialDAO;
import dao.UserDAO;

/**
 * Servlet implementation class DeviceController
 */
@WebServlet({"/device-show", "/device-view", "/device-update", "/device-add", "/device-delete", "/device-active"})
@MultipartConfig
public class DeviceController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	public CategoryDAO cdao = new CategoryDAO();
	public DeviceSerialDAO dsdao = new DeviceSerialDAO();
	private final int recordsEachPage = 10;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
            case "/device-delete":
                deleteDevice(request, response);
                break;
            case "/device-view":
            	viewDeviceDetails(request, response);
            	break;
            case "/device-update":
            	updateDevice(request, response);
            	break;
            case "/device-add":
            	addDevice(request, response);
            	break;
            case "/device-active":
            	activeDevice(request, response);
            	break;
            default:
            	showDeviceList(request, response);
        }
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
            case "/device-update":
            	updateDeviceDoPost(request, response);
            	break;
            case "/device-add":
            	addDeviceDoPost(request, response);
            	break;
            case "/device-delete":
            	deleteDeviceDoPost(request, response);
            	break;
        }
    }
	
	public void showDeviceList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
	    String mess = (String) session.getAttribute("mess");
	    if (mess != null) {
	        request.setAttribute("mess", mess);
	        session.removeAttribute("mess");
	    }
	    
		String page = request.getParameter("page");
		String key = request.getParameter("key");
		String categoryIdParam = request.getParameter("categoryId");
		String sortBy = request.getParameter("sortBy");
	    String order = request.getParameter("order");
		
		int categoryId = (categoryIdParam != null) ? Integer.parseInt(categoryIdParam) : 0;
		int currentPage = (page != null) ? Integer.parseInt(page) : 1;
		
		int offset = (currentPage - 1) * recordsEachPage;
		List<Category> listCategories = cdao.getAllCategories();
		List<Device> listDevices = dao.getDevicesByPage(key, offset, recordsEachPage, categoryId, sortBy, order);
		
		int totalDevices = dao.getTotalDevices(key, categoryId, sortBy, order);
		int totalPages = (int) Math.ceil((double) totalDevices / recordsEachPage);
		
		request.setAttribute("totalDevices", totalDevices);
		request.setAttribute("listCategories", listCategories);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("listDevices", listDevices);
		request.setAttribute("selectedCategory", categoryId);
		request.setAttribute("sortBy", sortBy);
	    request.setAttribute("order", order);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}
	
	public void viewDeviceDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			

		
		Device d = dao.getDeviceDetail(id);
		request.setAttribute("deviceDetail", d);
		request.getRequestDispatcher("view/admin/device/view.jsp").forward(request, response);
	}
	
	public void updateDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			

		
		Device getDevice = dao.getDeviceById(id);
		List<Category> listCategory = cdao.getAllCategories();
		request.setAttribute("device", getDevice);
        request.setAttribute("categories", listCategory);
		request.getRequestDispatcher("view/admin/device/edit.jsp").forward(request, response);
	}
	
	public void updateDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
        int id = Integer.parseInt(request.getParameter("id"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));	
        Double price = Double.parseDouble(request.getParameter("price"));
		
		Part filePart = request.getPart("image");
        String fileName = dao.saveUploadFile(filePart, "device", getServletContext());
        if (fileName.isEmpty()) {
            Device oldDevice = dao.getDeviceById(id);
            fileName = oldDevice.getImageUrl();
        }
		
        Category c = cdao.getCategoryById(categoryId);
        String unit = request.getParameter("unit");
        String description = request.getParameter("description");
        Boolean isFeatured = Boolean.parseBoolean(request.getParameter("isFeatured"));
        
        Device device = new Device(id, c, name, price, fileName, unit, description, isFeatured);
        boolean check = dao.updateDevice(device);
        String mess = check ? "Update device thành công" : "Update device thất bại";
		HttpSession session = request.getSession();
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-show");
	}
	
	public void addDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Category> listCategory = cdao.getAllCategories();
        request.setAttribute("categories", listCategory);
		request.getRequestDispatcher("view/admin/device/add.jsp").forward(request, response);
	}

	public void addDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		boolean checkName = dao.checkExistByName(name);
        int categoryId = 0;
        Double price = 0.0;
		try {
			categoryId = Integer.parseInt(request.getParameter("categoryId"));		
			price = Double.parseDouble(request.getParameter("price")); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Part filePart = request.getPart("image");
        String fileName = dao.saveUploadFile(filePart, "device", getServletContext());
        if (fileName.isEmpty()) {
            fileName = null;
        }
		
        Category c = cdao.getCategoryById(categoryId);
        String unit = request.getParameter("unit");
        String description = request.getParameter("description");
        Boolean isFeatured = Boolean.parseBoolean(request.getParameter("isFeatured"));
        if(checkName) {
    		checkAddDevice(request, response, fileName, categoryId, categoryId, unit, description, checkName, "Thiết bị đã tồn tại!");
			return;
		}
        
        Device d = new Device();
        d.setCategory(c);
        d.setName(name);
        d.setPrice(price);
        d.setUnit(unit);
        d.setImageUrl(fileName);
        d.setDesc(description);
        d.setIsFeatured(isFeatured);
        
        int newDeviceId = dao.insertDevice(d);
        if(newDeviceId <= 0) {
        	checkAddDevice(request, response, fileName, categoryId, categoryId, unit, description, checkName, "Thêm thiết bị thất bại! Vui lòng thử lại");
			return;
        }
        
        int storekeeperId = getStorekeeperId(request);
		if (storekeeperId != 0) {
			dao.insertInventory(newDeviceId, storekeeperId, 0);
		}
        String mess = "Add device thành công";
		HttpSession session = request.getSession();
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-show");
	}

	public void deleteDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			

		Device getDevice = dao.getDeviceById(id);
		List<DeviceSerial> listDeviceSerials = dsdao.getAllDeviceSerials(getDevice.getId());
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.setAttribute("device", getDevice);
		request.getRequestDispatcher("view/admin/device/delete.jsp").forward(request, response);
	}
	
	
	public void deleteDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			

		boolean check = dao.deleteDevice(id);
		String mess = check ? "Delete device thành công" : "Delete device thất bại";
		HttpSession session = request.getSession();
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-show");
	}
	
	private int getStorekeeperId(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			User current = (User) session.getAttribute("account");
			if (current != null && current.getRoleId() == 4) {
				return current.getId();
			}
		}
		UserDAO userDAO = new UserDAO();
		List<User> storekeepers = userDAO.getUsersByRole(4);
		if (!storekeepers.isEmpty()) {
			return storekeepers.get(0).getId();
		}
		return 0;
	}
	
	private void checkAddDevice(HttpServletRequest request, HttpServletResponse response, String name, int categoryId, double price, String unit, String description, boolean isFeatured, String mss) throws ServletException, IOException {
		request.setAttribute("name", name);
		request.setAttribute("categoryId", categoryId);
		request.setAttribute("price", price);
		request.setAttribute("unit", unit);
		request.setAttribute("desc", description);
		request.setAttribute("isFeatured", isFeatured);
		request.setAttribute("error", mss);
		List<Category> listCategory = cdao.getAllCategories();
        request.setAttribute("categories", listCategory);
		request.getRequestDispatcher("view/admin/device/add.jsp#device-name").forward(request, response);
	}
	
	public void activeDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));			
		boolean check = dao.activeDevice(id);
		String mess = check ? "Active device thành công" : "Active device thất bại";
		HttpSession session = request.getSession();
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	    response.sendRedirect("device-show");
		
	}
	
}
