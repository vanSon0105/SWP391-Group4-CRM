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

import dao.CategoryDAO;
import dao.DeviceDAO;
import dao.DeviceSerialDAO;

/**
 * Servlet implementation class CategoryController
 */
@WebServlet({"/category-show","/category-add", "/category-update", "/category-delete"})
public class CategoryController extends HttpServlet {
	public DeviceDAO dao = new DeviceDAO();
	public CategoryDAO cdao = new CategoryDAO();
	public DeviceSerialDAO dsdao = new DeviceSerialDAO();
	private final int recordsEachPage = 5;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
        switch (path) {
            case "/category-add":
            	req.getRequestDispatcher("view/admin/category/add.jsp").forward(req, resp);
            	break;
            case "/category-edit":
            	updateCategory(req, resp);
            	break;
            case "/category-delete":
            	req.getRequestDispatcher("view/admin/category/delete.jsp").forward(req, resp);
            	break;
            default:
            	showAllCategories(req, resp);
        }
	}
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		
		String categoryName = req.getParameter("name");
        boolean check = false;
        if (categoryName != null && !categoryName.trim().isEmpty()) {       
            check = cdao.addCategory(categoryName);
        }

        String mess = check ? "Add category thành công" : "Add category thất bại";
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
        resp.sendRedirect("category-show");
	}
	
	public void showAllCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int currentPage = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
		int offset = (currentPage - 1) * recordsEachPage;
		int totalCategories = cdao.getTotalCategories();
		int totalPages = (int) Math.ceil((double) totalCategories / recordsEachPage);
		
		List<Category> listCategories = cdao.getCategoriesByPage(offset, recordsEachPage);
		req.setAttribute("currentPage", currentPage);
		req.setAttribute("totalPages", totalPages);
		req.setAttribute("listCategories", listCategories);
		req.getRequestDispatcher("view/admin/category/show.jsp").forward(req, resp);
	}
	
	public void updateCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int id = Integer.parseInt(req.getParameter("id"));			
		Category c = cdao.getCategoryById(id);
		req.setAttribute("category", c);
		req.getRequestDispatcher("view/admin/category/edit.jsp").forward(req, resp);
	}
	
	

}
