package model;
import java.sql.*;

public class CustomerIssue {
	private int id;
	private int customer_id;
	private String issue_code;
	private String title;
	private String description;
	private int warrantyCardId;
	private Timestamp createdAt;
	public CustomerIssue() {
		super();
	}
	
	
	public CustomerIssue(int id, String title) {
		super();
		this.id = id;
		this.title = title;
	}


	public CustomerIssue(int id, int customer_id, String issue_code, String title, String description,
			int warrantyCardId, Timestamp createdAt) {
		super();
		this.id = id;
		this.customer_id = customer_id;
		this.issue_code = issue_code;
		this.title = title;
		this.description = description;
		this.warrantyCardId = warrantyCardId;
		this.createdAt = createdAt;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getCustomer_id() {
		return customer_id;
	}
	public void setCustomer_id(int customer_id) {
		this.customer_id = customer_id;
	}
	public String getIssue_code() {
		return issue_code;
	}
	public void setIssue_code(String issue_code) {
		this.issue_code = issue_code;
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
		return "CustomerIssue [id=" + id + ", customer_id=" + customer_id + ", issue_code=" + issue_code + ", title="
				+ title + ", description=" + description + ", warrantyCardId=" + warrantyCardId + ", createdAt="
				+ createdAt + "]";
	}
	
	
}
