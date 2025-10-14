package dao;

import model.UserAddress;
import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDAO {

    public List<UserAddress> getAddressesByUserId(int userId) {
        List<UserAddress> list = new ArrayList<>();
        String sql = "SELECT * FROM user_addresses WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserAddress a = new UserAddress();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setLabel(rs.getString("label"));
                a.setRecipientName(rs.getString("recipient_name"));
                a.setPhone(rs.getString("phone"));
                a.setAddressLine(rs.getString("address_line"));
                a.setDefault(rs.getBoolean("is_default"));
                a.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addAddress(UserAddress a) {
        String sql = "INSERT INTO user_addresses (user_id, label, recipient_name, phone, address_line, is_default) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getUserId());
            ps.setString(2, a.getLabel());
            ps.setString(3, a.getRecipientName());
            ps.setString(4, a.getPhone());
            ps.setString(5, a.getAddressLine());
            ps.setBoolean(6, a.isDefault());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAddress(UserAddress a) {
        String sql = "UPDATE user_addresses SET label=?, recipient_name=?, phone=?, address_line=?, is_default=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getLabel());
            ps.setString(2, a.getRecipientName());
            ps.setString(3, a.getPhone());
            ps.setString(4, a.getAddressLine());
            ps.setBoolean(5, a.isDefault());
            ps.setInt(6, a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
