package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            int totalBookings = bookingDAO.countTotalActiveBookings();
            double totalRevenue = bookingDAO.calculateTotalRevenue();
            Map<String, Double> chartData = bookingDAO.getRevenueLast7Days(); // Phục vụ Chart.js
            List<Map<String, Object>> topFields = bookingDAO.getTopFields();   // Top 5 sân đấu
            List<Map<String, Object>> topCustomers = bookingDAO.getTopCustomers(); // Top 5 khách VIP
            List<Booking> bookingList = bookingDAO.findAllBookings();
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("adminBookingList", bookingList); 
            request.setAttribute("chartData", chartData);
            request.setAttribute("topFieldsList", topFields);
            request.setAttribute("topCustomersList", topCustomers);
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            return;          
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=SystemServerError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");
                if (bookingDAO.updateBookingStatus(bookingId, status)) {
                    response.sendRedirect(request.getContextPath() + "/admin/booking?msg=update_success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/booking?error=update_failed");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/booking?error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/booking");
        }
    }
}