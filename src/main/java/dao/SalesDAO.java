package dao;

import dal.DBContext;
import java.sql.*;
import java.util.*;
import model.Sale;

public class SalesDAO extends DBContext {

    public Map<String, Object> getSummary() {
        Map<String, Object> map = new HashMap<>();
        String sql = 
            "SELECT " +
            "    COALESCE(SUM(p.amount), 0) AS total_revenue, " +
            "    COUNT(DISTINCT o.id) AS total_orders, " +
            "    CASE WHEN COUNT(DISTINCT o.id) > 0 " +
            "         THEN COALESCE(SUM(p.amount), 0) / COUNT(DISTINCT o.id) " +
            "         ELSE 0 END AS avg_order " +
            "FROM payments p " +
            "JOIN orders o ON p.order_id = o.id " +
            "WHERE p.status = 'success'";

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                map.put("totalRevenue", rs.getDouble("total_revenue"));
                map.put("totalOrders", rs.getInt("total_orders"));
                map.put("avgOrder", rs.getDouble("avg_order"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Sale> getMonthlyData() {
        List<Sale> list = new ArrayList<>();
        String sql = 
            "SELECT " +
            "    MONTH(o.date) AS month, " +
            "    YEAR(o.date) AS year, " +
            "    COALESCE(SUM(p.amount), 0) AS revenue, " +
            "    COALESCE(SUM(p.amount), 0) * 0.3 AS profit " +
            "FROM orders o " +
            "JOIN payments p ON o.id = p.order_id AND p.status = 'success' " +
            "WHERE o.date >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) " +
            "GROUP BY YEAR(o.date), MONTH(o.date) " +
            "ORDER BY year DESC, month DESC";

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Sale s = new Sale(
                    rs.getInt("month"),
                    rs.getInt("year"),
                    rs.getDouble("revenue"),
                    rs.getDouble("profit")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}