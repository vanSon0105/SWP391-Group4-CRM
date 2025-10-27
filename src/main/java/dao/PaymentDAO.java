package dao;
import java.util.*;
import java.sql.*;
import model.Payment;
import dal.DBContext;

public class PaymentDAO extends DBContext {
	
	public int addNewPayment(Payment payment) {
		String sql = "INSERT INTO payments \r\n"
				+ "(order_id, payment_url, amount, full_name, phone, address, delivery_time, technical_note, status, created_at, paid_at)  "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending', NOW(), ?)";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
			pre.setInt(1, payment.getOrderId());
			pre.setString(2, null);
			pre.setDouble(3, payment.getAmount());
			pre.setString(4, payment.getFullName());
			pre.setString(5, payment.getPhone());
			pre.setString(6, payment.getAddress());
			pre.setString(7, payment.getDeliveryTime());
			pre.setString(8, payment.getTechnicalNote());
			pre.setTimestamp(9, payment.getPaidAt());
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
								rs.getString("payment_url"),
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

	
}
