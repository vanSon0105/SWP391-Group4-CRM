package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dal.DBContext;
import model.Issue;
import model.DeviceSerial;


public class IssueDAO {

	public Issue getIssueById(int id) {
        Issue issue = null;

        String sql = "SELECT " + 
               " i.id AS issue_id, " +
               " i.issue_code, " +
               " i.title, " +
               " i.description, " +
               " i.issue_type, " +
               " i.support_status AS status, " +
               " i.created_at, " +
               " i.customer_id, " +
               " ds.serial_no, " +
               " d.name AS device_name " +
           " FROM customer_issues i " +
           " LEFT JOIN warranty_cards w ON i.warranty_card_id = w.id " +
           " LEFT JOIN device_serials ds ON w.device_serial_id = ds.id " +
           " LEFT JOIN devices d ON ds.device_id = d.id " +
           " WHERE i.id = ? ";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                issue = new Issue();
                issue.setId(rs.getInt("issue_id"));
                issue.setIssueCode(rs.getString("issue_code"));
                issue.setTitle(rs.getString("title"));
                issue.setDescription(rs.getString("description"));
                issue.setIssueType(rs.getString("issue_type"));
                issue.setStatus(rs.getString("status"));
                issue.setCreatedAt(rs.getTimestamp("created_at"));
                issue.setCustomerId(rs.getInt("customer_id"));

                DeviceSerial serial = new DeviceSerial();
                serial.setSerial_no(rs.getString("serial_no"));
                serial.setDeviceName(rs.getString("device_name"));
                issue.setDeviceSerial(serial);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return issue;
    }
}
