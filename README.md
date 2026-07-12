# Court Sport - Website Quản Lý Đặt Sân Bóng Đá Và Cầu Lông

## Thông Tin Đồ Án
* **Trường:** Đại học Hùng Vương TP. Hồ Chí Minh
* **Khoa:** Kỹ thuật - Công nghệ
* **Môn học:** Lập trình Web
* **Lớp:** CT07A
* **Giảng viên hướng dẫn:** TS. Lê Duy Tân
* **Nhóm thực hiện:** 4AN1PM
* **Thời gian thực hiện:** Năm học 2025-2026

---

## Thành Viên Nhóm & Phân Công Nhiệm Vụ

Hệ thống đánh giá đóng góp công việc nội bộ đạt sự đồng thuận 100% cho tất cả các thành viên:

| STT | Họ và Tên | MSSV | Nhiệm Vụ Đảm Nhiệm | Mức Độ Đóng Góp |
| :---: | :--- | :---: | :--- | :---: |
| 1 | **Phan Huỳnh Phi Long** | 2305CT2242 | Trưởng nhóm, Đảm nhiệm phần Frontend | 100% |
| 2 | **Võ Bá Huy** | 2305CT2318 | Lập trình Backend, Thiết kế bản thuyết trình PowerPoint | 100% |
| 3 | **Nguyễn Huy Đạt** | 2305CT2334 | Xử lý các chức năng nghiệp vụ CRUD, Viết báo cáo Word | 100% |
| 4 | **Hồ Lữ Anh Kiệt** | 2305CT0199 | Viết báo cáo Word, Hỗ trợ thiết kế bản thuyết trình PowerPoint | 100% |
| 5 | **Nguyễn Thiên Bảo** | 2305CT0628 | Thiết kế và cấu hình hệ thống Database | 100% |

---

## Giới Thiệu Đề Tài
Hiện nay, phần lớn các cơ sở kinh doanh sân thể thao vẫn áp dụng hình thức quản lý thủ công hoặc qua điện thoại, dẫn đến việc nhầm lẫn lịch, mất thời gian và khó tra cứu thông tin. Website **Court Sport** ra đời nhằm cung cấp nền tảng trực tuyến giúp người dùng dễ dàng tìm kiếm, đặt sân, thanh toán theo thời gian thực và hỗ trợ các đơn vị quản lý vận hành kinh doanh hiệu quả.

### Đối Tượng Sử Dụng Hệ Thống
1. **Khách hàng** 
2. **Quản lý** 
3. **Chủ kinh doanh** 
4. **Quản trị viên** 

## Các chức năng chính
* **Chức năng 1 (Đăng ký, Đăng nhập & Phân quyền):** Xác thực người dùng, bảo mật mật khẩu băm và phân quyền truy cập (Admin/User).
* **Chức năng 2 (Quản lý sân đấu - CRUD):** Thêm mới, chỉnh sửa, xóa và cập nhật trạng thái vận hành (Hoạt động/Bảo trì) cho hệ thống sân bóng đá và cầu lông.
* **Chức năng 3 (Đặt sân & Chống trùng lịch):** Khách hàng tra cứu ca trống, đặt lịch linh hoạt. Hệ thống áp dụng kỹ thuật Database Transaction và Row-level Lock để đảm bảo tuyệt đối không bị trùng lịch (Overbooking).
* **Chức năng 4 (Quản lý đơn đặt & Thanh toán):** Giả lập cổng thanh toán đa phương thức. Admin có quyền theo dõi toàn bộ hóa đơn, phê duyệt hoặc hủy ca khẩn cấp.
* **Chức năng 5 (Thống kê & Báo cáo):** Dashboard dành cho Admin hiển thị biểu đồ phân tích doanh thu, thống kê hiệu suất sân và top khách hàng VIP.

---

## Yêu Cầu Kỹ Thuật (Non-functional Requirements)
* **Kiến trúc:** Phát triển theo mô hình chuẩn **MVC** (Model - DAO - Servlet/Controller - JSP View).
* **Backend:** Xử lý Request/Response bằng **Java Servlet** kết nối qua **JDBC**.
* **Frontend:** Giao diện hiển thị động bằng **JSP**, thiết kế responsive thân thiện trên mọi thiết bị.
* **Database:** Hệ quản trị cơ sở dữ liệu **MySQL**, sử dụng cấu trúc Engine **InnoDB** và bảng mã **utf8mb4_unicode_ci**.

---

## Kiến Trúc Cơ Sở Dữ Liệu (`BookingFieldDB`)

