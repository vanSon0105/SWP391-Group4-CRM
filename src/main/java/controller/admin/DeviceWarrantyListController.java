package controller.admin;

import dao.WarrantyCardDAO;
import model.WarrantyCard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/warranty/list"})
public class DeviceWarrantyListController extends HttpServlet {

    private static final int PAGE_SIZE = 10; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        WarrantyCardDAO warrantyDAO = new WarrantyCardDAO();

        String search = request.getParameter("search");
        String status = request.getParameter("status"); 
        String pageParam = request.getParameter("page");

        int page = 1;
        try {
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam));
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<WarrantyCard> warrantyList = warrantyDAO.getWarrantyList(search, status, offset, PAGE_SIZE);
        int totalRecords = warrantyDAO.countWarranty(search, status);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("warrantyList", warrantyList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("status", status != null ? status : "");

        request.getRequestDispatcher("/view/admin/warranty/warrantyList.jsp").forward(request, response);
    }
}
