package dao;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mysql.cj.x.protobuf.MysqlxPrepare.Execute;

import dal.DBContext;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import model.Category;
import model.CustomerDeviceView;
import model.Device;
import model.DeviceSerial;

public class DeviceDAO extends DBContext {
	public List<Device> getRelatedDevicesWithOffset(int deviceId, int categoryId, int offset, int limit) {
	    List<Device> list = new ArrayList<>();
	    String sql = "SELECT * FROM devices WHERE category_id = ? AND id <> ? LIMIT ?, ?";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, categoryId);
	        ps.setInt(2, deviceId);
	        ps.setInt(3, offset);
	        ps.setInt(4, limit);

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
	    String sql = "SELECT * FROM devices WHERE id = ?;";
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
	                    rs.getBoolean("is_featured"),
	                    rs.getString("status"),
	                    rs.getInt("warrantyMonth")
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
	    String sql = "SELECT id, category_id, name, price, unit, image_url, description, created_at, is_featured FROM devices";

	    try (Connection conn = getConnection();
	         PreparedStatement pre = conn.prepareStatement(sql);
	         ResultSet rs = pre.executeQuery()) {

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

	    } catch (SQLException e) {
	        e.printStackTrace(); 
	    }

	    return list;
	}

	public List<Device> getFilteredDevices(Integer categoryId, Integer supplierId, String priceRange, String sortPrice,
			int offset, int limit, String keyword) {
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
		
		if (keyword != null && !keyword.trim().isEmpty()) {
	        sql += " AND d.name LIKE '%"+ keyword +"%' or d.description LIKE '%"+ keyword +"%' " ;
	    }
		
		if (sortPrice != null) {
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
		} else {
			sql += " order by d.id asc ";
		}

		sql += " LIMIT ? OFFSET ? ";

		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql);
				) {
			
			pre.setInt(1, limit);
			pre.setInt(2, offset);
			
			ResultSet rs = pre.executeQuery();
			while (rs.next()) {
				Category c = new Category();
				c.setId(rs.getInt("category_id"));
				list.add(new Device(rs.getInt("id"), c, rs.getString("name"), rs.getDouble("price"),
						rs.getString("unit"), rs.getString("image_url"), rs.getString("description"),
						rs.getTimestamp("created_at"), rs.getBoolean("is_featured")));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getFilteredDevicesCount(Integer categoryId, Integer supplierId, String priceRange, String keyword) {
		int count = 0;
		String sql = "select COUNT(distinct d.id) as total from devices d "
				+ "LEFT JOIN supplier_details sd on d.id = sd.device_id where 1 = 1 ";
		
		if(categoryId != null) {
			sql += " and d.category_id = " + categoryId + " ";
		}
		
		if(supplierId != null) {
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
		
		if (keyword != null && !keyword.trim().isEmpty()) {
	        sql += " AND d.name LIKE '%"+ keyword +"%' or d.description LIKE '%"+ keyword +"%' " ;
	    }
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery()){
			
			while(rs.next()) {
				count = rs.getInt("total");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return count;
	}
	
//	Device - Homepage
	public List<Device> getBestSellingDevicesList(int offset, int recordsEachPage) {
		List<Device> list = new ArrayList<>();   
        String sql = "SELECT d.id, d.name,d.price, d.description, d.image_url, SUM(od.quantity) AS total_sold FROM order_details od\r\n"
        		+ "JOIN devices d ON od.device_id = d.id\r\n"
        		+ "WHERE d.status = 'active'\r\n"
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
        		+ "WHERE (created_at >= NOW() - INTERVAL 7 DAY) AND status = 'active' \r\n"
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
        		+ "WHERE is_featured = ? AND status = 'active'\r\n"
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
                d.setImageUrl(rs.getString("image_url"));
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
	public List<Device> getDevicesByPage(String key, int offset, int recordsEachPage, int categoryId, String sortBy, String order) {
	    List<Device> list = new ArrayList<>();
	    String sql = "SELECT d.image_url, d.id, d.name, c.category_name, d.price, "
	            + "COALESCE(stock.quantity, 0) AS inventory, d.status "
	            + "FROM devices AS d "
	            + "JOIN categories AS c ON d.category_id = c.id "
	            + "LEFT JOIN ( "
	            + "     SELECT device_id, COUNT(id) AS quantity "
	            + "     FROM device_serials "
	            + "     WHERE stock_status = 'in_stock' "
	            + "     GROUP BY device_id "
	            + ") AS stock ON d.id = stock.device_id "
	            +"WHERE 1=1 ";
	    
	    if (key != null && !key.trim().isEmpty()) {
	    	sql += "AND (d.name LIKE ? OR CAST(d.id AS CHAR) LIKE ?)";
	    }
	    
	    if (categoryId > 0) {
	        sql += ("AND d.category_id = ? ");
	    }
	    
	    String sortColumn = "d.id";
        if ("price".equalsIgnoreCase(sortBy)) {
            sortColumn = "d.price";
        } else if ("name".equalsIgnoreCase(sortBy)) {
            sortColumn = "d.name";
        }
        
        String sortOrder = "ASC";
        if ("desc".equalsIgnoreCase(order)) {
            sortOrder = "DESC";
        }

	    sql += "ORDER BY " + sortColumn + " " + sortOrder + " LIMIT ?, ?;";

	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	    	int index = 1;
	        if (key != null && !key.trim().isEmpty()) {
	            String keyword = "%" + key + "%";
	            ps.setString(index++, keyword);
	            ps.setString(index++, keyword);
	        }
	        
	        if (categoryId > 0) {
	            ps.setInt(index++, categoryId);
	        }
	        
	        
	        
	        ps.setInt(index++, offset);
	        ps.setInt(index, recordsEachPage);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                Category c = new Category();
	                c.setName(rs.getString("category_name"));
	                Device d = new Device(
	                    rs.getInt("id"),
	                    c,
	                    rs.getString("name"),
	                    rs.getDouble("price"),
	                    rs.getString("image_url"),
	                    rs.getInt("inventory"),
	                    rs.getString("status")
	                );
	                list.add(d);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	
	public int getTotalDevices(String key, int categoryId, String sortBy, String order) {
	    String sql = "SELECT COUNT(*) FROM devices AS d WHERE 1=1 ";
	    
	    if (key != null && !key.trim().isEmpty()) {
	        sql += "AND (d.name LIKE ? OR CAST(d.id AS CHAR) LIKE ?)";
	    }
	    
	    if (categoryId > 0) {
	        sql += ("AND d.category_id = ? ");
	    }
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)){
	    	
	    	int index = 1;
	    	if (key != null && !key.trim().isEmpty()) {
	            String keyword = "%" + key + "%";
	            ps.setString(index++, keyword);
	            ps.setString(index++, keyword);
	        }
	    	
	    	if (categoryId > 0) {
	            ps.setInt(index++, categoryId);
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

	
	
	public Device getDeviceDetail(int id) {
	    String sql = "SELECT d.id, c.category_name, d.name, d.price, d.unit, d.description, d.image_url, d.created_at, d.is_featured, (SELECT COUNT(ds.id) FROM device_serials ds WHERE ds.device_id = d.id AND ds.status = 'in_stock') AS stock_quantity\r\n"
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
	                    rs.getString("unit"),
	                    rs.getString("image_url"),
	                    rs.getString("description"),
	                    rs.getTimestamp("created_at"),
	                    rs.getBoolean("is_featured"),
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
	    String sql = "UPDATE devices SET name = ?, category_id = ?, price = ?, unit = ?, description = ?, image_url=?, is_featured = ? WHERE id = ?;";
	    boolean update = false;
	    
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        
	        ps.setString(1, deviceUpdate.getName());
	        ps.setInt(2, deviceUpdate.getCategory().getId());
	        ps.setDouble(3, deviceUpdate.getPrice());
	        ps.setString(4, deviceUpdate.getUnit());
	        ps.setString(5, deviceUpdate.getDesc());
	        ps.setString(6, deviceUpdate.getImageUrl());
	        ps.setBoolean(7, deviceUpdate.getIsFeatured());
	        ps.setInt(8, deviceUpdate.getId());
	        
	        update = ps.executeUpdate() > 0;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return update;
	}
	
	public int insertDevice(Device device) {
        String sql = "INSERT INTO devices (name, category_id, price, unit, image_url, description, is_featured) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, device.getName());
            ps.setInt(2, device.getCategory().getId());
            ps.setDouble(3, device.getPrice());
            ps.setString(4, device.getUnit());
            ps.setString(5, device.getImageUrl());
            ps.setString(6, device.getDesc());
            ps.setBoolean(7, Boolean.TRUE.equals(device.getIsFeatured()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

	public boolean addDevice(Device device) {
        return insertDevice(device) > 0;
	}

    public boolean insertInventory(int deviceId, int storekeeperId, int quantity) {
        String sql = "INSERT INTO inventories (storekeeper_id, device_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, storekeeperId);
            ps.setInt(2, deviceId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
	
	public boolean checkExistByName(String name) {
		String sql = "SELECT 1 FROM devices WHERE LOWER(name) = LOWER(?) LIMIT 1";
		try (Connection c = getConnection();
			PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setString(1, name);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean deleteDevice(int id) {
	    String sql = "UPDATE devices SET status = 'discontinued' WHERE id = ?;";
	    
	    String sql1 = "UPDATE device_serials\r\n"
	    		+ "SET status = 'discontinued'\r\n"
	    		+ "WHERE device_id = ? AND (stock_status = 'in_stock' OR stock_status = 'out_stock') AND status = 'active';";

	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql);
	         PreparedStatement ps1 = connection.prepareStatement(sql1)) {
	        ps.setInt(1, id);
	        ps.executeUpdate();
	        ps1.setInt(1, id);
	        ps1.executeUpdate();
	        
	        return true;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public boolean activeDevice(int id) {
	    String sql = "UPDATE devices SET status = 'active' WHERE id = ?;";
	 
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setInt(1, id);        
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public List<Device> getBannerDevices(){
		List<Device> list = new ArrayList<Device>();
		String sql = "WITH BannerDevices AS (\r\n"
				+ "    SELECT \r\n"
				+ "        d.*, c.category_name,\r\n"
				+ "        ROW_NUMBER() OVER(\r\n"
				+ "            PARTITION BY d.category_id\r\n"
				+ "            ORDER BY d.id ASC \r\n"
				+ "        ) AS row_num\r\n"
				+ "    FROM devices d\r\n"
				+ "    JOIN categories c ON d.category_id = c.id\r\n"
				+ ")\r\n"
				+ "SELECT * FROM BannerDevices\r\n"
				+ "WHERE row_num = 1;";
		try (Connection connection = getConnection();
		     PreparedStatement ps = connection.prepareStatement(sql)) {
			 ResultSet rs = ps.executeQuery();
			 while (rs.next()) {
				Category c = new Category();
				c.setName(rs.getString("category_name"));
				Device d = new Device();
				d.setId(rs.getInt("id"));
				d.setCategory(c);
				d.setImageUrl(rs.getString("image_url"));
				d.setName(rs.getString("name"));
				d.setDesc(rs.getString("description"));
				d.setPrice(rs.getDouble("price"));
				d.setWarrantyMonth(rs.getInt("warrantyMonth"));
				list.add(d);
			}
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return list;
	}
	
	public String saveUploadFile(Part filePart, String targetFolder, ServletContext context) {
	    String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

	    if (originalFileName == null || originalFileName.isEmpty() || filePart.getSize() == 0) {
	        return "";
	    }

	    String finalName = System.currentTimeMillis() + "-" + originalFileName;
	    String deployRootPath = context.getRealPath("/assets/img");
	   
	    File deployDir = new File(deployRootPath + File.separator + targetFolder);
	    if (!deployDir.exists()) {
	        deployDir.mkdirs();
	    }
	    
	    String deployFullSavePath = deployDir.getAbsolutePath() + File.separator + finalName;
	    try {
	        filePart.write(deployFullSavePath);
	    } catch (IOException e) {
	        e.printStackTrace();
	        return "";
	    }


	    try {
	        String PROJECT_SOURCE_DIR = "D:\\Folder\\JavaProjects\\SWP391-Group4-CRM\\src\\main\\webapp";
	        
	        String sourceSaveDirStr = PROJECT_SOURCE_DIR + File.separator + "assets" + 
                    File.separator + "img" + File.separator + targetFolder;

	        File sourceSaveDir = new File(sourceSaveDirStr);
	        if (!sourceSaveDir.exists()) {
	            sourceSaveDir.mkdirs();
	        }

	        String sourceFullSavePath = sourceSaveDirStr + File.separator + finalName;

	        File deployFile = new File(deployFullSavePath);
	        File sourceFile = new File(sourceFullSavePath);
	        Files.copy(deployFile.toPath(), sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

	    } catch (Exception e) {
	        System.err.println("Lỗi khi copy file vào thư mục source: " + e.getMessage());
	        e.printStackTrace();
	    }

	    return finalName;
	}
	
	public boolean updateDevicePrice(int deviceId, double newPrice) {
	    String sql = "UPDATE devices SET price = ? WHERE id = ?";
	    try (Connection connection = getConnection();
	         PreparedStatement ps = connection.prepareStatement(sql)) {
	        ps.setDouble(1, newPrice);
	        ps.setInt(2, deviceId);
	        return ps.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public List<CustomerDeviceView> getDevicesByCustomerId(int customerId) {
	    List<CustomerDeviceView> list = new ArrayList<>();
	    String sql = """
	    	    SELECT 
	            u.id AS customer_id,
	            u.full_name AS customer_name,
	            u.email AS customer_email,
	            ds.id AS device_serial_id,
	            d.id AS device_id,
	            d.name AS device_name,
	            c.category_name AS category_name,
	            ds.serial_no AS serial_number,
	            d.price,
	            ds.stock_status AS status,
	            d.warrantyMonth,
	            wc.id AS warranty_card_id,
	            ci.id AS issue_id,
	            CASE WHEN wc.id IS NOT NULL THEN TRUE ELSE FALSE END AS hasWarranty,
	            CASE WHEN ci.id IS NOT NULL THEN TRUE ELSE FALSE END AS hasIssue
	        FROM users u
	        JOIN orders o ON o.customer_id = u.id
	        JOIN order_details od ON od.order_id = o.id
	        JOIN devices d ON od.device_id = d.id
	        JOIN categories c ON d.category_id = c.id
	        JOIN order_detail_serials ods ON ods.order_detail_id = od.id
	        JOIN device_serials ds ON ds.id = ods.device_serial_id
	        LEFT JOIN warranty_cards wc ON wc.device_serial_id = ds.id AND wc.customer_id = u.id
	        LEFT JOIN customer_issues ci ON ci.warranty_card_id = wc.id
	        WHERE u.id = ?
	    """;

	    try (Connection conn = DBContext.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, customerId);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            CustomerDeviceView device = new CustomerDeviceView();
	            device.setCustomerId(rs.getInt("customer_id"));
	            device.setCustomerName(rs.getString("customer_name"));
	            device.setCustomerEmail(rs.getString("customer_email"));
	            device.setDeviceId(rs.getInt("device_id"));
	            device.setDeviceName(rs.getString("device_name"));
	            device.setCategoryName(rs.getString("category_name"));
	            device.setSerialNumber(rs.getString("serial_number"));
	            device.setPrice(rs.getDouble("price"));
	            device.setStatus(rs.getString("status"));
	            device.setWarrantyMonth(rs.getInt("warrantyMonth"));
	            device.setHasWarranty(rs.getBoolean("hasWarranty"));
	            device.setHasIssue(rs.getBoolean("hasIssue"));
	            device.setWarrantyCardId(rs.getInt("warranty_card_id"));
	            device.setIssueId(rs.getInt("issue_id"));
	            list.add(device);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}



}
