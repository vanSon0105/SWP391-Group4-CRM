package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import dal.DBContext;
import model.ChartPoint;

public class DashBoardDAO extends DBContext {

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) AS total_revenue FROM payments WHERE status = 'success'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total_revenue");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS order_count FROM orders";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("order_count");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return 0;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS customer_count "
                + "FROM users u "
                + "JOIN roles r ON u.role_id = r.id "
                + "WHERE LOWER(r.role_name) = 'customer'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("customer_count");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return 0;
    }

    public int getOpenIssuesCount() {
        String sql = "SELECT COUNT(*) AS open_issues "
                + "FROM customer_issues "
                + "WHERE support_status NOT IN ('resolved', 'customer_cancelled')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("open_issues");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return 0;
    }

    public int getActiveDevicesCount() {
        String sql = "SELECT COUNT(*) AS device_count FROM devices WHERE status = 'active'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("device_count");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return 0;
    }

    public List<ChartPoint> getRevenueTrend(int months) {
        List<ChartPoint> result = new ArrayList<>();
        Map<YearMonth, BigDecimal> revenueMap = new HashMap<>();
        String sql = "SELECT DATE_FORMAT(COALESCE(p.paid_at, p.created_at), '%Y-%m') AS period, "
                + "       COALESCE(SUM(p.amount), 0) AS total "
                + "FROM payments p "
                + "WHERE p.status = 'success' "
                + "  AND COALESCE(p.paid_at, p.created_at) >= DATE_SUB(CURDATE(), INTERVAL ? MONTH) "
                + "GROUP BY period "
                + "ORDER BY period";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, months);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String period = rs.getString("period");
                    if (period == null) {
                        continue;
                    }
                    YearMonth key = YearMonth.parse(period);
                    revenueMap.put(key, rs.getBigDecimal("total"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }

        YearMonth current = YearMonth.now();
        for (int i = months - 1; i >= 0; i--) {
            YearMonth target = current.minusMonths(i);
            BigDecimal value = revenueMap.getOrDefault(target, BigDecimal.ZERO);
            String label = target.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH)
                    + " " + target.getYear();
            result.add(new ChartPoint(label, value.doubleValue()));
        }
        return result;
    }

    public List<ChartPoint> getTopCategoryRevenue(int limit) {
        List<ChartPoint> result = new ArrayList<>();
        String sql = "SELECT c.category_name AS label, "
                + "       COALESCE(SUM(od.quantity * od.price), 0) AS total "
                + "FROM order_details od "
                + "JOIN orders o ON od.order_id = o.id "
                + "JOIN payments p ON p.order_id = o.id AND p.status = 'success' "
                + "JOIN devices d ON od.device_id = d.id "
                + "JOIN categories c ON d.category_id = c.id "
                + "GROUP BY c.category_name "
                + "ORDER BY total DESC "
                + "LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new ChartPoint(rs.getString("label"), rs.getDouble("total")));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return result;
    }

    public List<ChartPoint> getTaskStatusDistribution() {
        List<ChartPoint> result = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) AS total FROM task_with_status GROUP BY status";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(new ChartPoint(rs.getString("status"), rs.getInt("total")));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return result;
    }

    public List<ChartPoint> getIssueStatusDistribution() {
        List<ChartPoint> result = new ArrayList<>();
        String sql = "SELECT support_status, COUNT(*) AS total FROM customer_issues GROUP BY support_status";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(new ChartPoint(rs.getString("support_status"), rs.getInt("total")));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            closeConnection();
        }
        return result;
    }
}
