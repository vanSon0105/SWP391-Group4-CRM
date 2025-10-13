package dao;
import java.sql.*;
import java.util.*;
import model.Category;

public class CategoryDAO extends dal.DBContext {
	public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    category = new Category(
                        rs.getInt("id"),
                        rs.getString("category_name")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getCategoryById: " + e.getMessage());
        }
        return category;
    }
	
	public List<Category> getAllCategories() {
		List<Category> list = new ArrayList<>();
		String sql = "select * from categories";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery()){
			
			while(rs.next()) {
				list.add(new Category(
						rs.getInt("id"),
						rs.getString("category_name")
						));
			}
			
		} catch (SQLException e) {
			System.out.print("Error get category");
		}
		
		return list;
	}
	
	public static void main(String[] args) {
		CategoryDAO dao = new CategoryDAO();
		List<Category> list = dao.getAllCategories();
		
		
		if(list.isEmpty()) {
			System.out.print("Error connection");
		} else {
			for(Category c : list) {
				System.out.print(" " + c.getId() + " "  + c.getCategoryName());
			}
			
		}
	}
}
