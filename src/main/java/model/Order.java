package model;

import java.math.BigDecimal;
import java.sql.Timestamp;


public class Order {
	private int id;
	private Customer customer_id;
	private double total_amount;
	private double discount;
	private String status;
	private Timestamp date;
	
	public Order() {}

	public Order(int id, Customer customer_id, double total_amount,double discount, String status, Timestamp date) {
		super();
		this.id = id;
		this.customer_id = customer_id;
		this.total_amount = total_amount;
		this.discount = discount;
		this.status = status;
		this.date = date;
	}
	
	

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Customer getCustomer_id() {
		return customer_id;
	}

	public void setCustomer_id(Customer customer_id) {
		this.customer_id = customer_id;
	}

	public double getTotal_amount() {
		return total_amount;
	}

	public void setTotal_amount(double total_amount) {
		this.total_amount = total_amount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getDate() {
		return date;
	}

	public void setDate(Timestamp date) {
		this.date = date;
	}

	@Override
	public String toString() {
		return "Order [id=" + id + ", customer_id=" + customer_id + ", total_amount=" + total_amount + ", status="
				+ status + ", date=" + date + "]";
	}
}
