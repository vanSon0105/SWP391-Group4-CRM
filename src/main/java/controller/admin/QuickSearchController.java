package controller.admin;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import dao.DeviceDAO;
import dao.OrderDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;
import model.Order;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/admin-quick-search")
public class QuickSearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_RESULTS = 5;

    private final DeviceDAO deviceDAO = new DeviceDAO();
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "Trang Admin");
        if (currentUser == null) {
            return;
        }

        String query = trimToNull(request.getParameter("q"));
        if (query == null) {
            response.sendRedirect("home");
            return;
        }

        List<Device> deviceResults = limitList(deviceDAO.searchDevice(query));
        List<User> userResults = limitList(userDAO.searchUsers(query, 0, MAX_RESULTS));
        Order orderResult = tryFindOrder(query);

        request.setAttribute("pageTitle", "Tìm kiếm nhanh");
        request.setAttribute("searchQuery", query);
        request.setAttribute("deviceResults", deviceResults);
        request.setAttribute("userResults", userResults);
        request.setAttribute("orderResult", orderResult);

        request.getRequestDispatcher("/view/admin/common/quick-search.jsp").forward(request, response);
    }

    private Order tryFindOrder(String query) {
        try {
            int orderId = Integer.parseInt(query);
            return orderDAO.getOrderById(orderId);
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private <T> List<T> limitList(List<T> list) {
        if (list == null) {
            return Collections.emptyList();
        }
        if (list.size() <= MAX_RESULTS) {
            return list;
        }
        return list.subList(0, MAX_RESULTS);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
