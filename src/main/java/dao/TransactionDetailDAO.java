package dao;

import java.sql.*;
import java.util.*;
import dal.DBContext;
import model.TransactionDetail;

public class TransactionDetailDAO extends DBContext {
	
	public void addTransactionDetail(int transactionId, List<TransactionDetail> details) {
	    String sql = "INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (?, ?, ?)";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        for (TransactionDetail td : details) {
	            ps.setInt(1, transactionId);
	            ps.setInt(2, td.getDeviceId());
	            ps.setInt(3, td.getQuantity());
	            ps.addBatch();
	        }
	        ps.executeBatch();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}

    public boolean addTransactionDetail(TransactionDetail detail, String type) {
        String insertSql = "INSERT INTO transaction_details (transaction_id, device_id, quantity) VALUES (?, ?, ?)";
        String updateStockSqlImport = "UPDATE devices SET quantity = quantity + ? WHERE id = ?";
        String updateStockSqlExport = "UPDATE devices SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, detail.getTransactionId());
                ps.setInt(2, detail.getDeviceId());
                ps.setInt(3, detail.getQuantity());
                ps.executeUpdate();
            }

            if ("import".equalsIgnoreCase(type)) {
                try (PreparedStatement ps = conn.prepareStatement(updateStockSqlImport)) {
                    ps.setInt(1, detail.getQuantity());
                    ps.setInt(2, detail.getDeviceId());
                    ps.executeUpdate();
                }
            } else if ("export".equalsIgnoreCase(type)) {
                int current = getCurrentStock(detail.getDeviceId());
                if (current < detail.getQuantity()) {
                    conn.rollback();
                    System.out.println("Not enough stock for device ID " + detail.getDeviceId());
                    return false;
                }
                try (PreparedStatement ps = conn.prepareStatement(updateStockSqlExport)) {
                    ps.setInt(1, detail.getQuantity());
                    ps.setInt(2, detail.getDeviceId());
                    ps.setInt(3, detail.getQuantity());
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.out.println("SQL Error in addTransactionDetail: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private int getCurrentStock(int deviceId) {
    	String sql = "SELECT COUNT(*) AS quantity FROM device_serials "
                + "WHERE device_id = ? AND stock_status = 'in_stock'";
        try (Connection conn = getConnection();
        	PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("quantity");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TransactionDetail> getTransactionDetailsByTransactionId(int transactionId) {
        List<TransactionDetail> list = new ArrayList<>();
        String sql = """
            SELECT td.*, d.name AS device_name
            FROM transaction_details td
            JOIN devices d ON td.device_id = d.id
            WHERE td.transaction_id = ?
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, transactionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransactionDetail td = new TransactionDetail();
                td.setId(rs.getInt("id"));
                td.setTransactionId(rs.getInt("transaction_id"));
                td.setDeviceId(rs.getInt("device_id"));
                td.setQuantity(rs.getInt("quantity"));
                td.setDeviceName(rs.getString("device_name"));
                list.add(td);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
