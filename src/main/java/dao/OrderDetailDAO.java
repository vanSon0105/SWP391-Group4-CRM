package dao;

import java.util.*;
import java.sql.*;
import model.OrderDetail;
import dal.DBContext;

public class OrderDetailDAO extends DBContext{
	public void addOrderDetail(int orderId, int deviceId, int deviceSerialId,int quantity, double price, int warrantyCardId) {
	    String sql = "INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, warranty_card_id) "
	               + "VALUES (?, ?, ?, ?, ?, ?)";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, orderId);
	        ps.setInt(2, deviceId);
	        ps.setInt(3, deviceSerialId); 
	        ps.setInt(4, quantity);
	        ps.setDouble(5, price);
	        ps.setInt(6, warrantyCardId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
