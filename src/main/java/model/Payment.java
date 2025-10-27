package model;
import java.sql.Timestamp;


public class Payment {
	private int id;
	private int orderId;
	private String paymentUrl;
//	private String paymentMethod;
	private double amount;
	private String fullName;
	private String phone;
	private String address;
	private String deliveryTime;
	private String technicalNote;
	private String status;
	private Timestamp createdAt;
	private Timestamp paidAt;
	public Payment() {
		super();
	}
	public Payment(int id, int orderId, String paymentUrl, double amount, String fullName,
			String phone, String address, String deliveryTime, String technicalNote, String status, Timestamp createdAt,
			Timestamp paidAt) {
		super();
		this.id = id;
		this.orderId = orderId;
		this.paymentUrl = paymentUrl;
		this.amount = amount;
		this.fullName = fullName;
		this.phone = phone;
		this.address = address;
		this.deliveryTime = deliveryTime;
		this.technicalNote = technicalNote;
		this.status = status;
		this.createdAt = createdAt;
		this.paidAt = paidAt;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public String getPaymentUrl() {
		return paymentUrl;
	}
	public void setPaymentUrl(String paymentUrl) {
		this.paymentUrl = paymentUrl;
	}

	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getDeliveryTime() {
		return deliveryTime;
	}
	public void setDeliveryTime(String deliveryTime) {
		this.deliveryTime = deliveryTime;
	}
	public String getTechnicalNote() {
		return technicalNote;
	}
	public void setTechnicalNote(String technicalNote) {
		this.technicalNote = technicalNote;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public Timestamp getPaidAt() {
		return paidAt;
	}
	public void setPaidAt(Timestamp paidAt) {
		this.paidAt = paidAt;
	}
	@Override
	public String toString() {
		return "Payment [id=" + id + ", orderId=" + orderId + ", paymentUrl=" + paymentUrl + ", paymentMethod="
				 + ", amount=" + amount + ", fullName=" + fullName + ", phone=" + phone + ", address="
				+ address + ", deliveryTime=" + deliveryTime + ", technicalNote=" + technicalNote + ", status=" + status
				+ ", createdAt=" + createdAt + ", paidAt=" + paidAt + "]";
	}
	
}
