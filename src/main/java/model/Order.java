package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int customerId;           
    private BigDecimal totalAmount;  
    private BigDecimal discount;      
    private String status;
    private Timestamp date;

    public Order() {}

    public Order(int id, int customerId, BigDecimal totalAmount, BigDecimal discount, String status, Timestamp date) {
        this.id = id;
        this.customerId = customerId;
        this.totalAmount = totalAmount;
        this.discount = discount;
        this.status = status;
        this.date = date;
    }

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public BigDecimal getDiscount() { return discount; }
    public void setDiscount(BigDecimal discount) { this.discount = discount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    @Override
    public String toString() {
        return "Order [id=" + id + ", customerId=" + customerId + ", totalAmount=" + totalAmount
                + ", discount=" + discount + ", status=" + status + ", date=" + date + "]";
    }
}
