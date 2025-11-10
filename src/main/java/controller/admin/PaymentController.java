               package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.sql.Timestamp;

import model.CartDetail;
import model.DeviceSerial;
import model.OrderDetail;
import model.Payment;
import model.Transaction;
import model.TransactionDetail;
import model.WarrantyCard;
import model.Device;
import dao.DeviceDAO;
import dao.PaymentDAO;
import dao.TransactionDAO;
import dao.TransactionDetailDAO;
import dao.DeviceSerialDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.UserDAO;
import dao.WarrantyCardDAO;
import dao.CartDAO;
import dao.CartDetailDAO;
import model.User;
import utils.AuthorizationUtils;

import java.util.logging.*;

/**
 * Servlet implementation class CategoryController
 */
@WebServlet("/payment-list")
public class PaymentController extends HttpServlet {
	private static int PAYMENT_PER_PAGE = 6;
	PaymentDAO paymentDao = new PaymentDAO();
	OrderDAO orderDao = new OrderDAO();
	UserDAO userDao = new UserDAO();
	CartDAO cartDao = new CartDAO();
	WarrantyCardDAO wcDao = new WarrantyCardDAO();
	OrderDetailDAO odDao = new OrderDetailDAO();
	DeviceSerialDAO dsDao = new DeviceSerialDAO();
	CartDetailDAO cdDao = new CartDetailDAO();
	DeviceDAO deviceDao = new DeviceDAO();
	TransactionDAO transactionDao = new TransactionDAO();
	TransactionDetailDAO transactionDetailDao = new TransactionDetailDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getManager(req, resp);
		if (staff == null) {
			return;
		}
		String pageParam = req.getParameter("page");
		String status = req.getParameter("status");
		String sortCreatedAt = req.getParameter("sortCreatedAt");
		String sortPaidAt = req.getParameter("sortPaidAt");
		String search = req.getParameter("search");

		int page = 1;
		if (pageParam != null) {
			page = Integer.parseInt(pageParam);
		}

		int totalPayments = paymentDao.getFilteredPaymentCount(status, search);
		int totalPages = (int) Math.ceil((double) totalPayments / PAYMENT_PER_PAGE);
		int offset = (page - 1) * PAYMENT_PER_PAGE;
		int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

