package dao;
import java.util.*;
import java.sql.*;

import model.OrderDetail;
import model.Payment;
import dal.DBContext;

public class PaymentDAO extends DBContext {
	
	public int addNewPayment(Payment payment) {
		String sql = "INSERT INTO payments \r\n"
				+ "(order_id, amount, full_name, phone, address, delivery_time, technical_note, status, created_at, paid_at)  "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', NOW(), ?)";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
			pre.setInt(1, payment.getOrderId());
			pre.setDouble(2, payment.getAmount());
			pre.setString(3, payment.getFullName());
			pre.setString(4, payment.getPhone());
			pre.setString(5, payment.getAddress());
			pre.setString(6, payment.getDeliveryTime());
			pre.setString(7, payment.getTechnicalNote());
			pre.setTimestamp(8, payment.getPaidAt());
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
	
	public void updateStatus(int id, String status) {
		String sql = null;

	    if ("success".equals(status)) {
	        sql = "UPDATE payments SET status = ?, paid_at = NOW() WHERE id = ?";
	    } else if ("failed".equals(status)) {
	        sql = "UPDATE payments SET status = ?, paid_at = NULL WHERE id = ?";
	    } else {
	        sql = "UPDATE payments SET status = ? WHERE id = ?";
	    }
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql)) {
			
			pre.setString(1, status);
			pre.setInt(2, id);
			pre.executeUpdate();
		} catch (Exception e) { 
			// TODO: handle exception
		}
	}
	
	public List<Payment> getFilteredPayments(String status, String sortCreatedAt, String sortPaidAt, String search,
			int limit, int offset) {
		List<Payment> list = new ArrayList<>();
		String sql = "select * from payments where 1=1 ";
		
		if(status != null && !status.trim().isEmpty()) {
			sql += " and status = '" + status + "' ";
		} 
		
		if (search != null && !search.trim().isEmpty()) {
	        sql += " AND (phone LIKE '%" + search + "%' OR full_name LIKE '%" + search + "%') ";
	    }
		
		 List<String> orderClauses = new ArrayList<>();

		    if (sortCreatedAt != null && !sortCreatedAt.trim().isEmpty()) {
		        orderClauses.add("created_at " + sortCreatedAt);
		    }

		    if (sortPaidAt != null && !sortPaidAt.trim().isEmpty()) {
		        orderClauses.add("paid_at " + sortPaidAt);
		    }

		    if (!orderClauses.isEmpty()) {
		        sql += " ORDER BY " + String.join(", ", orderClauses);
		    }
		    
		    sql += " LIMIT ? OFFSET ? ";
		
		    try (Connection conn = getConnection();
					 PreparedStatement pre = conn.prepareStatement(sql);
					 ){
					pre.setInt(1, limit);
					pre.setInt(2, offset);
					ResultSet rs = pre.executeQuery();
					while(rs.next()) {
						list.add(new Payment(
								rs.getInt("id"),
								rs.getInt("order_id"),
								rs.getDouble("amount"),
								rs.getString("full_name"),
								rs.getString("phone"),
								rs.getString("address"),
								rs.getString("delivery_time"),
								rs.getString("technical_note"),
								rs.getString("status"),
								rs.getTimestamp("created_at"),
								rs.getTimestamp("paid_at")
								));
					}
				} catch (Exception e) {
					// TODO: handle exception
				}
				
		    
		return list;
	}
	
	public int getFilteredPaymentCount(String status, String search) {
	    String sql = "SELECT COUNT(*) FROM payments WHERE 1=1 ";
	    if (status != null && !status.trim().isEmpty()) {
	        sql += " AND status = '" + status + "'";
	    }
	    if (search != null && !search.trim().isEmpty()) {
	        sql += " AND (full_name LIKE '%" + search + "%' OR phone LIKE '%" + search + "%')";
	    }
	    try (Connection conn = getConnection();
	         PreparedStatement st = conn.prepareStatement(sql);
	         ResultSet rs = st.executeQuery()) {
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) { e.printStackTrace(); }
	    return 0;
	}
	
	public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
	    List<OrderDetail> list = new ArrayList<>();
	    String sql = "SELECT od.id, od.device_id, d.name AS device_name, "
	            + "od.quantity, od.price, ods.device_serial_id, wc.id AS warranty_card_id "
	            + "FROM order_details od "
	            + "JOIN devices d ON od.device_id = d.id "
	            + "JOIN order_detail_serials ods ON od.id = ods.order_detail_id "
	            + "LEFT JOIN warranty_cards wc ON ods.device_serial_id = wc.device_serial_id "
	            + "WHERE od.order_id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, orderId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            OrderDetail o = new OrderDetail();
	            o.setId(rs.getInt("id"));
	            o.setDeviceId(rs.getInt("device_id"));
	            o.setDeviceName(rs.getString("device_name"));
	            o.setQuantity(rs.getInt("quantity"));
	            o.setPrice(rs.getDouble("price"));
	            o.setDeviceSerialId(rs.getInt("device_serial_id"));
	            o.setWarrantyCardId(rs.getInt("warranty_card_id"));
	            list.add(o);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public Payment getPaymentById(int id) {
	    String sql = "SELECT * FROM payments WHERE id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            Payment p = new Payment();
	            p.setId(rs.getInt("id"));
	            p.setFullName(rs.getString("full_name"));
	            p.setPhone(rs.getString("phone"));
	            p.setAddress(rs.getString("address"));
	            p.setDeliveryTime(rs.getString("delivery_time"));
	            p.setTechnicalNote(rs.getString("technical_note"));
	            p.setStatus(rs.getString("status"));
	            p.setCreatedAt(rs.getTimestamp("created_at"));
	            p.setPaidAt(rs.getTimestamp("paid_at"));
	            
	           
	            return p;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}


	
}
