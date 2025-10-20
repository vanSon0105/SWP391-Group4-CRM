package dao;

import java.sql.*;
import java.util.*;
import model.TaskDetail;
import dal.DBContext;

public class TaskDetailDAO extends DBContext{
	
	public List<TaskDetail> getTaskDetailWithStaffInfo(int taskId) {
        List<TaskDetail> list = new ArrayList<>();
        String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, td.deadline, td.status, " +
                     "u.full_name, u.email " +
                     "FROM task_details td " +
                     "JOIN users u ON td.technical_staff_id = u.id " +
                     "JOIN tasks t ON td.task_id = t.id " +
                     "LEFT JOIN customer_issues ci ON t.customer_issue_id = ci.id " +
                     "WHERE td.task_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);

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
                td.setTaskTitle(rs.getString("task_title"));
                td.setTaskDescription(rs.getString("task_description"));
                td.setCustomerIssueId(rs.getInt("customer_issue_id"));
                td.setIssueCode(rs.getString("issue_code"));
                td.setIssueTitle(rs.getString("issue_title"));

            if (deadline != null) ps.setTimestamp(4, deadline);
            else ps.setNull(4, Types.TIMESTAMP);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public boolean isStaffAssignedToTask(int taskId, int staffId) {
        String sql = "SELECT COUNT(*) FROM task_details WHERE task_id = ? AND technical_staff_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<TaskDetail> getTaskDetailsWithStaffInfo(int taskId) {
        List<TaskDetail> list = new ArrayList<>();
        String sql = "SELECT td.*, u.full_name AS technicalStaffName, u.email AS staffEmail, " +
                     "ub.full_name AS assignedByName " +
                     "FROM task_details td " +
                     "JOIN users u ON td.technical_staff_id = u.id " +
                     "LEFT JOIN users ub ON td.assigned_by = ub.id " +
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
                td.setAssignedBy(rs.getObject("assigned_by") != null ? rs.getInt("assigned_by") : null);
                td.setAssignedAt(rs.getTimestamp("assigned_at"));
                td.setDeadline(rs.getTimestamp("deadline"));
                td.setProgress(rs.getInt("progress"));
                td.setPriority(rs.getString("priority"));
                td.setStatus(rs.getString("status"));
                td.setNote(rs.getString("note"));
                td.setAttachmentUrl(rs.getString("attachment_url"));
                td.setUpdatedAt(rs.getTimestamp("updated_at"));
                td.setTechnicalStaffName(rs.getString("technicalStaffName"));
                td.setAssignedByName(rs.getString("assignedByName"));
                list.add(td);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void unassignStaffFromTask(int taskId, int staffId) {
        String sql = "DELETE FROM task_details WHERE task_id = ? AND technical_staff_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateDeadline(int taskId, int staffId, Timestamp deadline) {
        String sql = "UPDATE task_details SET deadline = ? WHERE task_id = ? AND technical_staff_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (deadline != null) ps.setTimestamp(1, deadline);
            else ps.setNull(1, Types.TIMESTAMP);

            ps.setInt(2, taskId);
            ps.setInt(3, staffId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<TaskDetail> getTaskDetailWithStaffInfo(int taskId) throws SQLException {
        List<TaskDetail> list = new ArrayList<>();
        String sql = """
            SELECT td.*, u.full_name AS technicalStaffName, ub.full_name AS assignedByName
            FROM task_details td
            JOIN users u ON td.technical_staff_id = u.id
            LEFT JOIN users ub ON td.assigned_by = ub.id
            WHERE td.task_id = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TaskDetail td = new TaskDetail();
                td.setId(rs.getInt("id"));
                td.setTaskId(rs.getInt("task_id"));
                td.setTechnicalStaffId(rs.getInt("technical_staff_id"));
                td.setAssignedBy(rs.getInt("assigned_by"));
                td.setAssignedAt(rs.getTimestamp("assigned_at"));
                td.setDeadline(rs.getTimestamp("deadline"));
                td.setProgress(rs.getInt("progress"));
                td.setPriority(rs.getString("priority"));
                td.setStatus(rs.getString("status"));
                td.setNote(rs.getString("note"));
                td.setAttachmentUrl(rs.getString("attachment_url"));
                td.setUpdatedAt(rs.getTimestamp("updated_at"));
                td.setTechnicalStaffName(rs.getString("technicalStaffName"));
                td.setAssignedByName(rs.getString("assignedByName"));
                list.add(td);
            }
        }
        return list;
    }
    public Set<Integer> getAssignedStaffIds(int taskId) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT technical_staff_id FROM task_details WHERE task_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                set.add(rs.getInt("technical_staff_id"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return set;
    }
    
    public List<TaskDetail> getAssignmentsForStaff(int staffId) {
        List<TaskDetail> list = new ArrayList<>();
        String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.assigned_at, td.deadline, td.status, "
                + "t.title AS task_title, t.description AS task_description, t.customer_issue_id, "
                + "ci.issue_code, ci.title AS issue_title "
                + "FROM task_details td "
                + "JOIN tasks t ON td.task_id = t.id "
                + "LEFT JOIN customer_issues ci ON t.customer_issue_id = ci.id "
                + "WHERE td.technical_staff_id = ? ORDER BY td.assigned_at DESC";

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
                    td.setTaskTitle(rs.getString("task_title"));
                    td.setTaskDescription(rs.getString("task_description"));
                    td.setCustomerIssueId((Integer) rs.getObject("customer_issue_id"));
                    td.setIssueCode(rs.getString("issue_code"));
                    td.setIssueTitle(rs.getString("issue_title"));
                    list.add(td);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public TaskDetail getAssignmentForStaff(int detailId, int staffId) {
        String sql = "SELECT td.id, td.task_id, td.technical_staff_id, td.status, t.customer_issue_id "
                + "FROM task_details td JOIN tasks t ON td.task_id = t.id "
                + "WHERE td.id = ? AND td.technical_staff_id = ?";
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
                    td.setCustomerIssueId((Integer) rs.getObject("customer_issue_id"));
                    return td;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateAssignmentStatus(int detailId, int staffId, String status) {
        String sql = "UPDATE task_details SET status = ? WHERE id = ? AND technical_staff_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, detailId);
            ps.setInt(3, staffId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean areAllAssignmentsCompleted(int taskId) {
        String sql = "SELECT COUNT(*) FROM task_details WHERE task_id = ? AND status <> 'completed'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
