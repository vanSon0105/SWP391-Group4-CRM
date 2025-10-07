package dao;
import model.OrderDetail;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
public class OrderDetailDAO extends dal.DBContext{
	 public int addOrderDetail(OrderDetail orderDetail) {
	        int n = 0;
	        String sql = "INSERT INTO [Order Details] (OrderID, DeviceID, Quantity, Price, Discount, WarrantyDate) VALUES (?, ?, ?, ?, ?, ?)";

	        try (Connection conn = getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            
	            stmt.setInt(1, orderDetail.getOrderId());
	            stmt.setInt(2, orderDetail.getDeviceId());
	            stmt.setInt(3, orderDetail.getQuantity());
	            stmt.setDouble(4, orderDetail.getPrice());
	            stmt.setDouble(5, orderDetail.getDiscount());
	            stmt.setTimestamp(6, orderDetail.getWarrantyDate());
	            
	            n = stmt.executeUpdate();
	        } catch (SQLException ex) {
	            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }

	        return n;
	    }

	    public int updateOrderDetail(OrderDetail orderDetail) {
	        int n = 0;
	        String sql = "UPDATE [Order Details] SET Quantity = ?, Price = ?, Discount = ?, WarrantyDate = ? WHERE OrderID = ? AND DeviceID = ?";

	        try (Connection conn = getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            
	            stmt.setInt(1, orderDetail.getQuantity());
	            stmt.setDouble(2, orderDetail.getPrice());
	            stmt.setDouble(3, orderDetail.getDiscount());
	            stmt.setTimestamp(4, orderDetail.getWarrantyDate());
	            stmt.setInt(5, orderDetail.getOrderId());
	            stmt.setInt(6, orderDetail.getDeviceId());

	            n = stmt.executeUpdate();
	        } catch (SQLException ex) {
	            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }

	        return n;
	    }

	    public int removeOrderDetail(int orderId, int deviceId) {
	        int n = 0;
	        String sql = "DELETE FROM [Order Details] WHERE OrderID = ? AND DeviceID = ?";

	        try (Connection conn = getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            
	            stmt.setInt(1, orderId);
	            stmt.setInt(2, deviceId);
	            
	            n = stmt.executeUpdate();
	        } catch (SQLException ex) {
	            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }

	        return n;
	    }


	    public Vector<OrderDetail> getOrderDetailsByOrderId(int orderId) {
	        Vector<OrderDetail> orderDetails = new Vector<>();
	        String sql = "SELECT * FROM [Order Details] WHERE OrderID = ?";

	        try (Connection conn = getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            
	            stmt.setInt(1, orderId);
	            ResultSet rs = stmt.executeQuery();
	            while (rs.next()) {
	                int orderIdFromDB = rs.getInt("OrderID");
	                int deviceId = rs.getInt("DeviceID");
	                int quantity = rs.getInt("Quantity");
	                double price = rs.getDouble("Price");
	                double discount = rs.getDouble("Discount");
	                Timestamp warrantyDate = rs.getTimestamp("WarrantyDate");
	                
	                OrderDetail orderDetail = new OrderDetail(orderIdFromDB, deviceId, quantity, price, discount, warrantyDate);
	                orderDetails.add(orderDetail);
	            }
	        } catch (SQLException ex) {
	            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }

	        return orderDetails;
	    }

	    public Vector<OrderDetail> getAllOrderDetails() {
	        Vector<OrderDetail> orderDetails = new Vector<>();
	        String sql = "SELECT * FROM [Order Details]";

	        try (Connection conn = getConnection();
	             Statement stmt = conn.createStatement()) {
	            
	            ResultSet rs = stmt.executeQuery(sql);
	            while (rs.next()) {
	                int orderId = rs.getInt("OrderID");
	                int deviceId = rs.getInt("DeviceID");
	                int quantity = rs.getInt("Quantity");
	                double price = rs.getDouble("Price");
	                double discount = rs.getDouble("Discount");
	                Timestamp warrantyDate = rs.getTimestamp("WarrantyDate");
	                
	                OrderDetail orderDetail = new OrderDetail(orderId, deviceId, quantity, price, discount, warrantyDate);
	                orderDetails.add(orderDetail);
	            }
	        } catch (SQLException ex) {
	            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }

	        return orderDetails;
	    }
	  
}
