package model;

import java.sql.Timestamp;

public class DeviceSerial {
	private int id;
	private int device_id;
	private String serial_no;
	private Enum status;
	private Timestamp import_date;
	
	public DeviceSerial() {}

	public DeviceSerial(int id, int device_id, String serial_no, Enum status, Timestamp import_date) {
		super();
		this.id = id;
		this.device_id = device_id;
		this.serial_no = serial_no;
		this.status = status;
		this.import_date = import_date;
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

	public Enum getStatus() {
		return status;
	}

	public void setStatus(Enum status) {
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
		return "DeviceSerial [id=" + id + ", device_id=" + device_id + ", serial_no=" + serial_no + ", status=" + status
				+ ", import_date=" + import_date + "]";
	}
	
	
	
}
