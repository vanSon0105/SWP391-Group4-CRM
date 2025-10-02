package model;

public class DeviceDetail {
    private int id;
    private int inventoryId;
    private int deviceId;
    private String description;
    private String serialNo;
    private String status;
    
    public DeviceDetail() {
    }

    public DeviceDetail(int id, int inventoryId, int deviceId, String description, String serialNo, String status) {
        this.id = id;
        this.inventoryId = inventoryId;
        this.deviceId = deviceId;
        this.description = description;
        this.serialNo = serialNo;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "DeviceDetail [id=" + id + ", inventoryId=" + inventoryId + ", deviceId=" + deviceId
                + ", description=" + description + ", serialNo=" + serialNo + ", status=" + status + "]";
    }
}

