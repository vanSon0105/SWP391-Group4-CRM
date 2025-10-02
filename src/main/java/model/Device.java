package model;

public class Device {
	private int id;
	private int categoryId;
	private String name;
	private Double price;
	private String unit;
	private String imageUrl;
	private String type;
	
	public Device() {}

	public Device(int id, int categoryId, String name, Double price, String unit, String imageUrl, String type) {
		super();
		this.id = id;
		this.categoryId = categoryId;
		this.name = name;
		this.price = price;
		this.unit = unit;
		this.imageUrl = imageUrl;
		this.type = type;
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

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
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
