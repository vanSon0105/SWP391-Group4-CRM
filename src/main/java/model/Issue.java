package model;

import java.sql.Timestamp;

public class Issue {
    private int id;
    private String issueCode;
    private String title;
    private String description;
    private String issueType;      
    private String supportStatus;    
    private Timestamp createdAt;
    private int customerId;
    private DeviceSerial deviceSerial;
    private String status;

    // ===== GETTERS & SETTERS =====
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getIssueCode() { return issueCode; }
    public void setIssueCode(String issueCode) { this.issueCode = issueCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIssueType() { return issueType; }
    public void setIssueType(String issueType) { this.issueType = issueType; }

    public String getSupportStatus() { return supportStatus; }
    public void setSupportStatus(String supportStatus) { this.supportStatus = supportStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public DeviceSerial getDeviceSerial() { return deviceSerial; }
    public void setDeviceSerial(DeviceSerial deviceSerial) { this.deviceSerial = deviceSerial; }
	
    public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
