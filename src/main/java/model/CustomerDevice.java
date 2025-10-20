package model;

public class CustomerDevice {
	private int warrantyCardId;
    private String deviceName;
    private String serialNumber;

    public CustomerDevice() {}

    public CustomerDevice(int warrantyCardId, String deviceName, String serialNumber) {
        this.warrantyCardId = warrantyCardId;
        this.deviceName = deviceName;
        this.serialNumber = serialNumber;
    }

    public int getWarrantyCardId() {
        return warrantyCardId;
    }

    public void setWarrantyCardId(int warrantyCardId) {
        this.warrantyCardId = warrantyCardId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getDisplayLabel() {
        return deviceName + " (" + serialNumber + ")";
    }
    
    @Override
	public String toString() {
		return "CustomerDevice [warrantyCardId=" + warrantyCardId + ", deviceName=" + deviceName + ", serialNumber="
				+ serialNumber + "]";
	}
}
