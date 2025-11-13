package controller.customer;

import java.io.IOException;
import java.util.regex.Pattern;

import dao.CustomerIssueDAO;
import dao.DeviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;
import model.User;
import utils.AuthorizationUtils;

@WebServlet("/external-repair")
public class ExternalRepairRequestController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final int TITLE_MAX = 80;
	private static final int DESC_MAX = 1200;
	private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{9,11}$");
	private static final Pattern EMAIL_PATTERN = Pattern
			.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

	private final CustomerIssueDAO issueDao = new CustomerIssueDAO();
	private final DeviceDAO deviceDao = new DeviceDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User customer = requireCustomer(req, resp);
		if (customer == null) {
			return;
		}
		prefillFromDeviceParam(req);
		prefillFromCustomer(req, customer);
		req.getRequestDispatcher("view/customer/externalRepairRequest.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		User customer = requireCustomer(req, resp);
		if (customer == null) {
			return;
		}

		String deviceName = trimParam(req, "deviceName");
		String serial = trimParam(req, "deviceSerial");
		String deviceCondition = trimParam(req, "deviceCondition");
		String accessories = trimParam(req, "includedItems");
		String title = trimParam(req, "title");
		String desc = trimParam(req, "desc");
		String dropoffNote = trimParam(req, "dropoffNote");

		String contactName = trimParam(req, "contactName");
		String contactPhone = trimParam(req, "contactPhone");
		String contactEmail = trimParam(req, "contactEmail");

		req.setAttribute("formDeviceName", deviceName);
		req.setAttribute("formDeviceSerial", serial);
		req.setAttribute("formDeviceCondition", deviceCondition);
		req.setAttribute("formIncludedItems", accessories);
		req.setAttribute("formTitle", title);
		req.setAttribute("formDesc", desc);
		req.setAttribute("formDropoffNote", dropoffNote);
		req.setAttribute("formContactName", contactName);
		req.setAttribute("formContactPhone", contactPhone);
		req.setAttribute("formContactEmail", contactEmail);

		boolean hasError = false;

		if (deviceName == null || deviceName.isEmpty()) {
			req.setAttribute("errorDeviceName", "Vui lòng nhập tên thiết bị cần sửa");
			hasError = true;
		} else if (deviceName.length() > 150) {
			req.setAttribute("errorDeviceName", "Tên thiết bị không được vượt quá 150 ký tự");
			hasError = true;
		}

		if (title == null || title.isEmpty()) {
			req.setAttribute("errorTitle", "Vui lòng nhập tóm tắt sự cố");
			hasError = true;
		} else if (title.length() > TITLE_MAX) {
			req.setAttribute("errorTitle", "Tóm tắt tối đa " + TITLE_MAX + " ký tự");
			hasError = true;
		}

		if (desc == null || desc.isEmpty()) {
			req.setAttribute("errorDesc", "Vui lòng mô tả chi tiết tình trạng thiết bị");
			hasError = true;
		} else if (desc.length() > DESC_MAX) {
			req.setAttribute("errorDesc", "Mô tả không được vượt quá " + DESC_MAX + " ký tự");
			hasError = true;
		}

		if (contactName == null || contactName.isEmpty()) {
			req.setAttribute("errorContactName", "Vui lòng nhập họ tên người gửi");
			hasError = true;
		} else if (contactName.length() > 120) {
			req.setAttribute("errorContactName", "Họ tên không được vượt quá 120 ký tự");
			hasError = true;
		}

		if (contactPhone == null || contactPhone.isEmpty()) {
			req.setAttribute("errorContactPhone", "Vui lòng nhập số điện thoại liên hệ");
			hasError = true;
		} else if (!PHONE_PATTERN.matcher(contactPhone).matches()) {
			req.setAttribute("errorContactPhone", "Số điện thoại không hợp lệ");
			hasError = true;
		}

		if (contactEmail != null && !contactEmail.isEmpty() && !EMAIL_PATTERN.matcher(contactEmail).matches()) {
			req.setAttribute("errorContactEmail", "Email không hợp lệ");
			hasError = true;
		}

		if (hasError) {
			req.getRequestDispatcher("view/customer/externalRepairRequest.jsp").forward(req, resp);
			return;
		}

		boolean created = issueDao.createIssue(customer.getId(), title, desc, "repair", 0);
		if (!created) {
			req.setAttribute("formError", "Không thể gửi yêu cầu. Vui lòng thử lại sau");
			req.getRequestDispatcher("view/customer/externalRepairRequest.jsp").forward(req, resp);
			return;
		}

		resp.sendRedirect("issue?created=1");
	}

	private void prefillFromDeviceParam(HttpServletRequest req) {
		String deviceIdParam = req.getParameter("deviceId");
		if (deviceIdParam != null) {
			try {
				int deviceId = Integer.parseInt(deviceIdParam);
				Device device = deviceDao.getDeviceById(deviceId);
				if (device != null && req.getAttribute("formDeviceName") == null) {
					req.setAttribute("formDeviceName", device.getName());
				}
			} catch (NumberFormatException ignored) {
			}
		}

		String deviceNameParam = trimParam(req, "deviceNamePrefill");
		if (deviceNameParam != null && req.getAttribute("formDeviceName") == null) {
			req.setAttribute("formDeviceName", deviceNameParam);
		}
	}

	private void prefillFromCustomer(HttpServletRequest req, User user) {
		if (req.getAttribute("formContactName") == null) {
			req.setAttribute("formContactName", user.getFullName());
		}
		if (req.getAttribute("formContactPhone") == null) {
			req.setAttribute("formContactPhone", user.getPhone());
		}
		if (req.getAttribute("formContactEmail") == null) {
			req.setAttribute("formContactEmail", user.getEmail());
		}
	}


	private User requireCustomer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		return AuthorizationUtils.requirePermission(req, resp, "Gửi Vấn Đề");
	}

	private String trimParam(HttpServletRequest req, String name) {
		String value = req.getParameter(name);
		return value != null ? value.trim() : null;
	}
}
