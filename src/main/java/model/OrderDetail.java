package model;
import java.sql.Timestamp;
public class OrderDetail {
	private int id;              
    private int orderId;        
    private int deviceId;  
    private String deviceName;
    private int quantity;        
    private double price;        
    private int discount;
    
    
    public OrderDetail(int id, int orderId, int deviceId, int quantity, double price) {
		this.id = id;
		this.orderId = orderId;
		this.deviceId = deviceId;
		this.quantity = quantity;
		this.price = price;
	}

	public OrderDetail(int orderId, int deviceId, int quantity, double price, int discount) {
        this.orderId = orderId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.price = price;
        this.discount = discount;
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

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }
    
    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }
    

	@Override
    public String toString() {
        return "OrderDetail [id=" + id + ", orderId=" + orderId + ", deviceId=" + deviceId + ", quantity=" + quantity
                + ", price=" + price + ", discount=" + discount +"]";
    }
}
