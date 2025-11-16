package dao;

import java.sql.*;
import java.util.*;

import dal.DBContext;
import model.Inventory;

public class InventoryDAO extends DBContext {

    public Inventory getInventoryByDevice(int deviceId) {
        String sql = "SELECT * FROM inventories WHERE device_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Inventory inv = new Inventory();
                inv.setId(rs.getInt("id"));
                inv.setDeviceId(rs.getInt("device_id"));
                inv.setStorekeeperId(rs.getInt("storekeeper_id"));
                inv.setQuantity(rs.getInt("quantity"));
                return inv;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Inventory getInventoryByDeviceAndStorekeeper(int deviceId, int storekeeperId) {
        String sql = "SELECT * FROM inventories WHERE device_id = ? AND storekeeper_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setInt(2, storekeeperId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Inventory inv = new Inventory();
                inv.setId(rs.getInt("id"));
                inv.setDeviceId(rs.getInt("device_id"));
                inv.setStorekeeperId(rs.getInt("storekeeper_id"));
                inv.setQuantity(rs.getInt("quantity"));
                return inv;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addInventory(Inventory inv) {
        String sql = "INSERT INTO inventories (storekeeper_id, device_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inv.getStorekeeperId());
            ps.setInt(2, inv.getDeviceId());
            ps.setInt(3, inv.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void adjustQuantity(int deviceId, int storekeeperId, int change) {
        String sql = "UPDATE inventories SET quantity = quantity + ? WHERE device_id = ? AND storekeeper_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, change);
            ps.setInt(2, deviceId);
            ps.setInt(3, storekeeperId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public int getTotalStockByDevice(int deviceId) {
        String sql = "SELECT SUM(quantity) FROM inventories WHERE device_id = ?";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
