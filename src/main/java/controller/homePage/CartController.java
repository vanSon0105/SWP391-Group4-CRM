package controller.homePage;

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
import java.math.BigDecimal;
import java.util.List;

import dao.CartDAO;

/**
 * Servlet implementation class CartController
 */
@WebServlet("/cart")
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;

		public CartDAO cdao = new CartDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		User u = (User) session.getAttribute("user");
//        int userId = u.getId();
		int userId = 2;
		List<CartDetail> list = cdao.getCartDetail(userId);
		int cartId = -1;
		double cartTotal = 0;
		double discount = 0;
		if (list!= null && !list.isEmpty()) {
			cartId = list.get(0).getCart_id(); 
			for (CartDetail cartDetail : list) {
				cartTotal += cartDetail.getTotalPrice();
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
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int cartDetailId = Integer.parseInt(req.getParameter("cartDetailId"));
        String action = req.getParameter("action");
        //String quantityInput = req.getParameter("quantity");

        CartDetail cd = cdao.getCartDetailById(cartDetailId);
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

        cdao.updateCartQuantity(cartDetailId, quantity);
        resp.sendRedirect("cart");
	}
	
	private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int cartDetailId = Integer.parseInt(request.getParameter("cartDetailId"));
        cdao.deleteCartDetail(cartDetailId);
        response.sendRedirect("cart");
    }
	

}
