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
import model.WarrantyCard;
import model.Device;
import dao.DeviceDAO;
import dao.PaymentDAO;
import dao.DeviceSerialDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.UserDAO;
import dao.WarrantyCardDAO;
import dao.CartDAO;
import dao.CartDetailDAO;

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

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

		List<Payment> paymentList = paymentDao.getFilteredPayments(status, sortCreatedAt, sortPaidAt, search,
				PAYMENT_PER_PAGE, offset);

		req.setAttribute("totalPayments", totalPayments);
		req.setAttribute("totalPages", totalPages);
		req.setAttribute("paymentList", paymentList);
		req.getRequestDispatcher("view/admin/paymentmanagement/PaymentList.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("paymentId");
		String action = req.getParameter("action");

		if ("success".equals(action)) {
			int paymentId = Integer.parseInt(id);
			paymentDao.updateStatus(paymentId, "success");

			int orderId = orderDao.getOrderByPaymentId(paymentId);
			orderDao.updateOrderStatus(orderId, "confirmed");

			int userId = userDao.getUserIdByOrderId(orderId);

			List<OrderDetail> orderItems = odDao.getOrderDetailsByOrderId(orderId);

			for (OrderDetail od : orderItems) {
				for (int i = 0; i < od.getQuantity(); i++) {
					DeviceSerial ds = dsDao.getInStockSerialId(od.getDeviceId());
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

					odDao.addOrderDetailSerial(od.getId(), ds.getId());
					
					dsDao.updateStatus(ds.getId(), "sold");
				}
			}

		} else if ("failed".equals(action)) {
			paymentDao.updateStatus(Integer.parseInt(id), action);
			orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(Integer.parseInt(id)), "cancelled");
		} else {
			paymentDao.updateStatus(Integer.parseInt(id), action);
			orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(Integer.parseInt(id)), "pending");
		}

		resp.sendRedirect("payment-list");
	}

}
