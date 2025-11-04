package model;

public class Inventory {
	 private int id;
	    private int storekeeperId;
	    private int deviceId;
	    private int quantity;
	    private String storekeeperName;
	    private String deviceName;

	    public Inventory() {}

	    public Inventory(int id, int storekeeperId, int deviceId, int quantity) {
	        this.id = id;
	        this.storekeeperId = storekeeperId;
	        this.deviceId = deviceId;
	        this.quantity = quantity;
	    }

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public int getStorekeeperId() {
			return storekeeperId;
		}

		public void setStorekeeperId(int storekeeperId) {
			this.storekeeperId = storekeeperId;
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

		public String getStorekeeperName() {
			return storekeeperName;
		}

		public void setStorekeeperName(String storekeeperName) {
			this.storekeeperName = storekeeperName;
		}

		public String getDeviceName() {
			return deviceName;
		}

		public void setDeviceName(String deviceName) {
			this.deviceName = deviceName;
		}
	    
	    
}
