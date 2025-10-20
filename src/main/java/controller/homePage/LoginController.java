package controller.homePage;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet({ "/login", "/logout" })
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String SESSION_LOGGED_ACCOUNTS = "loggedAccounts";
	private static final String SESSION_ACTIVE_ACCOUNT_ID = "activeAccountId";
	private static final int SESSION_TIMEOUT_SECONDS = 10 * 60 * 60; // keep session for 4 hours

	private final UserDAO userDAO = new UserDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		switch (path) {
		case "/login":
			handleLoginGet(req, resp);
			return;
		case "/logout":
			logoutPage(req, resp);
			return;
		default:
			resp.sendRedirect(req.getContextPath() + "/home");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		switch (path) {
		case "/login":
			loginPage(req, resp);
			break;
		case "/logout":
			logoutPage(req, resp);
			break;
		default:
			resp.sendRedirect(req.getContextPath() + "/home");
		}
	}

	private void handleLoginGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String switchAccountId = request.getParameter("switchAccountId");
		if (switchAccountId != null) {
			handleAccountSwitch(request, response, switchAccountId);
			return;
		}
		request.getRequestDispatcher("/view/authentication/login.jsp").forward(request, response);
	}

	private void handleAccountSwitch(HttpServletRequest request, HttpServletResponse response, String switchAccountId)
			throws IOException {
		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
			return;
		}

		@SuppressWarnings("unchecked")
		Map<Integer, User> loggedAccounts = (Map<Integer, User>) session.getAttribute(SESSION_LOGGED_ACCOUNTS);
		if (loggedAccounts == null || loggedAccounts.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
			return;
		}

		try {
			int accountId = Integer.parseInt(switchAccountId);
			User targetAccount = loggedAccounts.get(accountId);
			if (targetAccount != null) {
				session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
				session.setAttribute("account", targetAccount);
				session.setAttribute(SESSION_ACTIVE_ACCOUNT_ID, accountId);
				redirectAfterLogin(request, response, targetAccount);
				return;
			}
		} catch (NumberFormatException ex) {
			// ignore and fall through to redirect
		}

		response.sendRedirect(request.getContextPath() + "/view/authentication/login.jsp");
	}

	private void logoutPage(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		response.sendRedirect("home");
	}

	private void loginPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		User user = userDAO.getUserByLogin(email, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);

			@SuppressWarnings("unchecked")
			Map<Integer, User> loggedAccounts = (Map<Integer, User>) session.getAttribute(SESSION_LOGGED_ACCOUNTS);
			if (loggedAccounts == null) {
				loggedAccounts = new HashMap<>();
			}
			loggedAccounts.put(user.getId(), user);

			session.setAttribute(SESSION_LOGGED_ACCOUNTS, loggedAccounts);
			session.setAttribute(SESSION_ACTIVE_ACCOUNT_ID, user.getId());
			session.setAttribute("account", user);

			redirectAfterLogin(request, response, user);
		} else {
			request.setAttribute("error", "Email hoac mat khau khong dung!");
			request.getRequestDispatcher("/view/authentication/login.jsp").forward(request, response);
		}
	}

	private void redirectAfterLogin(HttpServletRequest request, HttpServletResponse response, User user)
			throws IOException {
		if (user.getRoleId() == 1) {
			response.sendRedirect(request.getContextPath() + "/account");
		} else {
			response.sendRedirect(request.getContextPath() + "/home");
		}
	}
}
