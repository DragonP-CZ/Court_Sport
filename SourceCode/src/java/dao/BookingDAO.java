package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Booking;
import utils.DBConnection;

public class BookingDAO {

    public boolean isSlotAvailable(int fieldId, java.sql.Date bookingDate, int slotId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE field_id = ? AND booking_date = ? AND slot_id = ? AND status != 'CANCELLED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);
            ps.setDate(2, bookingDate);
            ps.setInt(3, slotId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    public List<Integer> findBookedFieldIds(java.sql.Date bookingDate, int slotId) {
        List<Integer> bookedFieldIds = new ArrayList<>();
        String sql = "SELECT field_id FROM bookings WHERE booking_date = ? AND slot_id = ? AND status = 'CONFIRMED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, bookingDate);
            ps.setInt(2, slotId);
            rs = ps.executeQuery();
            while (rs.next()) {
                bookedFieldIds.add(rs.getInt("field_id"));
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return bookedFieldIds;
    }

    public List<Integer> getBookedFieldIdsByDateAndSlot(String bookingDate, int slotId) {
        List<Integer> bookedFieldIds = new ArrayList<>();
        String sql = "SELECT field_id FROM bookings WHERE booking_date = ? AND slot_id = ? AND status = 'CONFIRMED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, bookingDate);
            ps.setInt(2, slotId);
            rs = ps.executeQuery();
            while (rs.next()) {
                bookedFieldIds.add(rs.getInt("field_id"));
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return bookedFieldIds;
    }

    public boolean insertBookingWithPaymentAndPoints(Booking booking, String paymentMethod) {
        String insertBookingSql = "INSERT INTO bookings (user_id, field_id, slot_id, booking_date, total_price, points_earned, status) VALUES (?, ?, ?, ?, ?, ?, 'CONFIRMED')";
        String insertPaymentSql = "INSERT INTO payments (booking_id, amount, payment_method, payment_status, payment_time) VALUES (?, ?, ?, 'COMPLETED', NOW())";
        String updateUserPointsSql = "UPDATE users SET reward_points = reward_points + ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psPayment = null;
        PreparedStatement psUser = null;
        ResultSet generatedKeys = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 
            psBooking = conn.prepareStatement(insertBookingSql, java.sql.Statement.RETURN_GENERATED_KEYS);
            psBooking.setInt(1, booking.getUserId());
            psBooking.setInt(2, booking.getFieldId());
            psBooking.setInt(3, booking.getSlotId());
            psBooking.setDate(4, booking.getBookingDate());
            psBooking.setDouble(5, booking.getTotalPrice());
            psBooking.setInt(6, booking.getPointsEarned());          
            int rowsBooking = psBooking.executeUpdate();
            if (rowsBooking == 0) throw new SQLException("Thêm đơn đặt sân thất bại!");
            int bookingId = -1;
            generatedKeys = psBooking.getGeneratedKeys();
            if (generatedKeys.next()) {
                bookingId = generatedKeys.getInt(1);
            } 
            else {
                throw new SQLException("Không lấy được bookingId tự sinh!");
            }
            psPayment = conn.prepareStatement(insertPaymentSql);
            psPayment.setInt(1, bookingId);
            psPayment.setDouble(2, booking.getTotalPrice());
            psPayment.setString(3, paymentMethod);
            psPayment.executeUpdate();
            psUser = conn.prepareStatement(updateUserPointsSql);
            psUser.setInt(1, booking.getPointsEarned());
            psUser.setInt(2, booking.getUserId());
            psUser.executeUpdate();
            conn.commit(); 
            return true;
        } 
        catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } 
        finally {
            try { if (generatedKeys != null) generatedKeys.close(); } catch (SQLException e) {}
            try { if (psUser != null) psUser.close(); } catch (SQLException e) {}
            try { if (psPayment != null) psPayment.close(); } catch (SQLException e) {}
            try { if (psBooking != null) psBooking.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    public boolean updateBookingSchedule(int bookingId, java.sql.Date newDate, int newSlotId) {
        String sql = "UPDATE bookings SET booking_date = ?, slot_id = ? WHERE booking_id = ? AND status = 'CONFIRMED'";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, newDate);
            ps.setInt(2, newSlotId);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, null);
        }
        return false;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String updateBookingSql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        String getBookingInfoSql = "SELECT user_id, points_earned, status FROM bookings WHERE booking_id = ?";
        String updateUserPointsSql = "UPDATE users SET reward_points = CASE " +
                                     "  WHEN ? = 'CANCELLED' THEN reward_points - ? " +
                                     "  WHEN ? = 'CONFIRMED' THEN reward_points + ? " +
                                     "  ELSE reward_points END WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement psGet = null;
        PreparedStatement psUpdateBooking = null;
        PreparedStatement psUpdateUser = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 
            psGet = conn.prepareStatement(getBookingInfoSql);
            psGet.setInt(1, bookingId);
            rs = psGet.executeQuery();           
            int userId = -1;
            int pointsEarned = 0;
            String oldStatus = "";           
            if (rs.next()) {
                userId = rs.getInt("user_id");
                pointsEarned = rs.getInt("points_earned");
                oldStatus = rs.getString("status");
            }
            if (status.equals(oldStatus)) {
                conn.commit();
                return true;
            }
            psUpdateBooking = conn.prepareStatement(updateBookingSql);
            psUpdateBooking.setString(1, status);
            psUpdateBooking.setInt(2, bookingId);
            int rowsBooking = psUpdateBooking.executeUpdate();
            int rowsUser = 1; 
            if (userId != -1 && pointsEarned > 0) {
                psUpdateUser = conn.prepareStatement(updateUserPointsSql);
                psUpdateUser.setString(1, status);
                psUpdateUser.setInt(2, pointsEarned);
                psUpdateUser.setString(3, status);
                psUpdateUser.setInt(4, pointsEarned);
                psUpdateUser.setInt(5, userId);
                rowsUser = psUpdateUser.executeUpdate();
            }
            if (rowsBooking > 0 && rowsUser > 0) {
                conn.commit(); 
                return true;
            } 
            else {
                conn.rollback();
            }
        } 
        catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } 
        finally {
            try { if (psUpdateUser != null) psUpdateUser.close(); } catch (SQLException e) {}
            try { if (psUpdateBooking != null) psUpdateBooking.close(); } catch (SQLException e) {}
            closeResources(conn, psGet, rs);
        }
        return false;
    }

