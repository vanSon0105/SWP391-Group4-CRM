package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dal.DBContext;
import model.WarrantyCard;
import model.DeviceSerial;
import model.Customer;

public class WarrantyCardDAO extends DBContext{
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	public WarrantyCard getBySerialId(int serialId) {
	    String sql = "SELECT * FROM warranty_cards WHERE device_serial_id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, serialId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new WarrantyCard(
	            		rs.getInt("id"),
	            		rs.getInt("device_serial_id"),
	            		rs.getInt("customer_id"),
	            		rs.getTimestamp("start_at"),
	            		rs.getTimestamp("end_at")
	            		);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public boolean updateWarrantyDates(int warrantyId, Timestamp start, Timestamp end) {
	    String sql = "UPDATE warranty_cards SET start_at = ?, end_at = ? WHERE id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setTimestamp(1, start);
	        ps.setTimestamp(2, end);
	        ps.setInt(3, warrantyId);
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public int addWarrantyCard(int deviceSerialId, int customerId, Timestamp start, Timestamp end) throws SQLException {
        String sql = "INSERT INTO warranty_cards (device_serial_id, customer_id, start_at, end_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, deviceSerialId);
            ps.setInt(2, customerId);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); 
                }
            } catch (SQLException e) {
				e.printStackTrace();
			}
        }
        return -1;
    }
	
	public WarrantyCard getById(int id) {
	    String sql = "SELECT * FROM warranty_cards WHERE id = ?";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new WarrantyCard(
	            		rs.getInt("id"),
	            		rs.getInt("device_serial_id"),
	            		rs.getInt("customer_id"),
	            		rs.getTimestamp("start_at"),
	            		rs.getTimestamp("end_at")
	            		);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public List<WarrantyCard> getWarrantyList(String search, String status, int offset, int limit) {
	    List<WarrantyCard> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder(
	        "SELECT wc.id AS warrantyId, wc.start_at, wc.end_at, " +
	        "ds.id AS deviceSerialId, ds.serial_no, ds.device_id, " +
	        "d.name AS deviceName, " +
	        "u.id AS customerId, u.full_name AS customerName " +
	        "FROM warranty_cards wc " +
	        "JOIN device_serials ds ON wc.device_serial_id = ds.id " +
	        "JOIN devices d ON ds.device_id = d.id " +
	        "JOIN users u ON wc.customer_id = u.id " +
	        "JOIN customer_issues ci ON ci.warranty_card_id = wc.id " +
	        "WHERE ci.support_status IN (" +
	        "'new','in_progress','awaiting_customer','tech_in_progress','submitted'," +
	        "'manager_review','manager_approved','create_payment','waiting_payment'," +
	        "'waiting_confirm','task_created')" 
	    );

	    if (search != null && !search.isEmpty()) {
	        sql.append(" AND (d.name LIKE ? OR ds.serial_no LIKE ? OR u.full_name LIKE ?)");
	    }

	    if (status != null && !status.isEmpty()) {
	        if (status.equals("valid")) {
	            sql.append(" AND wc.end_at >= NOW()");
	        } else if (status.equals("expired")) {
	            sql.append(" AND wc.end_at < NOW()");
	        }
	    }

	    sql.append(" ORDER BY wc.end_at ASC LIMIT ? OFFSET ?");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int index = 1;
	        if (search != null && !search.isEmpty()) {
	            String like = "%" + search + "%";
	            ps.setString(index++, like);
	            ps.setString(index++, like);
	            ps.setString(index++, like);
	        }

	        ps.setInt(index++, limit);
	        ps.setInt(index++, offset);

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            DeviceSerial ds = new DeviceSerial();
	            ds.setId(rs.getInt("deviceSerialId"));
	            ds.setSerial_no(rs.getString("serial_no"));
	            ds.setDevice_id(rs.getInt("device_id"));
	            ds.setDeviceName(rs.getString("deviceName"));

	            Customer c = new Customer();
	            c.setId(rs.getInt("customerId"));
	            c.setFull_name(rs.getString("customerName"));

	            WarrantyCard wc = new WarrantyCard();
	            wc.setId(rs.getInt("warrantyId"));
	            wc.setDevice_serial(ds);
	            wc.setCustomer(c);
	            wc.setStart_at(rs.getTimestamp("start_at"));
	            wc.setEnd_at(rs.getTimestamp("end_at"));

	            list.add(wc);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	public int countWarranty(String search, String status) {
	    int total = 0;
	    StringBuilder sql = new StringBuilder(
	        "SELECT COUNT(DISTINCT wc.id) AS total " +
	        "FROM warranty_cards wc " +
	        "JOIN device_serials ds ON wc.device_serial_id = ds.id " +
	        "JOIN devices d ON ds.device_id = d.id " +
	        "JOIN users u ON wc.customer_id = u.id " +
	        "JOIN customer_issues ci ON ci.warranty_card_id = wc.id " +
	        "WHERE ci.support_status IN (" +
	        "'new','in_progress','awaiting_customer','tech_in_progress','submitted'," +
	        "'manager_review','manager_approved','create_payment','waiting_payment'," +
	        "'waiting_confirm','task_created')"
	    );

	    if (search != null && !search.isEmpty()) {
	        sql.append(" AND (d.name LIKE ? OR ds.serial_no LIKE ? OR u.full_name LIKE ?)");
	    }

	    if (status != null && !status.isEmpty()) {
	        if (status.equals("valid")) {
	            sql.append(" AND wc.end_at >= NOW()");
	        } else if (status.equals("expired")) {
	            sql.append(" AND wc.end_at < NOW()");
	        }
	    }

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int index = 1;
	        if (search != null && !search.isEmpty()) {
	            String like = "%" + search + "%";
	            ps.setString(index++, like);
	            ps.setString(index++, like);
	            ps.setString(index++, like);
	        }

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            total = rs.getInt("total");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return total;
	}
    public WarrantyCard getByIdWithDetails(int id) {
        String sql = "SELECT wc.id AS warrantyId, wc.start_at, wc.end_at, " +
                     "ds.id AS deviceSerialId, ds.serial_no, ds.device_id, d.name AS deviceName, " +
                     "u.id AS customerId, u.full_name AS customerName, u.email " +
                     "FROM warranty_cards wc " +
                     "JOIN device_serials ds ON wc.device_serial_id = ds.id " +
                     "JOIN devices d ON ds.device_id = d.id " +
                     "JOIN users u ON wc.customer_id = u.id " +
                     "WHERE wc.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                DeviceSerial ds = new DeviceSerial();
                ds.setId(rs.getInt("deviceSerialId"));
                ds.setSerial_no(rs.getString("serial_no"));
                ds.setDevice_id(rs.getInt("device_id"));
                ds.setDeviceName(rs.getString("deviceName"));

                Customer c = new Customer();
                c.setId(rs.getInt("customerId"));
                c.setFull_name(rs.getString("customerName"));
                c.setEmail(rs.getString("email"));

                WarrantyCard wc = new WarrantyCard();
                wc.setId(rs.getInt("warrantyId"));
                wc.setDevice_serial(ds);
                wc.setCustomer(c);
                wc.setStart_at(rs.getTimestamp("start_at"));
                wc.setEnd_at(rs.getTimestamp("end_at"));

                return wc;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<WarrantyCard> getHistoryWithStaffBySerialId(int warrantyCardId) {
        List<WarrantyCard> list = new ArrayList<>();
        String sql = "SELECT ci.id AS issueId, " +
                     "       ci.created_at AS startAt, " +
                     "       td.deadline AS endAt, " +
                     "       GROUP_CONCAT(DISTINCT m.id, ' - ', m.full_name SEPARATOR ', ') AS assignedBy, " +
                     "       GROUP_CONCAT(DISTINCT ts.id, ' - ', ts.full_name SEPARATOR ', ') AS handledBy " +
                     "FROM customer_issues ci " +
                     "LEFT JOIN tasks t ON ci.id = t.customer_issue_id " +
                     "LEFT JOIN users m ON t.manager_id = m.id " +
                     "LEFT JOIN task_details td ON t.id = td.task_id " +
                     "LEFT JOIN users ts ON td.technical_staff_id = ts.id " +
                     "WHERE ci.warranty_card_id = ? " +
                     "GROUP BY ci.id, ci.created_at, td.deadline " +
                     "ORDER BY ci.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, warrantyCardId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                WarrantyCard wc = new WarrantyCard();
                wc.setId(rs.getInt("issueId"));
                wc.setStart_at(rs.getTimestamp("startAt"));
                wc.setEnd_at(rs.getTimestamp("endAt"));

                wc.setAssignedByName(rs.getString("assignedBy"));
                wc.setHandledByName(rs.getString("handledBy"));

                list.add(wc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
