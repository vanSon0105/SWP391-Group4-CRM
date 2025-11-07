package model;

public class Sale {
	private int month;
	private int year;
	private double revenue;
	private double profit;

	public Sale(int month, int year, double revenue, double profit) {
		this.month = month;
		this.year = year;
		this.revenue = revenue;
		this.profit = profit;
	}

	public int getMonth() {
		return month;
	}

	public int getYear() {
		return year;
	}

	public double getRevenue() {
		return revenue;
	}

	public double getProfit() {
		return profit;
	}

	public void setMonth(int month) {
		this.month = month;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public void setRevenue(double revenue) {
		this.revenue = revenue;
	}

	public void setProfit(double profit) {
		this.profit = profit;
	}
}
