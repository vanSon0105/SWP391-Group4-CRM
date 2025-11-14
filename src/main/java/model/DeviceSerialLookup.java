package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Lightweight view model that aggregates details linked to a device serial.
 */
public class DeviceSerialLookup {
    private int serialId;
    private String serialNo;
    private String stockStatus;
    private String serialStatus;
    private Timestamp importDate;

    private int deviceId;
    private String deviceName;
    private String categoryName;
    private BigDecimal devicePrice;
    private Integer warrantyMonth;

    private Integer orderId;
    private String orderStatus;
    private Timestamp orderDate;

    private Integer customerId;
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    private Integer warrantyCardId;
    private Timestamp warrantyStartAt;
    private Timestamp warrantyEndAt;
    private Boolean warrantyCancelled;

    public int getSerialId() {
        return serialId;
    }

    public void setSerialId(int serialId) {
        this.serialId = serialId;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getStockStatus() {
        return stockStatus;
    }

    public void setStockStatus(String stockStatus) {
        this.stockStatus = stockStatus;
    }

    public String getSerialStatus() {
        return serialStatus;
    }

    public void setSerialStatus(String serialStatus) {
        this.serialStatus = serialStatus;
    }

    public Timestamp getImportDate() {
        return importDate;
    }

    public void setImportDate(Timestamp importDate) {
        this.importDate = importDate;
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

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public BigDecimal getDevicePrice() {
        return devicePrice;
    }

    public void setDevicePrice(BigDecimal devicePrice) {
        this.devicePrice = devicePrice;
    }

    public Integer getWarrantyMonth() {
        return warrantyMonth;
    }

    public void setWarrantyMonth(Integer warrantyMonth) {
        this.warrantyMonth = warrantyMonth;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public Integer getWarrantyCardId() {
        return warrantyCardId;
    }

    public void setWarrantyCardId(Integer warrantyCardId) {
        this.warrantyCardId = warrantyCardId;
    }

    public Timestamp getWarrantyStartAt() {
        return warrantyStartAt;
    }

    public void setWarrantyStartAt(Timestamp warrantyStartAt) {
        this.warrantyStartAt = warrantyStartAt;
    }

    public Timestamp getWarrantyEndAt() {
        return warrantyEndAt;
    }

    public void setWarrantyEndAt(Timestamp warrantyEndAt) {
        this.warrantyEndAt = warrantyEndAt;
    }

    public Boolean getWarrantyCancelled() {
        return warrantyCancelled;
    }

    public void setWarrantyCancelled(Boolean warrantyCancelled) {
        this.warrantyCancelled = warrantyCancelled;
    }

    public boolean hasCustomer() {
        return customerId != null;
    }

    public boolean hasWarrantyCard() {
        return warrantyCardId != null;
    }

    public String getWarrantyStatusLabel() {
        if (warrantyCardId == null) {
            return "Not assigned";
        }
        if (Boolean.TRUE.equals(warrantyCancelled)) {
            return "Cancelled";
        }
        if (warrantyEndAt == null) {
            return "Pending";
        }
        return warrantyEndAt.after(new java.util.Date()) ? "Active" : "Expired";
    }
}
