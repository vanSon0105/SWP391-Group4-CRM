package dao;
import java.util.*;
import java.sql.*;

import model.CustomerDevice;
import model.CustomerIssue;
import dal.DBContext;

public class CustomerIssueDAO extends DBContext{
	
	public List<CustomerIssue> getAllIssues() {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "select id, title from customer_issues";
		try {Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery();
			 while(rs.next()) { 
				list.add(new CustomerIssue(
						rs.getInt("id"),
						rs.getString("title")
						));
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<CustomerDevice> getCustomerDevices(int customerId) {
		List<CustomerDevice> list = new ArrayList<>();
		String sql = "SELECT wc.id AS warranty_id, d.name AS device_name, ds.serial_no "
				+ "FROM warranty_cards wc "
				+ "JOIN device_serials ds ON ds.id = wc.device_serial_id "
				+ "JOIN devices d ON d.id = ds.device_id "
				+ "WHERE wc.customer_id = ? "
				+ "ORDER BY wc.start_at DESC";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerDevice(rs.getInt("warranty_id"), rs.getString("device_name"),
						rs.getString("serial_no")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<CustomerIssue> getIssuesByUserId(int id) {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE customer_id = ? ORDER BY created_at DESC";
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			 ps.setInt(1, id);
			 ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	private String generateIssueCode() {
		return "ISS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
	}
	
	public boolean createIssue(int customerId, String title, String description, Integer warrantyCardId) {
		String sql = "INSERT INTO customer_issues (customer_id, issue_code, title, description, warranty_card_id) VALUES (?, ?, ?, ?, ?)";
		try (Connection conn = getConnection();
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ps.setString(2, generateIssueCode());
			ps.setString(3, title);
			ps.setString(4, description);
			if (warrantyCardId == 0) {
		        ps.setNull(5, java.sql.Types.INTEGER);
		    } else {
		    	ps.setInt(5, warrantyCardId);		        
		    }
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public CustomerIssue getIssueById(int id) {
		String sql = "SELECT * FROM customer_issues WHERE id = ?";
		try (Connection conn = getConnection(); 
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<CustomerIssue> getUnassignedIssues() {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE support_staff_id IS NULL OR support_status = 'new' ORDER BY created_at ASC";
		try (Connection conn = getConnection(); 
			 PreparedStatement ps = conn.prepareStatement(sql)){
			 ResultSet rs = ps.executeQuery();
			 while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status")));
			 }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<CustomerIssue> getIssuesAssignedToStaff(int staffId) {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE support_staff_id = ? ORDER BY created_at DESC";
		try (Connection conn = getConnection(); 
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			 ps.setInt(1, staffId);
			 ResultSet rs = ps.executeQuery();
			 while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status")));
			 }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean assignIssueIfAvailable(int issueId, int staffId) {
		String sql = "UPDATE customer_issues SET support_staff_id = ?, support_status = 'in_progress' WHERE id = ? AND support_staff_id IS NULL";
		try (Connection conn = getConnection(); 
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			 ps.setInt(1, staffId);
			 ps.setInt(2, issueId);
			 return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean updateSupportStatus(int issueId, int staffId, String status) {
		String sql = "UPDATE customer_issues SET support_status = ?, support_staff_id = ? WHERE id = ?";
		try (Connection conn = getConnection();
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, staffId);
			ps.setInt(3, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<CustomerIssue> getIssuesBySupportStatus(String status) {
		return getIssuesBySupportStatuses(new String[] { status });
	}
	
	public List<CustomerIssue> getIssuesBySupportStatuses(String[] statuses) {
		List<CustomerIssue> list = new ArrayList<>();
		if (statuses == null || statuses.length == 0) {
			return list;
		}

		String sql = "SELECT * FROM customer_issues WHERE support_status IN (";
		for (int i = 0; i < statuses.length; i++) {
			if (i > 0) {
				sql += (',');
			}
			sql += ('?');
		}
		sql += (") ORDER BY created_at ASC");

		try (Connection c = getConnection();
			 PreparedStatement ps = c.prepareStatement(sql)) {
			 for (int i = 0; i < statuses.length; i++) {
				ps.setString(i + 1, statuses[i]);
			 }
			 ResultSet rs = ps.executeQuery();
			 while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status")));
			 }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	public boolean updateSupportStatus(int issueId, String status) {
		String sql = "UPDATE customer_issues SET support_status = ? WHERE id = ?";
		try (Connection conn = getConnection();
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<CustomerIssue> getIssuesReadyForManager() {
		return getIssuesBySupportStatuses(new String[] { "manager_approved" });
	}
	
	public List<CustomerIssue> getIssuesAwaitingManagerReview() {
		return getIssuesBySupportStatuses(new String[] { "submitted", "manager_review" });
	}
}
