package model;

import java.math.BigDecimal;

public class CartDetail {
	private int id;
	private BigDecimal price;
	private int quantity;
	private Device device;
    private int cart_id;
    private BigDecimal totalPrice;
    
    public CartDetail() {}

	public CartDetail(int id, BigDecimal price, int quantity, Device device, int cart_id, BigDecimal totalPrice) {
		this.id = id;
		this.price = price;
		this.quantity = quantity;
		this.device = device;
		this.cart_id = cart_id;
		this.totalPrice = totalPrice;
	}

	public BigDecimal getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(BigDecimal totalPrice) {
		this.totalPrice = totalPrice;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Device getDevice() {
		return device;
	}

	public void setDevice(Device device) {
		this.device = device;
	}

	public int getCart_id() {
		return cart_id;
	}

	public void setCart_id(int cart_id) {
		this.cart_id = cart_id;
	}

	@Override
	public String toString() {
		return "CartDetail [id=" + id + ", price=" + price + ", quantity=" + quantity + ", device=" + device
				+ ", cart_id=" + cart_id + ", totalPrice=" + totalPrice + "]";
	}
	
	
}
