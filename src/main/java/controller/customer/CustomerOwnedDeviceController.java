package controller.customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CustomerIssueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerIssue;
import model.CustomerOwnedDevice;
import model.CustomerOwnedDeviceUnit;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/my-devices")
public class CustomerOwnedDeviceController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int PAGE_SIZE = 5;
	private final CustomerIssueDAO customerIssueDAO = new CustomerIssueDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String keyword = req.getParameter("keyword");
        
		int page = parseIntOrDefault(req.getParameter("page"), 1);
		if (page < 1) {
			page = 1;
		}
		
		int filteredDeviceModels = customerIssueDAO.countOwnedDeviceModels(user.getId(), keyword);
		int totalDeviceModels = customerIssueDAO.countOwnedDeviceModels(user.getId(), null);
		int totalPages = (int) Math.ceil(filteredDeviceModels / (double) PAGE_SIZE);
		if (totalPages == 0) {
			totalPages = 1;
		}
		if (page > totalPages) {
			page = totalPages;
		}
		int offset = (page - 1) * PAGE_SIZE;
		
		List<CustomerOwnedDevice> ownedDevices = customerIssueDAO.getOwnedDevicesByCustomer(user.getId(), offset, PAGE_SIZE, keyword);
		
		List<Integer> warrantyCardIds = new ArrayList<>();
		for (CustomerOwnedDevice device : ownedDevices) {
			for (CustomerOwnedDeviceUnit unit : device.getUnits()) {
				warrantyCardIds.add(unit.getWarrantyCardId());
			}
		}
		List<CustomerIssue> allIssues = customerIssueDAO.getIssuesByWarrantyCardIds(warrantyCardIds);
		for (CustomerOwnedDevice device : ownedDevices) {
			for (CustomerOwnedDeviceUnit unit : device.getUnits()) {
				List<CustomerIssue> history = new ArrayList<>();
				for (CustomerIssue issue : allIssues) {
					if (issue.getWarrantyCardId() == unit.getWarrantyCardId()) {
						history.add(issue);
					}
				}
				unit.setIssues(history);
			}
		}
		int totalOwnedUnits = customerIssueDAO.countOwnedUnits(user.getId());
		int totalUnitsWithIssue = customerIssueDAO.countOwnedUnitsWithIssue(user.getId());
		
		req.setAttribute("ownedDevices", ownedDevices);
		req.setAttribute("totalOwnedUnits", totalOwnedUnits);
		req.setAttribute("totalUnitsWithIssue", totalUnitsWithIssue);
		req.setAttribute("totalDeviceModels", totalDeviceModels);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPages", Math.max(totalPages, 1));
		req.setAttribute("pageSize", PAGE_SIZE);
		
		req.getRequestDispatcher("view/customer/ownedDevice.jsp").forward(req, resp);
	}
	
	private int parseIntOrDefault(String raw, int defaultValue) {
		if (raw == null) {
			return defaultValue;
		}
		try {
			return Integer.parseInt(raw);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}
}
