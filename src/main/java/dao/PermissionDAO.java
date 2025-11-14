package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import model.Permission;

public class PermissionDAO {
    
    public List<Permission> getAllPermissions() {
        List<Permission> permissions = new ArrayList<>();
        String sql = "SELECT id, permission_name FROM permissions ORDER BY permission_name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Permission permission = new Permission();
                permission.setId(rs.getInt("id"));
                permission.setName(rs.getString("permission_name"));
                permissions.add(permission);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
    
    public Integer getPermissionIdByName(String permissionName) {
        if (permissionName == null) {
            return null;
        }
        String sql = "SELECT id FROM permissions WHERE permission_name = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, permissionName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Permission createPermission(String permissionName) {
        String trimmedName = permissionName != null ? permissionName.trim() : null;
        if (trimmedName == null || trimmedName.isEmpty()) {
            return null;
        }

        String sql = "INSERT INTO permissions (permission_name) VALUES (?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, trimmedName);
            if (ps.executeUpdate() == 0) {
                return null;
            }
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return new Permission(rs.getInt(1), trimmedName);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
            
    public Set<String> getPermissionNamesByRole(int roleId) {
        String sql = "SELECT p.permission_name "
                   + "FROM permissions p "
                   + "INNER JOIN role_permission rp ON rp.permission_id = p.id "
                   + "WHERE rp.role_id = ?";
        Set<String> permissions = new HashSet<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permissions.add(rs.getString("permission_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
    
    public Set<String> getDirectPermissionNamesByUser(int userId) {
        String sql = "SELECT p.permission_name "
                   + "FROM permissions p "
                   + "INNER JOIN user_permission up ON up.permission_id = p.id "
                   + "WHERE up.user_id = ?";
        Set<String> permissions = new HashSet<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permissions.add(rs.getString("permission_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }
    
    public Set<Integer> getPermissionIdsByRole(int roleId) {
        String sql = "SELECT permission_id FROM role_permission WHERE role_id = ?";
        Set<Integer> permissionIds = new HashSet<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permissionIds.add(rs.getInt("permission_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissionIds;
    }
    
    public Set<Integer> getPermissionIdsByUser(int userId) {
        String sql = "SELECT permission_id FROM user_permission WHERE user_id = ?";
        Set<Integer> permissionIds = new HashSet<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    permissionIds.add(rs.getInt("permission_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissionIds;
    }
    
    public boolean replaceRolePermissions(int roleId, List<Integer> permissionIds) {
        List<Integer> normalizedIds = normalizeIds(permissionIds);
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM role_permission WHERE role_id = ?")) {
                deleteStmt.setInt(1, roleId);
                deleteStmt.executeUpdate();
            }

            if (!normalizedIds.isEmpty()) {
                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)")) {
                    for (Integer permissionId : normalizedIds) {
                        insertStmt.setInt(1, roleId);
                        insertStmt.setInt(2, permissionId);
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    public boolean replaceUserPermissions(int userId, List<Integer> permissionIds) {
        List<Integer> normalizedIds = normalizeIds(permissionIds);
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM user_permission WHERE user_id = ?")) {
                deleteStmt.setInt(1, userId);
                deleteStmt.executeUpdate();
            }

            if (!normalizedIds.isEmpty()) {
                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO user_permission (user_id, permission_id) VALUES (?, ?)")) {
                    for (Integer permissionId : normalizedIds) {
                        insertStmt.setInt(1, userId);
                        insertStmt.setInt(2, permissionId);
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    private List<Integer> normalizeIds(List<Integer> permissionIds) {
        if (permissionIds == null || permissionIds.isEmpty()) {
            return new ArrayList<>();
        }
        LinkedHashSet<Integer> unique = new LinkedHashSet<>();
        for (Integer id : permissionIds) {
            if (id != null && id > 0) {
                unique.add(id);
            }
        }
        return new ArrayList<>(unique);
    }
    
    public boolean existsUserWithPermissionExcludingRole(int permissionId, int roleId) {
        String sql = "SELECT 1 FROM users u "
                + "WHERE u.status = 'active' AND ("
                + " (u.role_id <> ? AND ("
                + "     EXISTS (SELECT 1 FROM role_permission rp WHERE rp.role_id = u.role_id AND rp.permission_id = ?)"
                + "     OR EXISTS (SELECT 1 FROM user_permission up WHERE up.user_id = u.id AND up.permission_id = ?)"
                + " ))"
                + " OR (u.role_id = ? AND EXISTS (SELECT 1 FROM user_permission up WHERE up.user_id = u.id AND up.permission_id = ?))"
                + ") LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            ps.setInt(3, permissionId);
            ps.setInt(4, roleId);
            ps.setInt(5, permissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsUserWithPermissionExcludingUser(int permissionId, int userId) {
        String sql = "SELECT 1 FROM users u "
                + "WHERE u.status = 'active' AND u.id <> ? AND ("
                + "    EXISTS (SELECT 1 FROM role_permission rp WHERE rp.role_id = u.role_id AND rp.permission_id = ?)"
                + "    OR EXISTS (SELECT 1 FROM user_permission up WHERE up.user_id = u.id AND up.permission_id = ?)"
                + ") LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, permissionId);
            ps.setInt(3, permissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String roleSql = "SELECT 1 FROM users u "
                + "JOIN role_permission rp ON rp.role_id = u.role_id AND rp.permission_id = ? "
                + "WHERE u.id = ? AND u.status = 'active' LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(roleSql)) {
            ps.setInt(1, permissionId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

