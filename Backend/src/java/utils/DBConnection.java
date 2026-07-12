package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/BookingFieldDB?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8";
    private static final String USERNAME = "root"; // Thay bằng username MySQL của bạn
    private static final String PASSWORD = "123456"; // Thay bằng password MySQL của bạn

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy Driver MySQL JDBC!", e);
        }
    }
}