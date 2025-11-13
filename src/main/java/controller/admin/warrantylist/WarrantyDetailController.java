package controller.admin.warrantylist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import dao.WarrantyCardDAO;
import model.WarrantyCard;

@WebServlet("/warranty-detail")
public class WarrantyDetailController extends HttpServlet {
    private WarrantyCardDAO warrantyDao = new WarrantyCardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy ID bảo hành");
            request.getRequestDispatcher("warrantyDetail.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            WarrantyCard warranty = warrantyDao.getByIdWithDetails(id);
            if (warranty == null) {
                request.setAttribute("error", "Không tìm thấy thông tin bảo hành");
            } else {
                request.setAttribute("warranty", warranty);
                List<WarrantyCard> history = warrantyDao.getHistoryWithStaffBySerialId(warranty.getDevice_serial().getId());
                request.setAttribute("warrantyHistory", history);

                request.setAttribute("now", new Date());
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID bảo hành không hợp lệ");
        }

        request.getRequestDispatcher("/view/admin/warranty/warrantyDetail.jsp").forward(request, response);
    }
}
