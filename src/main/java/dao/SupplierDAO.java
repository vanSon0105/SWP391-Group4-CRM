package dao;
import java.sql.*;
import java.util.*;
import model.Supplier;

public class SupplierDAO extends dal.DBContext {
	
	public List<Supplier> getAllSuppliers() {
		List<Supplier> list = new ArrayList<>();
		String sql = "select * from suppliers";
		
		try ( Connection conn = getConnection();
			  PreparedStatement pre = conn.prepareStatement(sql);
			  ResultSet rs = pre.executeQuery()){
			
			while(rs.next()) {
				list.add(new Supplier(
						rs.getInt("id"),
						rs.getString("name"),
						rs.getString("phone"),
						rs.getString("email"),
						rs.getString("address")
						));
			}
			
		} catch (SQLException e) {
			System.out.print("Connection error");
		}
	}
}
