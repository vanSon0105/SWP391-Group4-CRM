package model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items;

    public Cart() {
        items = new HashMap<>();
    }

    // Thêm sản phẩm
    public void addItem(CartItem item) {
        if (items.containsKey(item.getDeviceId())) {
            CartItem existing = items.get(item.getDeviceId());
            existing.setQuantity(existing.getQuantity() + item.getQuantity());
        } else {
            items.put(item.getDeviceId(), item);
        }
    }

    // Xóa sản phẩm
    public void removeItem(int deviceId) {
        items.remove(deviceId);
    }

    // Cập nhật số lượng
    public void updateQuantity(int deviceId, int quantity) {
        if (items.containsKey(deviceId)) {
            items.get(deviceId).setQuantity(quantity);
        }
    }

    // Tính tổng tiền
    public BigDecimal getTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public int getTotalQuantity() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public void clear() {
        items.clear();
    }
}
