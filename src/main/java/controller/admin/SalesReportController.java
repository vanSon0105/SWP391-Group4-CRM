package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.SalesDAO;
import dao.OrderDAO;
import model.Sale;
import java.util.List;
import java.util.Map;

@WebServlet("/sales-report")
public class SalesReportController extends HttpServlet {
    private SalesDAO dao = new SalesDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Map<String, Object> summary = dao.getSummary();
        req.setAttribute("totalRevenue", summary.get("totalRevenue"));
        req.setAttribute("totalOrders", summary.get("totalOrders"));
        req.setAttribute("avgOrder", summary.get("avgOrder"));

        req.setAttribute("monthlyData", dao.getMonthlyData());

        req.getRequestDispatcher("view/admin/dashboard/saleReport.jsp").forward(req, resp);
    }
}