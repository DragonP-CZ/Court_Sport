DROP DATABASE IF EXISTS `BookingFieldDB`;
CREATE DATABASE `BookingFieldDB` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `BookingFieldDB`;

-- BẢNG VAI TRÒ (ROLES)
CREATE TABLE `roles` (
    `role_id` INT AUTO_INCREMENT PRIMARY KEY,
    `role_name` VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BẢNG NGƯỜI DÙNG (USERS)
CREATE TABLE `users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `role_id` INT NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `phone` VARCHAR(15) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `reward_points` INT DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, LOCKED
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT,
    CONSTRAINT `chk_points_positive` CHECK (`reward_points` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BẢNG LOẠI SÂN / BỘ MÔN THỂ THAO 
CREATE TABLE `categories` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BẢNG DANH SÁCH SÂN THỂ THAO (FIELDS) - CẬP NHẬT TRẠNG THÁI BẢO TRÌ
CREATE TABLE `fields` (
    `field_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `field_name` VARCHAR(100) NOT NULL,
    `price_per_slot` DECIMAL(10,2) NOT NULL,
    `status` VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE (Sẵn sàng), MAINTENANCE (Bảo trì), UNAVAILABLE (Ngừng hoạt động)
    `description` TEXT,
    CONSTRAINT `fk_fields_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE,
    CONSTRAINT `chk_price_positive` CHECK (`price_per_slot` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BẢNG KHUNG GIỜ CỐ ĐỊNH (TIME SLOTS)
CREATE TABLE `time_slots` (
    `slot_id` INT AUTO_INCREMENT PRIMARY KEY,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    CONSTRAINT `uq_time_frame` UNIQUE (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BẢNG ĐƠN ĐẶT SÂN HỆ THỐNG (BOOKINGS)
CREATE TABLE `bookings` (
    `booking_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `field_id` INT NOT NULL,
    `slot_id` INT NOT NULL,
    `booking_date` DATE NOT NULL,
    `total_price` DECIMAL(10,2) NOT NULL,
    `points_earned` INT DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'CONFIRMED', -- CONFIRMED, CANCELLED
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT `fk_bookings_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_bookings_fields` FOREIGN KEY (`field_id`) REFERENCES `fields` (`field_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_bookings_slots` FOREIGN KEY (`slot_id`) REFERENCES `time_slots` (`slot_id`) ON DELETE RESTRICT,
    
    -- QUY TẮC VÀNG CHỐNG TRÙNG LỊCH THỜI GIAN THỰC
    CONSTRAINT `uq_realtime_booking` UNIQUE (`field_id`, `booking_date`, `slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. TẠO BẢNG HOÁ ĐƠN THANH TOÁN (PAYMENTS)
CREATE TABLE `payments` (
    `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` INT NOT NULL,
    `amount` DECIMAL(10,2) NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL, -- 'CASH', 'QR_CODE', 'BANK_TRANSFER'
    `payment_status` VARCHAR(50) DEFAULT 'COMPLETED',
    `payment_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_payments_bookings` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. TẠO INDEXES TỐI ƯU HOÁ HIỆU NĂNG TRUY VẤN TÌM KIẾM
CREATE INDEX idx_booking_date ON bookings(booking_date);
CREATE INDEX idx_field_status ON fields(status);
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Nạp cấu hình Vai trò (Roles)
INSERT INTO `roles` (`role_id`, `role_name`) VALUES 
(1, 'ADMIN'), 
(2, 'USER');

-- Nạp danh sách Tài khoản (Users)
INSERT INTO `users` (`user_id`, `role_id`, `full_name`, `email`, `phone`, `password_hash`, `reward_points`, `status`) VALUES 
(1, 1, 'Chủ Sân', 'admin@webcauda.com', '0911223344', '123456', 0, 'ACTIVE'),
(2, 2, 'Nguyễn Văn Khách', 'khachhang@gmail.com', '0988776655', '123456', 58, 'ACTIVE');

-- Nạp phân hệ Loại Bộ Môn (Categories)
INSERT INTO `categories` (`category_id`, `category_name`, `description`) VALUES 
(1, 'Cầu Lông', 'Sân thảm PVC tiêu chuẩn thi đấu, độ bám cao, ánh sáng chống lóa hoàn hảo.'),
(2, 'Pickleball', 'Môn thể thao xu hướng mới, hệ thống sân chuẩn quốc tế trong nhà.'),
(3, 'Bóng Đá', 'Sân cỏ nhân tạo chất lượng cao, hệ thống chiếu sáng LED ban đêm, tiêu chuẩn sân 5 và sân 7.');

-- Nạp danh sách Sân đấu động thực tế (Fields)
INSERT INTO `fields` (`field_id`, `category_id`, `field_name`, `price_per_slot`, `status`, `description`) VALUES 
(1, 1, 'Sân Cầu Lông Số 1', 80000.00, 'AVAILABLE', 'Sân thảm xanh PVC cao cấp, vị trí gần cửa ra vào thoáng mát.'),
(2, 1, 'Sân Cầu Lông Số 2', 80000.00, 'MAINTENANCE', 'Sân đang thực hiện bảo trì hệ thống chiếu sáng LED dọc biên, tạm thời đóng đặt lịch.'),
(3, 2, 'Sân Pickleball Premium A', 150000.00, 'AVAILABLE', 'Sân Pickleball VIP trong nhà, mái che kiên cố không sợ mưa nắng.'),
(4, 3, 'Sân Bóng Đá Mini Số 1 (Sân 5)', 350000.00, 'AVAILABLE', 'Sân cỏ 5 người, kích thước tiêu chuẩn, phù hợp đá giao lưu văn phòng.'),
(5, 3, 'Sân Bóng Đá Mini Số 2 (Sân 5)', 350000.00, 'AVAILABLE', 'Sân cỏ 5 người tiêu chuẩn, vị trí thoát nước tốt, không lo ngập úng.'),
(6, 3, 'Sân Bóng Đá Cỏ Nhân Tạo KST (Sân 7)', 500000.00, 'AVAILABLE', 'Sân lớn 7 người, cỏ nhân tạo nhập khẩu, hệ thống đèn LED cao áp chống lóa.');

-- Nạp cấu hình các Khung giờ cố định (Time Slots)
INSERT INTO `time_slots` (`slot_id`, `start_time`, `end_time`) VALUES 
(1, '08:00:00', '09:30:00'),
(2, '09:30:00', '11:00:00'),
(3, '13:00:00', '14:30:00'),
(4, '14:30:00', '16:00:00'),
(5, '16:00:00', '17:30:00'),
(6, '17:30:00', '19:00:00'),
(7, '19:00:00', '20:30:00'),
(8, '20:30:00', '22:00:00');

-- Nạp đơn đặt lịch ca mẫu để kích hoạt hiển thị hệ thống (Bookings)
INSERT INTO `bookings` (`booking_id`, `user_id`, `field_id`, `slot_id`, `booking_date`, `total_price`, `points_earned`, `status`) VALUES 
(1, 2, 1, 2, '2026-07-07', 80000.00, 8, 'CONFIRMED');

-- Nạp biên lai thanh toán mẫu liên kết tương ứng với đơn hàng số 1 (Payments)
INSERT INTO `payments` (`payment_id`, `booking_id`, `amount`, `payment_method`, `payment_status`) VALUES
(1, 1, 80000.00, 'CASH', 'COMPLETED');

SELECT 'HỆ THỐNG CƠ SỞ DỮ LIỆU ĐÃ ĐỒNG BỘ TOÀN VẸN VỚI VIEW VÀ DAO THUẦN!' AS `Trạng thái`;
SELECT 
    f.field_id AS `ID Sân`,
    c.category_name AS `Bộ Môn`,
    f.field_name AS `Tên Sân`,
    CONVERT(f.price_per_slot, DECIMAL(10,0)) AS `Giá Thuê (đ/ca)`,
    f.status AS `Trạng Thái`
FROM `fields` f
JOIN `categories` c ON f.category_id = c.category_id
ORDER BY c.category_id ASC, f.field_id ASC;
SELECT * FROM `users`;
SELECT * FROM `fields`;
SELECT * FROM `bookings`;
SELECT * FROM `payments`;
