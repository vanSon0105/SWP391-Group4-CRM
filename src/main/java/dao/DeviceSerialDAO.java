package dao;

import java.sql.*;

import java.util.*;
import model.DeviceSerial;


public class DeviceSerialDAO extends dal.DBContext {
	
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

    public boolean addSerial(DeviceSerial ds) {
        String sql = "INSERT INTO device_serials(device_id, serial_no, status, import_date) VALUES(?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ds.getDevice_id());
            ps.setString(2, ds.getSerial_no());
            ps.setString(3, ds.getStatus()); 
            ps.setTimestamp(4, ds.getImport_date());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
        String sql = "UPDATE device_serials SET stock_status = ? WHERE id = ?;";
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
    
}
