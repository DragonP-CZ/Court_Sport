package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TimeSlot; 
import utils.DBConnection;

public class SlotDAO {

    public List<TimeSlot> findAll() {
        List<TimeSlot> list = new ArrayList<>();
        String sql = "SELECT slot_id, DATE_FORMAT(start_time, '%H:%i') AS start, "
                   + "DATE_FORMAT(end_time, '%H:%i') AS end FROM time_slots ORDER BY start_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {           
            while (rs.next()) {
                TimeSlot slot = new TimeSlot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setStartTime(rs.getString("start"));
                slot.setEndTime(rs.getString("end"));
                list.add(slot);
            }
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}