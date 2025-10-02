package model;

import java.math.BigDecimal;

public class CartItem {
    private int deviceId;
    private String name;
    private BigDecimal price;
    private int quantity;
    private BigDecimal discount; // % hoặc số tiền
    private String imageUrl;

    public CartItem(int deviceId, String name, BigDecimal price, int quantity, BigDecimal discount, String imageUrl) {
        this.deviceId = deviceId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.discount = discount;
        this.imageUrl = imageUrl;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public String getName() {
        return name;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getDiscount() {
        return discount == null ? BigDecimal.ZERO : discount;
    }

    public BigDecimal getSubtotal() {
        BigDecimal total = price.multiply(new BigDecimal(quantity));
        return total.subtract(getDiscount());
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
