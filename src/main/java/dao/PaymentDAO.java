package dao;
import java.util.*;
import java.sql.*;
import model.Payment;
import dal.DBContext;

public class PaymentDAO extends DBContext {
	public int addNewPayment(Payment payment) {
		String sql = "INSERT INTO payments \r\n"
				+ "(order_id, payment_url, payment_method, amount, full_name, phone, address, delivery_time, technical_note, status, created_at, paid_at)  "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', NOW(), ?)";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
			pre.setInt(1, payment.getOrderId());
			pre.setString(2, null);
			pre.setString(3, payment.getPaymentMethod());
			pre.setDouble(4, payment.getAmount());
			pre.setString(5, payment.getFullName());
			pre.setString(6, payment.getPhone());
			pre.setString(7, payment.getAddress());
			pre.setString(8, payment.getDeliveryTime());
			pre.setString(9, payment.getTechnicalNote());
			pre.setTimestamp(10, payment.getPaidAt());
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
}
