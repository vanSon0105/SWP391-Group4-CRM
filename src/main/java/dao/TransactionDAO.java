package dao;

import java.sql.*;
import java.util.*;
import dal.DBContext;
import model.Transaction;

public class TransactionDAO extends DBContext {

    public int createTransaction(Transaction t) {
        int id = -1;
        String sql = """
            INSERT INTO transactions 
            (storekeeper_id, supplier_id, user_id, type, status, note)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, t.getStorekeeperId());

            if (t.getSupplierId() != null)
                ps.setInt(2, t.getSupplierId());
            else ps.setNull(2, Types.INTEGER);

            if (t.getUserId() != null)
                ps.setInt(3, t.getUserId());
            else ps.setNull(3, Types.INTEGER);

            ps.setString(4, t.getType());
            ps.setString(5, t.getStatus());
            ps.setString(6, t.getNote());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) id = rs.getInt(1);

        } catch (SQLException e) {
            System.out.println("❌ Error in createTransaction: " + e.getMessage());
            e.printStackTrace();
        }
        return id;
    }

    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.*, u.full_name AS storekeeper_name,
                   s.name AS supplier_name, cu.full_name AS customer_name
            FROM transactions t
            LEFT JOIN users u ON t.storekeeper_id = u.id
            LEFT JOIN suppliers s ON t.supplier_id = s.id
            LEFT JOIN users cu ON t.user_id = cu.id
            ORDER BY t.date DESC
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setId(rs.getInt("id"));
                t.setStorekeeperId(rs.getInt("storekeeper_id"));
                t.setUserId((Integer) rs.getObject("user_id"));
                t.setSupplierId((Integer) rs.getObject("supplier_id"));
                t.setType(rs.getString("type"));
                t.setStatus(rs.getString("status"));
                t.setDate(rs.getTimestamp("date"));
                t.setNote(rs.getString("note"));
                t.setStorekeeperName(rs.getString("storekeeper_name"));
                t.setSupplierName(rs.getString("supplier_name"));
                t.setUserName(rs.getString("customer_name"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateTransactionStatus(int id, String status) {
        String sql = "UPDATE transactions SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTransaction(int transactionId) {
        String sqlDetail = "DELETE FROM transaction_details WHERE transaction_id = ?";
        String sqlTransaction = "DELETE FROM transactions WHERE id = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                psDetail.setInt(1, transactionId);
                psDetail.executeUpdate();
            }

            try (PreparedStatement psTransaction = conn.prepareStatement(sqlTransaction)) {
                psTransaction.setInt(1, transactionId);
                psTransaction.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
