package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import dao.WarrantyCardDAO;
import model.User;
import model.WarrantyCard;

@WebServlet("/warranty-alert")
public class WarrantyAlertController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private WarrantyCardDAO wcDao = new WarrantyCardDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		User u = (User) session.getAttribute("account");
		if (u == null) {
			resp.sendRedirect("login");
			return;
		}

		String daysParam = req.getParameter("days");
		String searchKeyword = req.getParameter("search");
		String sortBy = req.getParameter("sortBy");
		String sortOrder = req.getParameter("sortOrder");
		String pageParam = req.getParameter("page");

		int days = 30;
		if (daysParam != null) {
			try {
				days = Integer.parseInt(daysParam);
				if (days <= 0)
					days = 30;
			} catch (NumberFormatException ex) {
				days = 30;
			}
		}

		int currentPage = 1;
		int pageSize = 3;
		if (pageParam != null) {
			try {
				currentPage = Integer.parseInt(pageParam);
				if (currentPage <= 0)
					currentPage = 1;
			} catch (NumberFormatException e) {
				currentPage = 1;
			}
		}

		if (sortBy == null || sortBy.isEmpty())
			sortBy = "endDate";
		if (sortOrder == null || sortOrder.isEmpty())
			sortOrder = "ASC";

		int offset = (currentPage - 1) * pageSize;

		List<WarrantyCard> list = wcDao.getFilteredWarrantiesPaged(u.getId(), days, searchKeyword, sortBy, sortOrder,
				offset, pageSize);

		LocalDateTime now = LocalDateTime.now();
		for (WarrantyCard wc : list) {
			if (wc.getEnd_at() != null) {
				LocalDateTime end = wc.getEnd_at().toLocalDateTime();
				long daysRemaining = Duration.between(now, end).toDays();
				wc.setDaysRemaining((int) daysRemaining);
			} else {
				wc.setDaysRemaining(-1);
			}
		}

		int totalRecords = wcDao.countFilteredWarranties(u.getId(), days, searchKeyword);
		int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

		req.setAttribute("list", list);
		req.setAttribute("days", days);
		req.setAttribute("search", searchKeyword != null ? searchKeyword : "");
		req.setAttribute("sortBy", sortBy);
		req.setAttribute("sortOrder", sortOrder);
		req.setAttribute("currentPage", currentPage);
		req.setAttribute("totalPages", totalPages);

		req.getRequestDispatcher("view/customer/warrantyAlert.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
