package controller.technicalmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import model.Device;
import model.Category;
import model.Supplier;
import dao.DeviceDAO;
import dao.CategoryDAO;
import dao.SupplierDAO;

@WebServlet("/task-list-page")
public class TaskListPageController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			
			

			request.getRequestDispatcher("view/technicalmanager/taskListPage.jsp").forward(request, response);
		} catch (Exception e) {
			System.out.print("Error");
		}

	}

}
