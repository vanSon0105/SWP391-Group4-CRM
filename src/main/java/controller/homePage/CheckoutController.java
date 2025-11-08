package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import model.Device;
import model.CartDetail;
import model.Category;
import model.Supplier;
import model.User;
import dao.PaymentDAO;
import dao.CartDAO;
import dao.DeviceSerialDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Cart;
import model.Payment;
import model.Order;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	CartDAO cartDao = new CartDAO();
	PaymentDAO paymentDao = new PaymentDAO();
	OrderDAO orderDao = new OrderDAO();
	OrderDetailDAO odDao = new OrderDetailDAO();
	DeviceSerialDAO dsDao = new DeviceSerialDAO();
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("account");
		if (user == null) {
		    response.sendRedirect("view/authentication/login.jsp");
		    return;
		}
		
		if (!validateCartStock(user, session)) {
			response.sendRedirect("cart");
			return;
		}
		request.setAttribute("user", user);
		
		loadCheckoutData(request, response);
		request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
	}
	
	private void loadCheckoutData(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("account");
		if (user == null) {
		    response.sendRedirect("login.jsp");
		    return;
		}
		
		Cart c = cartDao.getCartByUserId(user.getId());
		List<CartDetail> list = cartDao.getCartDetail(c.getId());
		double totalPrice = 0;
		double discount = 0;
		double finalPrice = 0;
		
		if(list != null && !list.isEmpty()) {
			for(CartDetail cart : list) {
				totalPrice += cart.getTotalPrice();
			}
			
			if (totalPrice >= 3000000) {
				double potentialDiscount = totalPrice * 0.10;
				discount = Math.min(potentialDiscount, 150000);
			}else if(totalPrice >= 1000000 && totalPrice < 3000000) {
				double potentialDiscount = totalPrice * 0.05;
				discount = Math.min(potentialDiscount, 100000);
			}else {
				discount = 0;
			}
		}
		finalPrice = totalPrice - discount;
		
		session.setAttribute("discount", discount);
		session.setAttribute("finalPrice", finalPrice); 
		request.setAttribute("finalPrice", finalPrice);
		request.setAttribute("discount", discount);
		request.setAttribute("totalPrice", totalPrice);
		request.setAttribute("listCart", list);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("account");
		if (user == null) {
			response.sendRedirect("login");
			return;
		}
		if (!validateCartStock(user, session)) {
			response.sendRedirect("cart");
			return;
		}
		
		Cart cart = cartDao.getCartByUserId(user.getId());
		if (cart == null) {
			session.setAttribute("cartErrorMessage", "Giỏ hàng rỗng.");
			response.sendRedirect("cart");
		 return;
		}
		
		int cartId = cart.getId();
		double finalPrice = (double)session.getAttribute("finalPrice");
		double discount = (double)session.getAttribute("discount");
		
		String fullName = request.getParameter("fullname");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String time = request.getParameter("time");
		String note = request.getParameter("note");
		
		if(fullName == null || fullName.trim().isEmpty()) {
			request.setAttribute("errorFullname", "Không được để trống mục này");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
			return;
		}
		
		String namePattern = "^[\\p{L}\\s]+$";
		if (!fullName.matches(namePattern)) {
		    request.setAttribute("errorFullname", "Họ tên không được chứa ký tự đặc biệt hoặc số");
		    loadCheckoutData(request, response);
		    request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
		    return;
		}
		
		if(fullName.length() > 50) {
			request.setAttribute("errorFullname", "Họ tên không được vượt quá 50 ký tự");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
		    return;
		}
		
		String phoneRegex = "^[0-9]{10}$";
		if(phone.length() != 10 || !phone.matches(phoneRegex)) {
			request.setAttribute("errorPhone", "Định dạng số điện thoại không chính xác");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
			return;
		}
		
		if(address == null || address.trim().isEmpty()) {
			request.setAttribute("errorAddress", "Không được để trống mục này");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
			return;
		}
		
		if(address.length() > 200) {
			request.setAttribute("errorAddress", "Địa chỉ không được vượt quá 200 ký tự");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
			return;
		}
		
		if(note != null && note.length() > 200) {
			request.setAttribute("errorNote", "Ghi chú không được vượt quá 200 ký tự");
			loadCheckoutData(request, response);
			request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
			return;
			
		}
		
		int orderId = orderDao.addNewOrder(user.getId(), finalPrice, discount);
		
		List<CartDetail> cartItems = cartDao.getCartDetail(cartId);
		for (CartDetail item : cartItems) {
	        odDao.addOrderDetail(
	                orderId,
	                item.getDevice().getId(),
	                item.getQuantity(),
	                item.getPrice()
	        );
	    }
		
		Payment payment = new Payment();
		payment.setOrderId(orderId);
		payment.setFullName(fullName);
		payment.setPhone(phone);
		payment.setAddress(address);
		payment.setAmount(finalPrice);
		payment.setDeliveryTime(time);
		payment.setTechnicalNote(note);
//		payment.setCreatedAt(Timestamp.);
		payment.setPaidAt(null);
		
		paymentDao.addNewPayment(payment);
		cartDao.deleteCart(cartId); 
		
		session.setAttribute("finalPrice", finalPrice);
		request.getRequestDispatcher("view/homepage/banking.jsp").forward(request, response);
	}
	
	private boolean validateCartStock(User user, HttpSession session) {
		Cart cart = cartDao.getCartByUserId(user.getId());
		if (cart == null) {
			return true;
		}
		List<CartDetail> items = cartDao.getCartDetail(cart.getId());
		if (items == null) {
			return true;
		}
		for (CartDetail item : items) {
			if (item.getDevice() == null) {
				continue;
			}
			int available = dsDao.countAvailableSerials(item.getDevice().getId());
			if (item.getQuantity() > available) {
				session.setAttribute("cartErrorMessage", buildStockMessage(item.getDevice().getName(), available));
				return false;
			}
		}
		return true;
	}
	
	private String buildStockMessage(String deviceName, int available) {
		String name = (deviceName == null || deviceName.isEmpty()) ? "Thiết bị" : deviceName;
		if (available <= 0) {
			return name + " hiện đã hết hàng. Vui lòng điều chỉnh giỏ hàng.";
		}
		return name + " chỉ còn " + available + " chiếc. Vui lòng giảm số lượng trước khi thanh toán.";
	}
}