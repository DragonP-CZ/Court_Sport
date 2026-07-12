package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList; 
import java.util.List;      
import model.User;
import utils.DBConnection;

public class UserDAO {

    public User login(String email, String password) {
        String cleanEmail = (email != null) ? email.trim() : "";
        String cleanPassword = (password != null) ? password.trim() : "";
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ? AND status = 'ACTIVE'";      
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;       
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, cleanEmail);
            ps.setString(2, cleanPassword);           
            rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setRoleId(rs.getInt("role_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRewardPoints(rs.getInt("reward_points"));
                user.setStatus(rs.getString("status"));
                return user;
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return null;
    }
    
    public boolean register(User user) {
        String sql = "INSERT INTO users (role_id, full_name, email, phone, password_hash, reward_points, status) VALUES (?, ?, ?, ?, ?, 0, 'ACTIVE')";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, 2); 
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail().trim());
            ps.setString(4, user.getPhone().trim());
            ps.setString(5, user.getPasswordHash().trim());
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

    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;         
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setRewardPoints(rs.getInt("reward_points"));
                return user;
            }
        } 
        catch (SQLException e) {
            System.err.println("[JDBC ERROR] Lỗi tra cứu điểm thưởng người dùng theo ID!");
            e.printStackTrace();
        } 
        finally {
            closeResources(conn, ps, rs);
        }
        return null;
    }

    public List<User> findAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id != 1 ORDER BY user_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRewardPoints(rs.getInt("reward_points"));
                u.setStatus(rs.getString("status")); 
                list.add(u);
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

    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
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

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}