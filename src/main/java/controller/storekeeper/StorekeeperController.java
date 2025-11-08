package controller.storekeeper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Device;
import model.DeviceSerial;
import model.Transaction;
import model.TransactionDetail;
import model.User;
import utils.AuthorizationUtils;

import java.io.IOException;
import java.util.List;

import com.mysql.cj.Session;

import dao.CategoryDAO;
import dao.DeviceDAO;
import dao.DeviceSerialDAO;
import dao.SupplierDAO;
import dao.TransactionDAO;
import dao.TransactionDetailDAO;

/**
 * Servlet implementation class StorekeeperController
 */
@WebServlet({"/de-show", "/des-show", "/des-add", "/de-price"})
public class StorekeeperController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public DeviceDAO dao = new DeviceDAO();
	public CategoryDAO cdao = new CategoryDAO();
	public DeviceSerialDAO dsdao = new DeviceSerialDAO();
	private final int recordsEachPage = 10;
	private final TransactionDAO transactionDAO = new TransactionDAO();
	private final TransactionDetailDAO transactionDetailDAO = new TransactionDetailDAO();
	private final SupplierDAO supplierDao = new SupplierDAO();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
        	case "/des-show":
        		showDeviceSerialsList(request, response);
        		break;
        	case "/des-add":
        		addDeviceSerials(request, response);
        		break;
            default:
            	showDeviceList(request, response);
            	break;
        }
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
		switch (path) {
		case "/de-price":
			updateDevicePrice(request, response);
			break;
		case "/des-add":
			addDeviceSerialsDoPost(request, response);
			break;
		default:
			response.sendRedirect("de-show");
			break;
		}
	}
	
	public void showDeviceList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		User currentUser = AuthorizationUtils.requirePermission(request, response, "DEVICE_MANAGEMENT_NODELETE");
        if (currentUser == null) {
            return;
        }
        HttpSession s = request.getSession();

        String action = request.getParameter("action");
		if("1".equalsIgnoreCase(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Device d = dao.getDeviceById(id);
			request.setAttribute("device", d);
			request.setAttribute("updatePrice", true);
		}
        
        
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
		request.getRequestDispatcher("view/admin/storekeeper/show.jsp").forward(request, response);
	}
	
	public void showDeviceSerialsList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));	
		
		String page = request.getParameter("page");
		String key = request.getParameter("key");
		String sortBy = request.getParameter("sortBy");
	    String order = request.getParameter("order");
	    
		int currentPage = (page != null) ? Integer.parseInt(page) : 1;
		int offset = (currentPage - 1) * recordsEachPage;
		
		List<DeviceSerial> listDeviceSerials = dsdao.getDeviceSerialsByPage(id, key, offset, recordsEachPage, sortBy, order);
		int totalDeviceSerials = dsdao.getTotalDeviceSerials(id, key, sortBy, order);
		int totalPages = (int) Math.ceil((double) totalDeviceSerials / recordsEachPage);
		
		request.setAttribute("totalDevices", totalDeviceSerials);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("sortBy", sortBy);
	    request.setAttribute("order", order);
		request.setAttribute("deviceId", id);
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.getRequestDispatcher("view/admin/storekeeper/showSerials.jsp").forward(request, response);
	}
	
	public void addDeviceSerials(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idParam = request.getParameter("id");
		String action = request.getParameter("action");
		int id = 0;
		try {
			id = Integer.parseInt(idParam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(id == 0) {
			request.setAttribute("mss", "Xảy ra lỗi khi tìm thiết bị!");
			response.sendRedirect("de-show");
			return;
		}
		
		if("1".equalsIgnoreCase(action)) {
			request.setAttribute("addDeviceSerials", true);
			request.setAttribute("suppliers", supplierDao.getAllSuppliers());
		}
		
		Device d = dao.getDeviceById(id);
		List<DeviceSerial> listDeviceSerials = dsdao.getAllDeviceSerials(id);
		request.setAttribute("device", d);
		request.setAttribute("deviceId", id);
		request.setAttribute("listDeviceSerials", listDeviceSerials);
		request.getRequestDispatcher("view/admin/storekeeper/showSerials.jsp").forward(request, response);
	}
	
	public void addDeviceSerialsDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User currentUser = AuthorizationUtils.requirePermission(request, response, "DEVICE_MANAGEMENT_NODELETE");
        if (currentUser == null) {
            return;
        }
        
        HttpSession s = request.getSession();
		String idParam = request.getParameter("id");
		int id = 0;
		try {
			id = Integer.parseInt(idParam);
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("de-show");
			return;
		}
		Device d = dao.getDeviceById(id);
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		String supplierParam = request.getParameter("supplierId");
		int supplierId;
		try {
			supplierId = Integer.parseInt(supplierParam);
		} catch (Exception ex) {
			s.setAttribute("mess", "Vui lòng chọn nhà cung cấp hợp lệ");
			response.sendRedirect("des-show?id="+id);
			return;
		}
		if (supplierDao.getSupplierById(supplierId) == null) {
			s.setAttribute("mess", "Nhà cung cấp không tồn tại hoặc không hoạt động");
			response.sendRedirect("des-show?id="+id);
			return;
		}
		boolean check = dsdao.insertDeviceSerials(d, quantity);
		if(!check) {
			s.setAttribute("mess", "Thêm device serials thất bại");
		} else {
			s.setAttribute("mess", "Thêm device serials thành công");
			recordManualImport(currentUser.getId(), supplierId, id, quantity);
		}
		response.sendRedirect("des-show?id="+id);
	}
	
	private void recordManualImport(int storekeeperId,int supplierId, int deviceId, int quantity) {
		if (quantity <= 0) {
			return;
		}
		Transaction transaction = new Transaction();
		transaction.setStorekeeperId(storekeeperId);
		transaction.setSupplierId(supplierId);
		transaction.setType("import");
		transaction.setStatus("confirmed");
		transaction.setNote("Nhận thiết bị" + deviceId);
		int transactionId = transactionDAO.createTransaction(transaction);
		if (transactionId <= 0) {
			return;
		}
		TransactionDetail detail = new TransactionDetail();
		detail.setTransactionId(transactionId);
		detail.setDeviceId(deviceId);
		detail.setQuantity(quantity);
		transactionDetailDAO.addTransactionDetail(detail, "import");
	}
	
	public void updateDevicePrice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User currentUser = AuthorizationUtils.requirePermission(request, response, "PRICE_UPDATE");
        if (currentUser == null) {
            return;
        }
        HttpSession s = request.getSession();
        String priceParam = request.getParameter("price");
        String idParam = request.getParameter("id");
        int id = 0;
        double price = 0.0;
        try {
			price = Double.parseDouble(priceParam);
			id = Integer.parseInt(idParam);
		} catch (Exception e) {
			e.printStackTrace();
			s.setAttribute("mess", "Cập nhật giá thất bại");
			response.sendRedirect("de-show");
			return;
		}
        
        if(id == 0) {
        	s.setAttribute("mess", "Không tìm thấy thiết bị");
			response.sendRedirect("de-show");
			return;
        }
        
        boolean check = dao.updateDevicePrice(id, price);
        if(!check) {
        	s.setAttribute("mess", "Cập nhật giá thất bại!");
        }else {
        	s.setAttribute("mess", "Cập nhật giá thành công!");
        }
        response.sendRedirect("de-show");  
	}
	

}
