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
                    sd.setPrice(rs.getBigDecimal("price"));
                    sd.setDate(rs.getTimestamp("date"));
                    list.add(sd);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
