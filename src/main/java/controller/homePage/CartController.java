package controller.homePage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartDetail;

import java.io.IOException;
import java.util.List;

import dao.CartDAO;

/**
 * Servlet implementation class CartController
 */
@WebServlet("/cart")
public class CartController extends HttpServlet {
		public CartDAO cdao = new CartDAO();
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
//        int id = (int) session.getAttribute("id");
		int id = 2;
		List<CartDetail> list = cdao.getCartDetail(id);
		
		request.setAttribute("cartList", list);
		request.getRequestDispatcher("view/customer/cartPage.jsp").forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int cartDetailId = Integer.parseInt(req.getParameter("cartDetailId"));
        String action = req.getParameter("action");
        String quantityInput = req.getParameter("quantity");

        CartDetail cd = cdao.getCartDetailById(cartDetailId);
        int quantity = cd.getQuantity();
        
        if(action == null) {
        	quantity = Integer.parseInt(quantityInput);
        }else if ("increase".equals(action)) {
            quantity++;
        } else if ("decrease".equals(action) && quantity > 1) {
            quantity--;
        }

        cdao.updateCartQuantity(cartDetailId, quantity);
        resp.sendRedirect("cart");
	}
	
	public static void main(String[] args) {
		CartDAO cdao = new CartDAO();
		int id = 2;
		List<CartDetail> list = cdao.getCartDetail(id);
		for (CartDetail cartDetail : list) {
			System.out.println(cartDetail.toString());
		}
	}

}
