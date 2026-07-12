package controller;

import dao.BookingDAO;
import dao.FieldDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckFieldServlet", urlPatterns = {"/api/check-fields"})
public class CheckFieldServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final FieldDAO fieldDAO = new FieldDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String dateParam = request.getParameter("date");
        String slotParam = request.getParameter("slotId");
        List<Integer> bookedIds = new ArrayList<>();
        List<Integer> maintenanceIds = new ArrayList<>();
        if (dateParam != null && !dateParam.trim().isEmpty() && slotParam != null && !slotParam.trim().isEmpty()) {
            String cleanDate = dateParam.trim();
            try {
                int slotId = Integer.parseInt(slotParam.trim());
                bookedIds = bookingDAO.getBookedFieldIdsByDateAndSlot(cleanDate, slotId);
            } 
            catch (Exception e) {
                System.err.println("[SERVER API] Lỗi truy vấn danh sách đơn ca bận: " + e.getMessage());
            }
        }
        try {
            maintenanceIds = fieldDAO.getFieldIdsByStatus("MAINTENANCE");
        } catch (Exception e) {
            System.err.println("[SERVER API] Lỗi truy vấn danh sách sân bảo trì: " + e.getMessage());
        }
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"bookedFieldIds\": [");
        if (bookedIds != null) {
            for (int i = 0; i < bookedIds.size(); i++) {
                json.append(bookedIds.get(i));
                if (i < bookedIds.size() - 1) {
                    json.append(",");
                }
            }
        }
        json.append("],");
        json.append("\"maintenanceFieldIds\": [");
        if (maintenanceIds != null) {
            for (int i = 0; i < maintenanceIds.size(); i++) {
                json.append(maintenanceIds.get(i));
                if (i < maintenanceIds.size() - 1) {
                    json.append(",");
                }
            }
        }
        json.append("]");       
        json.append("}");
        out.print(json.toString());
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}