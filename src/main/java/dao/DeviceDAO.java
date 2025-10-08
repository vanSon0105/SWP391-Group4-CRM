package dao;

import java.sql.*;
import java.util.*;

import dal.DBContext;
import model.Device;

public class DeviceDAO extends DBContext {

    public List<Device> getAllDevices() {
        List<Device> list = new ArrayList<>();
        String sql = "SELECT id, category_id, name, price, unit, image_url, type FROM devices";

        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
            	list.add(new Device(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getBigDecimal("price"), 
                        rs.getString("unit"),
                        rs.getString("image_url"),
                        rs.getString("type")
                ));
            }

        } catch (SQLException e) {
            System.out.println("Error get all devices: " + e.getMessage());
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
                System.out.println("ID: " + d.getId() +
                        ", Name: " + d.getName() +
                        ", Price: " + d.getPrice() +
                        ", Type: " + d.getType());
            }
        }
    }
}


