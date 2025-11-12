package controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import dao.DashBoardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import model.ChartPoint;
import utils.AuthorizationUtils;

@WebServlet("/admin")
public class DashBoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User currentUser = AuthorizationUtils.requirePermission(request, response, "Trang Admin");
        if (currentUser == null) {
            return;
        }
        
        DashBoardDAO dashboardDAO = new DashBoardDAO();

        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue();
        int totalOrders = dashboardDAO.getTotalOrders();
        int totalCustomers = dashboardDAO.getTotalCustomers();
        int openIssues = dashboardDAO.getOpenIssuesCount();
        int activeDevices = dashboardDAO.getActiveDevicesCount();
        BigDecimal averageOrderValue = totalOrders > 0
                ? totalRevenue.divide(BigDecimal.valueOf(totalOrders), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        List<ChartPoint> revenueTrend = dashboardDAO.getRevenueTrend(6);
        List<ChartPoint> topCategories = dashboardDAO.getTopCategoryRevenue(5);
        List<ChartPoint> taskStatus = dashboardDAO.getTaskStatusDistribution();
        List<ChartPoint> issueStatus = dashboardDAO.getIssueStatusDistribution();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("openIssues", openIssues);
        request.setAttribute("activeDevices", activeDevices);
        request.setAttribute("averageOrderValue", averageOrderValue);

        request.setAttribute("revenueTrend", revenueTrend);
        request.setAttribute("topCategories", topCategories);
        request.setAttribute("taskStatus", taskStatus);
        request.setAttribute("issueStatus", issueStatus);

        request.getRequestDispatcher("view/admin/dashboard/index.jsp").forward(request, response);
	}
}
