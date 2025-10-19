package model;

import java.sql.Timestamp;

public class CustomerIssueDetail {
	private int id;
	private int issueId;
	private int supportStaffId;
	private String customerFullName;
	private String  contactEmail;
	private String contactPhone;
	private String deviceSerial;
	private String summary;
	private boolean forwardToManager;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	
	public CustomerIssueDetail() {}

	public CustomerIssueDetail(int id, int issueId, int supportStaffId, String customerFullName, String contactEmail,
			String contactPhone, String deviceSerial, String summary, boolean forwardToManager, Timestamp createdAt,
			Timestamp updatedAt) {
		this.id = id;
		this.issueId = issueId;
		this.supportStaffId = supportStaffId;
		this.customerFullName = customerFullName;
		this.contactEmail = contactEmail;
		this.contactPhone = contactPhone;
		this.deviceSerial = deviceSerial;
		this.summary = summary;
		this.forwardToManager = forwardToManager;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getIssueId() {
		return issueId;
	}

	public void setIssueId(int issueId) {
		this.issueId = issueId;
	}

	public int getSupportStaffId() {
		return supportStaffId;
	}

	public void setSupportStaffId(int supportStaffId) {
		this.supportStaffId = supportStaffId;
	}

	public String getCustomerFullName() {
		return customerFullName;
	}

	public void setCustomerFullName(String customerFullName) {
		this.customerFullName = customerFullName;
	}

	public String getContactEmail() {
		return contactEmail;
	}

	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public String getDeviceSerial() {
		return deviceSerial;
	}

	public void setDeviceSerial(String deviceSerial) {
		this.deviceSerial = deviceSerial;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public boolean isForwardToManager() {
		return forwardToManager;
	}

	public void setForwardToManager(boolean forwardToManager) {
		this.forwardToManager = forwardToManager;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}

	@Override
	public String toString() {
		return "CustomerIssueDetail [id=" + id + ", issueId=" + issueId + ", supportStaffId=" + supportStaffId
				+ ", customerFullName=" + customerFullName + ", contactEmail=" + contactEmail + ", contactPhone="
				+ contactPhone + ", deviceSerial=" + deviceSerial + ", summary=" + summary + ", forwardToManager="
				+ forwardToManager + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + "]";
	}	
}
