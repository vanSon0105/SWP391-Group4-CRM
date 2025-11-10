package dao;

import java.util.*;
import java.sql.*;
import model.SupplierDetail;
import dal.DBContext;

public class SupplierDetailDAO extends DBContext {

    public List<SupplierDetail> getDetailsBySupplierId(int supplierId) {
        List<SupplierDetail> list = new ArrayList<>();
        String sql = "SELECT sd.id, sd.supplier_id, sd.device_id, d.name AS device_name, sd.price, sd.date " +
                     "FROM supplier_details sd " +
                     "JOIN devices d ON sd.device_id = d.id " +
                     "WHERE sd.supplier_id = ? " +
                     "ORDER BY sd.date DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupplierDetail sd = new SupplierDetail();
                    sd.setId(rs.getInt("id"));
                    sd.setSupplierId(rs.getInt("supplier_id"));
                    sd.setDeviceId(rs.getInt("device_id"));
                    sd.setDeviceName(rs.getString("device_name"));
                    sd.setPrice(rs.getDouble("price"));
                    sd.setDate(rs.getTimestamp("date"));
                    list.add(sd);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean insertSupplierDevice(int supplierId, int deviceId, double price) {
        String sql = "INSERT INTO supplier_details (supplier_id, device_id, price) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setInt(2, deviceId);
            ps.setDouble(3, price);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public SupplierDetail getLatestDetailByDeviceId(int deviceId) {
        String sql = "SELECT id, supplier_id, device_id, price, date FROM supplier_details " +
                     "WHERE device_id = ? ORDER BY date DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SupplierDetail detail = new SupplierDetail();
                    detail.setId(rs.getInt("id"));
                    detail.setSupplierId(rs.getInt("supplier_id"));
                    detail.setDeviceId(rs.getInt("device_id"));
                    detail.setPrice(rs.getDouble("price"));
                    detail.setDate(rs.getTimestamp("date"));
                    return detail;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
