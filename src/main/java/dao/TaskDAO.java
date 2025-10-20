package dao;

import java.sql.*;
import java.util.*;
import model.Task;
import model.User;
import dal.DBContext;

public class TaskDAO extends DBContext {
	public Task getTaskById(int id) {
	    String sql = "SELECT * FROM tasks WHERE id = ?";
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, id);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            Task t = new Task();
	            t.setId(rs.getInt("id"));
	            t.setTitle(rs.getString("title"));
	            t.setDescription(rs.getString("description"));
	            t.setManagerId(rs.getInt("manager_id"));
	            t.setCustomerIssueId(rs.getInt("customer_issue_id"));
	            return t;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
    public List<Task> filterTasks(String status, String priority, String technicianId,
                                  String fromDate, String toDate, String searchText) {
        List<Task> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT t.* " +
            "FROM tasks t " +
            "LEFT JOIN task_details td ON t.id = td.task_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append(" AND td.status = ?");
            params.add(status);
        }
        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND td.priority = ?");
            params.add(priority);
        }
        if (technicianId != null && !technicianId.isEmpty()) {
            sql.append(" AND td.technical_staff_id = ?");
            params.add(Integer.parseInt(technicianId));
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND td.assigned_at >= ?");
            params.add(Timestamp.valueOf(fromDate + " 00:00:00"));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND td.deadline <= ?");
            params.add(Timestamp.valueOf(toDate + " 23:59:59"));
        }
        if (searchText != null && !searchText.isEmpty()) {
            sql.append(" AND (LOWER(t.title) LIKE ? OR LOWER(t.description) LIKE ?)");
            String keyword = "%" + searchText.toLowerCase().trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY t.id DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task t = new Task();
                t.setId(rs.getInt("id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setManagerId(rs.getInt("manager_id"));
                t.setCustomerIssueId(rs.getInt("customer_issue_id"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Task> getAllTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, COUNT(td.id) AS assigned_count " +
                     "FROM tasks t " +
                     "LEFT JOIN task_details td ON t.id = td.task_id " +
                     "GROUP BY t.id " +
                     "ORDER BY t.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Task t = new Task();
                t.setId(rs.getInt("id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setManagerId(rs.getInt("manager_id"));
                t.setCustomerIssueId(rs.getInt("customer_issue_id"));
                t.setProgress(String.valueOf(rs.getInt("assigned_count")));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addTask(Task task) {
        String sql = "INSERT INTO tasks (title, description, manager_id, customer_issue_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());

            // Kiểm tra null để tránh lỗi
            if (task.getManagerId() != 0) ps.setInt(3, task.getManagerId());
            else ps.setNull(3, Types.INTEGER);

            if (task.getCustomerIssueId() != 0) ps.setInt(4, task.getCustomerIssueId());
            else ps.setNull(4, Types.INTEGER);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteTask(int id) {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateTaskStatus(int taskId, String status) {
        String sql = "UPDATE tasks SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, taskId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<User> getAllTechnicalStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = 3 AND status='active'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Task> getAllFullTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT ci.issue_code AS wo, t.id, t.title, t.description, " +
                     "td.status, td.priority, " +
                     "u1.full_name AS assignedToName, u2.full_name AS assignedByName, " +
                     "td.assigned_at, td.deadline, td.progress, td.note, " +
                     "td.attachment_url, td.updated_at " +
                     "FROM task_details td " +
                     "JOIN tasks t ON td.task_id = t.id " +
                     "JOIN customer_issues ci ON t.customer_issue_id = ci.id " +
                     "JOIN users u1 ON td.technical_staff_id = u1.id " +
                     "LEFT JOIN users u2 ON td.assigned_by = u2.id " +
                     "ORDER BY t.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Task t = new Task();
                t.setWo(rs.getString("wo"));
                t.setId(rs.getInt("id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setStatus(rs.getString("status"));
                t.setPriority(rs.getString("priority"));
                t.setAssignedToName(rs.getString("assignedToName"));
                t.setAssignedByName(rs.getString("assignedByName"));
                t.setAssignDate(rs.getTimestamp("assigned_at"));
                t.setDeadline(rs.getTimestamp("deadline"));
                t.setProgress(String.valueOf(rs.getInt("progress")));
                t.setNote(rs.getString("note"));
                t.setAttachmentUrl(rs.getString("attachment_url"));
                t.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    
	public Set<Integer> getAssignedStaffIds(int taskId) {
		Set<Integer> set = new HashSet<>();
		String sql = "SELECT technical_staff_id FROM task_details WHERE task_id=?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, taskId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next())
					set.add(rs.getInt("technical_staff_id"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return set;
	}
	
	public List<Task> getFilteredTasksWithStatus(String status, String search) {
		List<Task> list = new ArrayList<>();
		String sql = "select * from task_with_status WHERE 1 = 1 ";
		
		if(status != null && !status.isEmpty()) {
			sql += " and status = '" + status + "' ";
		}
		
		if(search != null && !search.isEmpty()) {
			sql += " and ( title LIKE '%" + search + "%' OR description LIKE '%" + search + "%') ";
		}
		
		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql);
				ResultSet rs = pre.executeQuery()) {
			while (rs.next()) {
				list.add(new Task(rs.getInt("id"), rs.getString("title"), rs.getString("description"),
						rs.getInt("manager_id"), rs.getInt("customer_issue_id"), rs.getString("status")));

			}

		} catch (Exception e) {
			System.out.print("Error");
		}

		return list;
	}
	
	public void updateTask(int id, String title, String desc, int managerId, int issueId) {
		String sql = "UPDATE tasks SET title=?, description=?, manager_id=?, customer_issue_id=? WHERE id=?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, title);
			ps.setString(2, desc);
			ps.setInt(3, managerId);
			ps.setInt(4, issueId);
			ps.setInt(5, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int addNewTask(Task task) {
		String sql = "INSERT INTO tasks (title, description, manager_id, customer_issue_id) VALUES (?, ?, ?, ?)";

		try (Connection conn = getConnection();
				PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			pre.setString(1, task.getTitle());
			pre.setString(2, task.getDescription());
			pre.setInt(3, task.getManagerId());
			pre.setInt(4, task.getCustomerIssueId());
			pre.executeUpdate();
			ResultSet rs = pre.getGeneratedKeys();

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.print("Error connection");
		}
		return -1;
	}
}
