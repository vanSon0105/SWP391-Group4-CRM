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
}
