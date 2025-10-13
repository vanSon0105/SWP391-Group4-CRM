package dao;

import model.UserPreference;
import dal.DBContext;
import java.sql.*;

public class UserPreferenceDAO {

    public UserPreference getPreferenceByUserId(int userId) {
        String sql = "SELECT * FROM user_preferences WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserPreference p = new UserPreference();
                p.setId(rs.getInt("id"));
                p.setUserId(rs.getInt("user_id"));
                p.setPromoEmails(rs.getBoolean("promo_emails"));
                p.setOrderUpdates(rs.getBoolean("order_updates"));
                p.setNewProducts(rs.getBoolean("new_products"));
                p.setWarrantyReminders(rs.getBoolean("warranty_reminders"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePreferences(UserPreference pref) {
        String sql = "UPDATE user_preferences SET promo_emails=?, order_updates=?, new_products=?, warranty_reminders=? WHERE user_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, pref.isPromoEmails());
            ps.setBoolean(2, pref.isOrderUpdates());
            ps.setBoolean(3, pref.isNewProducts());
            ps.setBoolean(4, pref.isWarrantyReminders());
            ps.setInt(5, pref.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
