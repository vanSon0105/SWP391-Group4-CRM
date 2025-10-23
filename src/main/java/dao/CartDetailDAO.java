package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dal.DBContext;
import model.CartDetail;

public class CartDetailDAO extends DBContext {
	DeviceDAO dDao = new DeviceDAO();
	
	public CartDetail getCartDetailByDevice(int cartId, int deviceId) {
	    String sql = "SELECT * FROM cart_details WHERE cart_id = ? AND device_id = ?";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, cartId);
	        ps.setInt(2, deviceId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            CartDetail cartDetail = new CartDetail();
	            cartDetail.setId(rs.getInt("id"));
	            cartDetail.setCartId(rs.getInt("cart_id"));
	            cartDetail.setDevice(dDao.getDeviceById(deviceId));
	            cartDetail.setPrice(rs.getDouble("price"));
	            cartDetail.setQuantity(rs.getInt("quantity"));
	            return cartDetail;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public double calculateCartSum(int cartId) {
	    double sum = 0;
	    String sql = "SELECT SUM(cd.price * cd.quantity) AS total_sum FROM cart_details cd WHERE cd.cart_id = ?";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, cartId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            sum = rs.getDouble("total_sum");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return sum;
	}

	
	public void addCartDetail(CartDetail cartDetail) {
	    String sql = "INSERT INTO cart_details (price, quantity, cart_id, device_id) VALUES (?, ?, ?, ?)";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setDouble(1, cartDetail.getPrice());
	        ps.setInt(2, cartDetail.getQuantity());
	        ps.setInt(3, cartDetail.getCartId());
	        ps.setInt(4, cartDetail.getDevice().getId());
	        ps.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
	
	public void updateCartDetailQuantity(CartDetail cartDetail) {
	    String sql = "UPDATE cart_details SET quantity = ? WHERE id = ?";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, cartDetail.getQuantity());
	        ps.setInt(2, cartDetail.getId());
	        ps.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
	
}
