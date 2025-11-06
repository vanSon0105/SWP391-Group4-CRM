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

        List<Sale> dbData = dao.getMonthlyData(); 
        Map<Integer, Sale> monthMap = new java.util.HashMap<>();
        for (Sale s : dbData) {
            monthMap.put(s.getMonth(), s);
        }

        List<Sale> fullYearData = new java.util.ArrayList<>();
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        for (int m = 1; m <= 12; m++) {
            if (monthMap.containsKey(m)) {
                fullYearData.add(monthMap.get(m));
            } else {
                fullYearData.add(new Sale(m, currentYear, 0, 0));
            }
        }

        req.setAttribute("monthlyData", fullYearData);

        req.getRequestDispatcher("view/admin/dashboard/saleReport.jsp").forward(req, resp);
    }

}