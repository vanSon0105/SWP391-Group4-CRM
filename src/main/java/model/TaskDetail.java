package model;

import java.sql.Timestamp;

public class TaskDetail {
    private int id;
    private int taskId;
    private int technicalStaffId;
    private Integer assignedBy;      
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
    private int progress;
    private String priority;          
    private String status;            
    private String note;
    private String attachmentUrl;
    private Timestamp updatedAt;
    private String technicalStaffName; 
    private String assignedByName;   

    public TaskDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getTechnicalStaffId() { return technicalStaffId; }
    public void setTechnicalStaffId(int technicalStaffId) { this.technicalStaffId = technicalStaffId; }

    public Integer getAssignedBy() { return assignedBy; }
    public void setAssignedBy(Integer assignedBy) { this.assignedBy = assignedBy; }

    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }

    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }

    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getAttachmentUrl() { return attachmentUrl; }
    public void setAttachmentUrl(String attachmentUrl) { this.attachmentUrl = attachmentUrl; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getTechnicalStaffName() { return technicalStaffName; }
    public void setTechnicalStaffName(String technicalStaffName) { this.technicalStaffName = technicalStaffName; }

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
    public String getAssignedByName() { return assignedByName; }
    public void setAssignedByName(String assignedByName) { this.assignedByName = assignedByName; }
}
