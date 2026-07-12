<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Booking, java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COURT SPORT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Lexend', sans-serif; background-color: #f4f6f9 !important; margin: 0; padding: 0; }
        .radius-premium { border-radius: 1rem !important; }
        .radius-2 { border-radius: 0.75rem !important; }
        .table-responsive { overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .filter-label { font-size: 0.78rem; font-weight: 700; color: #495057; text-transform: uppercase; letter-spacing: 0.5px; }
        .admin-sidebar .list-group-item {
            border: none !important;
            padding: 12px 18px;
            font-weight: 500;
            font-size: 0.9rem;
            color: #495057;
            border-radius: 0.5rem !important;
            margin-bottom: 4px;
            transition: all 0.2s ease;
        }
        .admin-sidebar .list-group-item:hover {
            background-color: #e9ecef;
            color: #212529;
        }
        .admin-sidebar .list-group-item.active {
            background-color: #198754 !important;
            color: #ffffff !important;
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-success fs-5" href="<%= request.getContextPath() %>/admin?action=dashboard">
                <i class="fa-brands fa-battle-net"></i> ĐƠN SÂN TOÀN HỆ THỐNG
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="d-flex align-items-center text-white ms-auto">
                    <span class="me-3 small"><i class="fa-solid fa-user-shield text-success me-1"></i> Mode: <strong>Chủ Sân</strong></span>
                    <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-outline-danger btn-sm radius-2">
                        <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4 my-4">
        <div class="row g-4">
            
            <div class="col-lg-2 mb-2 admin-sidebar">
                <div class="list-group shadow-sm p-2 bg-white radius-premium border-0">
                    <a href="<%= request.getContextPath() %>/admin?action=dashboard" class="list-group-item list-group-item-action"><i class="fa-solid fa-chart-pie me-2"></i>Tổng doanh thu</a>
                    <a href="<%= request.getContextPath() %>/admin/fields" class="list-group-item list-group-item-action"><i class="fa-solid fa-table-tennis-paddle-ball me-2"></i>Sân đấu</a>
                    <a href="<%= request.getContextPath() %>/admin-booking" class="list-group-item list-group-item-action active shadow-sm"><i class="fa-solid fa-list-check me-2"></i>Quản lý đơn ca</a>
                    <a href="<%= request.getContextPath() %>/admin/users" class="list-group-item list-group-item-action"><i class="fa-solid fa-users me-2"></i>Khách hàng</a>
                </div>
            </div>
            <div class="col-lg-10">
                <% if(request.getParameter("msg") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show p-3 mb-3 small radius-premium border-0 shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i><strong>Cập nhật thành công!</strong> Trạng thái đơn đặt ca đấu đã được đồng bộ hóa trên CSDL.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <div class="card shadow-sm border-0 radius-premium p-4 mb-4 bg-white">
                    <div class="row g-3">
                        <div class="col-xl-4 col-md-6">
                            <label class="filter-label mb-1.5"><i class="fa-solid fa-magnifying-glass me-1 text-success"></i> Tìm kiếm nhanh</label>
                            <input type="text" id="adminSearchInput" class="form-control border-light-subtle py-2 radius-2 shadow-sm" placeholder="Tìm tên khách, mã đơn, tên sân..." onkeyup="executeAdvancedSearchEngine()" style="font-size: 0.85rem;">
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <label class="filter-label mb-1.5"><i class="fa-solid fa-toggle-on me-1 text-success"></i> Trạng thái ca</label>
                            <select class="form-select border-light-subtle py-2 radius-2 shadow-sm" id="statusFilter" onchange="executeAdvancedSearchEngine()" style="font-size: 0.85rem; font-weight: 500;">
                                <option value="ALL">Tất cả trạng thái</option>
                                <option value="CONFIRMED">Thành công (CONFIRMED)</option>
                                <option value="CANCELLED">Đã hủy ca (CANCELLED)</option>
                            </select>
                        </div>
                        <div class="col-xl-2 col-sm-6">
                            <label class="filter-label mb-1.5"><i class="fa-solid fa-calendar-days me-1 text-success"></i> Lọc theo ngày</label>
                            <input type="date" id="dateFilter" class="form-control border-light-subtle py-2 radius-2 shadow-sm" onchange="executeAdvancedSearchEngine()" style="font-size: 0.85rem;">
                        </div>
                        <div class="col-xl-3 col-sm-6">
                            <label class="filter-label mb-1.5"><i class="fa-solid fa-clock me-1 text-success"></i> Lọc theo buổi thi đấu</label>
                            <select class="form-select border-light-subtle py-2 radius-2 shadow-sm" id="timeFilter" onchange="executeAdvancedSearchEngine()" style="font-size: 0.85rem; font-weight: 500;">
                                <option value="ALL">Tất cả khung giờ</option>
                                <option value="MORNING">Khung giờ Sáng (08:00 - 11:00)</option>
                                <option value="AFTERNOON">Khung giờ Chiều (13:00 - 17:30)</option>
                                <option value="NIGHT">Khung giờ Đêm ⚡ (17:30 - 22:00)</option>
                            </select>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        <button class="btn btn-link btn-sm text-decoration-none text-secondary p-0 fw-semibold" onclick="resetAllFilters()" style="font-size: 0.8rem;">
                            <i class="fa-solid fa-arrow-rotate-left me-1"></i>Xóa tất cả bộ lọc
                        </button>
                    </div>
                </div>
                <div class="card shadow-sm border-0 radius-premium overflow-hidden">
                    <div class="card-header bg-dark text-white fw-bold p-3 border-0" style="font-size: 0.9rem;">
                        <i class="fa-solid fa-list-check me-2"></i>Danh Sách Đơn Đặt Sân Toàn Hệ Thống
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" id="bookingMasterTable" style="font-size: 0.88rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3 text-secondary py-2.5">Mã đơn</th>
                                        <th class="text-secondary py-2.5">Khách Hàng</th>
                                        <th class="text-secondary py-2.5">Sân Đấu</th>
                                        <th class="text-secondary py-2.5">Ngày Ca</th>
                                        <th class="text-secondary py-2.5">Khung Giờ</th>
                                        <th class="text-secondary py-2.5">Doanh Thu</th>
                                        <th class="text-center text-secondary py-2.5">Trạng Thái & Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookingsList");
                                        if (allBookings != null && !allBookings.isEmpty()) {
                                            for (Booking b : allBookings) {
                                                
                                                String fName = b.getFieldName();
                                                String badgeColor = "bg-success-subtle text-success border-success-subtle"; 
                                                if (fName != null && fName.contains("Pickleball")) {
                                                    badgeColor = "bg-primary-subtle text-primary border-primary-subtle"; 
                                                } else if (fName != null && fName.contains("Bóng Đá")) {
                                                    badgeColor = "bg-warning text-dark border-warning"; 
                                                }
                                    %>
                                    <tr data-status="<%= b.getStatus() %>">
                                        <td class="fw-bold ps-3">#<%= b.getBookingId() %></td>
                                        <td><strong class="text-dark"><%= b.getCustomerName() != null ? b.getCustomerName() : "N/A" %></strong></td>
                                        <td><span class="badge border px-2 py-1.5 radius-2 <%= badgeColor %>" style="font-size: 0.72rem; font-weight: 600;"><%= fName %></span></td>
                                        <td class="fw-medium text-secondary"><%= b.getBookingDate() %></td>
                                        <td><strong class="text-primary"><%= b.getTimeSlotText() %></strong></td>
                                        <td class="fw-bold text-danger"><%= String.format("%,.0f", b.getTotalPrice()) %>đ</td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-2">
                                                <% if("CONFIRMED".equals(b.getStatus())) { %>
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1.5 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-square-check me-1"></i>Thành công</span>
                                                    <form action="<%= request.getContextPath() %>/admin-booking?action=updateStatus" method="POST" style="display:inline;" onsubmit="return confirm('Xác nhận hủy lịch đấu này? Hệ thống sẽ tự động hoàn tác trừ điểm tích lũy của khách hàng.');">
                                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                                        <input type="hidden" name="status" value="CANCELLED">
                                                        <button type="submit" class="btn btn-danger btn-sm py-1 px-2 fw-semibold radius-2" style="font-size: 0.75rem;"><i class="fa-solid fa-ban me-1"></i>Hủy ca</button>
                                                    </form>
                                                <% } else { %>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1.5 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-rectangle-xmark me-1"></i>Đã hủy ca</span>
                                                    <form action="<%= request.getContextPath() %>/admin-booking?action=updateStatus" method="POST" style="display:inline;" onsubmit="return confirm('Xác nhận khôi phục lịch ca đấu này? Hệ thống sẽ tự động tính toán cộng lại điểm thưởng cho khách hàng.');">
                                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                                        <input type="hidden" name="status" value="CONFIRMED">
                                                        <button type="submit" class="btn btn-success btn-sm py-1 px-2 fw-semibold radius-2" style="font-size: 0.75rem;"><i class="fa-solid fa-rotate-left me-1"></i>Khôi phục</button>
                                                    </form>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } else { 
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center p-5 text-muted fw-medium">
                                            <i class="fa-solid fa-inbox fs-3 mb-2 text-secondary d-block"></i>
                                            Hệ thống chưa ghi nhận đơn đặt ca nào từ tầng dữ liệu MySQL!
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function executeAdvancedSearchEngine() {
        var keyword = document.getElementById("adminSearchInput").value.toLowerCase().trim();
        var selectedStatus = document.getElementById("statusFilter").value;
        var selectedDate = document.getElementById("dateFilter").value; 
        var selectedTime = document.getElementById("timeFilter").value; 
        var tableRows = document.querySelectorAll("#bookingMasterTable tbody tr");
        tableRows.forEach(function(row) {
            if (row.cells.length < 7) return; 
            var rowStatus = row.getAttribute("data-status");
            var orderId = row.cells[0].textContent.toLowerCase();
            var customerName = row.cells[1].textContent.toLowerCase();
            var fieldName = row.cells[2].textContent.toLowerCase();
            var rowDate = row.cells[3].textContent.trim(); 
            var rowTimeRange = row.cells[4].textContent.trim(); 
            var matchKeyword = orderId.includes(keyword) || 
                               customerName.includes(keyword) || 
                               fieldName.includes(keyword);               
            var matchStatus = (selectedStatus === "ALL" || selectedStatus === rowStatus);
            var matchDate = (selectedDate === "" || rowDate === selectedDate);
            var matchTime = true;
            if (selectedTime !== "ALL") {
                var startTime = rowTimeRange.split("-")[0].trim(); 
                if (selectedTime === "MORNING") {
                    // Ca 1 (08:00 - 09:30), Ca 2 (09:30 - 11:00)
                    matchTime = (startTime >= "08:00" && startTime < "11:01");
                } else if (selectedTime === "AFTERNOON") {
                    // Ca 3 (13:00 - 14:30), Ca 4 (14:30 - 16:00), Ca 5 (16:00 - 17:30)
                    matchTime = (startTime >= "13:00" && startTime < "17:30");
                } else if (selectedTime === "NIGHT") {
                    // Ca 6 (17:30 - 19:00), Ca 7 (19:00 - 20:30), Ca 8 (20:30 - 22:00)
                    matchTime = (startTime >= "17:30" && startTime <= "22:00");
                }
            }
            if (matchKeyword && matchStatus && matchDate && matchTime) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }
    function resetAllFilters() {
        document.getElementById("adminSearchInput").value = "";
        document.getElementById("statusFilter").value = "ALL";
        document.getElementById("dateFilter").value = "";
        document.getElementById("timeFilter").value = "ALL";
        executeAdvancedSearchEngine();
    }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>