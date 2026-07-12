package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Field;
import utils.DBConnection;

public class FieldDAO {

    public Field getFieldById(int fieldId) {
        String sql = "SELECT f.*, c.category_name FROM fields f "
                   + "INNER JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.field_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setCategoryId(rs.getInt("category_id"));
                f.setFieldName(rs.getString("field_name"));
                f.setPricePerSlot(rs.getDouble("price_per_slot"));
                f.setStatus(rs.getString("status"));
                f.setDescription(rs.getString("description"));
                f.setCategoryName(rs.getString("category_name"));
                return f;
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

    public List<Integer> getFieldIdsByStatus(String status) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT field_id FROM fields WHERE status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("field_id"));
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

    public boolean updateStatus(int fieldId, String status) {
        String sql = "UPDATE fields SET status = ? WHERE field_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, fieldId);
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

    public List<Field> findAllAvailable() {
        List<Field> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM fields f "
                   + "INNER JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.status = 'AVAILABLE' ORDER BY f.field_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;       
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setCategoryId(rs.getInt("category_id"));
                f.setFieldName(rs.getString("field_name"));
                f.setPricePerSlot(rs.getDouble("price_per_slot"));
                f.setStatus(rs.getString("status"));
                f.setDescription(rs.getString("description"));
                f.setCategoryName(rs.getString("category_name")); 
                list.add(f);
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

    public List<Field> findAvailableByCategoryId(int categoryId) {
        List<Field> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM fields f "
                   + "INNER JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.status = 'AVAILABLE' AND f.category_id = ? "
                   + "ORDER BY f.field_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId); 
            rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setCategoryId(rs.getInt("category_id"));
                f.setFieldName(rs.getString("field_name"));
                f.setPricePerSlot(rs.getDouble("price_per_slot"));
                f.setStatus(rs.getString("status"));
                f.setDescription(rs.getString("description"));
                f.setCategoryName(rs.getString("category_name")); 
                list.add(f);
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

    public List<Field> findAllByCategoryId(int categoryId) {
        List<Field> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM fields f "
                   + "INNER JOIN categories c ON f.category_id = c.category_id "
                   + "WHERE f.category_id = ? "
                   + "ORDER BY f.field_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setCategoryId(rs.getInt("category_id"));
                f.setFieldName(rs.getString("field_name"));
                f.setPricePerSlot(rs.getDouble("price_per_slot"));
                f.setStatus(rs.getString("status"));
                f.setDescription(rs.getString("description"));
                f.setCategoryName(rs.getString("category_name"));
                list.add(f);
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
    
    public List<Field> findAll() {
        List<Field> list = new ArrayList<>();
        String sql = "SELECT f.*, c.category_name FROM fields f "
                   + "INNER JOIN categories c ON f.category_id = c.category_id "
                   + "ORDER BY f.field_id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;       
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setCategoryId(rs.getInt("category_id"));
                f.setFieldName(rs.getString("field_name"));
                f.setPricePerSlot(rs.getDouble("price_per_slot"));
                f.setStatus(rs.getString("status"));
                f.setDescription(rs.getString("description"));
                f.setCategoryName(rs.getString("category_name"));
                list.add(f);
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

    public boolean insert(Field field) {
        String sql = "INSERT INTO fields (category_id, field_name, price_per_slot, status, description) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, field.getCategoryId());
            ps.setString(2, field.getFieldName());
            ps.setDouble(3, field.getPricePerSlot());
            ps.setString(4, field.getStatus());
            ps.setString(5, field.getDescription());
            
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

    public boolean delete(int fieldId) throws SQLException {
        String sql = "DELETE FROM fields WHERE field_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);
            return ps.executeUpdate() > 0;
        } 
        catch (SQLException e) {
            throw e; 
        } 
        finally {
            closeResources(conn, ps, null);
        }
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}