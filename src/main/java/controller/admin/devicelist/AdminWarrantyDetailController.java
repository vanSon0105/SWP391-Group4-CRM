package controller.admin.devicelist;

import dao.DeviceDAO;
import dao.WarrantyCardDAO;
import model.Device;
import model.DeviceSerial;
import model.WarrantyCard;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warranty-details")
public class AdminWarrantyDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	  String idStr = request.getParameter("id");
          if (idStr == null || idStr.isEmpty()) {
              request.setAttribute("error", "Warranty ID không hợp lệ!");
              request.getRequestDispatcher("/view/admin/warranty-detail/warranty-detail.jsp").forward(request, response);
              return;
          }

          try {
              int id = Integer.parseInt(idStr);
              WarrantyCardDAO warrantyDao = new WarrantyCardDAO();
              WarrantyCard wc = warrantyDao.getWarrantyCardById(id);

              if (wc == null) {
                  request.setAttribute("error", "Không tìm thấy Warranty với ID: " + id);
              } else {
                  DeviceSerial ds = wc.getDevice_serial();
                  if (ds != null) {
                      DeviceDAO deviceDao = new DeviceDAO();
                      Device device = deviceDao.getDeviceById(ds.getDevice_id());
                      request.setAttribute("device", device);
                  }

                  request.setAttribute("warranty", wc);
              }
          } catch (NumberFormatException e) {
              request.setAttribute("error", "Warranty ID không hợp lệ!");
          }

          request.getRequestDispatcher("/view/admin/warranty-detail/warranty-detail.jsp").forward(request, response);
      }
}
