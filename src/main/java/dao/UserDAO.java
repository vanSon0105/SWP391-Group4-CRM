package dao;

import model.User;
import utils.PasswordUtils;

import java.sql.*;
import java.util.*;
import dal.DBContext;

public class UserDAO extends DBContext{
    
    public List<User> getUsersByRole(int roleId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = ? AND status='active'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id")); 
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean registerUser(User user) {
        String checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
        String sql = "INSERT INTO users (username, password, email, image_url, full_name, phone, gender, birthday, role_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, user.getUsername());
            checkStmt.setString(2, user.getEmail());
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                return false;
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, PasswordUtils.hashPassword(user.getPassword()));
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getImageUrl());
            stmt.setString(5, user.getFullName());
            stmt.setString(6, user.getPhone());
            stmt.setString(7, user.getGender());
            stmt.setTimestamp(8, user.getBirthday());
            stmt.setInt(9, user.getRoleId());
            stmt.setString(10, user.getStatus());
            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean hasChangedUsername(int userId) {
        String sql = "SELECT username_changed FROM users WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBoolean("username_changed");

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public User getUserByLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && PasswordUtils.verifyPassword(password, rs.getString("password"))) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(null);
                u.setEmail(rs.getString("email"));
                u.setImageUrl(rs.getString("image_url"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setGender(rs.getString("gender"));
                u.setBirthday(rs.getTimestamp("birthday"));
                u.setStatus(rs.getString("status"));
                u.setRoleId(rs.getInt("role_id"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    
    public boolean updateUsername(int userId, String newUsername) {
        String sql = "UPDATE users SET username = ?, username_changed = TRUE "
                   + "WHERE id = ? AND username_changed = FALSE";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newUsername);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<User> getAllTechnicalStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, full_name, email FROM users WHERE role_id = 3";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pre = conn.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public void updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtils.hashPassword(newPassword));
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setImageUrl(rs.getString("image_url"));
                u.setUsername(rs.getString("username"));
                u.setRoleId(rs.getInt("role_id"));
                u.setBirthday(rs.getTimestamp("birthday"));
                u.setGender(rs.getString("gender"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setImageUrl(rs.getString("image_url"));
                u.setRoleId(rs.getInt("role_id"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLastLoginAt(rs.getTimestamp("last_login_at"));

                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateUserProfile(User u) {
        String sql = "UPDATE users SET full_name=?, phone=?, email=?, image_url=?, gender=?, birthday=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getImageUrl());
            ps.setString(5, u.getGender());
            if (u.getBirthday() != null) {
                ps.setTimestamp(6, u.getBirthday());
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }
            ps.setInt(7, u.getId());

            int rows = ps.executeUpdate();
            System.out.println("Rows affected: " + rows);
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getUserIdByOrderId(int orderId) {
        int userId = -1;
        String sql = "SELECT customer_id FROM orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("customer_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userId;
    }

    public void addUser(User u) {
        String sql = "INSERT INTO users(username, email, password, full_name, phone, role_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getPhone());
            ps.setInt(6, u.getRoleId());
            ps.setString(7, u.getStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public User getUserDetailsById(int id) {
    	String sql = 
    		    "SELECT u.*, r.role_name " +
    		    "FROM users u " +
    		    "LEFT JOIN roles r ON u.role_id = r.id " +
    		    "WHERE u.id = ?";
    	    try (Connection conn = DBContext.getConnection();
    	         PreparedStatement ps = conn.prepareStatement(sql)) {

    	        ps.setInt(1, id);
    	        ResultSet rs = ps.executeQuery();

    	        if (rs.next()) {
    	            User u = new User();
    	            u.setId(rs.getInt("id"));
    	            u.setFullName(rs.getString("full_name"));
    	            u.setEmail(rs.getString("email"));
    	            u.setPhone(rs.getString("phone"));
    	            u.setImageUrl(rs.getString("image_url"));
    	            u.setRoleId(rs.getInt("role_id"));
    	            u.setUsername(rs.getString("username"));
    	            u.setPassword(rs.getString("password"));
    	            u.setStatus(rs.getString("status"));
    	            u.setCreatedAt(rs.getTimestamp("created_at"));
    	            u.setLastLoginAt(rs.getTimestamp("last_login_at")); 
    	            return u;
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }
    	    return null;
    }
    
    public boolean updateUser(User u) {
        String sql = "UPDATE users SET email = ?, full_name = ?, phone = ?, role_id = ?, status = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getEmail());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getPhone());
            ps.setInt(4, u.getRoleId());
            ps.setString(5, u.getStatus());
            ps.setInt(6, u.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public void updateLastLoginAt(int userId){
        String sql = "UPDATE users SET last_login_at = UTC_TIMESTAMP() WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public boolean softDeleteUser(int id) {
        String sql = "UPDATE users SET status = 'inactive' WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

public boolean activateUser(int id) {
        String sql = "UPDATE users SET status = 'active' WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    
}