Hệ thống bao gồm **07 bảng dữ liệu** được thiết kế chuẩn hóa chặt chẽ:
1. `roles`: Lưu trữ cấu hình vai trò hệ thống (ADMIN, USER...).
2. `users`: Quản lý thông tin tài khoản, mật khẩu băm bảo mật và điểm thưởng (`reward_points`).
3. `categories`: Danh mục bộ môn thể thao (Bóng đá, Cầu lông...).
4. `fields`: Danh sách các sân đấu thực tế kèm đơn giá và trạng thái (AVAILABLE, MAINTENANCE...).
5. `time_slots`: Cấu hình các ca/khung giờ cố định trong ngày.
6. `bookings`: Đơn đặt sân chi tiết của khách hàng.
7. `payments`: Biên lai thanh toán dòng tiền ('CASH', 'QR_CODE', 'BANK_TRANSFER').

### Sơ đồ Thực thể - Liên kết (ERD)
Sơ đồ quan hệ thực tế giữa các bảng dữ liệu trong hệ thống:

![Sơ đồ Cơ sở Dữ liệu ERD - Court Sport](https://github.com/user-attachments/assets/82e08585-20ca-4041-8080-9004c8060494)

> **Quy Tắc Vàng (Real-time Validation):**
> Hệ thống áp dụng ràng buộc duy nhất `CONSTRAINT uq_realtime_booking UNIQUE (field_id, booking_date, slot_id)`. Ràng buộc này đảm bảo tại một sân, vào một ca giờ của một ngày cụ thể, chỉ chấp nhận duy nhất một đơn đặt thành công.

---

## Hướng Dẫn Cài Đặt & Chạy Dự Án

## 1. Yêu cầu hệ thống
Để chạy dự án Website Đặt Sân Thể Thao, máy tính cần cài đặt các phần mềm sau:

| Phần mềm | Phiên bản khuyến nghị |
| :--- | :--- |
| **Hệ điều hành** | Windows 10/11 hoặc Ubuntu |
| **Java Development Kit (JDK)** | JDK 17 máy đang sài |
| **Apache NetBeans** | 17 trở lên |
| **Apache Tomcat** | Tomcat 11.0 |
| **MySQL Server** | 8.0 trở lên |
| **MySQL Workbench** | 8.0 trở lên |
| **Web Browser** | Google Chrome, Microsoft Edge hoặc Firefox |

---

## 2. Cài đặt môi trường 

### Bước 1: Cài đặt JDK
* Tải xuống và cài đặt bộ cài JDK từ trang chủ Oracle.
* Cấu hình biến môi trường hệ thống: Định nghĩa `JAVA_HOME` trỏ tới thư mục cài đặt JDK và thêm đường dẫn `;%JAVA_HOME%\bin` vào biến `Path`.
* Kiểm tra tính thông mạch bằng cửa sổ Command Prompt (cmd): `java -version` (hiển thị phiên bản là đúng).

### Bước 2: Tích hợp Web Server Apache Tomcat vào NetBeans
* Tải bản phân phối tệp nén `.zip` của Apache Tomcat về máy và giải nén.
* Mở giao diện Apache NetBeans, di chuyển đến thanh quản trị: **Services** ➡️ **Servers** ➡️ **Add Server**.
* Chọn **Apache Tomcat**.

### Bước 3: Khởi tạo Dịch vụ Dữ liệu MySQL
* Tiến hành cài đặt MySQL Workbench.
* Thiết lập mật khẩu cho tài khoản quản trị tối cao (`root`) và đảm bảo tiến trình **MySQL Service** đang chạy ngầm trên hệ thống.

---

## 3. Khởi tạo Cơ sở dữ liệu vật lý
Mở công cụ **MySQL Workbench**, thiết lập kết nối vào `Localhost` và thực thi tuần tự các bước cấu hình sau:

* **Bước 1**: Khởi tạo một Schema mới mang tên định danh của dự án:
  ```sql
  CREATE DATABASE courtsport CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
* **Bước 2**: Ra lệnh chỉ định phân vùng làm việc cho phiên kết nối:
  ```sql
  USE courtsport;
* **Bước 3**: Mở và chạy file script cấu trúc `database.sql` (hoặc `courtsport.sql`) đi kèm dự án để tự động xây dựng các bảng vật lý và mối quan hệ khóa ngoại:
  ```text
  users → roles → fields → categories → bookings → payments → time_slots
* **Bước 4**: Chạy file script dữ liệu để nạp sẵn danh mục các ca đấu cố định, danh sách sân bóng/sân cầu lông và các tài khoản thử nghiệm hệ thống.
## 4. Triển khai và Cấu hình mã nguồn trên IDE

### Bước 1: Mở dự án trong Apache NetBeans
* Khởi động NetBeans, trên thanh Menu điều hướng chọn: `File` → `Open Project`.
* Tìm đến thư mục chứa mã nguồn của đồ án mang tên `web_04` và nhấn nút `Open Project`.
### Bước 2: Định cấu hình kết nối trong tệp DBConnection.java
* Truy cập theo cấu trúc thư mục package `utils`, mở tệp tin `DBConnection.java` ra điều chỉnh thông số định danh truy cập MySQL cho khớp với máy cục bộ:
  ```java
  private static final String USERNAME = "tên tài khoản mysql của bạn mặc định là root";
  private static final String PASSWORD = "mật khẩu sql của bạn";
### Bước 3: Rà soát thư viện kết nối JDBC
* Chuột phải vào tên dự án → chọn `Properties` → chọn phân mục `Libraries`.
* Đảm bảo tại tab `Compile`, hệ thống đã nhận diện được file Driver trung gian: máy đang dùng `jakarta.servlet.jsp.jstl-3.0.1.jar`, `jakarta.servlet.jsp.jstl-api-3.0.0.jar` và `mysql-connector-j-9.6.0.jar`.
* Nếu chưa có, nhấn nút `Add JAR/Folder` để trỏ file thủ công.
## 5. Khởi chạy và Kiểm thử chức năng toàn cục

### A. Kích hoạt Server
* Nhấp chuột phải vào tên dự án, chọn `Clean and Build` để dọn dẹp bộ nhớ đệm và biên dịch lại mã nguồn sạch.
* Nhấn nút `Run` (biểu tượng hình tam giác màu xanh) trên thanh công cụ.
* Hệ thống máy chủ Apache Tomcat sẽ tự động biên dịch (compile) các Servlet, triển khai ứng dụng và mở trình duyệt mặc định để truy cập thẳng vào địa chỉ trang chủ: `http://localhost:8080/web_04`
### B. Hệ thống tài khoản mặc định có trong sql

**Mode: Chủ sân**
| Thuộc tính | Giá trị |
| :--- | :--- |
| Username | admin@webcauda.com |
| Password | 123456 |

**Mode: Khách**
| Thuộc tính | Giá trị |
| :--- | :--- |
| Username | khachhang@gmail.com |
| Password | 123456 |

Sau khi chạy thành công, kiểm tra lần lượt các chức năng:
* Đăng ký tài khoản.
* Đăng nhập.
* Xem danh sách sân.
* Tìm kiếm sân.
* Xem chi tiết sân.
* Đặt sân.
* Thanh toán (mô phỏng).
* Xem lịch sử đặt sân.
* Đăng xuất.
* Đăng nhập Admin.
* Quản lý sân.
* Quản lý người dùng.
* Quản lý đơn đặt.
* Xem thống kê.
## 6. Cấu trúc thư mục mã nguồn hoàn chỉnh của dự án
Cấu trúc thư mục được tổ chức chuẩn hóa theo mô hình phân lớp MVC (Model-View-Controller)

```text
courtsport/ (Thư mục gốc của dự án trên IDE NetBeans)
│
├── Web Pages (Thành phần Front-end & Cấu hình deployment)
│   ├── WEB-INF/
│   │   └── web.xml          → Tệp tin XML cấu hình hệ thống toàn cục (Welcome files, Session timeout)
│   ├── admin/               → Phân hệ giao diện Quản trị viên (Admin)
│   │   ├── booking.jsp      → Quản lý và xử lý danh sách đơn ca toàn hệ thống
│   │   ├── dashboard.jsp    → Xem biểu đồ phân tích doanh thu và các thẻ chỉ số KPI
│   │   ├── field.jsp        → Thiết lập danh mục sân đấu (CRUD) và bật/tắt bảo trì
│   │   └── user.jsp         → Xem thông tin khách hàng, điểm tích lũy và khóa tài khoản
│   │
│   ├── booking.jsp          → Giao diện chọn ngày, chọn ca bận thời gian thực của khách
│   ├── index.jsp            → Trang chủ hiển thị danh sách sân bãi và bộ lọc môn thể thao
│   ├── login.jsp            → Form đăng nhập tài khoản thành viên hệ thống
│   ├── payment.jsp          → Cổng thanh toán giả lập và tổng hợp hóa đơn trước khi chốt đơn
│   └── register.jsp         → Form đăng ký tài khoản khách hàng mới
│
└── Source Packages (Thành phần mã nguồn Java Backend)
    ├── controller/          → Tầng điều hướng (Servlet Layer) tiếp nhận Request/Response
    │   ├── AdminBookingController.java
    │   ├── AdminController.java
    │   ├── AdminSecurityFilter.java → Bộ lọc an ninh gác cổng, chặn truy cập trái phép vào /admin/*
    │   ├── AuthController.java      → Xử lý logic đăng ký, đăng nhập và đăng xuất
    │   ├── BookingController.java   → Xử lý luồng dữ liệu tạo đơn đặt lịch và thanh toán
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

```
## 7. Video thuyết trình và demo
* **Link xem video trình bày dự án:** [Xem Video Demo Đồ Án Court Sport Tại Đây](https://drive.google.com/file/d/1Pdl_apvmHJxQJrS-IBSJDIvketEn8Phj/view?usp=drive_link)
