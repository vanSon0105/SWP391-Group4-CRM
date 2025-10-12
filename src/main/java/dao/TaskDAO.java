package dao;
import java.util.*;
import java.sql.*;
import model.Task;
import dal.DBContext;
public class TaskDAO extends DBContext{
	public List<Task> getAllTasks() {
		List<Task> list = new ArrayList<>();
		String sql = "select * from tasks";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql);
			 ResultSet rs = pre.executeQuery()){
			while(rs.next()) {
				list.add(new Task(
						rs.getInt("id"),
						rs.getString("title"),
						rs.getString("description"),
						rs.getInt("manager_id"),
						rs.getInt("customer_issue_id")
						));
				
			}
			
		} catch (Exception e) {
			System.out.print("Error");
		}
		
		return list;
	}
	
	public Task getTaskById(int id) {
		Task task = null;
		String sql = "select * from tasks where id = ?";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql)){
			pre.setInt(1, id);
			ResultSet rs = pre.executeQuery();
			if(rs.next()) {
				task = new Task(
						rs.getInt("id"),
						rs.getString("title"),
						rs.getString("description"),
						rs.getInt("manager_id"),
						rs.getInt("customer_issue_id")
						);
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
		return task;
	}
	
	public static void main(String[] args) {
		TaskDAO dao = new TaskDAO();
		List<Task> list = dao.getAllTasks();
		
		for (Task task : list) {
			System.out.print(task.getId() + " ");
		}
	}
}
