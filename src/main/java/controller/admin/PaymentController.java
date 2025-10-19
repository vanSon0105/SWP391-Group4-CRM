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
import java.util.List;

import model.Payment;
import dao.PaymentDAO;
import dao.DeviceSerialDAO;

/**
 * Servlet implementation class CategoryController
 */
@WebServlet("/payment-list")
public class PaymentController extends HttpServlet {
	PaymentDAO paymentDao = new PaymentDAO();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<Payment> paymentList = paymentDao.getAllPayment();
		
		req.setAttribute("paymentList", paymentList);
		req.getRequestDispatcher("view/admin/paymentmanagement/PaymentList.jsp").forward(req, resp);
	}
	

	
	

}
