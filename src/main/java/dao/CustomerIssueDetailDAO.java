package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dal.DBContext;
import model.CustomerIssueDetail;

public class CustomerIssueDetailDAO extends DBContext {
	
	public CustomerIssueDetail getByIssueId(int issueId) {
		String sql = "SELECT * FROM customer_issue_details WHERE issue_id = ?";
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			 ps.setInt(1, issueId);
			 ResultSet rs = ps.executeQuery();
			 if (rs.next()) {
				 CustomerIssueDetail c = new CustomerIssueDetail();
				 c.setId(rs.getInt("id"));
				 c.setIssueId(rs.getInt("issue_id"));
				 c.setSupportStaffId(rs.getInt("support_staff_id"));
				 c.setCustomerFullName(rs.getString("customer_full_name"));
				 c.setContactEmail(rs.getString("contact_email"));
				 c.setContactPhone(rs.getString("contact_phone"));
				 c.setDeviceSerial(rs.getString("device_serial"));
				 c.setSummary(rs.getString("summary"));
				 c.setForwardToManager(rs.getBoolean("forward_to_manager"));
				 c.setCreatedAt(rs.getTimestamp("created_at"));
				 c.setUpdatedAt(rs.getTimestamp("updated_at"));
				 return c;
			 }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public boolean saveIssueDetail(CustomerIssueDetail form) {
		String sql = "INSERT INTO customer_issue_details (issue_id, support_staff_id, customer_full_name, contact_email, contact_phone, device_serial, summary, forward_to_manager) VALUES (?, ?, ?, ?, ?, ?, ?, ?)\r\n"
				+ "ON DUPLICATE KEY UPDATE support_staff_id = VALUES(support_staff_id), customer_full_name = VALUES(customer_full_name),\r\n"
				+ "contact_email = VALUES(contact_email), contact_phone = VALUES(contact_phone), device_serial = VALUES(device_serial),\r\n"
				+ "summary = VALUES(summary), forward_to_manager = VALUES(forward_to_manager), updated_at = CURRENT_TIMESTAMP;";
		try (Connection conn = getConnection(); 
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, form.getIssueId());
			ps.setInt(2, form.getSupportStaffId());
			ps.setString(3, form.getCustomerFullName());
			ps.setString(4, form.getContactEmail());
			ps.setString(5, form.getContactPhone());
			ps.setString(6, form.getDeviceSerial());
			ps.setString(7, form.getSummary());
			ps.setBoolean(8, form.isForwardToManager());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
}
