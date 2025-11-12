package dao;

import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dal.DBContext;
import model.WarrantyCard;

public class WarrantyCardDAO extends DBContext{
	private DeviceSerialDAO dsDao = new DeviceSerialDAO();
	private DeviceDAO deviceDao = new DeviceDAO();
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

	public List<WarrantyCard> getExpiringSoonByCustomerId(int customerId, int days) {
		List<WarrantyCard> list = new ArrayList<>();
		String sql = "SELECT * FROM warranty_cards WHERE customer_id = ? AND end_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) ORDER BY end_at ASC";
		try (Connection conn = DBContext.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ps.setInt(2, days);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				int id = rs.getInt("id");
				int deviceSerialId = rs.getInt("device_serial_id");
				int custId = rs.getInt("customer_id");
				java.sql.Timestamp start = rs.getTimestamp("start_at");
				java.sql.Timestamp end = rs.getTimestamp("end_at");
				WarrantyCard wc = new WarrantyCard(id, deviceSerialId, custId, start, end);

				try {
					model.DeviceSerial ds = dsDao.getDeviceSerial(deviceSerialId);
					wc.setDevice_serial(ds);
					if (ds != null && ds.getDevice_id() > 0) {
						model.Device device = deviceDao.getDeviceById(ds.getDevice_id());
						wc.setDevice(device);
					}
				} catch (Exception ex) {
				}
				list.add(wc);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<WarrantyCard> searchWarranties(int customerId, int days, String searchKeyword) {
		List<WarrantyCard> list = new ArrayList<>();
		String sql = "SELECT wc.* FROM warranty_cards wc " +
					 "LEFT JOIN device_serials ds ON wc.device_serial_id = ds.id " +
					 "LEFT JOIN devices d ON ds.device_id = d.id " +
					 "WHERE wc.customer_id = ? " +
					 "AND wc.end_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) " +
					 "AND (d.name LIKE ? OR ds.serial_no LIKE ?) " +
					 "ORDER BY wc.end_at ASC";
		
		try (Connection conn = DBContext.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			String keyword = "%" + searchKeyword.trim() + "%";
			ps.setInt(1, customerId);
			ps.setInt(2, days);
			ps.setString(3, keyword);
			ps.setString(4, keyword);
			
			ResultSet rs = ps.executeQuery();
			list = populateWarrantyList(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<WarrantyCard> filterWarranties(int customerId, int days, String sortBy, String sortOrder) {
		List<WarrantyCard> list = new ArrayList<>();
		
		String orderByClause = "ORDER BY wc.end_at ASC";
		if ("name".equalsIgnoreCase(sortBy)) {
			orderByClause = "ORDER BY d.name " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
		} else if ("serial".equalsIgnoreCase(sortBy)) {
			orderByClause = "ORDER BY ds.serial_no " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
		} else if ("endDate".equalsIgnoreCase(sortBy)) {
			orderByClause = "ORDER BY wc.end_at " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
		}
		
		String sql = "SELECT wc.* FROM warranty_cards wc " +
					 "LEFT JOIN device_serials ds ON wc.device_serial_id = ds.id " +
					 "LEFT JOIN devices d ON ds.device_id = d.id " +
					 "WHERE wc.customer_id = ? " +
					 "AND wc.end_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) " +
					 orderByClause;
		
		try (Connection conn = DBContext.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, customerId);
			ps.setInt(2, days);
			
			ResultSet rs = ps.executeQuery();
			list = populateWarrantyList(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<WarrantyCard> getFilteredWarrantiesPaged(int customerId, int days, String searchKeyword, String sortBy, String sortOrder, int offset, int limit) {
        List<WarrantyCard> list = new ArrayList<>();

        String orderBy = "wc.end_at ASC";
        if ("name".equalsIgnoreCase(sortBy)) {
            orderBy = "d.name " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        } else if ("serial".equalsIgnoreCase(sortBy)) {
            orderBy = "ds.serial_no " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        } else if ("endDate".equalsIgnoreCase(sortBy)) {
            orderBy = "wc.end_at " + ("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        }

        String sql = "SELECT wc.* FROM warranty_cards wc " +
                     "LEFT JOIN device_serials ds ON wc.device_serial_id = ds.id " +
                     "LEFT JOIN devices d ON ds.device_id = d.id " +
                     "WHERE wc.customer_id = ? ";

        boolean useDays = days > 0;
        if (useDays) {
            sql += "AND wc.end_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) ";
        }

        boolean useSearch = searchKeyword != null && !searchKeyword.trim().isEmpty();
        if (useSearch) {
            sql += "AND (d.name LIKE ? OR ds.serial_no LIKE ?) ";
        }

        sql += "ORDER BY " + orderBy + " LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, customerId);
            if (useDays) ps.setInt(idx++, days);
            if (useSearch) {
                String keyword = "%" + searchKeyword.trim() + "%";
                ps.setString(idx++, keyword);
                ps.setString(idx++, keyword);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx++, offset);

            ResultSet rs = ps.executeQuery();
            list = populateWarrantyList(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

	public int countFilteredWarranties(int customerId, int days, String searchKeyword) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM warranty_cards wc " +
                     "LEFT JOIN device_serials ds ON wc.device_serial_id = ds.id " +
                     "LEFT JOIN devices d ON ds.device_id = d.id " +
                     "WHERE wc.customer_id = ? ";

        boolean useDays = days > 0;
        if (useDays) {
            sql += "AND wc.end_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) ";
        }

        boolean useSearch = searchKeyword != null && !searchKeyword.trim().isEmpty();
        if (useSearch) {
            sql += "AND (d.name LIKE ? OR ds.serial_no LIKE ?) ";
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, customerId);
            if (useDays) ps.setInt(idx++, days);
            if (useSearch) {
                String keyword = "%" + searchKeyword.trim() + "%";
                ps.setString(idx++, keyword);
                ps.setString(idx++, keyword);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

	private List<WarrantyCard> populateWarrantyList(ResultSet rs) throws SQLException {
        List<WarrantyCard> list = new ArrayList<>();
        while (rs.next()) {
            int id = rs.getInt("id");
            int deviceSerialId = rs.getInt("device_serial_id");
            int custId = rs.getInt("customer_id");
            Timestamp start = rs.getTimestamp("start_at");
            Timestamp end = rs.getTimestamp("end_at");
            WarrantyCard wc = new WarrantyCard(id, deviceSerialId, custId, start, end);

            try {
                model.DeviceSerial ds = dsDao.getDeviceSerial(deviceSerialId);
                wc.setDevice_serial(ds);
                if (ds != null && ds.getDevice_id() > 0) {
                    model.Device device = deviceDao.getDeviceById(ds.getDevice_id());
                    wc.setDevice(device);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            list.add(wc);
        }
        return list;
    }

}
