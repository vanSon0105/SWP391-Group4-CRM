package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SupplierDetail {
    private int id;
    private int supplierId;
    private int deviceId;
    private String deviceName;
    private BigDecimal price;
    private Timestamp date;

    public SupplierDetail() {}

    public SupplierDetail(int id, int supplierId, int deviceId, String deviceName, BigDecimal price, Timestamp date) {
        this.id = id;
        this.supplierId = supplierId;
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.price = price;
        this.date = date;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
}
