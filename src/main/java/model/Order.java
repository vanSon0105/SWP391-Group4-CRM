package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

import model.EnumModel.OrderEnum;

public class Order {
	private int id;
	private Customer customer_id;
	private BigDecimal total_amount;
	private OrderEnum status;
	private Timestamp date;
	
	public Order() {}

	public Order(int id, Customer customer_id, BigDecimal total_amount, OrderEnum status, Timestamp date) {
		super();
		this.id = id;
		this.customer_id = customer_id;
		this.total_amount = total_amount;
		this.status = status;
		this.date = date;
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

	public BigDecimal getTotal_amount() {
		return total_amount;
	}

	public void setTotal_amount(BigDecimal total_amount) {
		this.total_amount = total_amount;
	}

	public OrderEnum getStatus() {
		return status;
	}

	public void setStatus(OrderEnum status) {
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
