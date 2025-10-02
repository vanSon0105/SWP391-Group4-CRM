package dao;
import model.DeviceDetail;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
public class DeviceDetailDAO extends DBConnect {
	 public int addDeviceDetail(DeviceDetail d) {
	        int n = 0;
	        String sql = "INSERT INTO DeviceDetail(inventoryId, deviceId, description, serialNo, status) "
	                   + "VALUES(?,?,?,?,?)";
	        try {
	            PreparedStatement pre = conn.prepareStatement(sql);
	            pre.setInt(1, d.getInventoryId());
	            pre.setInt(2, d.getDeviceId());
	            pre.setString(3, d.getDescription());
	            pre.setString(4, d.getSerialNo());
	            pre.setString(5, d.getStatus());
	            n = pre.executeUpdate();
	        } catch (SQLException ex) {
	            Logger.getLogger(DeviceDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }
	        return n;
	    }

	    // cập nhật
	    public int updateDeviceDetail(DeviceDetail d) {
	        int n = 0;
	        String sql = "UPDATE DeviceDetail SET inventoryId=?, deviceId=?, description=?, serialNo=?, status=? WHERE id=?";
	        try {
	            PreparedStatement pre = conn.prepareStatement(sql);
	            pre.setInt(1, d.getInventoryId());
	            pre.setInt(2, d.getDeviceId());
	            pre.setString(3, d.getDescription());
	            pre.setString(4, d.getSerialNo());
	            pre.setString(5, d.getStatus());
	            pre.setInt(6, d.getId());
	            n = pre.executeUpdate();
	        } catch (SQLException ex) {
	            Logger.getLogger(DeviceDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }
	        return n;
	    }

	    // xóa
	    public int removeDeviceDetail(int id) {
	        int n = 0;
	        String sql = "DELETE FROM DeviceDetail WHERE id=" + id;
	        try {
	            Statement st = conn.createStatement();
	            n = st.executeUpdate(sql);
	        } catch (SQLException ex) {
	            Logger.getLogger(DeviceDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }
	        return n;
	    }

	    // lấy dữ liệu
	    public Vector<DeviceDetail> getDeviceDetail(String sql) {
	        Vector<DeviceDetail> vector = new Vector<>();
	        try {
	            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	            ResultSet rs = state.executeQuery(sql);
	            while (rs.next()) {
	                int id = rs.getInt("id");
	                int inventoryId = rs.getInt("inventoryId");
	                int deviceId = rs.getInt("deviceId");
	                String description = rs.getString("description");
	                String serialNo = rs.getString("serialNo");
	                String status = rs.getString("status");
	                DeviceDetail d = new DeviceDetail(id, inventoryId, deviceId, description, serialNo, status);
	                vector.add(d);
	            }
	        } catch (SQLException ex) {
	            Logger.getLogger(DeviceDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
	        }
	        return vector;
	    }
}
