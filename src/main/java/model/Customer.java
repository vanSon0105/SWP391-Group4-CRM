package model;

import java.sql.Timestamp;

import model.EnumModel.CustomerEnum;

public class Customer {
	private int id;
	private String username;
	private String password;
	private String email;
	private String full_name;
	private String phone;
	private Role role_id;
	private CustomerEnum status;
    private Timestamp date;
    
    public Customer() {}

	public Customer(int id, String username, String password, String email, String full_name, String phone,
			Role role_id, CustomerEnum status, Timestamp date) {
		super();
		this.id = id;
		this.username = username;
		this.password = password;
		this.email = email;
		this.full_name = full_name;
		this.phone = phone;
		this.role_id = role_id;
		this.status = status;
		this.date = date;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getFull_name() {
		return full_name;
	}

	public void setFull_name(String full_name) {
		this.full_name = full_name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Role getRole_id() {
		return role_id;
	}

	public void setRole_id(Role role_id) {
		this.role_id = role_id;
	}

	public CustomerEnum getStatus() {
		return status;
	}

	public void setStatus(CustomerEnum status) {
		this.status = status;
	}

	public Timestamp getDate() {
		return date;
	}

	public void setDate(Timestamp date) {
		this.date = date;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", username=" + username + ", password=" + password + ", email=" + email
				+ ", full_name=" + full_name + ", phone=" + phone + ", role_id=" + role_id + ", status=" + status
				+ ", date=" + date + "]";
	}
    
}
