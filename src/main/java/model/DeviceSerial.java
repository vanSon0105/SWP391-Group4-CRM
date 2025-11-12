package model;

import java.sql.Timestamp;

public class DeviceSerial {
	private int id;
	private int device_id;
	private String serial_no;
	private String stock_status;
	private Timestamp import_date;
	private String status;
	private String deviceName;
	
	public DeviceSerial() {}

	public DeviceSerial(int id, int device_id, String serial_no, String stock_status, Timestamp import_date, String status) {
		super();
		this.id = id;
		this.device_id = device_id;
		this.serial_no = serial_no;
		this.stock_status = stock_status;
		this.import_date = import_date;
		this.status = status;
	}
	

	public DeviceSerial(int id, int device_id, String serial_no, String stock_status, Timestamp import_date,
			String status, String deviceName) {
		super();
		this.id = id;
		this.device_id = device_id;
		this.serial_no = serial_no;
		this.stock_status = stock_status;
		this.import_date = import_date;
		this.status = status;
		this.deviceName = deviceName;
	}

	public String getDeviceName() {
		return deviceName;
	}

	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}

	public String getStock_status() {
		return stock_status;
	}

	public void setStock_status(String stock_status) {
		this.stock_status = stock_status;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getDevice_id() {
		return device_id;
	}

	public void setDevice_id(int device_id) {
		this.device_id = device_id;
	}

	public String getSerial_no() {
		return serial_no;
	}

	public void setSerial_no(String serial_no) {
		this.serial_no = serial_no;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getImport_date() {
		return import_date;
	}

	public void setImport_date(Timestamp import_date) {
		this.import_date = import_date;
	}

	@Override
	public String toString() {
		return "DeviceSerial [id=" + id + ", device_id=" + device_id + ", serial_no=" + serial_no + ", status=" + stock_status
				+ ", import_date=" + import_date + "]";
	}
	
	
	
}
