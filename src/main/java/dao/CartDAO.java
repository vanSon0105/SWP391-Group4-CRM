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
import model.User;


public class CartDAO extends DBContext {
	private UserDAO uDao = new UserDAO();
	private DeviceDAO dDao = new DeviceDAO();
	private CartDetailDao cdDao = new CartDetailDao();
	
	public Cart getCartByUserId(int userId) {
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        try (
        		Connection connection = getConnection();
        		PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                Cart cart = new Cart();
	                cart.setId(rs.getInt("id"));
	                cart.setSum(rs.getDouble("sum"));
	                cart.setUserId(rs.getInt("user_id"));
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
			Connection connection = getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, cartID);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getDouble("device_price"));
                d.setImageUrl(rs.getString("image_url"));
                d.setDesc(rs.getString("description"));
                
                CartDetail cd = new CartDetail();
                cd.setId(rs.getInt("id"));
                cd.setPrice(rs.getDouble("cart_price"));
                cd.setQuantity(rs.getInt("quantity"));
                cd.setCartId(rs.getInt("cart_id"));
                cd.setDevice(d);
                cd.setTotalPrice(cd.getPrice() * cd.getQuantity());
                
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
			Connection connection = getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getDouble("device_price"));
                d.setImageUrl(rs.getString("image_url"));
                d.setDesc(rs.getString("description"));
                
                CartDetail cd = new CartDetail();
                cd.setId(rs.getInt("id"));
                cd.setPrice(rs.getDouble("cart_price"));
                cd.setQuantity(rs.getInt("quantity"));
                cd.setCartId(rs.getInt("cart_id"));
                cd.setDevice(d);
                cd.setTotalPrice(cd.getPrice() * cd.getQuantity());
                
                return cd;
			}

		} catch (SQLException e) {
			e.getMessage();
		}
		return null;
	}
	
	public boolean deleteCartDetail(int id) {
	    String sql = "DELETE FROM cart_details WHERE id = ?";
	    try (
	    		Connection connection = getConnection();
	            PreparedStatement ps = connection.prepareStatement(sql)) {
	            ps.setInt(1, id);
	            return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public Cart getCartById(int id) {
		String sql = "SELECT * FROM carts\r\n"
				+ "WHERE id = ?;";
	    try (
	    		Connection connection = getConnection();
	            PreparedStatement ps = connection.prepareStatement(sql)) {
	            ps.setInt(1, id);
	            ResultSet rs = ps.executeQuery();
	            if(rs.next()) {
	            	int cartId = rs.getInt("id");
	                double sum = rs.getDouble("sum");
	                int userId = rs.getInt("user_id");
	                
	                return new Cart(cartId, sum, userId);
	            }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public void updateCartSum(int cartId, double sum) {
	    String sql = "UPDATE carts SET sum = ? WHERE id = ?;";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {

	        ps.setDouble(1, sum);
	        ps.setInt(2, cartId);
	        ps.executeUpdate();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
	
	public boolean addCart(Cart c) {
        String sql = "INSERT INTO carts (sum, user_id) VALUES (?, ?)";

        try (Connection con = getConnection();
        	 PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, c.getSum());
            ps.setInt(2, c.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
	
	public Cart getOrCreateCart(int id) {
		Cart cart = getCartByUserId(id);
		if (cart != null) {
			return cart;
		}
		
		String sql = "INSERT INTO carts (sum, user_id) VALUES (0, ?)";
		try (Connection connection = getConnection();
			 PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, id);
			ps.executeUpdate();
			int affected = ps.executeUpdate();
	        if (affected == 0) throw new SQLException("Insert cart failed, no rows affected.");
			ResultSet rs = ps.getGeneratedKeys();
			if (rs.next()) {
				int cartId = rs.getInt(1);
				Cart newCart = new Cart();
				newCart.setId(cartId);
				newCart.setSum(0);
				newCart.setUserId(id);
				return newCart;
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

	
	public boolean addDeviceToCart(int id, int deviceId) {
		User user = uDao.getUserById(id);
        if (user == null) {
        	return false;
        }
        Cart cart = getOrCreateCart(id);
        if (cart == null) {
            return false;
        }
        Device d = dDao.getDeviceById(deviceId);
        if (d == null) {
        	return false;
        }
        
    	CartDetail cartDetail = cdDao.getCartDetailByDevice(cart.getId(), deviceId);
        if (cartDetail == null) {
            cartDetail = new CartDetail();
            cartDetail.setCartId(cart.getId());
            cartDetail.setDevice(d);
            cartDetail.setPrice(d.getPrice());
            cartDetail.setQuantity(1); 
            cdDao.addCartDetail(cartDetail);
        } else {
            cartDetail.setQuantity(cartDetail.getQuantity() + 1);
            cdDao.updateCartDetailQuantity(cartDetail);
        }

        double newSum = calculateCartSum(cart.getId());
        updateCartSum(cart.getId(), newSum);
        return true;
	}
	
	public int getCartIdByUserId(int userId) {
	    int cartId = -1;
	    String sql = "SELECT id FROM carts WHERE user_id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            cartId = rs.getInt("id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return cartId;
	}
	
	public void deleteCart(int cartId) {
	    String sql1 = "DELETE FROM cart_details WHERE cart_id = ?";
	    String sql2 = "DELETE FROM carts WHERE id = ?";
	    try (Connection conn = DBContext.getConnection()) {
	        conn.setAutoCommit(false);
	        try (PreparedStatement ps1 = conn.prepareStatement(sql1);
	             PreparedStatement ps2 = conn.prepareStatement(sql2)) {
	            ps1.setInt(1, cartId);
	            ps1.executeUpdate();
	            ps2.setInt(1, cartId);
	            ps2.executeUpdate();
	            conn.commit();
	        } catch (Exception e) {
	            conn.rollback();
	            throw e;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}


}
