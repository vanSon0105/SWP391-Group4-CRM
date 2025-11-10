package dao;
import java.sql.*;
import java.util.*;
import model.Supplier;

public class SupplierDAO extends dal.DBContext {
	public List<Supplier> filterSuppliers(String statusFilter, String addressFilter, int page, int pageSize) {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT * FROM suppliers WHERE 1=1";

	    if (statusFilter != null && !statusFilter.isEmpty()) {
	        sql += " AND status = ?";
	    }
	    if (addressFilter != null && !addressFilter.isEmpty()) {
	        sql += " AND LOWER(address) LIKE ?";
	    }

	    sql += " ORDER BY id ASC LIMIT ? OFFSET ?";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        int index = 1;
	        if (statusFilter != null && !statusFilter.isEmpty()) {
	            ps.setInt(index++, Integer.parseInt(statusFilter));
	        }
	        if (addressFilter != null && !addressFilter.isEmpty()) {
	            ps.setString(index++, "%" + addressFilter.trim().toLowerCase() + "%");
	        }

	        ps.setInt(index++, pageSize);
	        ps.setInt(index, (page - 1) * pageSize);

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
	
	public List<Supplier> getActiveSuppliers() {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT id, name, phone, email, address, status FROM suppliers WHERE status = 1 ORDER BY name ASC";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
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
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public int countSuppliersByFilter(String statusFilter, String addressFilter) {
	    String sql = "SELECT COUNT(*) FROM suppliers WHERE 1=1";

	    if (statusFilter != null && !statusFilter.isEmpty()) {
	        sql += " AND status = ?";
	    }
	    if (addressFilter != null && !addressFilter.isEmpty()) {
	        sql += " AND LOWER(address) LIKE ?";
	    }

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        int index = 1;
	        if (statusFilter != null && !statusFilter.isEmpty()) {
	            ps.setInt(index++, Integer.parseInt(statusFilter));
	        }
	        if (addressFilter != null && !addressFilter.isEmpty()) {
	            ps.setString(index++, "%" + addressFilter.trim().toLowerCase() + "%");
	        }

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
	
	public List<Supplier> searchSuppliersWithPaging(String keyword, int page, int pageSize) {
	    List<Supplier> list = new ArrayList<>();
	    String sql = "SELECT * FROM suppliers " +
	                 "WHERE status = 1 " +
	                 "AND (LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) " +
	                 "ORDER BY id ASC " +
	                 "LIMIT ? OFFSET ?";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        String key = "%" + (keyword == null ? "" : keyword.trim().toLowerCase()) + "%";
	        ps.setString(1, key);
	        ps.setString(2, key);
	        ps.setString(3, "%" + (keyword == null ? "" : keyword.trim()) + "%");
	        ps.setInt(4, pageSize);
	        ps.setInt(5, (page - 1) * pageSize);

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
	
	public int countSuppliersByKeyword(String keyword) {
	    String sql = "SELECT COUNT(*) FROM suppliers " +
	                 "WHERE status = 1 " +
	                 "AND (LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?)";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        String key = "%" + (keyword == null ? "" : keyword.trim().toLowerCase()) + "%";
	        ps.setString(1, key);
	        ps.setString(2, key);
	        ps.setString(3, "%" + (keyword == null ? "" : keyword.trim()) + "%");

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
	            list.add(new Supplier(
	                rs.getInt("id"),
	                rs.getString("name"),
	                rs.getString("phone"),
	                rs.getString("email"),
	                rs.getString("address"),
	                rs.getInt("status")
	            ));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
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
    
    public boolean existsPhone(String phone, Integer id) {
        String sql = "SELECT COUNT(*) FROM suppliers WHERE phone = ? AND status = 1";
        if (id != null) sql += " AND id != ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            if (id != null) ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existsEmail(String email, Integer id) {
        String sql = "SELECT COUNT(*) FROM suppliers WHERE email = ? AND status = 1";
        if (id != null) sql += " AND id != ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            if (id != null) ps.setInt(2, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
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
