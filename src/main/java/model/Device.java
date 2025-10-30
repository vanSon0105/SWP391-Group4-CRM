package model;

import java.sql.Timestamp;

public class Device {
	private int id;
	private Category category;
	private String name;
	private double price;
	private String unit;
	private String imageUrl;
	private int total_sold;
	private String desc;
	private Timestamp created_at;
	private Boolean isFeatured;
	private int device_inventory;
	private String status;
	private int warrantyMonth;

	public Device() {}

	public Device(int id, Category category, String name, double price, String unit, String imageUrl, String desc, Timestamp created_at, Boolean is_featured) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.desc = desc;
		this.created_at = created_at;
		this.isFeatured = is_featured;
	}
	
	
	public Device(int id, String name, double price, String imageUrl) {
		this.id = id;
		this.name = name;
		this.price = price;
		this.imageUrl = imageUrl;
	}
	
	
	public Device(int id, Category category, String name, double price, String imageUrl, int device_inventory, String status) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.imageUrl = imageUrl;
		this.device_inventory = device_inventory;
		this.status = status;
	}
	
	public Device(int id, Category category, String name, double price, String imageUrl, String unit, String desc, Timestamp created_at, int device_inventory) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.imageUrl = imageUrl;
		this.device_inventory = device_inventory;
		this.unit = unit;
		this.desc = desc;
		this.created_at = created_at;
	}
	
	public Device(int id, Category category, String name, double price, String imageUrl, String unit, String desc) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.imageUrl = imageUrl;
		this.unit = unit;
		this.desc = desc;
	}
	
	

	public Device(int id, Category category, String name, double price, String imageUrl, String unit, String desc,
			Boolean is_featured) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.desc = desc;
		this.isFeatured = is_featured;
	}
	
	

	public Device(int id, Category category, String name, double price, String unit, String imageUrl, String desc,
			Timestamp created_at, Boolean is_featured, int device_inventory) {
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.desc = desc;
		this.created_at = created_at;
		this.isFeatured = is_featured;
		this.device_inventory = device_inventory;
		this.status = status;
	}
	
	public Device(int id, Category category, String name, double price, String unit, String imageUrl, String desc,
			Timestamp created_at, Boolean is_featured, int warrantyMonth, int device_inventory) {
		super();
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.desc = desc;
		this.created_at = created_at;
		this.isFeatured = is_featured;
		this.warrantyMonth = warrantyMonth;
	}
	
	

	public Device(int id, Category category, String name, double price, String unit, String imageUrl, int total_sold,
			String desc, Timestamp created_at, Boolean isFeatured, int device_inventory, String status,
			int warrantyMonth) {
		super();
		this.id = id;
		this.category = category;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.total_sold = total_sold;
		this.desc = desc;
		this.created_at = created_at;
		this.isFeatured = isFeatured;
		this.device_inventory = device_inventory;
		this.status = status;
		this.warrantyMonth = warrantyMonth;
	}

	public int getWarrantyMonth() {
		return warrantyMonth;
	}

	public void setWarrantyMonth(int warrantyMonth) {
		this.warrantyMonth = warrantyMonth;
	}

	public Boolean getIsFeatured() {
		return isFeatured;
	}

	public void setIsFeatured(Boolean isFeatured) {
		this.isFeatured = isFeatured;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
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


	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public int getDevice_inventory() {
		return device_inventory;
	}

	public void setDevice_inventory(int device_inventory) {
		this.device_inventory = device_inventory;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Device [id=" + id + ", categoryId=" + category + ", name=" + name + ", price=" + price + ", unit="
				+ unit + ", imageUrl=" + imageUrl;
	}
	
	
	
}
