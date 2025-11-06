package model;

import java.sql.Timestamp;
import java.util.List;

public class Transaction {
    private int id;
    private int storekeeperId;
    private Integer userId;    
    private Integer supplierId;  
    private Timestamp date;
    private String type;    
    private String status;
    private String storekeeperName;
    private String supplierName;
    private String userName;
    private String note;
    private String deviceList;
    private List<TransactionDetail> details;

    public List<TransactionDetail> getDetails() {
        return details;
    }

    public void setDetails(List<TransactionDetail> details) {
        this.details = details;
    }

	public Transaction() {}

    public Transaction(int id, int storekeeperId, Integer userId, Integer supplierId, Timestamp date, String type, String status) {
        this.id = id;
        this.storekeeperId = storekeeperId;
        this.userId = userId;
        this.supplierId = supplierId;
        this.date = date;
        this.type = type;
        this.status = status;
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getStorekeeperId() {
		return storekeeperId;
	}

	public void setStorekeeperId(int storekeeperId) {
		this.storekeeperId = storekeeperId;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getSupplierId() {
		return supplierId;
	}

	public void setSupplierId(Integer supplierId) {
		this.supplierId = supplierId;
	}

	public Timestamp getDate() {
		return date;
	}

	public void setDate(Timestamp date) {
		this.date = date;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStorekeeperName() {
		return storekeeperName;
	}

	public void setStorekeeperName(String storekeeperName) {
		this.storekeeperName = storekeeperName;
	}

	public String getSupplierName() {
		return supplierName;
	}

	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getDeviceList() {
		return deviceList;
	}

	public void setDeviceList(String deviceList) {
		this.deviceList = deviceList;
	}
    
}
