package dao;

import java.util.*;
import java.sql.*;

import model.CustomerDevice;
import model.CustomerIssue;
import model.CustomerOwnedDevice;
import model.CustomerOwnedDeviceUnit;
import dal.DBContext;

public class CustomerIssueDAO extends DBContext {

	public List<CustomerIssue> getAllIssues() {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "select id, title from customer_issues";
		try {
			Connection conn = getConnection();
			PreparedStatement pre = conn.prepareStatement(sql);
			ResultSet rs = pre.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getString("title")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Integer findLatestIssueIdForCustomer(int customerId) {
		String sql = "SELECT id FROM customer_issues WHERE customer_id = ? ORDER BY created_at DESC, id DESC LIMIT 1";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt("id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String getSupportStatus(int taskDetailId) {
	    String sql = "SELECT ci.support_status FROM customer_issues ci "
	            + "JOIN tasks t ON t.customer_issue_id = ci.id "
	            + "JOIN task_details td ON td.task_id = t.id "
	            + "WHERE td.id = ?";
	    
	    try (Connection conn = getConnection();
	         PreparedStatement pre = conn.prepareStatement(sql)) {
	        
	        pre.setInt(1, taskDetailId);
	        
	        try (ResultSet rs = pre.executeQuery()) {
	            if (rs.next()) {
	                return rs.getString("support_status");
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public List<CustomerDevice> getCustomerDevices(int customerId) {
	    List<CustomerDevice> list = new ArrayList<>();
	    String sql = "SELECT wc.id AS warranty_id, d.name AS device_name, ds.serial_no, "
	            + " EXISTS (SELECT 1 FROM customer_issues ci "
	            + "         WHERE ci.warranty_card_id = wc.id "
	            + "         AND ci.support_status NOT IN ('resolved', 'customer_cancelled')) AS has_active_issue "
	            + "FROM warranty_cards wc "
	            + "JOIN device_serials ds ON ds.id = wc.device_serial_id "
	            + "JOIN devices d ON d.id = ds.device_id "
	            + "WHERE wc.customer_id = ? "
	            + "ORDER BY wc.start_at DESC";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        ps.setInt(1, customerId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            boolean active = rs.getBoolean("has_active_issue");
	            list.add(
	                    new CustomerDevice(rs.getInt("warranty_id"), rs.getString("device_name"), rs.getString("serial_no"), active));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public List<CustomerIssue> getIssuesByUserId(int id) {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE customer_id = ? ORDER BY created_at DESC";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"),
						rs.getString("issue_type"), rs.getString("feedback")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private String generateIssueCode() {
		return "ISS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
	}

	public boolean createIssue(int customerId, String title, String description, String issueType, int warrantyCardId) {
		String sql = "INSERT INTO customer_issues (customer_id, issue_code, title, description, issue_type, warranty_card_id, created_at) "
				+ "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ps.setString(2, generateIssueCode());
			ps.setString(3, title);
			ps.setString(4, description);
			ps.setString(5, issueType);

			if (warrantyCardId == 0) {
				ps.setNull(6, java.sql.Types.INTEGER);
			} else {
				ps.setInt(6, warrantyCardId);
			}

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public CustomerIssue getIssueById(int id) {
		String sql = "SELECT * FROM customer_issues WHERE id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"),
						rs.getString("issue_type"), rs.getString("feedback"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<CustomerIssue> getUnassignedIssues() {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE support_staff_id IS NULL OR support_status = 'new' ORDER BY created_at ASC";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"),
						rs.getString("issue_type"), rs.getString("feedback")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<CustomerIssue> getIssuesAssignedToStaff(int staffId) {
		List<CustomerIssue> list = new ArrayList<>();
		String sql = "SELECT * FROM customer_issues WHERE support_staff_id = ? ORDER BY created_at DESC";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, staffId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"),
						rs.getString("issue_type"), rs.getString("feedback")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean assignIssueIfAvailable(int issueId, int staffId) {
		String sql = "UPDATE customer_issues SET support_staff_id = ?, support_status = 'in_progress' WHERE id = ? AND support_staff_id IS NULL";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, staffId);
			ps.setInt(2, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateSupportStatus(int issueId, int staffId, String status) {
		String sql = "UPDATE customer_issues SET support_status = ?, support_staff_id = ? WHERE id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, staffId);
			ps.setInt(3, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<CustomerIssue> getIssuesBySupportStatuses(String[] statuses) {
		List<CustomerIssue> list = new ArrayList<>();
		if (statuses == null || statuses.length == 0) {
			return list;
		}

		String sql = "SELECT * FROM customer_issues WHERE support_status IN (";
		for (int i = 0; i < statuses.length; i++) {
			if (i > 0) {
				sql += (',');
			}
			sql += ('?');
		}
		sql += (") ORDER BY created_at ASC");

		try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			for (int i = 0; i < statuses.length; i++) {
				ps.setString(i + 1, statuses[i]);
			}
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"), rs.getString("issue_code"),
						rs.getString("title"), rs.getString("description"), rs.getInt("warranty_card_id"),
						rs.getTimestamp("created_at"), rs.getInt("support_staff_id"), rs.getString("support_status"),
						rs.getString("issue_type"), rs.getString("feedback")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean updateSupportStatus(int issueId, String status) {
		String sql = "UPDATE customer_issues SET support_status = ? WHERE id = ?";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<CustomerIssue> getIssuesReadyForManager() {
		return getIssuesBySupportStatuses(new String[] { "manager_approved" });
	}

	public boolean updateFeedback(int issueId, String feedback) {
		String sql = "UPDATE customer_issues SET feedback = ? WHERE id = ?";
		try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
			if (feedback == null) {
				ps.setNull(1, Types.VARCHAR);
			} else {
				ps.setString(1, feedback);
			}
			ps.setInt(2, issueId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	private boolean hasActiveIssue(int warrantyCardId) {
		String sql = "SELECT COUNT(*) FROM customer_issues WHERE warranty_card_id = ? AND support_status NOT IN ('resolved', 'customer_cancelled')";
		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, warrantyCardId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<CustomerIssue> getIssuesWithoutTask() {
	    List<CustomerIssue> list = new ArrayList<>();
	    String sql = "SELECT ci.* FROM customer_issues ci "
	               + "WHERE ci.support_status = 'manager_approved' "
	               + "AND NOT EXISTS ("
	               + "  SELECT 1 FROM tasks t WHERE t.customer_issue_id = ci.id AND t.is_cancelled = FALSE"
	               + ") "
	               + "ORDER BY ci.created_at DESC";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(new CustomerIssue(
						rs.getInt("id"),
						rs.getString("title")));
			}

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}



	public List<CustomerIssue> getIssuesForTask(int currentIssueId) {
	    List<CustomerIssue> list = new ArrayList<>();
	    String sql = "SELECT * FROM customer_issues WHERE id = ? " +
	                 "UNION " +
	                 "SELECT ci.* FROM customer_issues ci " +
	                 "WHERE ci.support_status = 'manager_approved' " +
	                 "AND NOT EXISTS ( " +
	                 "  SELECT 1 FROM tasks t " +
	                 "  WHERE t.customer_issue_id = ci.id " +
	                 "    AND t.is_cancelled = FALSE " +
	                 ") " +
	                 "ORDER BY created_at DESC";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, currentIssueId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            list.add(new CustomerIssue(
	                rs.getInt("id"),
	                rs.getString("title")
	            ));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public List<CustomerOwnedDevice> getOwnedDevicesByCustomer(int customerId, int offset, int limit,
	        String keyword) {
	    
	    if (limit <= 0) {
	        return Collections.emptyList();
	    }
	    
	    // --- BƯỚC 1: Lấy danh sách ID thiết bị (Pagination) ---
	    List<Integer> deviceIds = new ArrayList<>();
	    List<Object> params = new ArrayList<>(); // Lưu tham số keyword nếu có
	    
	    StringBuilder idSql = new StringBuilder("SELECT d.id "
	            + "FROM warranty_cards wc "
	            + "JOIN device_serials ds ON ds.id = wc.device_serial_id "
	            + "JOIN devices d ON d.id = ds.device_id "
	            + "WHERE wc.customer_id = ? ");

	    if (keyword != null && !keyword.isEmpty()) {
	        idSql.append("AND (LOWER(d.name) LIKE ? OR LOWER(ds.serial_no) LIKE ?) ");
	        String like = "%" + keyword.toLowerCase() + "%";
	        params.add(like);
	        params.add(like);
	    }
	    idSql.append("GROUP BY d.id ORDER BY MAX(wc.start_at) DESC, d.name ASC LIMIT ? OFFSET ?");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(idSql.toString())) {
	        
	        int idx = 1;
	        ps.setInt(idx++, customerId);
	        
	        for (Object param : params) {
	            if (param instanceof String) {
	                ps.setString(idx++, (String) param);
	            }
	        }
	        
	        ps.setInt(idx++, limit);
	        ps.setInt(idx, offset);
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                deviceIds.add(rs.getInt(1));
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    if (deviceIds.isEmpty()) {
	        return Collections.emptyList();
	    }

	    // --- BƯỚC 2: Lấy chi tiết units (serials) cho các ID đã tìm được ---
	    // Sử dụng List thay vì Map
	    List<CustomerOwnedDevice> resultList = new ArrayList<>();
	    CustomerOwnedDevice currentSummary = null; // Biến tạm để theo dõi model hiện tại

	    String placeholders = String.join(",", Collections.nCopies(deviceIds.size(), "?"));
	    
	    StringBuilder detailSql = new StringBuilder("SELECT d.id AS device_id, d.name AS device_name, d.image_url, "
	            + "wc.id AS warranty_id, wc.start_at, wc.end_at, ds.serial_no, "
	            + "TIMESTAMPDIFF(DAY, wc.start_at, NOW()) AS days_since_purchase, "
	            + "latest_issue.id AS issue_id, latest_issue.issue_code, latest_issue.support_status "
	            + "FROM warranty_cards wc "
	            + "JOIN device_serials ds ON ds.id = wc.device_serial_id "
	            + "JOIN devices d ON d.id = ds.device_id "
	            + "LEFT JOIN ( "
	            + "    SELECT ci1.* FROM customer_issues ci1 "
	            + "    JOIN ( "
	            + "        SELECT warranty_card_id, MAX(created_at) AS latest_created "
	            + "        FROM customer_issues "
	            + "        GROUP BY warranty_card_id "
	            + "    ) latest ON latest.warranty_card_id = ci1.warranty_card_id "
	            + "        AND latest.latest_created = ci1.created_at "
	            + ") latest_issue ON latest_issue.warranty_card_id = wc.id "
	            + "WHERE wc.customer_id = ? "
	            + "AND d.id IN (" + placeholders + ") "
	            // Quan trọng: ORDER BY FIELD giúp gom nhóm các dòng cùng device_id lại gần nhau
	            + "ORDER BY FIELD(d.id, " + placeholders + "), wc.start_at DESC");

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(detailSql.toString())) {
	        
	        int idx = 1;
	        ps.setInt(idx++, customerId);
	        
	        // Tham số cho mệnh đề IN (...)
	        for (Integer id : deviceIds) {
	            ps.setInt(idx++, id);
	        }
	        
	        // Tham số cho mệnh đề ORDER BY FIELD(...)
	        for (Integer id : deviceIds) {
	            ps.setInt(idx++, id);
	        }
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                int deviceId = rs.getInt("device_id");

	                // Logic thay thế Map: Kiểm tra xem có chuyển sang thiết bị mới chưa
	                // Vì đã ORDER BY device_id, nên các dòng cùng ID sẽ nằm liền nhau
	                if (currentSummary == null || currentSummary.getDeviceId() != deviceId) {
	                    currentSummary = new CustomerOwnedDevice();
	                    currentSummary.setDeviceId(deviceId);
	                    currentSummary.setDeviceName(rs.getString("device_name"));
	                    currentSummary.setImageUrl(rs.getString("image_url"));
	                    
	                    // Thêm model mới vào danh sách kết quả
	                    resultList.add(currentSummary);
	                }

	                // --- Xử lý thông tin từng Unit (Serial/Thẻ bảo hành) ---
	                CustomerOwnedDeviceUnit unit = new CustomerOwnedDeviceUnit();
	                unit.setWarrantyCardId(rs.getInt("warranty_id"));
	                unit.setSerialNo(rs.getString("serial_no"));
	                unit.setPurchaseDate(rs.getTimestamp("start_at"));
	                unit.setWarrantyEnd(rs.getTimestamp("end_at"));
	                unit.setDaysSincePurchase(rs.getLong("days_since_purchase"));

	                Integer issueId = (Integer) rs.getObject("issue_id");
	                boolean hasIssue = issueId != null;
	                unit.setHasIssue(hasIssue);
	                
	                if (hasIssue) {
	                    unit.setLatestIssueId(issueId);
	                    unit.setLatestIssueCode(rs.getString("issue_code"));
	                    unit.setLatestIssueStatus(rs.getString("support_status"));
	                    currentSummary.incrementUnitsWithIssue();
	                }

	                // Thêm unit vào model hiện tại
	                currentSummary.getUnits().add(unit);
	                currentSummary.setTotalUnits(currentSummary.getUnits().size());

	                // Cập nhật ngày mua gần nhất của model này
	                Timestamp purchaseDate = unit.getPurchaseDate();
	                if (purchaseDate != null) {
	                    Timestamp latestPurchase = currentSummary.getLatestPurchaseAt();
	                    if (latestPurchase == null || purchaseDate.after(latestPurchase)) {
	                        currentSummary.setLatestPurchaseAt(purchaseDate);
	                        currentSummary.setDaysSinceLatestPurchase(unit.getDaysSincePurchase());
	                    }
	                }
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return resultList;
	}
	
    public int countOwnedDeviceModels(int customerId, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT d.id) FROM warranty_cards wc "
                + "JOIN device_serials ds ON ds.id = wc.device_serial_id "
                + "JOIN devices d ON d.id = ds.device_id "
                + "WHERE wc.customer_id = ? ");
        
        List<String> params = new ArrayList<>();
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (LOWER(d.name) LIKE ? OR LOWER(ds.serial_no) LIKE ?) ");
            String like = "%" + keyword.toLowerCase() + "%";
            params.add(like);
            params.add(like);
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            ps.setInt(idx++, customerId);
            
            for (String param : params) {
                ps.setString(idx++, param);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
	
	public int countOwnedUnits(int customerId) {
		String sql = "SELECT COUNT(*) FROM warranty_cards WHERE customer_id = ?";
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public int countOwnedUnitsWithIssue(int customerId) {
		String sql = "SELECT COUNT(*) FROM warranty_cards wc "
				+ "WHERE wc.customer_id = ? "
				+ "AND EXISTS (SELECT 1 FROM customer_issues ci WHERE ci.warranty_card_id = wc.id)";
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	private List<Integer> fetchPagedDeviceIds(int customerId, int offset, int limit) {
		List<Integer> ids = new ArrayList<>();
		String sql = "SELECT d.id "
				+ "FROM warranty_cards wc "
				+ "JOIN device_serials ds ON ds.id = wc.device_serial_id "
				+ "JOIN devices d ON d.id = ds.device_id "
				+ "WHERE wc.customer_id = ? "
				+ "GROUP BY d.id "
				+ "ORDER BY MAX(wc.start_at) DESC, d.name ASC "
				+ "LIMIT ? OFFSET ?";
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			ps.setInt(2, limit);
			ps.setInt(3, offset);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				ids.add(rs.getInt(1));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return ids;
	}
	
	private List<CustomerOwnedDevice> fetchOwnedDevices(int customerId, List<Integer> deviceFilter) {
		Map<Integer, CustomerOwnedDevice> map = new LinkedHashMap<>();
		StringBuilder sql = new StringBuilder("SELECT d.id AS device_id, d.name AS device_name, d.image_url, "
				+ "wc.id AS warranty_id, wc.start_at, wc.end_at, ds.serial_no, "
				+ "TIMESTAMPDIFF(DAY, wc.start_at, NOW()) AS days_since_purchase, "
				+ "latest_issue.id AS issue_id, latest_issue.issue_code, latest_issue.support_status "
				+ "FROM warranty_cards wc "
				+ "JOIN device_serials ds ON ds.id = wc.device_serial_id "
				+ "JOIN devices d ON d.id = ds.device_id "
				+ "LEFT JOIN ( "
				+ "    SELECT ci1.* FROM customer_issues ci1 "
				+ "    JOIN ( "
				+ "        SELECT warranty_card_id, MAX(created_at) AS latest_created "
				+ "        FROM customer_issues "
				+ "        GROUP BY warranty_card_id "
				+ "    ) latest ON latest.warranty_card_id = ci1.warranty_card_id "
				+ "        AND latest.latest_created = ci1.created_at "
				+ ") latest_issue ON latest_issue.warranty_card_id = wc.id "
				+ "WHERE wc.customer_id = ? ");
		boolean hasFilter = deviceFilter != null && !deviceFilter.isEmpty();
		if (hasFilter) {
			String placeholders = String.join(",", Collections.nCopies(deviceFilter.size(), "?"));
			sql.append("AND d.id IN (").append(placeholders).append(") ")
			   .append("ORDER BY FIELD(d.id");
			for (int i = 0; i < deviceFilter.size(); i++) {
				sql.append(",?");
			}
			sql.append("), wc.start_at DESC");
		} else {
			sql.append("ORDER BY d.name ASC, wc.start_at DESC");
		}
		
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			int idx = 1;
			ps.setInt(idx++, customerId);
			if (hasFilter) {
				for (Integer id : deviceFilter) {
					ps.setInt(idx++, id);
				}
				for (Integer id : deviceFilter) {
					ps.setInt(idx++, id);
				}
			}
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				int deviceId = rs.getInt("device_id");
				CustomerOwnedDevice summary = map.get(deviceId);
				if (summary == null) {
					summary = new CustomerOwnedDevice();
					summary.setDeviceId(deviceId);
					summary.setDeviceName(rs.getString("device_name"));
					summary.setImageUrl(rs.getString("image_url"));
					map.put(deviceId, summary);
				}
				
				CustomerOwnedDeviceUnit unit = new CustomerOwnedDeviceUnit();
				unit.setWarrantyCardId(rs.getInt("warranty_id"));
				unit.setSerialNo(rs.getString("serial_no"));
				unit.setPurchaseDate(rs.getTimestamp("start_at"));
				unit.setWarrantyEnd(rs.getTimestamp("end_at"));
				unit.setDaysSincePurchase(rs.getLong("days_since_purchase"));
				
				Integer issueId = (Integer) rs.getObject("issue_id");
				boolean hasIssue = issueId != null;
				unit.setHasIssue(hasIssue);
				if (hasIssue) {
					unit.setLatestIssueId(issueId);
					unit.setLatestIssueCode(rs.getString("issue_code"));
					unit.setLatestIssueStatus(rs.getString("support_status"));
					summary.incrementUnitsWithIssue();
				}
				
				summary.getUnits().add(unit);
				summary.setTotalUnits(summary.getUnits().size());
				
				Timestamp purchaseDate = unit.getPurchaseDate();
				if (purchaseDate != null) {
					Timestamp latestPurchase = summary.getLatestPurchaseAt();
					if (latestPurchase == null || latestPurchase.before(purchaseDate)) {
						summary.setLatestPurchaseAt(purchaseDate);
						summary.setDaysSinceLatestPurchase(unit.getDaysSincePurchase());
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return new ArrayList<>(map.values());
	}

	public List<CustomerIssue> getIssuesByWarrantyCardIds(List<Integer> warrantyCardIds) {
		if (warrantyCardIds == null || warrantyCardIds.isEmpty()) {
			return Collections.emptyList();
		}
		String placeholders = String.join(",", Collections.nCopies(warrantyCardIds.size(), "?"));
		String sql = "SELECT ci.id, ci.customer_id, ci.issue_code, ci.title, ci.description, "
				+ "ci.warranty_card_id, ci.created_at, ci.support_staff_id, ci.support_status, "
				+ "ci.issue_type, ci.feedback, u.full_name AS support_staff_name "
				+ "FROM customer_issues ci "
				+ "LEFT JOIN users u ON ci.support_staff_id = u.id "
				+ "WHERE ci.warranty_card_id IN (" + placeholders + ") "
				+ "ORDER BY ci.warranty_card_id ASC, ci.created_at DESC";
		List<CustomerIssue> list = new ArrayList<>();
		try (Connection conn = getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			for (int i = 0; i < warrantyCardIds.size(); i++) {
				ps.setInt(i + 1, warrantyCardIds.get(i));
			}
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				CustomerIssue issue = new CustomerIssue(rs.getInt("id"), rs.getInt("customer_id"),
						rs.getString("issue_code"), rs.getString("title"), rs.getString("description"),
						rs.getInt("warranty_card_id"), rs.getTimestamp("created_at"), rs.getInt("support_staff_id"),
						rs.getString("support_status"), rs.getString("issue_type"), rs.getString("feedback"));
				issue.setSupportStaffName(rs.getString("support_staff_name"));
				list.add(issue);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}


}
