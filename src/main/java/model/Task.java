package model;

public class Task {
	private int id;
	private String title;
	private String description;
	private int managerId;
	private int customerIssueId;
	public Task() {
		super();
	}
	public Task(int id, String title, String description, int managerId, int customerIssueId) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.managerId = managerId;
		this.customerIssueId = customerIssueId;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public int getManagerId() {
		return managerId;
	}
	public void setManagerId(int managerId) {
		this.managerId = managerId;
	}
	public int getCustomerIssueId() {
		return customerIssueId;
	}
	public void setCustomerIssueId(int customerIssueId) {
		this.customerIssueId = customerIssueId;
	}
	@Override
	public String toString() {
		return "Task [id=" + id + ", title=" + title + ", description=" + description + ", managerId=" + managerId
				+ ", customerIssueId=" + customerIssueId + "]";
	}
	
	
}
