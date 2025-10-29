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
            case "/category-update":
            	updateCategory(req, resp);
            	break;
            case "/category-delete":
            	int id = Integer.parseInt(req.getParameter("id"));
            	Category c = cdao.getCategoryById(id);
            	req.setAttribute("category", c);
            	req.getRequestDispatcher("view/admin/category/delete.jsp").forward(req, resp);
            	break;
            default:
            	showAllCategories(req, resp);
        }
	}
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
        switch (path) {
            case "/category-add":
            	addCategory(req, resp);
            	break;
            case "/category-delete":
            	deleteCategory(req, resp);
            	break;
            case "/category-update":
            	updateCategoryDoPost(req, resp);
            	break;
        }
            	
	}
	
	public void showAllCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int currentPage = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
		int offset = (currentPage - 1) * recordsEachPage;
		
		String key = req.getParameter("key");
		String categoryIdParam = req.getParameter("categoryId");
		int categoryId = (categoryIdParam != null) ? Integer.parseInt(categoryIdParam) : 0;
		
		
		int totalCategories = cdao.getTotalCategories(key);
		int totalPages = (int) Math.ceil((double) totalCategories / recordsEachPage);
		
		List<Category> listCategories = cdao.getCategoriesByPage(offset, recordsEachPage, key);
		
		req.setAttribute("totalCategories", totalCategories);
		req.setAttribute("selectedCategory", categoryId);
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
	
	public void updateCategoryDoPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int id = Integer.parseInt(req.getParameter("id"));			
		String name = req.getParameter("name");
		boolean check = false;
		if(name != null) {
			check = cdao.updateCategory(id, name);
		}
		mess(req, resp, check, "Cập nhật category");
		resp.sendRedirect("category-show");
	}
	
	public void addCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String categoryName = req.getParameter("name");
        boolean check = false;
        if (categoryName != null && !categoryName.trim().isEmpty()) {       
            check = cdao.addCategory(categoryName);
        }

        mess(req, resp, check, "Thêm category");
        resp.sendRedirect("category-show");
	}
	
	public void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int id = Integer.parseInt(req.getParameter("id"));
        boolean check = cdao.deleteCategory(id);
        mess(req, resp, check, "Xóa category");
        resp.sendRedirect("category-show");
	}
	
	public void mess(HttpServletRequest req, HttpServletResponse resp, boolean check, String str) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String mess = check ? (str + " thành công") : (str + " thất bại");
		session.removeAttribute("mess");
	    session.setAttribute("mess", mess);
	}
	
	

}
