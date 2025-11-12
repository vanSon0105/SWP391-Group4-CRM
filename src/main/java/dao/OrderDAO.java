package dao;
import java.util.*;
import java.math.BigDecimal;
import java.sql.*;
import model.Order;
import model.OrderDetail;
import model.OrderHistory;
import dal.DBContext;

public class OrderDAO extends DBContext{
	
 

	public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY date DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setCustomerId(rs.getInt("customer_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setDiscount(rs.getBigDecimal("discount"));
                o.setStatus(rs.getString("status"));
                o.setDate(rs.getTimestamp("date"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setCustomerId(rs.getInt("customer_id"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setDiscount(rs.getBigDecimal("discount"));
                    o.setStatus(rs.getString("status"));
                    o.setDate(rs.getTimestamp("date"));
                    return o;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateOrderStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int addNewOrder(int customerId, double totalAmount, double discount) {
        String sql = "INSERT INTO orders (customer_id, total_amount, discount, status, date) VALUES (?, ?, ?, 'pending', NOW())";
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
            e.printStackTrace();
        }
        return -1;
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
			e.printStackTrace();
		}
		return -1;
	}
	
	public void clearCart(int cartId)  {
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement("DELETE FROM cart_details WHERE cart_id = ?")) {
			ps.setInt(1, cartId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement("UPDATE carts SET sum = 0 WHERE id = ?")) {
			ps.setInt(1, cartId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public List<Order> getOrdersByCustomerWithFilter(int customerId, String status, String sortField, int limit, int offset) {
	    List<Order> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE customer_id = ?");

	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND status = ?");
	    }

	    if (sortField == null || sortField.isEmpty()) sortField = "date";

	    sql.append(" LIMIT ? OFFSET ?");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int idx = 1;
	        ps.setInt(idx++, customerId);
	        if (status != null && !status.isEmpty()) {
	            ps.setString(idx++, status);
	        }
	        ps.setInt(idx++, limit);
	        ps.setInt(idx++, offset);

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            list.add(new Order(
	                rs.getInt("id"),
	                rs.getInt("customer_id"),
	                rs.getBigDecimal("total_amount"),
	                rs.getBigDecimal("discount"),
	                rs.getString("status"),
	                rs.getTimestamp("date")
	            ));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countOrdersByCustomerWithFilter(int customerId, String status) {
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE customer_id = ?");
	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND status = ?");
	    }
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	        ps.setInt(1, customerId);
	        if (status != null && !status.isEmpty()) {
	            ps.setString(2, status);
	        }
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
	
	 public List<OrderHistory> getAllOrderHistories() throws SQLException {
	        List<OrderHistory> list = new ArrayList<>();
	        String sql = "SELECT o.id AS order_id, o.customer_id, u.full_name, o.total_amount, " +
	                     "o.date, o.status " +
	                     "FROM orders o " +
	                     "JOIN users u ON o.customer_id = u.id " +
	                     "ORDER BY o.date DESC";

	        try (Connection conn = DBContext.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                OrderHistory order = new OrderHistory();
	                order.setOrderId(rs.getInt("order_id"));
	                order.setCustomerId(rs.getInt("customer_id"));
	                order.setCustomerName(rs.getString("full_name"));
	                order.setTotalAmount(rs.getBigDecimal("total_amount"));
	                order.setDate(rs.getTimestamp("date"));
	                order.setStatus(rs.getString("status"));
	                list.add(order);
	            }
	        }
	        return list;
	    }

	  public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
	        List<OrderDetail> list = new ArrayList<>();
	        String sql = "SELECT * FROM order_details WHERE order_id = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setInt(1, orderId);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                OrderDetail od = new OrderDetail();
	                od.setId(rs.getInt("id"));
	                od.setOrderId(rs.getInt("order_id"));
	                //od.setDeviceName(rs.getString("device_name"));
	                od.setQuantity(rs.getInt("quantity"));
	                od.setPrice(rs.getDouble("price"));
	                list.add(od);
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return list;
	    }
	  
	  public int getTotalDevicesPurchasedByCustomer(int customerId) {
			String sql = "SELECT COUNT(*) FROM warranty_cards WHERE customer_id = ?";
			try (Connection conn = getConnection();
				 PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setInt(1, customerId);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next()) {
						return rs.getInt(1);
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return 0;
		}
}
