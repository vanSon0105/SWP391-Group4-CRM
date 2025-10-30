package model;

import java.sql.Timestamp;
import java.util.List;
import java.util.Set;

public class Task {
    private int id;
    private String title;
    private String description;
    private String wo;
    private int managerId;           
    private int customerIssueId;              
    private String status;                 
    private String assignedToName;  
    private String assignedByName;   
    private Timestamp assignDate;
    private Timestamp deadline;       
    private String note;
    private Timestamp updatedAt;
    private Set<Integer> assignedStaffIds;
    private List<TaskDetail> details;
    
    public Task() {}

    public Set<Integer> getAssignedStaffIds() {
        return assignedStaffIds;
    }

    public void setAssignedStaffIds(Set<Integer> assignedStaffIds) {
        this.assignedStaffIds = assignedStaffIds;
    }

    public List<TaskDetail> getDetails() {
        return details;
    }

    public void setDetails(List<TaskDetail> details) {
        this.details = details;
    }
    

    public Task(int id, String title, String description, int managerId, int customerIssueId, String status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.managerId = managerId;
        this.customerIssueId = customerIssueId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public int getCustomerIssueId() { return customerIssueId; }
    public void setCustomerIssueId(int customerIssueId) { this.customerIssueId = customerIssueId; }

    public String getWo() { return wo; }
    public void setWo(String wo) { this.wo = wo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
//
//    public String getPriority() { return priority; }
//    public void setPriority(String priority) { this.priority = priority; }

    public String getAssignedToName() { return assignedToName; }
    public void setAssignedToName(String assignedToName) { this.assignedToName = assignedToName; }

    public String getAssignedByName() { return assignedByName; }
    public void setAssignedByName(String assignedByName) { this.assignedByName = assignedByName; }

    public Timestamp getAssignDate() { return assignDate; }
    public void setAssignDate(Timestamp assignDate) { this.assignDate = assignDate; }

    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }

//    public String getProgress() { return progress; }
//    public void setProgress(String progress) { this.progress = progress; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

//    public String getAttachmentUrl() { return attachmentUrl; }
//    public void setAttachmentUrl(String attachmentUrl) { this.attachmentUrl = attachmentUrl; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
