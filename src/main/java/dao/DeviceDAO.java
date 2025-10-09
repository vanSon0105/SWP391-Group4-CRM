package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mysql.cj.x.protobuf.MysqlxPrepare.Execute;

import dal.DBContext;
import model.Device;

public class DeviceDAO extends DBContext {
	
	public boolean addDevice(Device d) {
        String sql = "INSERT INTO devices (category_id, name, price, unit, image_url, description, created_at) \"\r\n"
        		+ "                   + \"VALUES (?, ?, ?, ?, ?, ?, NOW()";
        try {
            PreparedStatement prs = connection.prepareStatement(sql);
            prs.setInt(1, d.getCategoryId());
            prs.setString(2, d.getName());
            prs.setBigDecimal(3, d.getPrice());
            prs.setString(4, d.getUnit());
            prs.setString(5, d.getImageUrl());
            prs.setString(6, d.getDesc());
            int n = prs.executeUpdate();
            return n > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateDeviceDetail(Device d) {
        String sql = "UPDATE devices\r\n"
        		+ "SET category_id = ?, name = ?, price = ?, unit = ?, image_url = ?, description = ?, updated_at = NOW()\r\n"
        		+ "WHERE id = ?;";
        try {
            PreparedStatement prs = connection.prepareStatement(sql);
            prs.setInt(1, d.getCategoryId());
            prs.setString(2, d.getName());
            prs.setBigDecimal(3, d.getPrice());
            prs.setString(4, d.getUnit());
            prs.setString(5, d.getImageUrl());
            prs.setString(6, d.getDesc());
            prs.setInt(8, d.getId());
            int n = prs.executeUpdate();
            return n > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean removeDeviceDetail(int id) {
        String sql = "DELETE FROM devices WHERE id= ?";
        try {
            Statement st = connection.createStatement();
            PreparedStatement prs = connection.prepareStatement(sql);
            prs.setInt(1, id);
            int n = st.executeUpdate(sql);
            return n > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


	public List<Device> getAllDevices() {
		List<Device> list = new ArrayList<>();
		String sql = "SELECT id, category_id, name, price, unit, image_url FROM devices";

		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql);
				ResultSet rs = pre.executeQuery()) {

			while (rs.next()) {
				list.add(new Device(rs.getInt("id"), rs.getInt("category_id"), rs.getString("name"),
						rs.getBigDecimal("price"), rs.getString("unit"), rs.getString("image_url")));
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
				list.add(new Device(rs.getInt("id"), rs.getInt("category_id"), rs.getString("name"),
						rs.getBigDecimal("price"), rs.getString("unit"), rs.getString("image_url")));
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}

		return list;
	}

	public static void main(String[] args) {
		DeviceDAO dao = new DeviceDAO();
		List<Device> devices = dao.getAllDevices();

		if (devices.isEmpty()) {
			System.out.println("Connection error");
		} else {
			for (Device d : devices) {
				System.out.println("ID: " + d.getId() + ", Name: " + d.getName() + ", Price: " + d.getPrice());
			}
		}
	}
}
