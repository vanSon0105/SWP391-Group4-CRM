package dao;
import java.util.*;
import java.sql.*;
import dal.DBContext;
import model.TaskDetail;

public class TaskDetailDAO extends DBContext{
	
	public List<TaskDetail> getTaskDetailWithStaffInfo(int taskId) {
        List<TaskDetail> list = new ArrayList<>();
        String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, td.deadline, td.status, " +
                     "u.full_name, u.email " +
                     "FROM task_details td " +
                     "JOIN users u ON td.technical_staff_id = u.id " +
                     "WHERE td.task_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TaskDetail td = new TaskDetail();
                td.setId(rs.getInt("id"));
                td.setTaskId(rs.getInt("task_id"));
                td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
                td.setAssignedAt(rs.getTimestamp("assigned_at"));
                td.setDeadline(rs.getTimestamp("deadline"));
                td.setStatus(rs.getString("status"));
                td.setStaffName(rs.getString("full_name"));
                td.setStaffEmail(rs.getString("email"));

                list.add(td);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

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
	
	public List<TaskDetail> getTaskDetailsByTaskId(int taskId) {
        List<TaskDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, u.full_name, u.email FROM task_details td " +
                     "JOIN users u ON td.technical_staff_id = u.id " +
                     "WHERE td.task_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskDetail td = new TaskDetail();
                    td.setId(rs.getInt("id"));
                    td.setTaskId(rs.getInt("task_id"));
                    td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
                    td.setAssignedAt(rs.getTimestamp("assigned_at"));
                    td.setDeadline(rs.getTimestamp("deadline"));
                    td.setStatus(rs.getString("status"));
                    td.setStaffName(rs.getString("full_name"));
                    td.setStaffEmail(rs.getString("email"));
                    list.add(td);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void assignStaffToTask(int taskId, int staffId, Timestamp deadline) {
        String sql = "INSERT INTO task_details (task_id, technical_staff_id, deadline) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);
            ps.setTimestamp(3, deadline);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unassignStaffFromTask(int taskId, int staffId) {
        String sql = "DELETE FROM task_details WHERE task_id=? AND technical_staff_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateDeadline(int taskId, int staffId, Timestamp deadline) {
        String sql = "UPDATE task_details SET deadline=? WHERE task_id=? AND technical_staff_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, deadline);
            ps.setInt(2, taskId);
            ps.setInt(3, staffId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
