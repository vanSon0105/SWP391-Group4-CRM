package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import dal.DBContext;
import model.IssuePayment;

public class IssuePaymentDAO extends DBContext {
	
	private static final int PAGE_SIZE = 10;

	private IssuePayment mapRow(ResultSet rs) throws SQLException {
		IssuePayment p = new IssuePayment();
		p.setId(rs.getInt("id"));
		p.setIssueId(rs.getInt("issue_id"));
		p.setAmount(rs.getDouble("amount"));
		p.setNote(rs.getString("note"));
		p.setShippingFullName(rs.getString("shipping_full_name"));
		p.setShippingPhone(rs.getString("shipping_phone"));
		p.setShippingAddress(rs.getString("shipping_address"));
		p.setShippingNote(rs.getString("shipping_note"));
		p.setStatus(rs.getString("status"));
		p.setCreatedBy(rs.getInt("created_by"));
		int approved = rs.getInt("approved_by");
		if (!rs.wasNull()) {
			p.setApprovedBy(approved);
		}
		int confirmed = rs.getInt("confirmed_by");
		if (!rs.wasNull()) {
			p.setConfirmedBy(confirmed);
		}
		p.setCreatedAt(rs.getTimestamp("created_at"));
		p.setUpdatedAt(rs.getTimestamp("updated_at"));
		p.setPaidAt(rs.getTimestamp("paid_at"));
		return p;
	}

