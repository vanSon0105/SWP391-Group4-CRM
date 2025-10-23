package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.CartDetail;
import model.User;

import java.io.IOException;
import java.lang.annotation.Repeatable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import dao.CartDAO;
import dao.CartDetailDAO;

/**
 * Servlet implementation class CartController
 */
@WebServlet({"/cart", "/cart-add"})
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CartDAO cdao = new CartDAO();
	public CartDetailDAO cdDao = new CartDetailDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
        switch (path) {
            case "/cart":
                showCart(request, response);
                break;
            case "/cart-add":
            	addDeviceToCart(request, response);
            	break;
        }
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		User user = (User) session.getAttribute("account");
		if (user == null) {
			resp.sendRedirect("login");
			return;
		}
		
		int cartDetailId = Integer.parseInt(req.getParameter("cartDetailId"));
        String action = req.getParameter("action");
        //String quantityInput = req.getParameter("quantity");

        CartDetail cd = cdao.getCartDetailById(cartDetailId);
        if (cd == null) {
            resp.sendRedirect("cart");
            return;
        }
        int quantity = cd.getQuantity();
        
//        if(action == null) {
        	//quantity = Integer.parseInt(quantityInput);
        if("remove".equals(action)) {
        	removeFromCart(req, resp);
        	return;
        }else if ("increase".equals(action)) {
            quantity++;
        } else if ("decrease".equals(action) && quantity > 1) {
            quantity--;
        }
        cd.setQuantity(quantity);
        cd.setId(cartDetailId);
        cdDao.updateCartDetailQuantity(cd);
        Cart cart = cdao.getCartById(cd.getCartId());
        if (cart != null) {
            double cartTotal = cdao.calculateCartSum(cart.getId());
            double discount = 0;
            if (cartTotal >= 3000000) {
                discount = Math.min(cartTotal * 0.10, 150_000);
            } else if (cartTotal >= 1_000_000) {
                discount = Math.min(cartTotal * 0.05, 100_000);
            }
            double finalTotal = Math.max(0, cartTotal - discount);
            cdao.updateCartSum(cart.getId(), finalTotal);
        }
        
        resp.sendRedirect("cart");
	}
	
	public void showCart(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		User u = (User) session.getAttribute("account");
		if (u == null) {
			response.sendRedirect("login");
			return;
		}
		int userId = u.getId();
		Cart cart = cdao.getOrCreateCart(userId);
		
		int cartId = -1;
		double cartTotal = 0;
		double discount = 0;
		List<CartDetail> list = new ArrayList<>();
		if (cart != null) {
			cartId = cart.getId(); 
			cartTotal = cdDao.calculateCartSum(cartId);
			list = cdao.getCartDetail(cartId);
		}
		if (cartTotal >= 3000000) {
			double potentialDiscount = cartTotal * 0.10;
			discount = Math.min(potentialDiscount, 150000);
		}else if(cartTotal >= 1000000 && cartTotal < 3000000) {
			double potentialDiscount = cartTotal * 0.05;
			discount = Math.min(potentialDiscount, 100000);
		}else {
			discount = 0;
		}
		
		double finalTotal = cartTotal - discount;
        if (finalTotal < 0) {
            finalTotal = 0;
        }
        
        if(cartId != -1) {
			cdao.updateCartSum(cartId, finalTotal);
		}
		
        request.setAttribute("discount", discount);
        request.setAttribute("finalTotal", finalTotal);
		request.setAttribute("cartTotal", cartTotal);
		request.setAttribute("cartList", list);
		request.getRequestDispatcher("view/customer/cartPage.jsp").forward(request, response);
	}
	
	private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        int cartDetailId = Integer.parseInt(request.getParameter("cartDetailId"));
        cdao.deleteCartDetail(cartDetailId);
        response.sendRedirect("cart");
    }
	
	public void addDeviceToCart(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		int deviceId = Integer.parseInt(req.getParameter("id"));
		HttpSession session = req.getSession();
		User u = (User) session.getAttribute("account");
		if (u == null) {
			resp.sendRedirect("login");
			return;
		}
		int userId = u.getId();
		cdao.addDeviceToCart(userId, deviceId);
		resp.sendRedirect("home");
	}
	

}
