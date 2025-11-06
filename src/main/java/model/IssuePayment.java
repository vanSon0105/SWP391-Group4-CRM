package model;

import java.sql.Timestamp;

public class IssuePayment {
	private int id;
	private int issueId;
	private double amount;
	private String note;
	private String shippingFullName;
	private String shippingPhone;
	private String shippingAddress;
	private String shippingNote;
	private String status;
	private int createdBy;
	private Integer approvedBy;
	private Integer confirmedBy;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private Timestamp paidAt;
	
	public IssuePayment() {}

	public IssuePayment(int id, int issueId, double amount, String note, String shippingFullName, String shippingPhone,
			String shippingAddress, String shippingNote, String status, int createdBy, Integer approvedBy,
			Integer confirmedBy, Timestamp createdAt, Timestamp updatedAt, Timestamp paidAt) {
		super();
		this.id = id;
		this.issueId = issueId;
		this.amount = amount;
		this.note = note;
		this.shippingFullName = shippingFullName;
		this.shippingPhone = shippingPhone;
		this.shippingAddress = shippingAddress;
		this.shippingNote = shippingNote;
		this.status = status;
		this.createdBy = createdBy;
		this.approvedBy = approvedBy;
		this.confirmedBy = confirmedBy;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
		this.paidAt = paidAt;
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

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}

	public Integer getApprovedBy() {
		return approvedBy;
	}

	public void setApprovedBy(Integer approvedBy) {
		this.approvedBy = approvedBy;
	}

	public Integer getConfirmedBy() {
		return confirmedBy;
	}

	public void setConfirmedBy(Integer confirmedBy) {
		this.confirmedBy = confirmedBy;
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

	public Timestamp getPaidAt() {
		return paidAt;
	}

	public void setPaidAt(Timestamp paidAt) {
		this.paidAt = paidAt;
	}

	public boolean isAwaitingSupport() {
		return "awaiting_support".equalsIgnoreCase(status);
	}

	public boolean isAwaitingCustomer() {
		return "awaiting_customer".equalsIgnoreCase(status);
	}

	public boolean isPaid() {
		return "paid".equalsIgnoreCase(status);
	}

	public boolean isClosed() {
		return "closed".equalsIgnoreCase(status);
	}

	public String getShippingFullName() {
		return shippingFullName;
	}

	public void setShippingFullName(String shippingFullName) {
		this.shippingFullName = shippingFullName;
	}

	public String getShippingPhone() {
		return shippingPhone;
	}

	public void setShippingPhone(String shippingPhone) {
		this.shippingPhone = shippingPhone;
	}

	public String getShippingAddress() {
		return shippingAddress;
	}

	public void setShippingAddress(String shippingAddress) {
		this.shippingAddress = shippingAddress;
	}

	public String getShippingNote() {
		return shippingNote;
	}

	public void setShippingNote(String shippingNote) {
		this.shippingNote = shippingNote;
	}
	
	
}
