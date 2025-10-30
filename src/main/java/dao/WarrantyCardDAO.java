package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dal.DBContext;
import model.WarrantyCard;

public class WarrantyCardDAO extends DBContext{
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	public WarrantyCard getBySerialId(int serialId) {
	    String sql = "SELECT * FROM warranty_cards WHERE device_serial_id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, serialId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new WarrantyCard(
	            		rs.getInt("id"),
	            		rs.getInt("device_serial_id"),
	            		rs.getInt("customer_id"),
	            		rs.getTimestamp("start_at"),
	            		rs.getTimestamp("end_at")
	            		);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public boolean updateWarrantyDates(int warrantyId, Timestamp start, Timestamp end) {
	    String sql = "UPDATE warranty_cards SET start_at = ?, end_at = ? WHERE id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setTimestamp(1, start);
	        ps.setTimestamp(2, end);
	        ps.setInt(3, warrantyId);
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public int addWarrantyCard(int deviceSerialId, int customerId, Timestamp start, Timestamp end) throws SQLException {
        String sql = "INSERT INTO warranty_cards (device_serial_id, customer_id, start_at, end_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, deviceSerialId);
            ps.setInt(2, customerId);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); 
                }
            } catch (SQLException e) {
				// TODO: handle exception
			}
        }
        return -1;
    }
	
	public WarrantyCard getById(int id) {
	    String sql = "SELECT * FROM warranty_cards WHERE id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new WarrantyCard(
	            		rs.getInt("id"),
	            		rs.getInt("device_serial_id"),
	            		rs.getInt("customer_id"),
	            		rs.getTimestamp("start_at"),
	            		rs.getTimestamp("end_at")
	            		);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}


}
