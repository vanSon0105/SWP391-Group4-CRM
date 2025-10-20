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
import dao.PaymentDAO;
import dao.DeviceSerialDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.UserDAO;
import dao.CartDAO;
import dao.CartDetailDao;
import dao.WarrantyCardDao;

import java.util.logging.*;
/**
 * Servlet implementation class CategoryController
 */
@WebServlet("/payment-list")
public class PaymentController extends HttpServlet {
	private static int PAYMENT_PER_PAGE = 10;
	PaymentDAO paymentDao = new PaymentDAO();
	OrderDAO orderDao = new OrderDAO();
	UserDAO userDao = new UserDAO();
	CartDAO cartDao = new CartDAO();
	WarrantyCardDao wcDao = new WarrantyCardDao();
	OrderDetailDAO odDao = new OrderDetailDAO();
	DeviceSerialDAO dsDao = new DeviceSerialDAO();
	CartDetailDao cdDao = new CartDetailDao();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String pageParam = req.getParameter("page");

		int page = 1;
		if (pageParam != null) {
			page = Integer.parseInt(pageParam);
		}

		int totalPayments = paymentDao.getPaymentCount();
		int totalPages = (int) Math.ceil((double) totalPayments / PAYMENT_PER_PAGE);
		int offset = (page - 1) * PAYMENT_PER_PAGE;

		List<Payment> paymentList = paymentDao.getAllPayment(PAYMENT_PER_PAGE, offset);

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
			int cartId = cartDao.getCartIdByUserId(userId);

			List<CartDetail> orderItems = cartDao.getCartDetail(cartId);

			Timestamp now = new Timestamp(System.currentTimeMillis());
			Timestamp end = new Timestamp(System.currentTimeMillis() + 365L * 24 * 60 * 60 * 1000);

			for (CartDetail cd : orderItems) {
				DeviceSerial ds = dsDao.getInStockSerialId(cd.getDevice().getId());
				if (ds == null) {
				    continue; 
				}
				
				dsDao.updateStatus(ds.getId(), "sold");
				WarrantyCard wc = wcDao.getBySerialId(ds.getId());
				
				if(wc == null) {
					try {
					    wcDao.addWarrantyCard(ds.getId(), userId, now, end);
					} catch (SQLException e) {
					    e.printStackTrace();
					}

				} else {
				    wcDao.updateWarrantyDates(wc.getId(), now, end);
				}

				odDao.addOrderDetail(orderId, cd.getDevice().getId(), ds.getId(), cd.getQuantity(), cd.getPrice(),
						wc.getId());

				dsDao.updateStatus(ds.getId(), "sold");
			}

			cartDao.deleteCart(cartId);
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
