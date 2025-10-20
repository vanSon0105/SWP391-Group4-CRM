package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Device;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import model.Payment;
import dao.PaymentDAO;
import dao.DeviceSerialDAO;
import dao.OrderDAO;
import dao.UserDAO;
import dao.CartDAO;

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
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String pageParam = req.getParameter("page");
		 
		int page = 1;
		if(pageParam != null) {
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
	
		
		
		if("success".equals(action)) {
			paymentDao.updateStatus(Integer.parseInt(id), action);
			orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(Integer.parseInt(id)), "confirmed");
			int orderId = orderDao.getOrderByPaymentId(Integer.parseInt(id));
			int userId = userDao.getUserIdByOrderId(orderId);
			int cartId = cartDao.getCartIdByUserId(userId);
			cartDao.deleteCart(cartId);
		} else if ("failed".equals(action)) {
			paymentDao.updateStatus(Integer.parseInt(id), action);
			orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(Integer.parseInt(id)), "canceled");
		} else {
			paymentDao.updateStatus(Integer.parseInt(id), action);
			orderDao.updateOrderStatus(orderDao.getOrderByPaymentId(Integer.parseInt(id)), "pending");
		}
		 
		resp.sendRedirect("payment-list");
	}

	
	

}
