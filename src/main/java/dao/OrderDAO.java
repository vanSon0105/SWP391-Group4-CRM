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
}
