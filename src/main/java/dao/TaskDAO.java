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
	
	public int addNewTask(Task task) {
		String sql = "INSERT INTO tasks (title, description, manager_id, customer_issue_id) VALUES (?, ?, ?, ?)";
		
		try (Connection conn = getConnection();
			 PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
			pre.setString(1, task.getTitle());
			pre.setString(2, task.getDescription());
			pre.setInt(3, task.getManagerId());
			pre.setInt(4, task.getCustomerIssueId());
			pre.executeUpdate();
			ResultSet rs = pre.executeQuery();
			
			if(rs.next()) {
				return rs.getInt(1);
			}
			
			
		} catch (Exception e) {
			System.out.print("Error connection");
		}
		return -1;
	}
	
	public void updateTask(int id, String title, String desc, int managerId, int issueId) {
        String sql = "UPDATE tasks SET title=?, description=?, manager_id=?, customer_issue_id=? WHERE id=?";
        try (Connection conn = getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, desc);
            ps.setInt(3, managerId);
            ps.setInt(4, issueId);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) {
			// TODO: handle exception
		}
    }
	
	public Set<Integer> getAssignedStaffIds(int taskId) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT technical_staff_id FROM task_details WHERE task_id=?";
        try (Connection conn = getConnection();
        	 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) set.add(rs.getInt("technical_staff_id"));
            }
        } catch (Exception e) {
			// TODO: handle exception
		}
        return set;
    }
	
	public static void main(String[] args) {
		TaskDAO dao = new TaskDAO();
		List<Task> list = dao.getAllTasks();
		
		for (Task task : list) {
			System.out.print(task.getId() + " ");
		}
	}
}
