package dao;

import java.sql.*;
import java.util.*;
import model.DeviceSerial;
import model.EnumModel.DeviceSerialEnum;

public class DeviceSerialDAO extends dal.DBContext {

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
                    ds.setStatus(DeviceSerialEnum.valueOf(rs.getString("status"))); 
                    ds.setImport_date(rs.getTimestamp("import_date"));
                    list.add(ds);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addSerial(DeviceSerial ds) {
        String sql = "INSERT INTO device_serials(device_id, serial_no, status, import_date) VALUES(?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ds.getDevice_id());
            ps.setString(2, ds.getSerial_no());
            ps.setString(3, ds.getStatus().name()); 
            ps.setTimestamp(4, ds.getImport_date());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int serialId, DeviceSerialEnum status) {
        String sql = "UPDATE device_serials SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, serialId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSerial(int serialId) {
        String sql = "DELETE FROM device_serials WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serialId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        DeviceSerialDAO dao = new DeviceSerialDAO();
        List<DeviceSerial> serials = dao.getSerialsByDeviceId(1);
        for (DeviceSerial ds : serials) {
            System.out.println(ds.getSerial_no() + " - " + ds.getStatus());
        }
    }
}
