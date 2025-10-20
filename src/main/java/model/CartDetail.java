package model;


public class CartDetail {
	private int id;
	private double price;
	private int quantity;
	private Device device;
    private int cartId;
    private double totalPrice;
    
    public CartDetail() {}

	public CartDetail(int id, double price, int quantity, Device device, int cartId, double totalPrice) {
		this.id = id;
		this.price = price;
		this.quantity = quantity;
		this.device = device;
		this.cartId = cartId;
		this.totalPrice = totalPrice;
	}

	public double getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
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

	public int getCartId() {
		return cartId;
	}

	public void setCartId(int cartId) {
		this.cartId = cartId;
	}

	@Override
	public String toString() {
		return "CartDetail [id=" + id + ", price=" + price + ", quantity=" + quantity + ", device=" + device
				+ ", cart_id=" + cartId + ", totalPrice=" + totalPrice + "]";
	}
	
	
}
