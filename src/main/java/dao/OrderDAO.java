package dao;
import java.util.*;
import java.sql.*;
import model.Order;
import dal.DBContext;

public class OrderDAO extends DBContext{
	public int addNewOrder(int customerId, double totalAmount, double discount) {
		String sql = "INSERT INTO orders (customer_id, total_amount, discount, status, date) VALUES "
					+ "(?, ?, ?, 'pending', NOW())";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
			pre.setInt(1, customerId);
			pre.setDouble(2, totalAmount);
			pre.setDouble(3, discount);
			pre.executeUpdate();
			ResultSet rs = pre.getGeneratedKeys();
			
			if(rs.next()) {
				return rs.getInt(1);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return -1;
	}
	
	public void updateOrderStatus(int id, String status) {
		String sql = "UPDATE orders set status = ? where id = ?";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql)){
			
			pre.setString(1, status);
			pre.setInt(2, id);
			pre.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
		}
	} 
	
	public int getOrderByPaymentId(int paymentId) {
		String sql = "select order_id from payments where id = ?";
		
		try (Connection conn = getConnection();
			PreparedStatement pre = conn.prepareStatement(sql)){
			pre.setInt(1, paymentId);
			ResultSet rs = pre.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("order_id");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return -1;
	}
	
	public void clearCart(int cartId)  {
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement("DELETE FROM cart_details WHERE cart_id = ?")) {
			ps.setInt(1, cartId);
			ps.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
		}
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement("UPDATE carts SET sum = 0 WHERE id = ?")) {
			ps.setInt(1, cartId);
			ps.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
}
//package dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Statement;
//import java.sql.Timestamp;
//import java.sql.Types;
//import java.time.LocalDateTime;
//import java.util.ArrayList;
//import java.util.List;
//
//import dal.DBContext;
//import model.CartDetail;
//import model.CheckoutInfo;
//
//public class OrderDAO extends DBContext {
//
//	public int placeOrder(int userId, int cartId, List<CartDetail> items, double discount,
//			double finalTotal, CheckoutInfo info) throws SQLException {
//		if (items == null || items.isEmpty()) {
//			throw new IllegalArgumentException("Cart is empty.");
//		}
//
//		try (Connection conn = getConnection()) {
//			boolean oldAutoCommit = conn.getAutoCommit();
//			conn.setAutoCommit(false);
//			try {
//				int orderId = insertOrder(conn, userId, finalTotal, discount);
//				insertShippingInfo(conn, orderId, info);
//				createOrderDetails(conn, orderId, userId, items);
//				insertPaymentRecord(conn, orderId, info.getPaymentMethod());
//				clearCart(conn, cartId);
//				conn.commit();
//				conn.setAutoCommit(oldAutoCommit);
//				return orderId;
//			} catch (SQLException ex) {
//				conn.rollback();
//				throw ex;
//			}
//		}
//	}
//
//	private int insertOrder(Connection conn, int userId, double totalAmount, double discount) throws SQLException {
//		String sql = "INSERT INTO orders (customer_id, total_amount, discount, status, date) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
//		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//			ps.setInt(1, userId);
//			ps.setDouble(2, totalAmount);
//			ps.setDouble(3, discount);
//			ps.setString(4, "pending");
//			ps.executeUpdate();
//			try (ResultSet rs = ps.getGeneratedKeys()) {
//				if (rs.next()) {
//					return rs.getInt(1);
//				}
//			}
//		}
//		throw new SQLException("Unable to create order record.");
//	}
//
//	private void insertShippingInfo(Connection conn, int orderId, CheckoutInfo info) throws SQLException {
//		String sql = "INSERT INTO order_shipping_details (order_id, full_name, phone, address, delivery_time, payment_method, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
//		try (PreparedStatement ps = conn.prepareStatement(sql)) {
//			ps.setInt(1, orderId);
//			ps.setString(2, info.getFullName());
//			ps.setString(3, info.getPhone());
//			ps.setString(4, info.getAddress());
//			ps.setString(5, info.getDeliveryTime());
//			ps.setString(6, info.getPaymentMethod());
//			ps.setString(7, info.getNote());
//			ps.executeUpdate();
//		}
//	}
//
//	private void createOrderDetails(Connection conn, int orderId, int customerId, List<CartDetail> items)
//			throws SQLException {
//		for (CartDetail item : items) {
//			int quantity = item.getQuantity();
//			List<Integer> serials = reserveSerials(conn, item.getDevice().getId(), quantity);
//			if (serials.size() < quantity) {
//				throw new SQLException("Không đủ serial cho thiết bị " + item.getDevice().getName());
//			}
//
//			for (int i = 0; i < quantity; i++) {
//				int serialId = serials.get(i);
//				int warrantyId = createWarrantyCard(conn, serialId, customerId);
//				insertOrderDetail(conn, orderId, item, serialId, warrantyId);
//				updateSerialStatus(conn, serialId);
//			}
//		}
//	}
//
//	private List<Integer> reserveSerials(Connection conn, int deviceId, int quantity) throws SQLException {
//		String sql = "SELECT id FROM device_serials WHERE device_id = ? AND stock_status = 'in_stock' AND status = 'active' "
//				+ "ORDER BY import_date LIMIT ? FOR UPDATE";
//		List<Integer> serials = new ArrayList<>();
//		try (PreparedStatement ps = conn.prepareStatement(sql)) {
//			ps.setInt(1, deviceId);
//			ps.setInt(2, quantity);
//			try (ResultSet rs = ps.executeQuery()) {
//				while (rs.next()) {
//					serials.add(rs.getInt("id"));
//				}
//			}
//		}
//		return serials;
//	}
//
//	private int createWarrantyCard(Connection conn, int serialId, int customerId) throws SQLException {
//		String sql = "INSERT INTO warranty_cards (device_serial_id, customer_id, start_at, end_at) VALUES (?, ?, ?, ?)";
//		LocalDateTime now = LocalDateTime.now();
//		Timestamp start = Timestamp.valueOf(now);
//		Timestamp end = Timestamp.valueOf(now.plusMonths(12));
//		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//			ps.setInt(1, serialId);
//			ps.setInt(2, customerId);
//			ps.setTimestamp(3, start);
//			ps.setTimestamp(4, end);
//			ps.executeUpdate();
//			try (ResultSet rs = ps.getGeneratedKeys()) {
//				if (rs.next()) {
//					return rs.getInt(1);
//				}
//			}
//		}
//		throw new SQLException("Không thể tạo thẻ bảo hành cho serial " + serialId);
//	}
//
//	private void insertOrderDetail(Connection conn, int orderId, CartDetail item, int serialId, int warrantyId)
//			throws SQLException {
//		String sql = "INSERT INTO order_details (order_id, device_id, device_serial_id, quantity, price, warranty_card_id) VALUES (?, ?, ?, ?, ?, ?)";
//		try (PreparedStatement ps = conn.prepareStatement(sql)) {
//			ps.setInt(1, orderId);
//			ps.setInt(2, item.getDevice().getId());
//			ps.setInt(3, serialId);
//			ps.setInt(4, 1);
//			ps.setDouble(5, item.getPrice());
//			ps.setInt(6, warrantyId);
//			ps.executeUpdate();
//		}
//	}
//
//	private void updateSerialStatus(Connection conn, int serialId) throws SQLException {
//		String sql = "UPDATE device_serials SET stock_status = 'sold', status = 'active' WHERE id = ?";
//		try (PreparedStatement ps = conn.prepareStatement(sql)) {
//			ps.setInt(1, serialId);
//			ps.executeUpdate();
//		}
//	}
//
//	private void insertPaymentRecord(Connection conn, int orderId, String paymentMethod) throws SQLException {
//		String status = "pending";
//		Timestamp paidAt = null;
//		if (paymentMethod != null && !"cash_on_delivery".equalsIgnoreCase(paymentMethod)) {
//			status = "success";
//			paidAt = new Timestamp(System.currentTimeMillis());
//		}
//		String sql = "INSERT INTO payments (order_id, payment_url, status, created_at, paid_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
//		try (PreparedStatement ps = conn.prepareStatement(sql)) {
//			ps.setInt(1, orderId);
//			ps.setNull(2, Types.VARCHAR);
//			ps.setString(3, status);
//			if (paidAt != null) {
//				ps.setTimestamp(4, paidAt);
//			} else {
//				ps.setNull(4, Types.TIMESTAMP);
//			}
//			ps.executeUpdate();
//		}
//	}
//

//}
