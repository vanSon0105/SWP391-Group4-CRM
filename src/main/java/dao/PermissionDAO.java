package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

public class PermissionDAO {
            
    public Set<String> getPermissionsForUser(int userId) {
    	String sql = "SELECT p.permission_name\n"
                + "FROM permissions p\n"
                + "INNER JOIN role_permission rp ON rp.permission_id = p.id\n"
                + "INNER JOIN users u ON u.role_id = rp.role_id\n"
                + "WHERE u.id = ?\n"
                + "UNION\n"
                + "SELECT p.permission_name\n"
                + "FROM permissions p\n"
                + "INNER JOIN user_permission up ON up.permission_id = p.id\n"
                + "WHERE up.user_id = ?";
        Set<String> permissions = new HashSet<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String permission = rs.getString("permission_name");
                    if (permission != null) {
                        permissions.add(permission);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
}

