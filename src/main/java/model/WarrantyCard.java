package model;

import java.sql.Timestamp;

public class WarrantyCard {
	private int id;
	private int deviceSerialId;
	private DeviceSerial device_serial;
	private int customerId;
	private Customer customer;
	private Timestamp start_at;
	private Timestamp end_at;
	
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
	
	
	
	
}
