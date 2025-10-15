package dao;
import java.sql.*;
import java.util.*;
import model.Category;

public class CategoryDAO extends dal.DBContext {
	public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT * FROM categories WHERE id = ?";
        try {Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql);

            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                category = new Category(
                    rs.getInt("id"),
                    rs.getString("category_name"));
                }
        } catch (SQLException e) {
            e.printStackTrace();;
        }
        return category;
    }
	
	public List<Category> getAllCategories() {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT * FROM categories";
		
		
		try {Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery();
			
			while(rs.next()) {
				list.add(new Category(rs.getInt("id"),rs.getString("category_name")));
				};
		} catch (SQLException e) {
			System.out.print("Error get category");
		}
		
		return list;
	}
	
	public boolean checkDeviceConnectCategory(int id) {
		String sql = "SELECT COUNT(*) AS device_count\r\n"
				+ "FROM devices\r\n"
				+ "WHERE category_id = ?;";
		
		try {
			Connection connection = getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt("device_count") > 0;
	        }		
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<Category> getCategoriesByPage(int offset, int recordsEachPage) {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT c.id, c.category_name, (SELECT COUNT(d.id) FROM devices d WHERE d.category_id = c.id) AS device_count\r\n"
				+ "FROM categories c\r\n"
				+ "ORDER BY c.id DESC\r\n"
				+ "LIMIT ? OFFSET ?;";

		try {Connection connection = getConnection();
			 PreparedStatement ps = connection.prepareStatement(sql);
			 ps.setInt(1, recordsEachPage);
			 ps.setInt(2, offset);
			 ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				list.add(new Category(rs.getInt("id"),rs.getString("category_name"), rs.getInt("device_count") > 0));
				};
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public int getTotalCategories() {
	    String sql = "SELECT COUNT(*) FROM categories";
	    try {Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
	
	public boolean addCategory(String name) {
		String sql = "INSERT INTO categories (category_name) VALUES (?);";
	    try {Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql);
	         ps.setString(1, name);
	         return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
}
