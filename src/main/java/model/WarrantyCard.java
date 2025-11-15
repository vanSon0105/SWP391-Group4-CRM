package model;

import java.sql.Timestamp;

public class WarrantyCard {
	private int id;
	private int deviceSerialId;
	private DeviceSerial device_serial;
	private Device device;
	private int customerId;
	private Customer customer;
	private Timestamp start_at;
	private Timestamp end_at;
	private int daysRemaining;
	private String assignedByName;
	private String handledByName;
	private boolean isCancelled;
	private String issueType;

	public String getIssueType() {
		return issueType;
	}

	public void setIssueType(String issueType) {
		this.issueType = issueType;
	}

	
	public boolean getIsCancelled() {
		return isCancelled;
	}

	public void setCancelled(boolean isCancelled) {
		this.isCancelled = isCancelled;
	}

	public int getDeviceSerialId() {
		return deviceSerialId;
	}

	public void setDeviceSerialId(int deviceSerialId) {
		this.deviceSerialId = deviceSerialId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	

	public String getAssignedByName() {
		return assignedByName;
	}

	public void setAssignedByName(String assignedByName) {
		this.assignedByName = assignedByName;
	}

	public String getHandledByName() {
		return handledByName;
	}

	public void setHandledByName(String handledByName) {
		this.handledByName = handledByName;
	}

	public int getDaysRemaining() {
		return daysRemaining;
	}

	public void setDaysRemaining(int daysRemaining) {
		this.daysRemaining = daysRemaining;
	}

	public WarrantyCard() {}
	
	public WarrantyCard(int id, int deviceSerialId, int customerId, Timestamp start_at, Timestamp end_at) {
		super();
		this.id = id;
		this.deviceSerialId = deviceSerialId;
		this.customerId = customerId;
		this.start_at = start_at;
		this.end_at = end_at;
	}



	public WarrantyCard(int id, DeviceSerial device_serial, Customer customer, Timestamp start_at, Timestamp end_at) {
		super();
		this.id = id;
		this.device_serial = device_serial;
		this.customer = customer;
		this.start_at = start_at;
		this.end_at = end_at;
	}
	
	

	public WarrantyCard(int id, int deviceSerialId, int customerId, Timestamp start_at, Timestamp end_at,
			boolean isCancelled) {
		super();
		this.id = id;
		this.deviceSerialId = deviceSerialId;
		this.customerId = customerId;
		this.start_at = start_at;
		this.end_at = end_at;
		this.isCancelled = isCancelled;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public DeviceSerial getDevice_serial() {
		return device_serial;
	}

	public void setDevice_serial(DeviceSerial device_serial) {
		this.device_serial = device_serial;
	}

	public Device getDevice() {
		return device;
	}

	public void setDevice(Device device) {
		this.device = device;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public Timestamp getStart_at() {
		return start_at;
	}

	public void setStart_at(Timestamp start_at) {
		this.start_at = start_at;
	}

	public Timestamp getEnd_at() {
		return end_at;
	}

	public void setEnd_at(Timestamp end_at) {
		this.end_at = end_at;
	}
	
	public String getWarrantyStatus() {
	    if (end_at == null) {
	        return "Hết hạn"; 
	    }
	    return end_at.after(new java.util.Date()) ? "Còn hạn" : "Hết hạn";
	}

	@Override
	public String toString() {
		return "WarrantyCard [id=" + id + ", deviceSerialId=" + deviceSerialId + ", device_serial=" + device_serial
				+ ", device=" + device + ", customerId=" + customerId + ", customer=" + customer + ", start_at="
				+ start_at + ", end_at=" + end_at + ", daysRemaining=" + daysRemaining + ", assignedByName="
				+ assignedByName + ", handledByName=" + handledByName + ", isCancelled=" + isCancelled + "]";
	}
	
	
}
