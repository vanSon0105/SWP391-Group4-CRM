package model;

public class CustomerDeviceView {
    private int customerId;        
    private String customerName;   
    private String customerEmail; 

    private int deviceId;          
    private String deviceName;    
    private String categoryName;   
    private String serialNumber;   
    private double price;         
    private String status;        
    private int warrantyMonth;     

    private boolean hasWarranty;   
    private boolean hasIssue;  
    
    private Integer warrantyCardId;
    private int issueId;   
    
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getCustomerEmail() {
		return customerEmail;
	}
	public void setCustomerEmail(String customerEmail) {
		this.customerEmail = customerEmail;
	}
	public int getDeviceId() {
		return deviceId;
	}
	public void setDeviceId(int deviceId) {
		this.deviceId = deviceId;
	}
	public String getDeviceName() {
		return deviceName;
	}
	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getWarrantyMonth() {
		return warrantyMonth;
	}
	public void setWarrantyMonth(int warrantyMonth) {
		this.warrantyMonth = warrantyMonth;
	}
	public boolean isHasWarranty() {
		return hasWarranty;
	}
	public void setHasWarranty(boolean hasWarranty) {
		this.hasWarranty = hasWarranty;
	}
	public boolean isHasIssue() {
		return hasIssue;
	}
	public void setHasIssue(boolean hasIssue) {
		this.hasIssue = hasIssue;
	}
	public Integer getWarrantyCardId() {
		return warrantyCardId;
	}
	public void setWarrantyCardId(Integer warrantyCardId) {
		this.warrantyCardId = warrantyCardId;
	}
	public int getIssueId() {
		return issueId;
	}
	public void setIssueId(int issueId) {
		this.issueId = issueId;
	}

}
