package dal;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.Cart;
import model.Device;

import java.sql.ResultSet;
import java.sql.Statement;

public class DBContext {
    protected static Connection connection;
    private static String url;
    private static String user;
    private static String password;
    
    public static Connection getConnection() {
        connection = null;
        try {
            url = "jdbc:mysql://127.0.0.1:3306/swp391?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
            user = "root";
           password = "13042005"; //password in local mysql

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return (connection);
    }
    	 
    public static void closeConnection() {
        try {
            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    //Test main CSDL
    public static void main(String[] args) {
        Connection c = getConnection();
        List<Device> list = new ArrayList<>();
        if (c == null) {
            System.out.println("something wrong");
        } else {
            String query = "SELECT * from devices";
            try {
                PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery();
                while(rs.next()){
                	int id = rs.getInt("id");
                    int inventoryId = rs.getInt("inventory_id");
                    int deviceId = rs.getInt("device_id");
                    String description = rs.getString("description");
                    String serialNo = rs.getString("serial_no");
                    String status = rs.getString("status");
                }
            } catch (SQLException e) {
                System.out.println(e);
            }
        }
        
        if(list != null) {
        	for (Device deviceDetail : list) {
				System.out.println(list.toString());
			}
        }
    }
}