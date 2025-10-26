package model;
import java.sql.*;

public class CustomerIssue {
	private int id;
	private int customerId;
	private String issueCode;
	private String title;
	private String description;
	private int warrantyCardId;
	private String issueType;
	private Timestamp createdAt;
	private int supportStaffId;
	private String supportStatus;
	
	public CustomerIssue() {}
	
	public CustomerIssue(int id, int customerId, String issueCode, String title, String description, int warrantyCardId,
			Timestamp createdAt, int supportStaffId, String supportStatus) {
		this.id = id;
		this.customerId = customerId;
		this.issueCode = issueCode;
		this.title = title;
		this.description = description;
		this.warrantyCardId = warrantyCardId;
		this.createdAt = createdAt;
		this.supportStaffId = supportStaffId;
		this.supportStatus = supportStatus;
	}
	
	public CustomerIssue(int id, int customerId, String issueCode, String title, String description, int warrantyCardId,
			Timestamp createdAt, int supportStaffId, String supportStatus, String issueType) {
		this.id = id;
		this.customerId = customerId;
		this.issueCode = issueCode;
		this.title = title;
		this.description = description;
		this.warrantyCardId = warrantyCardId;
		this.createdAt = createdAt;
		this.supportStaffId = supportStaffId;
		this.supportStatus = supportStatus;
		this.issueType = issueType;
	}
	
	
	
	public String getIssueType() {
		return issueType;
	}

	public void setIssueType(String issueType) {
		this.issueType = issueType;
	}

	public CustomerIssue(int id, String title) {
		this.id = id;
		this.title = title;
	}


	public int getSupportStaffId() {
		return supportStaffId;
	}


	public void setSupportStaffId(int supportStaffId) {
		this.supportStaffId = supportStaffId;
	}


	public String getSupportStatus() {
		return supportStatus;
	}


	public void setSupportStatus(String supportStatus) {
		this.supportStatus = supportStatus;
	}
	

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public String getIssueCode() {
		return issueCode;
	}
	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getWarrantyCardId() {
		return warrantyCardId;
	}
	public void setWarrantyCardId(int warrantyCardId) {
		this.warrantyCardId = warrantyCardId;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	@Override
	public String toString() {
		return "CustomerIssue [id=" + id + ", customer_id=" + customerId + ", issue_code=" + issueCode + ", title="
				+ title + ", description=" + description + ", warrantyCardId=" + warrantyCardId + ", createdAt="
				+ createdAt + "]";
	}
	
	
}
