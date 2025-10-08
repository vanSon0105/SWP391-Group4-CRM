package dal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dal.DBContext;
import model.Device;
import model.DeviceDetail;

public class DeviceDAO extends DBContext{
	public List<Device> getFeaturedDevicesList(int offset, int recordsEachPage) {
		List<Device> list = new ArrayList<>();   
        String sql = "SELECT d.id, d.name,d.price, d.description, SUM(od.quantity) AS total_sold FROM order_details od\r\n"
        		+ "JOIN devices d ON od.device_id = d.id\r\n"
        		+ "GROUP BY d.id, d.name, d.price, d.description\r\n"
        		+ "ORDER BY total_sold DESC\r\n"
        		+ "LIMIT ?, ?;";
        try {
        	connection = DBContext.getConnection();
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, offset);
            pre.setInt(2, recordsEachPage);
            ResultSet rs = pre.executeQuery();
            while(rs.next()) {
            	Device d = new Device();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setDesc(rs.getString("description"));
                d.setTotal_sold(rs.getInt("total_sold"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();;
        }finally {
        	closeConnection();
        }
        return list;
    }
	
	
	public int getTotalFeaturedDevices() {
	    int count = 0;
	    String sql = "SELECT COUNT(DISTINCT d.id) " +
	                 "FROM order_details od " +
	                 "JOIN devices d ON od.device_id = d.id ";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) count = rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	}
	
	public List<Device> getNewDevicesList(int offset, int recordsEachPage) {
		List<Device> list = new ArrayList<>();
		String sql = "SELECT id, name, image_url, price, created_at, description FROM devices\r\n"
        		+ "WHERE created_at >= NOW() - INTERVAL 7 DAY \r\n"
        		+ "ORDER BY created_at DESC\r\n"
        		+ "LIMIT ?, ?;";
       
        try {
        	connection = DBContext.getConnection();
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, offset);
            pre.setInt(2, recordsEachPage);
            ResultSet rs = pre.executeQuery();
            while(rs.next()) {
            	Device d = new Device();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setImageUrl(rs.getString("image_url"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setCreated_at(rs.getTimestamp("created_at"));
                d.setDesc(rs.getString("description"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();;
        }finally {
        	closeConnection();
        }
        return list;
    }
	
	public int getTotalNewDevices() {
	    int count = 0;
	    String sql = "SELECT COUNT(DISTINCT id) FROM devices\r\n"
	    		+ "WHERE created_at >= NOW() - INTERVAL 7 DAY;";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) count = rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	}
	
}
