package dao;

import java.util.*;
import java.sql.*;
import model.OrderDetail;
import dal.DBContext;

public class OrderDetailDAO extends DBContext{
	/*
	 * public boolean addOrderDetail(int orderId, int deviceId, int deviceSerialId,
	 * int quantity, double price, int warrantyCardId) { String sql =
	 * "INSERT INTO order_details (order_id, device_id, quantity, price) " +
	 * "VALUES (?, ?, ?, ?, ?, ?)"; try (Connection conn = getConnection();
	 * PreparedStatement ps = conn.prepareStatement(sql)) { ps.setInt(1, orderId);
	 * ps.setInt(2, deviceId); ps.setInt(3, quantity); ps.setDouble(4, price);
	 * return ps.executeUpdate() > 0; } catch (Exception e) { e.printStackTrace(); }
	 * return false; }
	 */
	public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
	    List<OrderDetail> list = new ArrayList<>();
	    String sql = "SELECT od.id, od.order_id, od.device_id, od.quantity, od.price, d.name AS device_name " +
	                 "FROM order_details od " +
	                 "JOIN devices d ON od.device_id = d.id " +
	                 "WHERE od.order_id = ?";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, orderId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                OrderDetail od = new OrderDetail(
	                    rs.getInt("id"),
	                    rs.getInt("order_id"),
	                    rs.getInt("device_id"),
	                    rs.getInt("quantity"),
	                    rs.getDouble("price")
	                );
	                od.setDeviceName(rs.getString("device_name")); 
	                
	                list.add(od);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}


	    public void updateOrderDetail(int id, int quantity, double price, int discount) {
	        String sql = "UPDATE order_details SET quantity = ?, price = ?, discount = ? WHERE id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, quantity);
	            ps.setDouble(2, price);
	            ps.setInt(3, discount);
	            ps.setInt(4, id);
	            ps.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    public void deleteOrderDetail(int id) {
	        String sql = "DELETE FROM order_details WHERE id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, id);
	            ps.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    public void deleteOrderDetailsByOrderId(int orderId) {
	        String sql = "DELETE FROM order_details WHERE order_id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, orderId);
	            ps.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    public int addOrderDetail(int orderId, int deviceId, int quantity, double price) {
	        String sql = "INSERT INTO order_details (order_id, device_id, quantity, price) VALUES (?, ?, ?, ?)";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
	            ps.setInt(1, orderId);
	            ps.setInt(2, deviceId);
	            ps.setInt(3, quantity);
	            ps.setDouble(4, price);
	            ps.executeUpdate();

	            ResultSet rs = ps.getGeneratedKeys();
	            if (rs.next()) {
	                return rs.getInt(1); 
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1;
	    }
	    
	    public boolean addOrderDetailSerial(int orderDetailId, int deviceSerialId) {
	        String sql = "INSERT INTO order_detail_serials (order_detail_id, device_serial_id) VALUES (?, ?)";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, orderDetailId);
	            ps.setInt(2, deviceSerialId);
	            return ps.executeUpdate() > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	    
	    public boolean isSerialAlreadyAssigned(int deviceSerialId) {
	        String sql = "SELECT 1 FROM order_detail_serials WHERE device_serial_id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, deviceSerialId);
	            try (ResultSet rs = ps.executeQuery()) {
	                return rs.next();
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }


}
