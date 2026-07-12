package controller;

import model.User;
import model.Booking;
import model.Field;
import model.TimeSlot;
import dao.BookingDAO;
import dao.UserDAO;
import dao.FieldDAO;
import dao.SlotDAO; 
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();       
    private final FieldDAO fieldDAO = new FieldDAO();   
    private final SlotDAO slotDAO = new SlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache"); 
        response.setDateHeader("Expires", 0);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8"); 
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=PlsLogin");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "list":                
                    User u = userDAO.findById(sessionUser.getUserId());
                    if (u != null) {
                        session.setAttribute("currentUser", u);
                    }
                    List<Booking> bookingList = bookingDAO.findByUserId(sessionUser.getUserId());
                    request.setAttribute("bookingList", bookingList);
                    List<Field> fieldList = fieldDAO.findAll();
                    request.setAttribute("fieldList", fieldList);
                    List<TimeSlot> slotList = slotDAO.findAll();
                    request.setAttribute("slotList", slotList);
                    request.getRequestDispatcher("/booking.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/booking?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("currentUser");        
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=PlsLogin");
            return;
        }
        String action = request.getParameter("action");        
        try {
            if ("create".equals(action)) {
                handleCreateBooking(request, response, sessionUser);
            } 
            else if ("update".equals(action)) {
                handleUpdateBooking(request, response);
            } 
            else if ("cancel".equals(action)) {
                handleCancelBooking(request, response);
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/booking?action=list");
            }
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
        }
    }

    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException, ServletException {
        try {
            String fieldIdParam = request.getParameter("fieldId");
            String slotIdParam = request.getParameter("slotId");
            String dateParam = request.getParameter("bookingDate");
            String priceParam = request.getParameter("price");           
            String paymentMethod = request.getParameter("paymentMethod"); 
            String isCheckoutConfirm = request.getParameter("isCheckoutConfirm"); 
            if (fieldIdParam == null || fieldIdParam.trim().isEmpty() ||
                slotIdParam == null || slotIdParam.trim().isEmpty() ||
                dateParam == null || dateParam.trim().isEmpty() ||
                priceParam == null || priceParam.trim().isEmpty()) {               
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
                return;
            }
            int fieldId = Integer.parseInt(fieldIdParam);
            int slotId = Integer.parseInt(slotIdParam);
            java.sql.Date bookingDate = java.sql.Date.valueOf(dateParam);
            Field targetField = fieldDAO.getFieldById(fieldId);
            if (targetField != null && "MAINTENANCE".equalsIgnoreCase(targetField.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=slot_taken");
                return;
            }
            String cleanPrice = priceParam.replaceAll("[^0-9.]", "");
            double submittedPrice = Double.parseDouble(cleanPrice);
            if (submittedPrice <= 0) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
                return;
            }
            if (!"true".equals(isCheckoutConfirm) && (paymentMethod == null || paymentMethod.trim().isEmpty())) {
                request.setAttribute("fId", fieldIdParam);
                request.setAttribute("sId", slotIdParam);
                request.setAttribute("bDate", dateParam);
                request.setAttribute("total", priceParam);                 
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "CASH";
            }
            if (!bookingDAO.isSlotAvailable(fieldId, bookingDate, slotId)) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=slot_taken");
                return;
            }
            Booking newBooking = new Booking();
            newBooking.setUserId(user.getUserId());
            newBooking.setFieldId(fieldId);
            newBooking.setSlotId(slotId);
            newBooking.setBookingDate(bookingDate);
            newBooking.setTotalPrice(submittedPrice);
            int pointsEarned = (int) (submittedPrice / 10000);
            newBooking.setPointsEarned(pointsEarned);
            if (bookingDAO.insertBookingWithPaymentAndPoints(newBooking, paymentMethod)) {
                int points = user.getRewardPoints();
                user.setRewardPoints(points + pointsEarned);
                request.getSession().setAttribute("currentUser", user);               
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=success");
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
            }
        } 
        catch (IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
        }
    }
    
    private void handleUpdateBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int newSlotId = Integer.parseInt(request.getParameter("newSlotId"));
            java.sql.Date newDate = java.sql.Date.valueOf(request.getParameter("newBookingDate"));
            if (bookingDAO.updateBookingSchedule(bookingId, newDate, newSlotId)) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=update_success");
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
            }
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
        }
    }

    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));            
            if (bookingDAO.updateBookingStatus(bookingId, "CANCELLED")) {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=cancel_success");
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
            }
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?action=list&msg=system_error");
        }
    }
}