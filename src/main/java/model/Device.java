package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Device {
	private int id;
	private int categoryId;
	private String name;
	private BigDecimal price;
	private String unit;
	private String imageUrl;
	private String type;
	private int total_sold;
	private String desc;
	private Timestamp created_at;

	public Device() {}


	public Device(int id, int categoryId, String name, BigDecimal price, String unit, String imageUrl, String type, String desc, Timestamp created_at) {
		super();
		this.id = id;
		this.categoryId = categoryId;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.type = type;
		this.desc = desc;
		this.created_at = created_at;
	}
	
	
	public Device(int id, int categoryId, String name, BigDecimal price, String unit, String imageUrl, String type) {
		super();
		this.id = id;
		this.categoryId = categoryId;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.type = type;
	}


	public int getTotal_sold() {
		return total_sold;
	}

	public void setTotal_sold(int total_sold) {
		this.total_sold = total_sold;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Override
	public String toString() {
		return "Device [id=" + id + ", categoryId=" + categoryId + ", name=" + name + ", price=" + price + ", unit="
				+ unit + ", imageUrl=" + imageUrl + ", type=" + type + "]";
	}
	
	
	
}
