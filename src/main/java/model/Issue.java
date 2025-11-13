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
	
	public String getStatusVN() {
	    if (status == null) return "";

	    switch (status) {
	        case "new": return "Mới";
	        case "in_progress": return "Đang xử lý";
	        case "awaiting_customer": return "Chờ khách hàng";
	        case "submitted": return "Đã gửi";
	        case "manager_review": return "Chờ duyệt quản lý";
	        case "manager_approved": return "Quản lý đã duyệt";
	        case "manager_rejected": return "Quản lý từ chối";
	        case "task_created": return "Đã tạo công việc";
	        case "tech_in_progress": return "Kỹ thuật đang xử lý";
	        case "customer_cancelled": return "Khách hàng hủy";
	        case "completed": return "Hoàn thành";
	        case "create_payment": return "Tạo thanh toán";
	        case "waiting_payment": return "Chờ thanh toán";
	        case "waiting_confirm": return "Chờ xác nhận";
	        case "resolved": return "Đã giải quyết";
	        default: return status; 
	    }
	}
	
	
}