    public List<Booking> findByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, f.field_name, CONCAT(t.start_time, ' - ', t.end_time) AS time_slot " +
                     "FROM bookings b " +
                     "INNER JOIN fields f ON b.field_id = f.field_id " +
                     "INNER JOIN time_slots t ON b.slot_id = t.slot_id " +
                     "WHERE b.user_id = ? ORDER BY b.booking_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setFieldId(rs.getInt("field_id"));
                b.setSlotId(rs.getInt("slot_id"));
                b.setBookingDate(rs.getDate("booking_date"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setPointsEarned(rs.getInt("points_earned"));
                b.setStatus(rs.getString("status"));
                
                b.setFieldName(rs.getString("field_name"));
                b.setTimeSlotText(rs.getString("time_slot"));
                list.add(b);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Booking> findAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, f.field_name, u.full_name AS customer_name, CONCAT(t.start_time, ' - ', t.end_time) AS time_slot " +
                     "FROM bookings b " +
                     "INNER JOIN fields f ON b.field_id = f.field_id " +
                     "INNER JOIN users u ON b.user_id = u.user_id " +
                     "INNER JOIN time_slots t ON b.slot_id = t.slot_id " +
                     "ORDER BY b.booking_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setFieldId(rs.getInt("field_id"));
                b.setSlotId(rs.getInt("slot_id"));
                b.setBookingDate(rs.getDate("booking_date"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setPointsEarned(rs.getInt("points_earned"));
                b.setStatus(rs.getString("status"));
                
                b.setFieldName(rs.getString("field_name")); 
                b.setTimeSlotText(rs.getString("time_slot"));
                b.setCustomerName(rs.getString("customer_name"));
                
                list.add(b);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public double calculateTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE status = 'CONFIRMED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return 0.0;
    }

    public int countTotalActiveBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = 'CONFIRMED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return 0;
    }
    public Map<String, Double> getRevenueLast7Days() {
        Map<String, Double> revenueMap = new HashMap<>();
        String sql = "SELECT DATE(booking_date) AS b_date, SUM(total_price) AS daily_revenue "
                   + "FROM bookings WHERE status = 'CONFIRMED' "
                   + "AND booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) "
                   + "GROUP BY DATE(booking_date) ORDER BY b_date ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                revenueMap.put(rs.getString("b_date"), rs.getDouble("daily_revenue"));
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return revenueMap;
    }

    public List<Map<String, Object>> getTopFields() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT f.field_name, COUNT(b.booking_id) AS total_orders "
                   + "FROM bookings b JOIN fields f ON b.field_id = f.field_id "
                   + "WHERE b.status = 'CONFIRMED' "
                   + "GROUP BY f.field_id ORDER BY total_orders DESC LIMIT 5";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("fieldName", rs.getString("field_name"));
                map.put("totalOrders", rs.getInt("total_orders"));
                list.add(map);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public List<Map<String, Object>> getTopCustomers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.full_name, u.phone, SUM(b.total_price) AS total_spent "
                   + "FROM bookings b JOIN users u ON b.user_id = u.user_id "
                   + "WHERE b.status = 'CONFIRMED' "
                   + "GROUP BY u.user_id ORDER BY total_spent DESC LIMIT 5";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("fullName", rs.getString("full_name"));
                map.put("phone", rs.getString("phone"));
                map.put("totalSpent", rs.getDouble("total_spent"));
                list.add(map);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}