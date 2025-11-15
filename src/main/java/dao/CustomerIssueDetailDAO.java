package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dal.DBContext;
import model.CustomerIssueDetail;

public class CustomerIssueDetailDAO extends DBContext {
	
	public CustomerIssueDetail getByIssueId(int issueId, String serialNo) {
		String sql = "SELECT * FROM customer_issue_details WHERE issue_id = ? "
				+ "ORDER BY updated_at DESC, id DESC LIMIT 1";
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
				 String storedSerial = rs.getString("device_serial");
				 if (storedSerial == null || storedSerial.trim().isEmpty()) {
					 storedSerial = serialNo;
				 }
				 c.setDeviceSerial(storedSerial);
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
		String updateSql = "UPDATE customer_issue_details SET support_staff_id = ?, customer_full_name = ?, "
				+ "contact_email = ?, contact_phone = ?, device_serial = ?, summary = ?, forward_to_manager = ?, "
				+ "updated_at = CURRENT_TIMESTAMP WHERE issue_id = ?";
		String insertSql = "INSERT INTO customer_issue_details (issue_id, support_staff_id, customer_full_name, "
				+ "contact_email, contact_phone, device_serial, summary, forward_to_manager) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		
		try (Connection conn = getConnection()) {
			try (PreparedStatement update = conn.prepareStatement(updateSql)) {
				update.setInt(1, form.getSupportStaffId());
				update.setString(2, form.getCustomerFullName());
				update.setString(3, form.getContactEmail());
				update.setString(4, form.getContactPhone());
				update.setString(5, form.getDeviceSerial());
				update.setString(6, form.getSummary());
				update.setBoolean(7, form.isForwardToManager());
				update.setInt(8, form.getIssueId());
				int affected = update.executeUpdate();
				if (affected > 0) {
					return true;
				}
			}
			
			try (PreparedStatement insert = conn.prepareStatement(insertSql)) {
				insert.setInt(1, form.getIssueId());
				insert.setInt(2, form.getSupportStaffId());
				insert.setString(3, form.getCustomerFullName());
				insert.setString(4, form.getContactEmail());
				insert.setString(5, form.getContactPhone());
				insert.setString(6, form.getDeviceSerial());
				insert.setString(7, form.getSummary());
				insert.setBoolean(8, form.isForwardToManager());
				return insert.executeUpdate() > 0;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
}
