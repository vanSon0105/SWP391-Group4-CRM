package dao;

import java.util.*;
import java.sql.*;
import model.OrderDetail;
import dal.DBContext;

public class OrderDetailDAO extends DBContext{
	  public boolean addOrderDetail(int orderId, int deviceId, int deviceSerialId, int quantity, double price, int warrantyCardId) {
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
	            return ps.executeUpdate() > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
	        List<OrderDetail> list = new ArrayList<>();
	        String sql = "SELECT * FROM order_details WHERE order_id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setInt(1, orderId);
	            try (ResultSet rs = ps.executeQuery()) {
	                while (rs.next()) {
	                    OrderDetail od = new OrderDetail(
	                        rs.getInt("id"),
	                        rs.getInt("order_id"),
	                        rs.getInt("device_id"),
	                        rs.getInt("device_serial_id"),
	                        rs.getInt("quantity"),
	                        rs.getDouble("price"),
	                        rs.getInt("warranty_card_id")
	                    );
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
}
