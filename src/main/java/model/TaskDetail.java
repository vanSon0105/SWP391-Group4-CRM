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
    private String note;
    private Timestamp updatedAt;
    private String technicalStaffName; 
    private String assignedByName;   
    private String support_status;

    public TaskDetail() {}

	public TaskDetail(int id, int taskId, int technicalStaffId, Integer assignedBy, Timestamp assignedAt,
			Timestamp deadline, String status, String staffName, String staffEmail, String taskTitle,
			String taskDescription, Integer customerIssueId, String issueCode, String issueTitle, String note,
			Timestamp updatedAt, String technicalStaffName, String assignedByName) {
		this.id = id;
		this.taskId = taskId;
		this.technicalStaffId = technicalStaffId;
		this.assignedBy = assignedBy;
		this.assignedAt = assignedAt;
		this.deadline = deadline;
		this.status = status;
		this.staffName = staffName;
		this.staffEmail = staffEmail;
		this.taskTitle = taskTitle;
		this.taskDescription = taskDescription;
		this.customerIssueId = customerIssueId;
		this.issueCode = issueCode;
		this.issueTitle = issueTitle;
		this.note = note;
		this.updatedAt = updatedAt;
		this.technicalStaffName = technicalStaffName;
		this.assignedByName = assignedByName;
	}

	public TaskDetail(int id, int taskId, int technicalStaffId, Timestamp assignedAt, Timestamp deadline, String status,
			String staffName, String staffEmail, String taskTitle, String taskDescription, Integer customerIssueId,
			String issueCode, String issueTitle) {
		super();
		this.id = id;
		this.taskId = taskId;
		this.technicalStaffId = technicalStaffId;
		this.assignedAt = assignedAt;
		this.deadline = deadline;
		this.status = status;
		this.staffName = staffName;
		this.staffEmail = staffEmail;
		this.taskTitle = taskTitle;
		this.taskDescription = taskDescription;
		this.customerIssueId = customerIssueId;
		this.issueCode = issueCode;
		this.issueTitle = issueTitle;
	}

	public TaskDetail(int id, int taskId, int technicalStaffId, Timestamp assignedAt, Timestamp deadline,
			String status) {
		super();
		this.id = id;
		this.taskId = taskId;
		this.technicalStaffId = technicalStaffId;
		this.assignedAt = assignedAt;
		this.deadline = deadline;
		this.status = status;
	}
	
	public TaskDetail(int id, int taskId, int technicalStaffId, Timestamp assignedAt, Timestamp deadline,
			String status, String note) {
		super();
		this.id = id;
		this.taskId = taskId;
		this.technicalStaffId = technicalStaffId;
		this.assignedAt = assignedAt;
		this.deadline = deadline;
		this.status = status;
		this.note = note;
	}


	public int getId() {
		return id;
	}

	public String getSupport_status() {
		return support_status;
	}

	public void setSupport_status(String support_status) {
		this.support_status = support_status;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getTaskId() {
		return taskId;
	}

	public void setTaskId(int taskId) {
		this.taskId = taskId;
	}



	public int getTechnicalStaffId() {
		return technicalStaffId;
	}



	public void setTechnicalStaffId(int technicalStaffId) {
		this.technicalStaffId = technicalStaffId;
	}



	public Integer getAssignedBy() {
		return assignedBy;
	}



	public void setAssignedBy(Integer assignedBy) {
		this.assignedBy = assignedBy;
	}



	public Timestamp getAssignedAt() {
		return assignedAt;
	}



	public void setAssignedAt(Timestamp assignedAt) {
		this.assignedAt = assignedAt;
	}



	public Timestamp getDeadline() {
		return deadline;
	}



	public void setDeadline(Timestamp deadline) {
		this.deadline = deadline;
	}



	public String getStatus() {
		return status;
	}



	public void setStatus(String status) {
		this.status = status;
	}



	public String getStaffName() {
		return staffName;
	}



	public void setStaffName(String staffName) {
		this.staffName = staffName;
	}



	public String getStaffEmail() {
		return staffEmail;
	}



	public void setStaffEmail(String staffEmail) {
		this.staffEmail = staffEmail;
	}



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


	public String getNote() {
		return note;
	}



	public void setNote(String note) {
		this.note = note;
	}



	public Timestamp getUpdatedAt() {
		return updatedAt;
	}



	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}



	public String getTechnicalStaffName() {
		return technicalStaffName;
	}



	public void setTechnicalStaffName(String technicalStaffName) {
		this.technicalStaffName = technicalStaffName;
	}



	public String getAssignedByName() {
		return assignedByName;
	}



	public void setAssignedByName(String assignedByName) {
		this.assignedByName = assignedByName;
	}
	
	


}