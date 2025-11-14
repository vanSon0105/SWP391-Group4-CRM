package dao;

import java.security.SecureRandom;
import java.sql.*;

import java.util.*;

import model.Category;
import model.Device;
import model.DeviceSerial;
import model.DeviceSerialLookup;


public class DeviceSerialDAO extends dal.DBContext {
	private final DeviceDAO deviceDAO = new DeviceDAO();
	private SecureRandom secureRandom = new java.security.SecureRandom();
	
	public List<DeviceSerial> getAllDeviceSerials(int id){
		List<DeviceSerial> list = new ArrayList<DeviceSerial>();
		String sql = "\r\n"
				+ "SELECT * \r\n"
				+ "FROM device_serials \r\n"
				+ "WHERE device_id = ?;";
		try {
			Connection connection = getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				DeviceSerial ds = new DeviceSerial();
				ds.setId(rs.getInt("id"));
				ds.setSerial_no(rs.getString("serial_no"));
				ds.setStock_status(rs.getString("stock_status")); 
				ds.setStatus(rs.getString("status"));
				ds.setImport_date(rs.getTimestamp("import_date"));
				list.add(ds);
			}
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return list;
	}

    public List<DeviceSerial> getSerialsByDeviceId(int deviceId) {
        List<DeviceSerial> list = new ArrayList<>();
        String sql = "SELECT * FROM device_serials WHERE device_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DeviceSerial ds = new DeviceSerial();
                    ds.setId(rs.getInt("id"));
                    ds.setDevice_id(rs.getInt("device_id"));
                    ds.setSerial_no(rs.getString("serial_no"));
                    ds.setStock_status(rs.getString("stock_status")); 
                    ds.setImport_date(rs.getTimestamp("import_date"));
                    ds.setStatus(rs.getString("status")); 
                    list.add(ds);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public DeviceSerial getDeviceSerial(int id) {
    	DeviceSerial ds = new DeviceSerial();
    	String sql = "SELECT * FROM device_serials WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);;
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ds.setId(rs.getInt("id"));
                    ds.setDevice_id(rs.getInt("device_id"));
                    ds.setSerial_no(rs.getString("serial_no"));
                    ds.setStatus(rs.getString("status")); 
                    ds.setImport_date(rs.getTimestamp("import_date"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ds;
    }


    public boolean updateStatus(int serialId, String status) {
        String sql = "UPDATE device_serials SET stock_status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, serialId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean statusSerial(int id, String mess) {
        String sql = "UPDATE device_serials SET status = ? WHERE id = ?;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        	ps.setString(1, mess);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public DeviceSerial getInStockSerialId(int deviceId) {
    	String sql = "select * from device_serials where device_id = ? and stock_status = 'in_stock' limit 1";
    	
    	try (Connection conn = getConnection();
    		 PreparedStatement pre = conn.prepareStatement(sql)){
    		pre.setInt(1, deviceId);
    		ResultSet rs = pre.executeQuery();
    		
    		if(rs.next()) {
    			return new DeviceSerial(
    					rs.getInt("id"),
    					rs.getInt("device_id"),
    					rs.getString("serial_no"),
    					rs.getString("stock_status"),
    					rs.getTimestamp("import_date"),
    					rs.getString("status")
    					);
    		}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return null;
    }
    
    public String getDeviceSerialByWarrantyId(int warrantyCardId) {
		String sql = "SELECT ds.serial_no FROM warranty_cards wc "
				+ "JOIN device_serials ds ON wc.device_serial_id = ds.id WHERE wc.id = ?";
		try (Connection conn = getConnection(); 
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, warrantyCardId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getString("serial_no");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
    
    public boolean insertDeviceSerials(Device d, int quantity) {
        String sql = "INSERT INTO device_serials (device_id, serial_no, import_date) VALUES (?, ?, NOW())";
        String prefix = generatePrefix(d.getName());

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                int generatedCount = 0;

                while (generatedCount < quantity) {
                    String serial = generateRandomSerial(prefix, d.getId());
                    if (checkSerialExists(serial, conn)) {
                        continue;
                    }
                    ps.setInt(1, d.getId());
                    ps.setString(2, serial);
                    ps.addBatch();
                    generatedCount++;
                }

                ps.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateRandomSerial(String prefix, int deviceId) {
        int rand1 = secureRandom.nextInt(1000000); 
        int rand2 = secureRandom.nextInt(1000000); 

        return String.format("%s-%d-%06d-%06d",
                prefix, deviceId, rand1, rand2);
    }


    private boolean checkSerialExists(String serial, Connection conn) throws SQLException {
        String checkSql = "SELECT 1 FROM device_serials WHERE serial_no = ? LIMIT 1";
        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, serial);
            try (ResultSet rs = checkPs.executeQuery()) {
                return rs.next();
            }
        }
    }

    private String generatePrefix(String deviceName) {
        if (deviceName == null || deviceName.isBlank()) {
            return "UNKNOWN";
        }
        String[] parts = deviceName.trim().split("\\s+");
        String prefix = parts[0].toUpperCase().replaceAll("[^A-Z0-9]", "");
        return prefix;
    }
    
    public int getTotalDeviceSerials(int id, String key, String sortBy, String order) {
	    String sql = "SELECT COUNT(*) FROM device_serials WHERE device_id = ? ";
	    
	    if (key != null && !key.trim().isEmpty()) {
	        sql += "AND (serial_no LIKE ? OR CAST(id AS CHAR) LIKE ?)";
	    }
	    
	    if ("status".equalsIgnoreCase(sortBy)) {
	        sql += " AND status = ? ";
	    }
	    
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)){
	    	
	    	int index = 1;
	    	ps.setInt(index++, id);
	    	if (key != null && !key.trim().isEmpty()) {
	            String keyword = "%" + key + "%";
	            ps.setString(index++, keyword);
	            ps.setString(index++, keyword);
	        }
	    	
	    	if ("status".equalsIgnoreCase(sortBy)) {
	            ps.setString(index++, order);
	        }
	    	
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
    
    public List<DeviceSerial> getDeviceSerialsByPage(int id, String key, int offset, int recordsEachPage, String sortBy, String order) {
	    List<DeviceSerial> list = new ArrayList<>();
	    String sql = "SELECT * FROM device_serials WHERE device_id = ? ";
	    
    	if (key != null && !key.trim().isEmpty()) {
    		sql += "AND (serial_no LIKE ? OR CAST(id AS CHAR) LIKE ?)";
    	}
    	
    	if("status".equalsIgnoreCase(sortBy)) {
    		sql += "AND status = ? ";
    	}
    	
    	String sortColumn = "id";
    	String sortOrder = "ASC";
    	
    	if ("status".equalsIgnoreCase(sortBy)) {
            sortColumn = "id";
            sortOrder = "ASC";
        } else {
            if ("serial_no".equalsIgnoreCase(sortBy)) {
                sortColumn = "serial_no";
            } else if ("import_date".equalsIgnoreCase(sortBy)) {
                sortColumn = "import_date";
            }
            if ("desc".equalsIgnoreCase(order)) {
                sortOrder = "DESC";
            }
        }
    	sql += "ORDER BY " + sortColumn + " " + sortOrder + " LIMIT ?, ?;";

	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	    	int index = 1;
	    	ps.setInt(index++, id);
	    	
	    	if (key != null && !key.trim().isEmpty()) {
    			String keyword = "%" + key + "%";
    			ps.setString(index++, keyword);
    			ps.setString(index++, keyword);
    		}
	    	
	    	if("status".equalsIgnoreCase(sortBy)) {
	    		ps.setString(index++, order);
	    	}    		
	    		
	        ps.setInt(index++, offset);
	        ps.setInt(index++, recordsEachPage);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	               DeviceSerial ds = new DeviceSerial();
	               ds.setId(rs.getInt("id"));
	               ds.setDevice_id(rs.getInt("device_id"));
	               ds.setImport_date(rs.getTimestamp("import_date"));
	               ds.setSerial_no(rs.getString("serial_no"));
	               ds.setStatus(rs.getString("status"));
	               ds.setStock_status(rs.getString("stock_status"));
	               list.add(ds);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
    
    public int countAvailableSerials(int deviceId) {
        String sql = "SELECT COUNT(*) FROM device_serials WHERE device_id = ? AND stock_status = 'in_stock'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<DeviceSerialLookup> searchSerialLookups(String keyword, int offset, int limit) {
        List<DeviceSerialLookup> results = new ArrayList<>();
        String trimmed = (keyword != null) ? keyword.trim() : null;
        boolean hasKeyword = trimmed != null && !trimmed.isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
           .append("ds.id AS serial_id, ds.serial_no, ds.stock_status, ds.status AS serial_status, ds.import_date, ")
           .append("d.id AS device_id, d.name AS device_name, c.category_name, d.price, d.warrantyMonth, ")
           .append("o.id AS order_id, o.status AS order_status, o.date AS order_date, ")
           .append("u.id AS customer_id, u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone, ")
           .append("wc.id AS warranty_card_id, wc.start_at AS warranty_start_at, wc.end_at AS warranty_end_at, ")
           .append("wc.is_cancelled AS warranty_cancelled ")
           .append("FROM device_serials ds ")
           .append("JOIN devices d ON ds.device_id = d.id ")
           .append("LEFT JOIN categories c ON d.category_id = c.id ")
           .append("LEFT JOIN order_detail_serials ods ON ods.device_serial_id = ds.id ")
           .append("LEFT JOIN order_details od ON ods.order_detail_id = od.id ")
           .append("LEFT JOIN orders o ON od.order_id = o.id ")
           .append("LEFT JOIN users u ON o.customer_id = u.id ")
           .append("LEFT JOIN warranty_cards wc ON wc.device_serial_id = ds.id ")
           .append("WHERE 1 = 1 ");

        if (hasKeyword) {
            sql.append("AND (ds.serial_no LIKE ? OR d.name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?) ");
        }

        sql.append("ORDER BY ds.import_date DESC, ds.id DESC LIMIT ?, ?;");

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword) {
                String likeKeyword = "%" + trimmed + "%";
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DeviceSerialLookup lookup = new DeviceSerialLookup();
                    lookup.setSerialId(rs.getInt("serial_id"));
                    lookup.setSerialNo(rs.getString("serial_no"));
                    lookup.setStockStatus(rs.getString("stock_status"));
                    lookup.setSerialStatus(rs.getString("serial_status"));
                    lookup.setImportDate(rs.getTimestamp("import_date"));

                    lookup.setDeviceId(rs.getInt("device_id"));
                    lookup.setDeviceName(rs.getString("device_name"));
                    lookup.setCategoryName(rs.getString("category_name"));
                    lookup.setDevicePrice(rs.getBigDecimal("price"));
                    Object monthObj = rs.getObject("warrantyMonth");
                    if (monthObj != null) {
                        lookup.setWarrantyMonth(rs.getInt("warrantyMonth"));
                    }

                    Object orderIdObj = rs.getObject("order_id");
                    if (orderIdObj != null) {
                        lookup.setOrderId(rs.getInt("order_id"));
                    }
                    lookup.setOrderStatus(rs.getString("order_status"));
                    lookup.setOrderDate(rs.getTimestamp("order_date"));

                    Object customerIdObj = rs.getObject("customer_id");
                    if (customerIdObj != null) {
                        lookup.setCustomerId(rs.getInt("customer_id"));
                    }
                    lookup.setCustomerName(rs.getString("customer_name"));
                    lookup.setCustomerEmail(rs.getString("customer_email"));
                    lookup.setCustomerPhone(rs.getString("customer_phone"));

                    Object warrantyIdObj = rs.getObject("warranty_card_id");
                    if (warrantyIdObj != null) {
                        lookup.setWarrantyCardId(rs.getInt("warranty_card_id"));
                    }
                    lookup.setWarrantyStartAt(rs.getTimestamp("warranty_start_at"));
                    lookup.setWarrantyEndAt(rs.getTimestamp("warranty_end_at"));
                    Object cancelledObj = rs.getObject("warranty_cancelled");
                    if (cancelledObj != null) {
                        lookup.setWarrantyCancelled(rs.getBoolean("warranty_cancelled"));
                    }

                    results.add(lookup);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return results;
    }

    public int countSerialLookups(String keyword) {
        String trimmed = (keyword != null) ? keyword.trim() : null;
        boolean hasKeyword = trimmed != null && !trimmed.isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM device_serials ds ")
           .append("JOIN devices d ON ds.device_id = d.id ")
           .append("LEFT JOIN order_detail_serials ods ON ods.device_serial_id = ds.id ")
           .append("LEFT JOIN order_details od ON ods.order_detail_id = od.id ")
           .append("LEFT JOIN orders o ON od.order_id = o.id ")
           .append("LEFT JOIN users u ON o.customer_id = u.id ")
           .append("WHERE 1 = 1 ");

        if (hasKeyword) {
            sql.append("AND (ds.serial_no LIKE ? OR d.name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?)");
        }

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword) {
                String likeKeyword = "%" + trimmed + "%";
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
                ps.setString(idx++, likeKeyword);
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
    
}
