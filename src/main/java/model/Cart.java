package model;

public class Cart {
	private int id;
	private double sum;
	private int userId;
	
	public Cart() {}

	public Cart(int id, double sum, int userId) {
		super();
		this.id = id;
		this.sum = sum;
		this.userId = userId;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public double getSum() {
		return sum;
	}

	public void setSum(double sum) {
		this.sum = sum;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	
}
