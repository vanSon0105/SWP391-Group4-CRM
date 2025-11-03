package model;

public class TransactionDetail {
    private int id;
    private int transactionId;
    private int deviceId;
    private int quantity;
    private String deviceName;

    public TransactionDetail() {}

    public TransactionDetail(int id, int transactionId, int deviceId, int quantity) {
        this.id = id;
        this.transactionId = transactionId;
        this.deviceId = deviceId;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getDeviceId() { return deviceId; }
    public void setDeviceId(int deviceId) { this.deviceId = deviceId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }
}
