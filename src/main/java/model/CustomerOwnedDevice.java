package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CustomerOwnedDevice {
	private int deviceId;
	private String deviceName;
	private String imageUrl;
	private int totalUnits;
	private int unitsWithIssue;
	private Timestamp latestPurchaseAt;
	private long daysSinceLatestPurchase;
	private final List<CustomerOwnedDeviceUnit> units = new ArrayList<>();

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

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public int getTotalUnits() {
		return totalUnits;
	}

	public void setTotalUnits(int totalUnits) {
		this.totalUnits = totalUnits;
	}

	public int getUnitsWithIssue() {
		return unitsWithIssue;
	}

	public void incrementUnitsWithIssue() {
		this.unitsWithIssue++;
	}

	public Timestamp getLatestPurchaseAt() {
		return latestPurchaseAt;
	}

	public void setLatestPurchaseAt(Timestamp latestPurchaseAt) {
		this.latestPurchaseAt = latestPurchaseAt;
	}

	public long getDaysSinceLatestPurchase() {
		return daysSinceLatestPurchase;
	}

	public void setDaysSinceLatestPurchase(long daysSinceLatestPurchase) {
		this.daysSinceLatestPurchase = daysSinceLatestPurchase;
	}

	public List<CustomerOwnedDeviceUnit> getUnits() {
		return units;
	}
}