		List<Payment> paymentList = paymentDao.getFilteredPayments(status, sortCreatedAt, sortPaidAt, search,
				PAYMENT_PER_PAGE, offset);

		
		req.setAttribute("totalPayments", totalPayments);
		req.setAttribute("totalPages", totalPages);
		req.setAttribute("currentPage", currentPage);
		req.setAttribute("paymentList", paymentList);
		removeMess(req);
		req.getRequestDispatcher("view/admin/paymentmanagement/PaymentList.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User staff = getManager(req, resp);
		if (staff == null) {
			return;
		}
		
		String id = req.getParameter("paymentId");
		String action = req.getParameter("action");

		try {
			if ("success".equals(action)) {
				int paymentId = Integer.parseInt(id);
				
				Payment payment = paymentDao.getPaymentById(paymentId);
				if (payment == null) {
					resp.sendRedirect("payment-list?error=payment_not_found");
					return;
				}
				
				if ("success".equalsIgnoreCase(payment.getStatus())) {
					resp.sendRedirect("payment-list?info=already_confirmed");
					return;
				}
				
				paymentDao.updateStatus(paymentId, "success");
	
				int orderId = orderDao.getOrderByPaymentId(paymentId);
				orderDao.updateOrderStatus(orderId, "confirmed");
	
				int userId = userDao.getUserIdByOrderId(orderId);
	
				List<OrderDetail> orderItems = odDao.getOrderDetailsByOrderId(orderId);
	
				for (OrderDetail od : orderItems) {
					for (int i = 0; i < od.getQuantity(); i++) {
						DeviceSerial ds = fetchAvailableSerial(od.getDeviceId());
						if (ds == null) {
							continue;
						}
						
						Device device = deviceDao.getDeviceById(od.getDeviceId());
						int warrantyMonths = (device != null) ? device.getWarrantyMonth() : 12;
						Timestamp now = new Timestamp(System.currentTimeMillis());
				        Timestamp end = new Timestamp(
				            now.getTime() + (long) warrantyMonths * 30 * 24 * 60 * 60 * 1000
				        );
						
						WarrantyCard wc = wcDao.getBySerialId(ds.getId());
						int wcId;
	
						if (wc == null) {
							try {
								wcId = wcDao.addWarrantyCard(ds.getId(), userId, now, end);
							} catch (SQLException e) {
								e.printStackTrace();
								continue;
							}
	
							if (wcId <= 0) {
								continue;
							}
						} else {
							wcDao.updateWarrantyDates(wc.getId(), now, end);
							wcId = wc.getId();
						}
	
						if (odDao.addOrderDetailSerial(od.getId(), ds.getId())) {
							dsDao.updateStatus(ds.getId(), "sold");
						}
					}
				}
				
				recordExportTransaction(staff, userId, payment, orderItems);
				sendMess(req, "success", "Đã xác nhận thanh toán #" + paymentId);
	
			} else if ("failed".equals(action)) {
				int paymentId = Integer.parseInt(id);
				paymentDao.updateStatus(paymentId, "failed");
				orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(paymentId), "cancelled");
				sendMess(req, "success", "Đã từ chối thanh toán #" + paymentId);
			} else {
				int paymentId = Integer.parseInt(id);
				paymentDao.updateStatus(paymentId, action);
				orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(paymentId), "pending");
				sendMess(req, "success", "Đã đưa thanh toán #" + paymentId + " về trạng thái pending");
			}
		} catch (Exception e) {
			sendMess(req, "error", "Không thể cập nhật thanh toán. Vui lòng thử lại");
		}
		resp.sendRedirect("payment-list");
	}
	
	private DeviceSerial fetchAvailableSerial(int deviceId) {
		DeviceSerial ds = dsDao.getInStockSerialId(deviceId);
		int guard = 0;
		while (ds != null && odDao.isSerialAlreadyAssigned(ds.getId()) && guard < 20) {
			dsDao.updateStatus(ds.getId(), "sold");
			ds = dsDao.getInStockSerialId(deviceId);
			guard++;
		}
		if (guard >= 20) {
			return null;
		}
		return ds;
	}
	
	private User getManager(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    return AuthorizationUtils.requirePermission(request, response, "PAYMENT_REPORTS");
	}
	
	private void recordExportTransaction(User staff, int userId, Payment payment, List<OrderDetail> items) {
		if (items == null || items.isEmpty()) {
			return;
		}
		Transaction transaction = new Transaction();
		transaction.setStorekeeperId(staff != null ? staff.getId() : 0);
		transaction.setUserId(userId);
		transaction.setType("export");
		transaction.setStatus("confirmed");
		transaction.setNote("Order #" + payment.getOrderId());
		int transactionId = transactionDao.createTransaction(transaction);
		if (transactionId <= 0) {
			return;
		}
		for (OrderDetail od : items) {
			TransactionDetail detail = new TransactionDetail();
			detail.setTransactionId(transactionId);
			detail.setDeviceId(od.getDeviceId());
			detail.setQuantity(od.getQuantity());
			transactionDetailDao.addTransactionDetail(detail, null);
		}
	}
	
	private void sendMess(HttpServletRequest request, String type, String message) {
		HttpSession session = request.getSession();
		session.setAttribute("paymentMessage", message);
		session.setAttribute("paymentMessageType", type);
	}
	
	private void removeMess(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return;
		}
		Object message = session.getAttribute("paymentMessage");
		if (message != null) {
			request.setAttribute("paymentMessage", message);
			request.setAttribute("paymentMessageType", session.getAttribute("paymentMessageType"));
			session.removeAttribute("paymentMessage");
			session.removeAttribute("paymentMessageType");
		}
	}


}
