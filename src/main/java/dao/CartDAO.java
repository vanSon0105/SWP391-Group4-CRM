package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dal.DBContext;
import model.Cart;
import model.CartDetail;
import model.Device;


public class CartDAO extends DBContext {
	public Cart getCartByUserId(int userId) {
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        try (
        		Connection connection = DBContext.getConnection();
        		PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                Cart cart = new Cart();
	                cart.setId(rs.getInt("id"));
	                cart.setSum(rs.getInt("sum"));
	                cart.setUser_id(rs.getInt("user_id"));
	                return cart;
	            }
	        } catch (SQLException e) {
	            e.getMessage();
	        }
	        return null;
    }
	
	public List<CartDetail> getCartDetail(int cartID){
		List<CartDetail> list = new ArrayList<>();
		String sql = "SELECT cd.id, cd.price AS cart_price, cd.quantity, cd.cart_id, d.id AS device_id, d.name, d.description, d.price AS device_price, d.image_url\r\n"
				+ "FROM cart_details cd\r\n"
				+ "JOIN devices d ON cd.device_id = d.id\r\n"
				+ "WHERE cd.cart_id = ?;";

		try { 
			Connection connection = DBContext.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, cartID);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getBigDecimal("device_price"));
                d.setImageUrl(rs.getString("image_url"));
                d.setDesc(rs.getString("description"));
                
                CartDetail cd = new CartDetail();
                cd.setId(rs.getInt("id"));
                cd.setPrice(rs.getBigDecimal("cart_price"));
                cd.setQuantity(rs.getInt("quantity"));
                cd.setCart_id(rs.getInt("cart_id"));
                cd.setDevice(d);
                cd.setTotalPrice(cd.getPrice().multiply(BigDecimal.valueOf(cd.getQuantity())));
                
                list.add(cd);
			}

		} catch (SQLException e) {
			e.getMessage();
		}

		return list;
	}
	
	public CartDetail getCartDetailById(int id) {
		String sql = "SELECT cd.id, cd.price AS cart_price, cd.quantity, cd.cart_id, d.id AS device_id, d.name, d.description, d.price AS device_price, d.image_url\r\n"
				+ "FROM cart_details cd\r\n"
				+ "JOIN devices d ON cd.device_id = d.id\r\n"
				+ "WHERE cd.id = ?;";

		try { 
			Connection connection = DBContext.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getBigDecimal("device_price"));
                d.setImageUrl(rs.getString("image_url"));
                d.setDesc(rs.getString("description"));
                
                CartDetail cd = new CartDetail();
                cd.setId(rs.getInt("id"));
                cd.setPrice(rs.getBigDecimal("cart_price"));
                cd.setQuantity(rs.getInt("quantity"));
                cd.setCart_id(rs.getInt("cart_id"));
                cd.setDevice(d);
                cd.setTotalPrice(cd.getPrice().multiply(BigDecimal.valueOf(cd.getQuantity())));
                
                return cd;
			}

		} catch (SQLException e) {
			e.getMessage();
		}
		return null;
	}
	
	public void updateCartQuantity(int cartDetailId, int quantity) {
	    String sql = "UPDATE cart_details SET quantity = ? WHERE id = ?";
	    try (
	    		Connection connection = DBContext.getConnection();
		        PreparedStatement ps = connection.prepareStatement(sql)) {
		        ps.setInt(1, quantity);
		        ps.setInt(2, cartDetailId);
		        ps.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
}
