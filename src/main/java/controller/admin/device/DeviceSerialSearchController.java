package controller.admin.device;

import dao.DeviceSerialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DeviceSerialLookup;
import model.User;
import utils.AuthorizationUtils;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/device-serial-search")
public class DeviceSerialSearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 15;

    private final DeviceSerialDAO deviceSerialDAO = new DeviceSerialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = AuthorizationUtils.requirePermission(request, response, "Tra Cứu Seri");
        if (currentUser == null) {
            return;
        }

        String keyword = trimToNull(request.getParameter("keyword"));
        int currentPage = parsePage(request.getParameter("page"));

        int totalSerials = deviceSerialDAO.countSerialLookups(keyword);
        int totalPages = totalSerials > 0 ? (int) Math.ceil((double) totalSerials / PAGE_SIZE) : 0;

        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        } else if (totalPages == 0) {
            currentPage = 1;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;
        List<DeviceSerialLookup> results = totalSerials > 0
                ? deviceSerialDAO.searchSerialLookups(keyword, offset, PAGE_SIZE)
                : Collections.emptyList();

        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("results", results);
        request.setAttribute("totalSerials", totalSerials);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/view/admin/device/serial-search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private int parsePage(String pageParam) {
        if (pageParam == null) {
            return 1;
        }
        try {
            int page = Integer.parseInt(pageParam);
            return Math.max(page, 1);
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
