package dao;

import java.sql.*;
import java.util.*;
import model.TaskDetail;
import dal.DBContext;

public class TaskDetailDAO extends DBContext {

	public void deleteByTaskIdAndStaffId(int taskId, int staffId){
		String sql = "DELETE FROM task_details WHERE task_id = ? AND technical_staff_id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, taskId);
			ps.setInt(2, staffId);
			ps.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	public boolean areAllAssignmentsCompletedForIssue(int issueId) {
		String sql = "SELECT COUNT(*) FROM task_details td " + "JOIN tasks t ON td.task_id = t.id "
				+ "WHERE t.customer_issue_id = ? " + "AND td.status NOT IN ('completed', 'cancelled')";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, issueId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) == 0;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public int getTechnicalStaffIdByTaskId(int taskId) {
		String sql = "SELECT technical_staff_id FROM task_details WHERE task_id = ?;";
		try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, taskId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("technical_staff_id");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}

	public List<TaskDetail> getStaffInfoWithTaskDetailId(int taskId) {
		List<TaskDetail> list = new ArrayList<>();
		String sql = "SELECT td.*, u.username AS technicalStaffName, u.email AS staffEmail, u2.username AS managerName\r\n"
				+ "FROM task_details td\r\n" + "JOIN tasks t ON td.task_id = t.id\r\n"
				+ "JOIN users u ON td.technical_staff_id = u.id \r\n" + "JOIN users u2 ON t.manager_id = u2.id\r\n"
				+ "WHERE td.task_id = ?;";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
				td.setNote(rs.getString("note"));
				td.setUpdatedAt(rs.getTimestamp("updated_at"));
				td.setTechnicalStaffName(rs.getString("technicalStaffName"));
				td.setAssignedByName(rs.getString("managerName"));
				list.add(td);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<TaskDetail> getAssignmentsForStaff(int staffId) {
		List<TaskDetail> list = new ArrayList<>();
		String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, td.deadline, td.status, td.note,\r\n"
				+ "t.title AS task_title, t.description AS task_description, t.customer_issue_id, ci.support_status, ci.issue_code, ci.title AS issue_title\r\n"
				+ "FROM task_details td\r\n" + "JOIN tasks t ON td.task_id = t.id\r\n"
				+ "LEFT JOIN customer_issues ci ON t.customer_issue_id = ci.id\r\n"
				+ "WHERE td.technical_staff_id = ? ORDER BY td.assigned_at DESC;";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, staffId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					TaskDetail td = new TaskDetail();
					td.setId(rs.getInt("id"));
					td.setTaskId(rs.getInt("task_id"));
					td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
					td.setAssignedAt(rs.getTimestamp("assigned_at"));
					td.setDeadline(rs.getTimestamp("deadline"));
					td.setStatus(rs.getString("status"));
					td.setNote(rs.getString("note"));
					td.setTaskTitle(rs.getString("task_title"));
					td.setTaskDescription(rs.getString("task_description"));
					td.setCustomerIssueId((Integer) rs.getObject("customer_issue_id"));
					td.setIssueCode(rs.getString("issue_code"));
					td.setIssueTitle(rs.getString("issue_title"));
					td.setSupport_status(rs.getString("support_status"));
					list.add(td);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public TaskDetail getAssignmentForStaff(int detailId, int staffId) {
		String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.status, t.customer_issue_id\r\n"
				+ "FROM task_details td\r\n" + "JOIN tasks t ON td.task_id = t.id\r\n"
				+ "WHERE td.id = ? AND td.technical_staff_id = ?;";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, detailId);
			ps.setInt(2, staffId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					TaskDetail td = new TaskDetail();
					td.setId(rs.getInt("id"));
					td.setTaskId(rs.getInt("task_id"));
					td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
					td.setStatus(rs.getString("status"));
					td.setCustomerIssueId(rs.getInt("customer_issue_id"));
					return td;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean updateAssignmentStatus(int detailId, int staffId, String status, String summary, Boolean cancelledByWarranty) {
	    String sql = "UPDATE task_details SET status = ?, note = ?, cancelled_by_warranty = ? WHERE id = ? AND technical_staff_id = ?";
	    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, status);
	        if (summary != null) {
	            ps.setString(2, summary);
	        } else {
	            ps.setNull(2, Types.VARCHAR);
	        }
	        if (cancelledByWarranty != null) {
	            ps.setBoolean(3, cancelledByWarranty);
	        } else {
	            ps.setNull(3, Types.BOOLEAN);
	        }
	        ps.setInt(4, detailId);
	        ps.setInt(5, staffId);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}


	public List<TaskDetail> getTaskDetail(int taskId) {
		List<TaskDetail> list = new ArrayList<>();
		String sql = "SELECT td.*, t.customer_issue_id\r\n"
				+ "FROM task_details td\r\n"
				+ "JOIN tasks t ON td.task_id = t.id\r\n"
				+ "WHERE td.task_id = ?\r\n"
				+ "";

		try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
			pre.setInt(1, taskId);
			ResultSet rs = pre.executeQuery();

			while (rs.next()) {
				list.add(new TaskDetail(rs.getInt("id"),
						rs.getInt("task_id"),
						rs.getInt("technical_staff_id"),
						rs.getTimestamp("assigned_at"),
						rs.getTimestamp("deadline"),
						rs.getString("status"),
						rs.getString("note"),
						rs.getBoolean("cancelled_by_warranty"),
						rs.getInt("customer_issue_id")));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void insertStaffToTask(int taskId, int staffId, Timestamp deadline) {
		String sql = "INSERT INTO task_details (task_id, technical_staff_id, deadline) VALUES (?, ?, ?)";
		try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
			pre.setInt(1, taskId);
			pre.setInt(2, staffId);
			pre.setTimestamp(3, deadline);
			pre.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void deleteStaffFromTask(int taskId, int staffId) {
		String sql = "DELETE FROM task_details WHERE task_id=? AND technical_staff_id=?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, taskId);
			ps.setInt(2, staffId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateDeadlineForTask(int taskId, Timestamp deadline) {
		String sql = "UPDATE task_details SET deadline=? WHERE task_id=?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setTimestamp(1, deadline);
			ps.setInt(2, taskId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void assignStaffToTask(int taskId, int staffId, Timestamp deadline) {
		String sql = "INSERT INTO task_details (task_id, technical_staff_id, deadline) VALUES (?, ?, ?)";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, taskId);
			ps.setInt(2, staffId);
			ps.setTimestamp(3, deadline);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void cancelTask(int taskId) {
		String updateTaskSql = "UPDATE tasks SET is_cancelled = TRUE WHERE id = ?";
		String updateIssueSql = "UPDATE customer_issues " + "SET support_status = 'manager_approved' "
				+ "WHERE id = (SELECT customer_issue_id FROM tasks WHERE id = ?)";

		try (Connection conn = getConnection();
				PreparedStatement ps1 = conn.prepareStatement(updateTaskSql);
				PreparedStatement ps2 = conn.prepareStatement(updateIssueSql)) {

			conn.setAutoCommit(false);

			ps1.setInt(1, taskId);
			ps1.executeUpdate();
			ps2.setInt(1, taskId);
			ps2.executeUpdate();

			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void add(TaskDetail detail) {
		String sql = "INSERT INTO task_details (task_id, technical_staff_id, assigned_at, deadline, status) VALUES (?, ?, ?, ?, ?)";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, detail.getTaskId());
			ps.setInt(2, detail.getTechnicalStaffId());
			ps.setTimestamp(3, detail.getAssignedAt());
			ps.setTimestamp(4, detail.getDeadline());
			ps.setString(5, detail.getStatus());
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void completeTaskDetails(int taskId) {
		String sql = "UPDATE task_details SET status=? WHERE task_id=?";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, "completed");
			ps.setInt(2, taskId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int countActiveTasksForStaff(int staffId) {
		String sql = "SELECT COUNT(DISTINCT task_id) FROM task_details " + "WHERE technical_staff_id = ? "
				+ "AND status NOT IN ('completed', 'cancelled');";
		try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, staffId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public TaskDetail getTaskDetailFromCustomerIssue(int issueId) {
		String sql = "SELECT t.id, t.customer_issue_id, t.title, t.description, td.id AS 'task_detail_id', u.username, \r\n"
				+ "td.assigned_at, td.deadline, td.note, td.status, td.updated_at FROM tasks t \r\n"
				+ "JOIN task_details td ON t.id = td.task_id\r\n" + "JOIN users u ON u.id = t.customer_issue_id\r\n"
				+ "WHERE t.customer_issue_id = ?;";
		try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, issueId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				TaskDetail t = new TaskDetail();
				t.setId(rs.getInt("task_detail_id"));
				t.setTaskTitle(rs.getString("title"));
				t.setTaskDescription(rs.getString("description"));
				t.setTaskId(rs.getInt("id"));
				t.setTechnicalStaffName(rs.getString("username"));
				t.setAssignedAt(rs.getTimestamp("assigned_at"));
				t.setDeadline(rs.getTimestamp("deadline"));
				t.setNote(rs.getString("note"));
				t.setStatus(rs.getString("status"));
				t.setUpdatedAt(rs.getTimestamp("updated_at"));
				t.setCustomerIssueId(rs.getInt("customer_issue_id"));
				return t;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public TaskDetail getAssignmentDetailForStaff(int detailId, int staffId) {
		String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, td.deadline, td.status, td.note, td.updated_at, \r\n"
				+ "t.title AS task_title, t.description AS task_description, t.customer_issue_id, \r\n"
				+ "ci.issue_code, ci.title AS issue_title, \r\n"
				+ "staff.username AS staff_name, staff.email AS staff_email, m.username AS assigned_by_name\r\n"
				+ "FROM task_details td \r\n" + "JOIN tasks t ON td.task_id = t.id \r\n"
				+ "LEFT JOIN customer_issues ci ON t.customer_issue_id = ci.id \r\n"
				+ "JOIN users staff ON td.technical_staff_id = staff.id \r\n"
				+ "LEFT JOIN users m ON m.id = t.manager_id\r\n" + "WHERE td.id = ? AND td.technical_staff_id = ?;";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, detailId);
			ps.setInt(2, staffId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					TaskDetail td = new TaskDetail();
					td.setId(rs.getInt("id"));
					td.setTaskId(rs.getInt("task_id"));
					td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
					td.setAssignedAt(rs.getTimestamp("assigned_at"));
					td.setDeadline(rs.getTimestamp("deadline"));
					td.setStatus(rs.getString("status"));
					td.setNote(rs.getString("note"));
					td.setUpdatedAt(rs.getTimestamp("updated_at"));
					td.setTaskTitle(rs.getString("task_title"));
					td.setTaskDescription(rs.getString("task_description"));
					td.setCustomerIssueId((Integer) rs.getObject("customer_issue_id"));
					td.setIssueCode(rs.getString("issue_code"));
					td.setIssueTitle(rs.getString("issue_title"));
					td.setStaffName(rs.getString("staff_name"));
					td.setStaffEmail(rs.getString("staff_email"));
					td.setAssignedByName(rs.getString("assigned_by_name"));
					return td;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<TaskDetail> getBasicTaskDetailsByStaffId(int staffId) {
		List<TaskDetail> list = new ArrayList<>();

		String sql = 
			    "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, "
			  + "td.deadline, td.status, td.note, t.title AS taskTitle "
			  + "FROM task_details td "
			  + "JOIN tasks t ON td.task_id = t.id "
			  + "WHERE td.technical_staff_id = ? "
			  + "AND td.status IN ('pending', 'in_progress') "
			  + "ORDER BY td.assigned_at DESC";


		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, staffId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				TaskDetail td = new TaskDetail();
				td.setId(rs.getInt("id"));
				td.setTaskId(rs.getInt("task_id"));
				td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
				td.setAssignedAt(rs.getTimestamp("assigned_at"));
				td.setDeadline(rs.getTimestamp("deadline"));
				td.setStatus(rs.getString("status"));
				td.setNote(rs.getString("note"));
				td.setTaskTitle(rs.getString("taskTitle"));

				list.add(td);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	
	public void insert(TaskDetail taskDetail) {
        String sql = "INSERT INTO task_details (task_id, technical_staff_id, assigned_at, deadline, note, status) "
                   + "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskDetail.getTaskId());
            ps.setInt(2, taskDetail.getTechnicalStaffId());
            if(taskDetail.getDeadline() != null){
                ps.setTimestamp(3, taskDetail.getDeadline());
            } else {
                ps.setTimestamp(3, null);
            }
            ps.setString(4, taskDetail.getNote());
            ps.setString(5, taskDetail.getStatus());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
