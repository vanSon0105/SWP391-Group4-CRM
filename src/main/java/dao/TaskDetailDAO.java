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
	
	public void addTaskDetail(int taskId, int technicalStaffId, Timestamp deadline) {
		String sql = "INSERT INTO task_details (task_id, technical_staff_id, deadline) VALUES (?, ?, ?)";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql)){
			
			pre.setInt(1, taskId);
			pre.setInt(2, technicalStaffId);
			pre.setTimestamp(3, deadline);
			pre.executeUpdate();
			
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	public void insertStaffToTask(int taskId, int staffId, Timestamp deadline) {
		String sql = "INSERT INTO task_details (task_id, technical_staff_id, deadline) VALUES (?, ?, ?)";
		try(Connection conn = getConnection();
			PreparedStatement pre = conn.prepareStatement(sql)) {
			pre.setInt(1, taskId);
			pre.setInt(2, staffId);
			pre.setTimestamp(3, deadline);
			pre.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	public void deleteStaffFromTask(int taskId, int staffId)  {
        String sql = "DELETE FROM task_details WHERE task_id=? AND technical_staff_id=?";
        try (Connection conn = getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.setInt(2, staffId);
            ps.executeUpdate();
        } catch (Exception e) {
			// TODO: handle exception
		}
    }
	
	public void updateDeadlineForTask(int taskId, Timestamp deadline) {
        String sql = "UPDATE task_details SET deadline=? WHERE task_id=?";
        try (Connection conn = getConnection();
        	PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, deadline);
            ps.setInt(2, taskId);
            ps.executeUpdate();
        } catch (Exception e) {
			// TODO: handle exception
		}
    }
}
