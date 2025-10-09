package dao;

import model.User;
import java.sql.*;

public class UserDAO {
    private Connection conn;

    public UserDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/swp391",
                "root",
                "123123"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean registerUser(User user) {
        String checkSql = "SELECT * FROM users WHERE username = ? OR email = ?";
        String sql = "INSERT INTO users (username, password, email, image_url, full_name, phone, role_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, user.getUsername());
            checkStmt.setString(2, user.getEmail());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                return false; // trùng username hoặc email
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getImageUrl());
            stmt.setString(5, user.getFullName());
            stmt.setString(6, user.getPhone());
            stmt.setInt(7, user.getRoleId());
            stmt.setString(8, user.getStatus());

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
