package model;

import java.sql.Timestamp;

public class TaskDetail {
    private int id;
    private int taskId;
    private int technicalStaffId;
    private Timestamp assignedAt;
    private Timestamp deadline;
    private String status;

    private String staffName;
    private String staffEmail;
    private String taskTitle;
    private String taskDescription;
    private Integer customerIssueId;
    private String issueCode;
    private String issueTitle;

    public TaskDetail() {}

    public TaskDetail(int id, int taskId, int technicalStaffId, Timestamp assignedAt, Timestamp deadline, String status) {
        this.id = id;
        this.taskId = taskId;
        this.technicalStaffId = technicalStaffId;
        this.assignedAt = assignedAt;
        this.deadline = deadline;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getTechnicalStaffId() { return technicalStaffId; }
    public void setTechnicalStaffId(int technicalStaffId) { this.technicalStaffId = technicalStaffId; }

    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }

    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getStaffEmail() { return staffEmail; }
    public void setStaffEmail(String staffEmail) { this.staffEmail = staffEmail; }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    public String getTaskDescription() {
        return taskDescription;
    }

    public void setTaskDescription(String taskDescription) {
        this.taskDescription = taskDescription;
    }

    public Integer getCustomerIssueId() {
        return customerIssueId;
    }

    public void setCustomerIssueId(Integer customerIssueId) {
        this.customerIssueId = customerIssueId;
    }

    public String getIssueCode() {
        return issueCode;
    }

    public void setIssueCode(String issueCode) {
        this.issueCode = issueCode;
    }

    public String getIssueTitle() {
        return issueTitle;
    }

    public void setIssueTitle(String issueTitle) {
        this.issueTitle = issueTitle;
    }
}
