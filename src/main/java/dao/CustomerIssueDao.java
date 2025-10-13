package dao;
import java.util.*;
import java.sql.*;
import model.CustomerIssue;
import dal.DBContext;

public class CustomerIssueDao extends DBContext{
	public List<CustomerIssue> getAllIssues() {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "select id, title from customer_issues";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery()){
			while(rs.next()) {
				list.add(new CustomerIssue(
						rs.getInt("id"),
						rs.getString("title")
						));
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return list;
	}
}
