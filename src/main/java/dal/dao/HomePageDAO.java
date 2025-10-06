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

public class HomePageDAO extends DBContext{
	public List<Device> listFeaturedDevices() {
		List<Device> list = new ArrayList<>();
        String sql = "SELECT \r\n"
        		+ "    d.id,\r\n"
        		+ "    d.name,\r\n"
        		+ "    d.price,\r\n"
        		+ "    dd.description,\r\n"
        		+ "    SUM(od.quantity) AS total_sold\r\n"
        		+ "FROM order_details od\r\n"
        		+ "JOIN devices d ON od.device_id = d.id\r\n"
        		+ "JOIN device_details dd ON dd.device_id = d.id \r\n"
        		+ "GROUP BY d.id, d.name, d.price, dd.description\r\n"
        		+ "ORDER BY total_sold DESC\r\n"
        		+ "LIMIT 10;";
        try {
        	connection = DBContext.getConnection();
            PreparedStatement pre = connection.prepareStatement(sql);
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
	
	public List<Device> listNewDevices() {
		List<Device> list = new ArrayList<>();
        String sql = "SELECT d.id, d.name, d.image_url, d.price, d.created_at, dd.description FROM devices d\r\n"
        		+ "JOIN device_details dd ON d.id = dd.device_id\r\n"
        		+ "WHERE created_at >= NOW() - INTERVAL 7 DAY \r\n"
        		+ "GROUP BY d.id, d.name, d.image_url, d.price, d.created_at, dd.description\r\n"
        		+ "ORDER BY created_at DESC;\r\n"
        		+ "";
        try {
        	connection = DBContext.getConnection();
            PreparedStatement pre = connection.prepareStatement(sql);
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
}
