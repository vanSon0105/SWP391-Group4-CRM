package dao;

import java.sql.*;
import java.util.*;
import model.TaskDetail;
import dal.DBContext;

public class TaskDetailDAO extends DBContext {

    public void assignStaffToTask(int taskId, int staffId, Integer assignedBy, Timestamp deadline) {
        String sql = "INSERT INTO task_details (task_id, technical_staff_id, assigned_by, deadline) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, staffId);

            if (assignedBy != null) ps.setInt(3, assignedBy);
            else ps.setNull(3, Types.INTEGER);

            if (deadline != null) ps.setTimestamp(4, deadline);
            else ps.setNull(4, Types.TIMESTAMP);

            ps.executeUpdate();

        } catch (SQLException e) {
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

}
