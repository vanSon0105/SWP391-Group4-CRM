package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mysql.cj.x.protobuf.MysqlxPrepare.Execute;

import dal.DBContext;
import model.Category;
import model.Device;
import model.DeviceSerial;

public class DeviceDAO extends DBContext {
	
	public List<Device> getRelatedDevices(int deviceId, int categoryId, int limit) {
	    List<Device> list = new ArrayList<>();
	    String sql = "SELECT * FROM devices WHERE category_id = ? AND id <> ? LIMIT ?";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, categoryId);
	        ps.setInt(2, deviceId);
	        ps.setInt(3, limit);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	            	Category c = new Category();
	            	c.setId(rs.getInt("category_id"));
	                Device d = new Device(
	                    rs.getInt("id"),
	                    c,
	                    rs.getString("name"),
	                    rs.getDouble("price"),       
	                    rs.getString("unit"),
	                    rs.getString("image_url"),     
	                    rs.getString("description"),  
	                    rs.getTimestamp("created_at"),
	                    rs.getBoolean("is_featured")
	                );
	                list.add(d);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	public Device getDeviceById(int id) {
	    String sql = "SELECT id, category_id, name, price, unit, image_url, description, created_at, is_featured FROM devices WHERE id = ?;";
	    try (Connection conn = getConnection();
	         PreparedStatement pre = conn.prepareStatement(sql)) {
	        pre.setInt(1, id);
	        try (ResultSet rs = pre.executeQuery()) {
	            if (rs.next()) {
	            	Category c = new Category();
	            	c.setId(rs.getInt("category_id"));
	            	
	                return new Device(
	                    rs.getInt("id"),
	                    c,
	                    rs.getString("name"),
	                    rs.getDouble("price"),
	                    rs.getString("unit"),
	                    rs.getString("image_url"),
	                    rs.getString("description"),
	                    rs.getTimestamp("created_at"),
	                    rs.getBoolean("is_featured")
	                );
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();  
	    }
	    return null;  
	}

	public List<Device> getAllDevices() {
		List<Device> list = new ArrayList<>();
		String sql = "SELECT id, category_id, name, price, unit, image_url FROM devices";

		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql);
				ResultSet rs = pre.executeQuery()) {

			while (rs.next()) {
				Category c = new Category();
            	c.setId(rs.getInt("category_id"));
				list.add(new Device(rs.getInt("id"), c, rs.getString("name"),
						rs.getDouble("price"), rs.getString("unit"), rs.getString("image_url"),rs.getString("desciption"),rs.getTimestamp("created_at"), rs.getBoolean("is_featured")));
			}

		} catch (SQLException e) {
			System.out.println("Error get all devices: " + e.getMessage());
		}

		return list;
	}

