package dao;
import java.sql.*;
import java.util.*;
import model.Supplier;

public class SupplierDAO extends dal.DBContext {
	
	public List<Supplier> searchSuppliers(String keyword) {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT * FROM suppliers WHERE name LIKE ? OR phone LIKE ? OR email LIKE ?";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        String key = "%" + (keyword == null ? "" : keyword.trim()) + "%";
	        ps.setString(1, key);
	        ps.setString(2, key);
	        ps.setString(3, key);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            list.add(new Supplier(
	                rs.getInt("id"),
	                rs.getString("name"),
	                rs.getString("phone"),
	                rs.getString("email"),
	                rs.getString("address")
	            ));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
    public Supplier getSupplierById(int id) {
        String sql = "SELECT * FROM suppliers WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
            
            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return new Supplier(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("address")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getSupplierById: " + e.getMessage());
        }
        return null;
    }

    public void addSupplier(Supplier s) {
        String sql = "INSERT INTO suppliers (name, phone, email, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
            
            pre.setString(1, s.getName());
            pre.setString(2, s.getPhone());
            pre.setString(3, s.getEmail());
            pre.setString(4, s.getAddress());
            pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertSupplier: " + e.getMessage());
        }
    }

    public void updateSupplier(Supplier s) {
        String sql = "UPDATE suppliers SET name = ?, phone = ?, email = ?, address = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
            
            pre.setString(1, s.getName());
            pre.setString(2, s.getPhone());
            pre.setString(3, s.getEmail());
            pre.setString(4, s.getAddress());
            pre.setInt(5, s.getId());
            pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updateSupplier: " + e.getMessage());
        }
    }

    public void deleteSupplier(int id) {
        String sql = "DELETE FROM suppliers WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
            
            pre.setInt(1, id);
            pre.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteSupplier: " + e.getMessage());
        }
    }
	
	public List<Supplier> getAllSuppliers() {
		List<Supplier> list = new ArrayList<>();
		String sql = "select * from suppliers";
		
		try ( Connection conn = getConnection();
			  PreparedStatement pre = conn.prepareStatement(sql);
			  ResultSet rs = pre.executeQuery()){
			
			while(rs.next()) {
				list.add(new Supplier(
						rs.getInt("id"),
						rs.getString("name"),
						rs.getString("phone"),
						rs.getString("email"),
						rs.getString("address")
						));
			}
			
		} catch (SQLException e) {
			System.out.print("Connection error");
		}
		return list;
	}
	
	public static void main(String[] args) {
	    SupplierDAO dao = new SupplierDAO();
	    List<Supplier> suppliers = dao.getAllSuppliers();
	    for (Supplier s : suppliers) {
	        System.out.println(s.getName() + " - " + s.getPhone());
	    }
	}
}
