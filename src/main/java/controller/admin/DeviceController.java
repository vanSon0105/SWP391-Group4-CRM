package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Category;
import model.Device;
import model.DeviceSerial;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import dao.CategoryDAO;
import dao.DeviceDAO;

/**
 * Servlet implementation class DeviceController
 */
@WebServlet({"/device-show", "/device-view", "/device-serials", "/device-update", "/device-add", "/device-delete"})
@MultipartConfig
public class DeviceController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	public CategoryDAO cdao = new CategoryDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
            case "/device-delete":
                deleteDevice(request, response);
                break;
            case "/device-serials":
            	viewDeviceSerialList(request, response);
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
		List<Device> listDevices = dao.findAllDevices();
		request.setAttribute("listDevices", listDevices);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}
	
	public void viewDeviceSerialList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));			
		} catch (Exception e) {
			e.printStackTrace();
		}
		List<DeviceSerial> listDeviceSerials = dao.getAllDeviceSerials(id);
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.getRequestDispatcher("view/admin/device/show.jsp").forward(request, response);
	}
	
	public void viewDeviceDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Device d = dao.getDeviceDetail(id);
		request.setAttribute("deviceDetail", d);
		request.getRequestDispatcher("view/admin/device/view.jsp").forward(request, response);
	}
	
	public void updateDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Device getDevice = dao.getDeviceById(id);
		List<Category> listCategory = cdao.getAllCategories();
		request.setAttribute("device", getDevice);
        request.setAttribute("categories", listCategory);
		request.getRequestDispatcher("view/admin/device/edit.jsp").forward(request, response);
	}
	
	public void updateDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
        int id = 0;
        int categoryId = 0;
        Double price = 0.0;
		try {
			categoryId = Integer.parseInt(request.getParameter("categoryId"));
			id = Integer.parseInt(request.getParameter("id"));			
			price = Double.parseDouble(request.getParameter("price")); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
		
        Category c = cdao.getCategoryById(categoryId);
        String unit = request.getParameter("unit");
        String description = request.getParameter("description");
        
        Device device = new Device(id, c, name, price, fileName, unit, description);
        dao.updateDevice(device);
        response.sendRedirect("device-show");
	}
	
	public void addDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Category> listCategory = cdao.getAllCategories();
        request.setAttribute("categories", listCategory);
		request.getRequestDispatcher("view/admin/device/add.jsp").forward(request, response);
	}

	public void addDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
        int categoryId = 0;
        Double price = 0.0;
		try {
			categoryId = Integer.parseInt(request.getParameter("categoryId"));		
			price = Double.parseDouble(request.getParameter("price")); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
		
        Category c = cdao.getCategoryById(categoryId);
        String unit = request.getParameter("unit");
        String description = request.getParameter("description");
		
		boolean isFeatured = request.getParameter("isFeatured") != null;
        Device d = new Device();
        d.setCategory(c);
        d.setName(name);
        d.setPrice(price);
        d.setUnit(unit);
        d.setImageUrl(fileName);
        d.setDesc(description);
        d.setIs_featured(isFeatured);
        
        dao.addDevice(d);
        response.sendRedirect("device-show");
	}

	public void deleteDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));			
		} catch (Exception e) {
			e.printStackTrace();
		}
		Device getDevice = dao.getDeviceById(id);
		List<DeviceSerial> listDeviceSerials = dao.getAllDeviceSerials(getDevice.getId());
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.setAttribute("device", getDevice);
		request.getRequestDispatcher("view/admin/device/delete.jsp").forward(request, response);
	}
	
	public void deleteDeviceDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = 0;
		try {
			id = Integer.parseInt(request.getParameter("id"));			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String mess = "";
		boolean check = dao.deleteDevice(id);
		if(check) {
			mess ="Delete Successfully";
		}else {
			mess ="Delete Failed";
		}
		request.setAttribute("mess", mess);
		response.sendRedirect("device-show");
	}
}
