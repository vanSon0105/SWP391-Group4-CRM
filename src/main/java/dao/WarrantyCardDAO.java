package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dal.DBContext;
import model.Customer;
import model.DeviceSerial;
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
				e.printStackTrace();
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
	
	 public WarrantyCard getWarrantyCardById(int id) {
	        String sql = """
	            SELECT 
	                wc.id,
	                wc.device_serial_id,
	                wc.customer_id,
	                wc.start_at,
	                wc.end_at,
	                ds.serial_no,
	                ds.device_id,
	                u.full_name AS customer_name,
	                u.email AS customer_email
	            FROM warranty_cards wc
	            JOIN device_serials ds ON ds.id = wc.device_serial_id
	            JOIN users u ON u.id = wc.customer_id
	            WHERE wc.id = ?
	        """;

	        try (Connection conn = DBContext.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setInt(1, id);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                WarrantyCard wc = new WarrantyCard();
	                wc.setId(rs.getInt("id"));
	                wc.setStart_at(rs.getTimestamp("start_at"));
	                wc.setEnd_at(rs.getTimestamp("end_at"));

	                // DeviceSerial
	                DeviceSerial ds = new DeviceSerial();
	                ds.setId(rs.getInt("device_serial_id"));
	                ds.setSerial_no(rs.getString("serial_no"));
	                ds.setDevice_id(rs.getInt("device_id"));
	                wc.setDevice_serial(ds);

	                // Customer
	                Customer customer = new Customer();
	                customer.setId(rs.getInt("customer_id"));
	                customer.setFull_name(rs.getString("customer_name"));
	                customer.setEmail(rs.getString("customer_email"));
	                wc.setCustomer(customer);

	                return wc;
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return null;
	    }


}
