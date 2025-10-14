package model;

public class UserPreference {
    private int id;
    private int userId;
    private boolean promoEmails;
    private boolean orderUpdates;
    private boolean newProducts;
    private boolean warrantyReminders;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public boolean isPromoEmails() { return promoEmails; }
    public void setPromoEmails(boolean promoEmails) { this.promoEmails = promoEmails; }

    public boolean isOrderUpdates() { return orderUpdates; }
    public void setOrderUpdates(boolean orderUpdates) { this.orderUpdates = orderUpdates; }

    public boolean isNewProducts() { return newProducts; }
    public void setNewProducts(boolean newProducts) { this.newProducts = newProducts; }

    public boolean isWarrantyReminders() { return warrantyReminders; }
    public void setWarrantyReminders(boolean warrantyReminders) { this.warrantyReminders = warrantyReminders; }
}
