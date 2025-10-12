package dao;
import java.util.*;
import java.sql.*;
import dal.DBContext;
import model.TaskDetail;

public class TaskDetailDAO extends DBContext{
	public List<TaskDetail> getTaskDetail(int taskId) {
		List<TaskDetail> list = new ArrayList<>();
		String sql = "select * from task_details where task_id = ?";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql)){
			pre.setInt(1, taskId);
			ResultSet rs = pre.executeQuery();
			
			while(rs.next()) {
				list.add(new TaskDetail(
						rs.getInt("id"),
						rs.getInt("task_id"),
						rs.getInt("technical_staff_id"),
						rs.getTimestamp("assigned_at"),
						rs.getTimestamp("deadline"),
						rs.getString("status")
						));
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return list;
	}
}
