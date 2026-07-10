│   ├── CheckFieldServlet.java   → Tiếp nhận yêu cầu AJAX quét trùng ca bận ngầm từ client
    │   ├── FieldController.java
    │   ├── HomeController.java      → Đẩy danh sách sân hoạt động ra trang chủ index.jsp
    │   └── UserController.java
    │
    ├── dao/                 → Tầng truy vấn dữ liệu (Data Access Object) chứa các câu lệnh SQL
    │   ├── BookingDAO.java  → Thực thi Transaction chốt đơn, cộng điểm Rank và tính doanh thu
    │   ├── CategoryDAO.java
    │   ├── FieldDAO.java    → Xử lý CRUD danh mục sân bãi và trạng thái hoạt động
    │   ├── SlotDAO.java
    │   └── UserDAO.java     → Truy xuất thông tin, cập nhật điểm thưởng và khóa tài khoản
    │
    ├── model/               → Tầng thực thể (Entity Model) ánh xạ 1:1 từ bảng cơ sở dữ liệu
    │   ├── Booking.java
    │   ├── Category.java
    │   ├── Field.java
    │   ├── Payment.java
    │   ├── TimeSlot.java
    │   └── User.java
    │
    └── utils/               → Kết nối MYSQL
        └── DBConnection.java → Kết nối trực tiếp DBase
