package model;

import java.sql.Date;
import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String imageUrl;
    private String fullName;
    private String phone;
    private String gender;       
    private Timestamp birthday;       
    private int roleId;
    private String status;       
    private Timestamp createdAt;
    private Timestamp lastLoginAt;
    private boolean usernameChanged;

    public User() {}

    public User(int id, String username, String email, String fullName, String phone, String gender, Timestamp birthday, String imageUrl, int roleId) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.gender = gender;
        this.birthday = birthday;
        this.imageUrl = imageUrl;
        this.roleId = roleId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Timestamp getBirthday() { 
    	return birthday; 
    	}
    public void setBirthday(Timestamp birthday) { this.birthday = birthday; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Timestamp lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public boolean isUsernameChanged() { return usernameChanged; }
    public void setUsernameChanged(boolean usernameChanged) { this.usernameChanged = usernameChanged; }

    public String getRole() {
        switch (this.roleId) {
            case 1: return "admin";
            case 2: return "technical_manager";
            case 3: return "technical_staff";
            case 4: return "customer_support_staff";
            case 5: return "storekeeper";
            case 6: return "customer";
            default: return "unknown";
        }
    }
}
