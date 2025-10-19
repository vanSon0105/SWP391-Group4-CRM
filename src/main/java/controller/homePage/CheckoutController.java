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
import dao.DeviceDAO;
import dao.CategoryDAO;
import dao.SupplierDAO;
import dao.CartDAO;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DeviceDAO deviceDao = new DeviceDAO();
	CategoryDAO categoryDao = new CategoryDAO();
	SupplierDAO supplierDao = new SupplierDAO();
	CartDAO cartDao = new CartDAO();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute("user");
		int userId = 1;
		List<CartDetail> list = cartDao.getCartDetail(userId);
		int cartId = -1;
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
		
		session.setAttribute("finalPrice", finalPrice);
		request.setAttribute("finalPrice", finalPrice);
		request.setAttribute("discount", discount);
		request.setAttribute("totalPrice", totalPrice);
		request.setAttribute("listCart", list);
		request.getRequestDispatcher("view/homepage/checkout.jsp").forward(request, response);
	}
}