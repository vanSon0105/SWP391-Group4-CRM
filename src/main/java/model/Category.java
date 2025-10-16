package model;

public class Category {
	private int id;
	private String name;
	private boolean hasDevice;
	public Category() {
	}
	public Category(int id, String name, boolean hasDevice) {
		this.id = id;
		this.name = name;
		this.hasDevice = hasDevice;
	}
	
	public Category(int id, String name) {
		this.id = id;
		this.name = name;
	}
	public int getId() {
		return id;
	}
	public boolean isHasDevice() {
		return hasDevice;
	}
	public void setHasDevice(boolean hasDevice) {
		this.hasDevice = hasDevice;
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
	@Override
	public String toString() {
		return "Category [id=" + id + ", categoryName=" + name + "]";
	}

}
