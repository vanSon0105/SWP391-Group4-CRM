package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CustomerOwnedDeviceUnit {
	private int warrantyCardId;
	private String serialNo;
	private Timestamp purchaseDate;
	private Timestamp warrantyEnd;
	private long daysSincePurchase;
	private boolean hasIssue;
	private String latestIssueStatus;
	private String latestIssueCode;
	private Integer latestIssueId;
	private List<CustomerIssue> issues = new ArrayList<>();

	public int getWarrantyCardId() {
		return warrantyCardId;
	}

	public void setWarrantyCardId(int warrantyCardId) {
		this.warrantyCardId = warrantyCardId;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public Timestamp getPurchaseDate() {
		return purchaseDate;
	}

	public void setPurchaseDate(Timestamp purchaseDate) {
		this.purchaseDate = purchaseDate;
	}

	public Timestamp getWarrantyEnd() {
		return warrantyEnd;
	}

	public void setWarrantyEnd(Timestamp warrantyEnd) {
		this.warrantyEnd = warrantyEnd;
	}

	public long getDaysSincePurchase() {
		return daysSincePurchase;
	}

	public void setDaysSincePurchase(long daysSincePurchase) {
		this.daysSincePurchase = daysSincePurchase;
	}

	public boolean isHasIssue() {
		return hasIssue;
	}

	public void setHasIssue(boolean hasIssue) {
		this.hasIssue = hasIssue;
	}

	public String getLatestIssueStatus() {
		return latestIssueStatus;
	}

	public void setLatestIssueStatus(String latestIssueStatus) {
		this.latestIssueStatus = latestIssueStatus;
	}

	public String getLatestIssueCode() {
		return latestIssueCode;
	}

	public void setLatestIssueCode(String latestIssueCode) {
		this.latestIssueCode = latestIssueCode;
	}

	public Integer getLatestIssueId() {
		return latestIssueId;
	}

	public void setLatestIssueId(Integer latestIssueId) {
		this.latestIssueId = latestIssueId;
	}

	public boolean isWarrantyExpired() {
		return warrantyEnd != null && warrantyEnd.before(new Timestamp(System.currentTimeMillis()));
	}

	public List<CustomerIssue> getIssues() {
		return issues;
	}

	public void setIssues(List<CustomerIssue> issues) {
		this.issues = issues;
	}
}