	public List<Device> getFilteredDevices(Integer categoryId, Integer supplierId, String priceRange, String sortPrice) {
		List<Device> list = new ArrayList<>();
		String sql = "select distinct d.* from devices d "
				+ "left join supplier_details sd on d.id = sd.device_id where 1 = 1 ";

		if (categoryId != null) {
			sql += " and d.category_id = " + categoryId + " ";
		}

		if (supplierId != null) {
			sql += " and sd.supplier_id = " + supplierId + " ";
		}

		if (priceRange != null) {
			switch (priceRange) {
			case "under5":
				sql += " and d.price < 5000000 ";
				break;
			case "5to15":
				sql += " and d.price between 5000000 and 15000000 ";
				break;

			case "15to30":
				sql += " and d.price between 15000000 and 30000000 ";
				break;
			case "over30":
				sql += " and d.price > 30000000 ";
				break;
			default:
				break;
			
			}
		}
		
		if(sortPrice != null) {
			switch (sortPrice) {
			case "asc":
				sql += " order by d.price asc ";
				break;
			case "desc":
				sql += " order by d.price desc ";
				break;
			default:
				break;
			}
		}
		
		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql);
				ResultSet rs = pre.executeQuery()){
			while(rs.next()) {
				Category c = new Category();
            	c.setId(rs.getInt("category_id"));
				list.add(new Device(rs.getInt("id"), c, rs.getString("name"),
						rs.getDouble("price"), rs.getString("unit"), rs.getString("image_url"),rs.getString("description"),rs.getTimestamp("created_at"), rs.getBoolean("is_featured")));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
//	Device - Homepage
	public List<Device> getBestSellingDevicesList(int offset, int recordsEachPage) {
		List<Device> list = new ArrayList<>();   
        String sql = "SELECT d.id, d.name,d.price, d.description, d.image_url, SUM(od.quantity) AS total_sold FROM order_details od\r\n"
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
                d.setPrice(rs.getDouble("price"));
                d.setDesc(rs.getString("description"));
                d.setImageUrl(rs.getString("image_url"));
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
	
	
	public int getTotalBestSellingDevices() {
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
                d.setPrice(rs.getDouble("price"));
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
	    String sql = "SELECT COUNT(id) FROM devices\r\n"
	    		+ "WHERE created_at >= NOW() - INTERVAL 7 DAY;";
	    try (
	    	 Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) count = rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	} 
	
	public List<Device> searchDevice(String key){
		List<Device> list = new ArrayList<>();
		String sql = "SELECT * FROM devices\r\n"
				+ "WHERE name LIKE ? OR description LIKE ?";
		try {
			Connection conn = DBContext.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "%" + key + "%");
			ps.setString(2, "%" + key + "%");
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				Category c = new Category();
				c.setId(rs.getInt("category_id"));
				
				Device d = new Device();
				d.setId(rs.getInt("id"));
				d.setCategory(c);
	            d.setName(rs.getString("name"));
	            d.setPrice(rs.getDouble("price"));
	            d.setName(rs.getString("name"));
	            d.setImageUrl(rs.getString("image_url"));
	            d.setDesc(rs.getString("description"));
	            d.setCreated_at(rs.getTimestamp("created_at"));
	            list.add(d);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Device> getFeaturedDevicesList(int offset, int recordsEachPage) {
		List<Device> list = new ArrayList<>();   
        String sql = "SELECT id, name, price, image_url, description\r\n"
        		+ "FROM devices\r\n"
        		+ "WHERE is_featured = ?\r\n"
        		+ "LIMIT ?, ?;";
        try {
        	connection = DBContext.getConnection();
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setBoolean(1, true);
            pre.setInt(2, offset);
            pre.setInt(3, recordsEachPage);
            ResultSet rs = pre.executeQuery();
            while(rs.next()) {
            	Device d = new Device();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setPrice(rs.getDouble("price"));
                d.setDesc(rs.getString("image_url"));
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
	
	
	public int getTotalFeaturedDevices() {
	    int count = 0;
	    String sql = "SELECT COUNT(id)\r\n"
	    		+ "FROM devices\r\n"
	    		+ "WHERE is_featured = TRUE;";
	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) count = rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	}
	
//	Device - Admin
	public List<Device> findAllDevices() {
		List<Device> list = new ArrayList<>();
		String sql = "SELECT d.image_url, d.id, d.name, c.category_name, d.price, COALESCE(stock.quantity, 0) AS 'inventory', d.status\r\n"
				+ "FROM devices AS d\r\n"
				+ "JOIN categories AS c ON d.category_id = c.id\r\n"
				+ "LEFT JOIN\r\n"
				+ "    (SELECT device_id, COUNT(id) AS quantity\r\n"
				+ "     FROM  device_serials\r\n"
				+ "     WHERE status = 'in_stock'\r\n"
				+ "     GROUP BY device_id	\r\n"
				+ "    ) AS stock ON d.id = stock.device_id;";

		try (Connection connection = getConnection();
				PreparedStatement pre = connection.prepareStatement(sql);
				ResultSet rs = pre.executeQuery()) {

			while (rs.next()) {
				Category c = new Category();
            	c.setName(rs.getString("category_name"));
				list.add(new Device(rs.getInt("id"), c, rs.getString("name"),
						rs.getDouble("price"), rs.getString("image_url"),rs.getInt("inventory"),rs.getString("status")));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}

		return list;
	}
	
	public List<DeviceSerial> getAllDeviceSerials(int id){
		List<DeviceSerial> list = new ArrayList<DeviceSerial>();
		String sql = "\r\n"
				+ "SELECT id, serial_no, status, import_date \r\n"
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
				ds.setStatus(rs.getString("status"));
				ds.setImport_date(rs.getTimestamp("import_date"));
				list.add(ds);
			}
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		return list;
	}
	
	public Device getDeviceDetail(int id) {
	    String sql = "SELECT d.id, d.name, c.category_name, d.price, d.unit, d.description, d.created_at, d.image_url, (SELECT COUNT(ds.id) FROM device_serials ds WHERE ds.device_id = d.id AND ds.status = 'in_stock') AS stock_quantity\r\n"
	    		+ "FROM devices AS d\r\n"
	    		+ "JOIN categories AS c ON d.category_id = c.id\r\n"
	    		+ "WHERE d.id = ?;";
	    try (Connection connection = getConnection();
	         PreparedStatement pre = connection.prepareStatement(sql)) {
	        pre.setInt(1, id);
	        try (ResultSet rs = pre.executeQuery()) {
	            if (rs.next()) {
	            	Category c = new Category();
	            	c.setName(rs.getString("category_name"));
	            	
	                return new Device(
	                    rs.getInt("id"),
	                    c,
	                    rs.getString("name"),
	                    rs.getDouble("price"),
	                    rs.getString("image_url"),
	                    rs.getString("unit"),
	                    rs.getString("description"),
	                    rs.getTimestamp("created_at"),
	                    rs.getInt("stock_quantity")
	                );
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();  
	    }
	    return null;  
	}
	
	public boolean updateDevice(Device deviceUpdate) {
	    String sql = "UPDATE devices SET name = ?, category_id = ?, price = ?, unit = ?, description = ?, image_url=? WHERE id = ?;";
	    boolean update = false;
	    
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        
	        ps.setString(1, deviceUpdate.getName());
	        ps.setInt(2, deviceUpdate.getCategory().getId());
	        ps.setDouble(3, deviceUpdate.getPrice());
	        ps.setString(4, deviceUpdate.getUnit());
	        ps.setString(5, deviceUpdate.getDesc());
	        ps.setString(6, deviceUpdate.getImageUrl());
	        ps.setInt(7, deviceUpdate.getId());
	        
	        update = ps.executeUpdate() > 0;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return update;
	}
	
	public boolean addDevice(Device device) {
		String sql = "INSERT INTO devices (name, category_id, price, unit, image_url, description, is_featured) VALUES (?, ?, ?, ?, ?, ?, ?);";
	    boolean add = false;
	    
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        ps.setString(1, device.getName());
	        ps.setInt(2, device.getCategory().getId());
	        ps.setDouble(3, device.getPrice());
	        ps.setString(4, device.getUnit());
	        ps.setString(5, device.getImageUrl());
	        ps.setString(6, device.getDesc());
	        ps.setBoolean(7, device.isIs_featured());
	        
	        add = ps.executeUpdate() > 0;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return add;
	}
	
	public boolean deleteDevice(int id) {
	    String sql = "UPDATE devices SET status = 'discontinued' WHERE id = ?;";
	    boolean updated = false;

	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        updated = ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return updated;
	}

}
