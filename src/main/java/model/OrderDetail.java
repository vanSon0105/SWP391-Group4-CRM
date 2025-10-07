package model;
import java.sql.Timestamp;
public class OrderDetail {
	private int id;              
    private int orderId;        
    private int deviceId;       
    private int quantity;        
    private double price;        
    private double discount;      
    private Timestamp warrantyDate; 
    
    public OrderDetail(int orderId, int deviceId, int quantity, double price, double discount, Timestamp warrantyDate) {
        this.orderId = orderId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.price = price;
        this.discount = discount;
        this.warrantyDate = warrantyDate;
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

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public Timestamp getWarrantyDate() {
        return warrantyDate;
    }

    public void setWarrantyDate(Timestamp warrantyDate) {
        this.warrantyDate = warrantyDate;
    }

    @Override
    public String toString() {
        return "OrderDetail [id=" + id + ", orderId=" + orderId + ", deviceId=" + deviceId + ", quantity=" + quantity
                + ", price=" + price + ", discount=" + discount + ", warrantyDate=" + warrantyDate + "]";
    }
}
