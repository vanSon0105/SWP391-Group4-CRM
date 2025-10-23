package dao;
import java.sql.*;
import java.util.*;
import model.Supplier;

public class SupplierDAO extends dal.DBContext {
	
	public List<Supplier> searchSuppliers(String keyword) {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT * FROM suppliers WHERE status = 1 AND (name LIKE ? OR phone LIKE ? OR email LIKE ?)";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        String key = "%" + (keyword == null ? "" : keyword.trim()) + "%";
	        ps.setString(1, key);
	        ps.setString(2, key);
	        ps.setString(3, key);
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                list.add(new Supplier(
	                    rs.getInt("id"),
	                    rs.getString("name"),
	                    rs.getString("phone"),
	                    rs.getString("email"),
	                    rs.getString("address"),
	                    rs.getInt("status")
	                ));
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public List<Supplier> getDeletedSuppliers() {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT * FROM suppliers WHERE status = 0";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            Supplier supplier = new Supplier(
	            		rs.getInt("id"),
	                    rs.getString("name"),
	                    rs.getString("phone"),
	                    rs.getString("email"),
	                    rs.getString("address"),
	                    rs.getInt("status")
	            );
	            list.add(supplier);
	        }

	    } catch (SQLException e) {
	        System.out.println("Error getDeletedSuppliers: " + e.getMessage());
	    }

	    return list;
	}
	
	
	
	public Supplier getSupplierById(int id) {
	    String sql = "SELECT * FROM suppliers WHERE id = ? AND status = 1";
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
	                    rs.getString("address"),
	                    rs.getInt("status")
	                );
	            }
	        }
	    } catch (SQLException e) {
	        System.out.println("Error getSupplierById: " + e.getMessage());
	    }
	    return null;
	}

    public void addSupplier(Supplier s) {
        String sql = "INSERT INTO suppliers(name, phone, email, address, status) VALUES (?, ?, ?, ?, 1)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setString(2, s.getPhone());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getAddress());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateSupplier(Supplier s) {
        String sql = "UPDATE suppliers SET name=?, phone=?, email=?, address=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setString(2, s.getPhone());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getAddress());
            ps.setInt(5, s.getId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteSupplier(int id) {
        String sql = "UPDATE suppliers SET status = 0 WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void restoreSupplier(int id) {
        String sql = "UPDATE suppliers SET status = 1 WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE status = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setStatus(rs.getInt("status"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
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
