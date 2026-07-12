package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

@WebServlet(name = "AdminBookingController", urlPatterns = {"/admin-booking"}) 
public class AdminBookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { 
        System.out.println(">>> [DEBUG - SERVER]: Da vao den AdminBookingController.doGet() thanh cong!");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache"); 
        response.setHeader("Expires", "0"); 
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            System.out.println(">>> [DEBUG - SERVER]: Dang truy van du lieu tu BookingDAO...");
            int totalBookings = bookingDAO.countTotalActiveBookings();
            double totalRevenue = bookingDAO.calculateTotalRevenue();
            List<Booking> bookingList = bookingDAO.findAllBookings();           
            System.out.println(">>> [DEBUG - SERVER]: Lay du lieu thanh cong. So luong don: " + (bookingList != null ? bookingList.size() : 0));            
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("allBookingsList", bookingList); 
            System.out.println(">>> [DEBUG - SERVER]: Dang forward request den /admin/booking.jsp...");
            request.getRequestDispatcher("/admin/booking.jsp").forward(request, response);
            return;           
        } catch (Exception e) {
            System.out.println(">>> [DEBUG - SERVER ERROR]: Gap loi trong qua trinh nap du lieu!");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard&msg=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {       
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");       
        String action = request.getParameter("action");
        System.out.println(">>> [DEBUG - SERVER]: AdminBookingController.doPost() duoc goi. Action = " + action);       
        if ("updateStatus".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");
                System.out.println(">>> [DEBUG - SERVER]: Cap nhat trang thai don ID: " + bookingId + " sang thành: " + status);
                if (bookingDAO.updateBookingStatus(bookingId, status)) {
                    System.out.println(">>> [DEBUG - SERVER]: Cap nhat thành cong. Dang redirect ve /admin-booking");
                    response.sendRedirect(request.getContextPath() + "/admin-booking?msg=success");
                } else {
                    System.out.println(">>> [DEBUG - SERVER]: DAO bao cap nhat that bai.");
                    response.sendRedirect(request.getContextPath() + "/admin-booking?msg=system_error");
                }
            } catch (NumberFormatException e) {
                System.out.println(">>> [DEBUG - SERVER ERROR]: Sai dinh dang ID don ca.");
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin-booking?msg=system_error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-booking");
        }
    }
}