	public IssuePayment getByIssueId(int issueId) {
		String sql = "SELECT * FROM issue_payments WHERE issue_id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, issueId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public Map<Integer, IssuePayment> getByIssueIds(List<Integer> issueIds) {
		if (issueIds == null || issueIds.isEmpty()) {
			return Collections.emptyMap();
		}
		StringBuilder sb = new StringBuilder("SELECT * FROM issue_payments WHERE issue_id IN (");
		for (int i = 0; i < issueIds.size(); i++) {
			if (i > 0) {
				sb.append(',');
			}
			sb.append('?');
		}
		sb.append(')');

		Map<Integer, IssuePayment> map = new HashMap<>();
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sb.toString())) {
			for (int i = 0; i < issueIds.size(); i++) {
				ps.setInt(i + 1, issueIds.get(i));
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					IssuePayment p = mapRow(rs);
					map.put(p.getIssueId(), p);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return map;
	}

	public IssuePayment createOrUpdateDraft(int issueId, int createdBy, double amount, String note) {
		IssuePayment existing = getByIssueId(issueId);
		if (existing == null) {
			String insert = "INSERT INTO issue_payments (issue_id, amount, note, status, created_by) "
					+ "VALUES (?, ?, ?, 'awaiting_support', ?)";
			try (Connection conn = getConnection();
					PreparedStatement ps = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
				ps.setInt(1, issueId);
				ps.setDouble(2, amount);
				ps.setString(3, note);
				ps.setInt(4, createdBy);
				if (ps.executeUpdate() > 0) {
					try (ResultSet rs = ps.getGeneratedKeys()) {
						if (rs.next()) {
							int newId = rs.getInt(1);
							return getById(newId);
						}
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return null;
		}

		if (!existing.isAwaitingSupport()) {
			return existing;
		}

		String update = "UPDATE issue_payments SET amount = ?, note = ?, updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(update)) {
			ps.setDouble(1, amount);
			ps.setString(2, note);
			ps.setInt(3, existing.getId());
			ps.executeUpdate();
			return getById(existing.getId());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public IssuePayment getById(int id) {
		String sql = "SELECT * FROM issue_payments WHERE id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean approveForCustomer(int paymentId, int supportStaffId) {
		String sql = "UPDATE issue_payments SET status = 'awaiting_customer', approved_by = ?, updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status = 'awaiting_support'";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, supportStaffId);
			ps.setInt(2, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean markPaidByCustomer(int paymentId, int customerId, String fullName, String phone, String address,
			String shippingNote) {
		String sql = "UPDATE issue_payments SET shipping_full_name = ?, shipping_phone = ?, shipping_address = ?, shipping_note = ?, "
				+ "status = 'paid', confirmed_by = ?, paid_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status = 'awaiting_customer'";
		try (Connection conn = getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setString(1, fullName.trim());
				ps.setString(2, phone.trim());
				ps.setString(3, address.trim());
			if (shippingNote == null || shippingNote.trim().isEmpty()) {
				ps.setNull(4, Types.VARCHAR);
			} else {
				ps.setString(4, shippingNote.trim());
			}
			ps.setInt(5, customerId);
			ps.setInt(6, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean closeAfterFeedback(int paymentId) {
		String sql = "UPDATE issue_payments SET status = 'closed', updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status = 'paid'";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean hasStaffOwnership(int issueId, int staffId) {
		String sql = "SELECT COUNT(*) FROM task_details td "
				+ "JOIN tasks t ON td.task_id = t.id "
				+ "WHERE t.customer_issue_id = ? AND td.technical_staff_id = ?";
		try (Connection conn = getConnection(); 
			PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, issueId);
			ps.setInt(2, staffId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateSupportNote(int paymentId, double amount, String note) {
		String sql = "UPDATE issue_payments SET amount = ?, note = ?, updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status = 'awaiting_support'";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setDouble(1, amount);
			ps.setString(2, note);
			ps.setInt(3, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean reopenForCustomer(int paymentId, int supportStaffId) {
		String sql = "UPDATE issue_payments SET status = 'awaiting_customer', approved_by = ?, updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status = 'paid'";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, supportStaffId);
			ps.setInt(2, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateStatus(int paymentId, String status, Integer actorId, Timestamp paidAt) {
		StringBuilder sql = new StringBuilder("UPDATE issue_payments SET status = ?, updated_at = CURRENT_TIMESTAMP");
		if (actorId != null) {
			if ("awaiting_customer".equalsIgnoreCase(status)) {
				sql.append(", approved_by = ").append(actorId);
			} else if ("paid".equalsIgnoreCase(status)) {
				sql.append(", confirmed_by = ").append(actorId);
			}
		}
		if (paidAt != null) {
			sql.append(", paid_at = ?");
		}
		sql.append(" WHERE id = ?");
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setString(1, status);
			int index = 2;
			if (paidAt != null) {
				ps.setTimestamp(index++, paidAt);
			}
			ps.setInt(index, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<IssuePayment> getPayments(String status, String sortField, int page, String search) throws SQLException {
	    List<IssuePayment> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder("SELECT * FROM issue_payments WHERE 1=1 ");
	    
	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND status = ? ");
	    }

	    if (search != null && !search.trim().isEmpty()) {
	        sql.append(" AND (shipping_full_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?) ");
	    }

	    if (sortField == null || sortField.isEmpty()) {
	        sortField = "created_at";
	    }
	    sql.append(" ORDER BY ").append(sortField).append(" DESC ");
	    sql.append(" LIMIT ? OFFSET ? ");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int idx = 1;
	        if (status != null && !status.isEmpty()) {
	            ps.setString(idx++, status);
	        }

	        if (search != null && !search.trim().isEmpty()) {
	            String searchLike = "%" + search.trim() + "%";
	            ps.setString(idx++, searchLike);
	            ps.setString(idx++, searchLike);
	            ps.setString(idx++, searchLike);
	        }

	        ps.setInt(idx++, PAGE_SIZE);
	        ps.setInt(idx, (page - 1) * PAGE_SIZE);

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            IssuePayment p = new IssuePayment();
	            p.setId(rs.getInt("id"));
	            p.setIssueId(rs.getInt("issue_id"));
	            p.setAmount(rs.getDouble("amount"));
	            p.setNote(rs.getString("note"));
	            p.setShippingFullName(rs.getString("shipping_full_name"));
	            p.setShippingPhone(rs.getString("shipping_phone"));
	            p.setShippingAddress(rs.getString("shipping_address"));
	            p.setShippingNote(rs.getString("shipping_note"));
	            p.setStatus(rs.getString("status"));
	            p.setCreatedBy(rs.getInt("created_by"));
	            p.setApprovedBy((Integer) rs.getObject("approved_by"));
	            p.setConfirmedBy((Integer) rs.getObject("confirmed_by"));
	            p.setCreatedAt(rs.getTimestamp("created_at"));
	            p.setUpdatedAt(rs.getTimestamp("updated_at"));
	            p.setPaidAt(rs.getTimestamp("paid_at"));
	            list.add(p);
	        }
	    }
	    return list;
	}

	public int countPayments(String status, String search) throws SQLException {
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM issue_payments WHERE 1=1 ");
	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND status = ? ");
	    }

	    if (search != null && !search.trim().isEmpty()) {
	        sql.append(" AND (shipping_full_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?) ");
	    }

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int idx = 1;
	        if (status != null && !status.isEmpty()) {
	            ps.setString(idx++, status);
	        }

	        if (search != null && !search.trim().isEmpty()) {
	            String searchLike = "%" + search.trim() + "%";
	            ps.setString(idx++, searchLike);
	            ps.setString(idx++, searchLike);
	            ps.setString(idx++, searchLike);
	        }

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }
	    return 0;
	}
	
	public List<IssuePayment> getPaymentsByCustomer(int customerId, String status, String keyword, int page) throws SQLException {
	    List<IssuePayment> list = new ArrayList<>();
	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT ip.* ")
	       .append("FROM issue_payments ip ")
	       .append("JOIN customer_issues ci ON ip.issue_id = ci.id ")
	       .append("WHERE ci.customer_id = ? ");

	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND ip.status = ? ");
	    }

	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append(" AND (ip.shipping_full_name LIKE ? OR ip.shipping_phone LIKE ? OR ip.shipping_address LIKE ?) ");
	    }

	    sql.append(" ORDER BY ip.created_at DESC ")
	       .append(" LIMIT ? OFFSET ? ");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int idx = 1;
	        ps.setInt(idx++, customerId);

	        if (status != null && !status.isEmpty()) {
	            ps.setString(idx++, status);
	        }

	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            ps.setString(idx++, kw);
	            ps.setString(idx++, kw);
	            ps.setString(idx++, kw);
	        }

	        ps.setInt(idx++, PAGE_SIZE);
	        ps.setInt(idx, (page - 1) * PAGE_SIZE); 

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            IssuePayment p = new IssuePayment();
	            p.setId(rs.getInt("id"));
	            p.setIssueId(rs.getInt("issue_id"));
	            p.setAmount(rs.getDouble("amount"));
	            p.setNote(rs.getString("note"));
	            p.setShippingFullName(rs.getString("shipping_full_name"));
	            p.setShippingPhone(rs.getString("shipping_phone"));
	            p.setShippingAddress(rs.getString("shipping_address"));
	            p.setShippingNote(rs.getString("shipping_note"));
	            p.setStatus(rs.getString("status"));
	            p.setCreatedBy(rs.getInt("created_by"));
	            p.setApprovedBy((Integer) rs.getObject("approved_by"));
	            p.setConfirmedBy((Integer) rs.getObject("confirmed_by"));
	            p.setCreatedAt(rs.getTimestamp("created_at"));
	            p.setUpdatedAt(rs.getTimestamp("updated_at"));
	            p.setPaidAt(rs.getTimestamp("paid_at"));
	            list.add(p);
	        }
	    }
	    return list;
	}

	public int countPaymentsByCustomer(int customerId, String status, String keyword) throws SQLException {
	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT COUNT(*) ")
	       .append("FROM issue_payments ip ")
	       .append("JOIN customer_issues ci ON ip.issue_id = ci.id ")
	       .append("WHERE ci.customer_id = ? ");

	    if (status != null && !status.isEmpty()) {
	        sql.append(" AND ip.status = ? ");
	    }

	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append(" AND (ip.shipping_full_name LIKE ? OR ip.shipping_phone LIKE ? OR ip.shipping_address LIKE ?) ");
	    }

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

	        int idx = 1;
	        ps.setInt(idx++, customerId);

	        if (status != null && !status.isEmpty()) {
	            ps.setString(idx++, status);
	        }

	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String kw = "%" + keyword.trim() + "%";
	            ps.setString(idx++, kw);
	            ps.setString(idx++, kw);
	            ps.setString(idx++, kw);
	        }

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }
	    return 0;
	}

	public boolean updateCustomerShippingInfo(int paymentId, String fullName, String phone, String address, String shippingNote) {
		String sql = "UPDATE issue_payments SET shipping_full_name = ?, shipping_phone = ?, shipping_address = ?, shipping_note = ?, "
				+ "updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status IN ('awaiting_customer','awaiting_admin')";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, fullName.trim());
			ps.setString(2, phone.trim());
			ps.setString(3, address.trim());
			if (shippingNote == null || shippingNote.trim().isEmpty()) {
				ps.setNull(4, Types.VARCHAR);
			} else {
				ps.setString(4, shippingNote.trim());
			}
			ps.setInt(5, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean markAwaitingAdminConfirmation(int paymentId) {
		String sql = "UPDATE issue_payments SET status = 'awaiting_admin', updated_at = CURRENT_TIMESTAMP "
				+ "WHERE id = ? AND status IN ('awaiting_customer','awaiting_admin')";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean confirmPaymentByAdmin(int paymentId, int adminId) {
		String sql = "UPDATE issue_payments SET status = 'paid', confirmed_by = ?, paid_at = CURRENT_TIMESTAMP, "
				+ "updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'awaiting_admin'";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, adminId);
			ps.setInt(2, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

}
