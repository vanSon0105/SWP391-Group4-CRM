//package controller.customer;
//
//import java.io.IOException;
//import java.sql.SQLException;
//import java.util.List;
//
//import dao.CartDAO;
//import dao.OrderDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import model.Cart;
//import model.CartDetail;
//import model.CheckoutInfo;
//import model.User;
//
//@WebServlet("/checkout")
//public class CheckoutController extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//	private final CartDAO cartDao = new CartDAO();
//	private final OrderDAO orderDao = new OrderDAO();
//
//	@Override
//	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//		User user = resolveUser(req, resp);
//		if (user == null) {
//			return;
//		}
//
//		Cart cart = cartDao.getCartByUserId(user.getId());
//		if (cart == null) {
//			req.setAttribute("cartItems", List.of());
//			req.setAttribute("subtotal", 0.0);
//			req.setAttribute("discount", 0.0);
//			req.setAttribute("finalTotal", 0.0);
//			req.getRequestDispatcher("view/homepage/checkout.jsp").forward(req, resp);
//			return;
//		}
//
//		List<CartDetail> items = cartDao.getCartDetail(cart.getId());
//		CheckoutTotals totals = calculateTotals(items);
//
//		req.setAttribute("cart", cart);
//		req.setAttribute("cartItems", items);
//		req.setAttribute("subtotal", totals.subtotal);
//		req.setAttribute("discount", totals.discount);
//		req.setAttribute("finalTotal", totals.finalTotal);
//		req.getRequestDispatcher("view/homepage/checkout.jsp").forward(req, resp);
//	}
//
//	@Override
//	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//		User user = resolveUser(req, resp);
//		if (user == null) {
//			return;
//		}
//
//		Cart cart = cartDao.getCartByUserId(user.getId());
//		if (cart == null) {
//			resp.sendRedirect(req.getContextPath() + "/cart");
//			return;
//		}
//
//		List<CartDetail> items = cartDao.getCartDetail(cart.getId());
//		if (items.isEmpty()) {
//			resp.sendRedirect(req.getContextPath() + "/cart");
//			return;
//		}
//
//		CheckoutInfo info = extractCheckoutInfo(req);
//		String validationError = validate(info);
//		if (validationError != null) {
//			req.setAttribute("error", validationError);
//			req.setAttribute("formInfo", info);
//			req.setAttribute("cart", cart);
//			req.setAttribute("cartItems", items);
//			CheckoutTotals totals = calculateTotals(items);
//			req.setAttribute("subtotal", totals.subtotal);
//			req.setAttribute("discount", totals.discount);
//			req.setAttribute("finalTotal", totals.finalTotal);
//			req.getRequestDispatcher("view/homepage/checkout.jsp").forward(req, resp);
//			return;
//		}
//
//		CheckoutTotals totals = calculateTotals(items);
//		try {
//			int orderId = orderDao.placeOrder(user.getId(), cart.getId(), items, totals.subtotal, totals.discount,
//					totals.finalTotal, info);
//			req.setAttribute("orderId", orderId);
//			req.setAttribute("finalTotal", totals.finalTotal);
//			req.setAttribute("info", info);
//			req.getRequestDispatcher("view/homepage/order-success.jsp").forward(req, resp);
//		} catch (SQLException e) {
//			e.printStackTrace();
//			req.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại sau.");
//			req.setAttribute("cart", cart);
//			req.setAttribute("cartItems", items);
//			req.setAttribute("subtotal", totals.subtotal);
//			req.setAttribute("discount", totals.discount);
//			req.setAttribute("finalTotal", totals.finalTotal);
//			req.getRequestDispatcher("view/homepage/checkout.jsp").forward(req, resp);
//		}
//	}
//
//	private User resolveUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
//		HttpSession session = req.getSession(false);
//		if (session == null) {
//			resp.sendRedirect(req.getContextPath() + "/view/authentication/login.jsp");
//			return null;
//		}
//		User user = (User) session.getAttribute("account");
//		if (user == null) {
//			resp.sendRedirect(req.getContextPath() + "/view/authentication/login.jsp");
//			return null;
//		}
//		return user;
//	}
//
//	private CheckoutInfo extractCheckoutInfo(HttpServletRequest req) {
//		CheckoutInfo info = new CheckoutInfo();
//		info.setFullName(req.getParameter("fullname"));
//		info.setPhone(req.getParameter("phone"));
//		info.setAddress(req.getParameter("address"));
//		info.setDeliveryTime(req.getParameter("time"));
//		info.setPaymentMethod(req.getParameter("method"));
//		info.setNote(req.getParameter("note"));
//		return info;
//	}
//
//	private String validate(CheckoutInfo info) {
//		if (isBlank(info.getFullName()) || isBlank(info.getPhone()) || isBlank(info.getAddress())) {
//			return "Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ giao hàng.";
//		}
//		if (isBlank(info.getDeliveryTime()) || isBlank(info.getPaymentMethod())) {
//			return "Vui lòng chọn thời gian giao hàng và phương thức thanh toán.";
//		}
//		return null;
//	}
//
//	private boolean isBlank(String value) {
//		return value == null || value.trim().isEmpty();
//	}
//
//	private CheckoutTotals calculateTotals(List<CartDetail> items) {
//		double subtotal = 0;
//		for (CartDetail item : items) {
//			subtotal += item.getPrice() * item.getQuantity();
//		}
//		double discount = 0;
//		if (subtotal >= 3000000) {
//			discount = Math.min(subtotal * 0.10, 150000);
//		} else if (subtotal >= 1000000) {
//			discount = Math.min(subtotal * 0.05, 100000);
//		}
//		double finalTotal = Math.max(subtotal - discount, 0);
//		return new CheckoutTotals(subtotal, discount, finalTotal);
//	}
//
//	private static class CheckoutTotals {
//		final double subtotal;
//		final double discount;
//		final double finalTotal;
//
//		CheckoutTotals(double subtotal, double discount, double finalTotal) {
//			this.subtotal = subtotal;
//			this.discount = discount;
//			this.finalTotal = finalTotal;
//		}
//	}
//}
