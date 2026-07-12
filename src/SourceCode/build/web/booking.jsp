<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Booking, model.Field, model.TimeSlot, java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COURT SPORT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700&display=swap" rel="stylesheet">    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_green.css">   
    <style>
        body { font-family: 'Lexend', sans-serif; background-color: #f4f6f9 !important; margin: 0; padding: 0; }
        .radius-premium { border-radius: 1rem !important; }
        .radius-2 { border-radius: 0.75rem !important; }
        .table-responsive { overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .badge-field { max-width: 150px; display: inline-block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; vertical-align: middle; }
        .history-table th { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .history-table td { font-size: 0.85rem; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-success fs-5" href="<%= request.getContextPath() %>/"><i class="fa-brands fa-battle-net"></i> COURT SPORT</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-lg-center">
                    <li class="nav-item"><a class="nav-link fw-semibold text-white-50 small me-2" href="<%= request.getContextPath() %>/home">Trang Chủ</a></li>
                    <li class="nav-item"><a class="nav-link active fw-semibold small me-3" href="<%= request.getContextPath() %>/booking?action=list">Đặt Lịch</a></li>
                </ul>
                <div class="d-flex align-items-center ms-auto">
                    <% 
                        User user = (User) session.getAttribute("currentUser");
                        if (user != null) {
                    %>
                        <span class="text-white me-2 small"><i class="fa-solid fa-user text-success me-1"></i>HI, <strong><%= user.getFullName() %></strong></span>
                        <span class="badge bg-warning text-dark p-2 fw-bold me-3" style="font-size:0.65rem; border-radius: 0.5rem;"><i class="fa-solid fa-star me-1"></i>Điểm: <%= user.getRewardPoints() %></span>
                        <% if(user.getRoleId() == 1) { %>
                            <a href="<%= request.getContextPath() %>/admin" class="btn btn-sm btn-success me-2 radius-2 fw-semibold px-2" style="font-size: 0.75rem;"><i class="fa-solid fa-user-shield me-1"></i>Quản trị</a>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-outline-danger btn-sm radius-2"><i class="fa-solid fa-right-from-bracket"></i></a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
    <div class="container my-4">
        <% String msg = request.getParameter("msg"); %>
        <% if("success".equals(msg)) { %>
            <div class="alert alert-success alert-dismissible fade show radius-premium shadow-sm border-0" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> <strong>Đặt sân thành công!</strong> Bạn đã được cộng thêm điểm thưởng dựa trên hạng thành viên của mình.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if("slot_taken".equals(msg) || "update_taken".equals(msg)) { %>
            <div class="alert alert-danger alert-dismissible fade show radius-premium shadow-sm border-0" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> <strong>Thao tác thất bại!</strong> Khung giờ tại sân đấu lựa chọn đã bị đặt trước hoặc sân đang đóng bảo trì.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <div class="row g-4">
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 radius-premium">
                    <div class="card-header bg-success text-white fw-bold p-3 border-0" style="border-top-left-radius: 1rem; border-top-right-radius: 1rem;">
                        <i class="fa-solid fa-calendar-plus me-2"></i>Đặt Sân Liền Tay
                    </div>
                    <div class="card-body p-4">
                        <form action="<%= request.getContextPath() %>/booking?action=create" method="POST" id="bookingForm">
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-dark small">CHỌN SÂN THI ĐẤU</label>
                                <select class="form-select border-light-subtle radius-2 shadow-sm" name="fieldId" id="fieldSelect" required style="font-size: 0.85rem; font-weight: 500;">
                                    <option value="" data-price="0" disabled selected>--- Chọn sân còn trống ---</option>
                                    <% 
                                        List<Field> fieldList = (List<Field>) request.getAttribute("fieldList");
                                        if (fieldList != null && !fieldList.isEmpty()) {
                                            for (Field f : fieldList) {
                                                String rawStatus = (f.getStatus() != null) ? f.getStatus().trim().toUpperCase() : "AVAILABLE";
                                                String formattedPrice = String.format("%,.0f", f.getPricePerSlot());
                                                String cleanText = f.getFieldName() + " (" + formattedPrice + "đ/ca)";
                                    %>
                                        <option value="<%= f.getFieldId() %>" 
                                                data-price="<%= f.getPricePerSlot() %>" 
                                                data-status="<%= rawStatus %>"
                                                data-original-text="<%= cleanText %>">
                                            <%= cleanText %>
                                        </option>
                                    <% 
                                            }
                                        } 
                                    %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-dark small">CHỌN NGÀY CHƠI</label>
                                <input type="date" class="form-control border-light-subtle radius-2 shadow-sm" name="bookingDate" id="dateInput" required style="font-size: 0.85rem;">
                            </div>                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-dark small">CHỌN KHUNG GIỜ</label>
                                <select class="form-select border-light-subtle radius-2 shadow-sm" name="slotId" id="slotSelect" required style="font-size: 0.85rem; font-weight: 500;">
                                    <option value="" disabled selected>--- Chọn ca thi đấu ---</option>
                                    <% 
                                        List<TimeSlot> slotList = (List<TimeSlot>) request.getAttribute("slotList");
                                        if (slotList != null && !slotList.isEmpty()) {
                                            for (TimeSlot s : slotList) {
                                    %>
                                        <option value="<%= s.getSlotId() %>">
                                            Ca <%= s.getSlotId() %>: <%= s.getStartTime() %> - <%= s.getEndTime() %>
                                        </option>
                                    <% 
                                            }
                                        } 
                                    %>
                                </select>
                            </div>
                            <div class="card bg-light p-3 mb-3 border-0 radius-premium">
                                <%
                                    int userPoints = (user != null) ? user.getRewardPoints() : 0;
                                    String rankName = "Thành Viên Bạc";
                                    String rankClass = "bg-secondary";
                                    int discountPercent = 0;
                                    int nextTargetPoints = 500;
                                    String nextRankName = "Vàng";
                                    int progressPercent = 0;
                                    if (userPoints >= 1000) {
                                        rankName = "Hội Viên Bạch Kim (VIP)";
                                        rankClass = "bg-danger shadow-sm";
                                        discountPercent = 5;
                                        progressPercent = 100;
                                    } else if (userPoints >= 500) {
                                        rankName = "Hội Viên Vàng";
                                        rankClass = "bg-warning text-dark shadow-sm";
                                        discountPercent = 2;
                                        nextTargetPoints = 1000;
                                        nextRankName = "Bạch Kim";
                                        progressPercent = (int) (((userPoints - 500) / 500.0) * 100);
                                    } else {
                                        progressPercent = (int) ((userPoints / 500.0) * 100);
                                    }
                                %>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-semibold text-secondary" style="font-size: 0.8rem;"><i class="fa-solid fa-crown text-warning me-1"></i> Cột mốc Rank:</span>
                                    <span class="badge <%= rankClass %> fw-bold py-1 px-2" id="rankBadge" style="font-size: 0.70rem;"><%= rankName %></span>
                                </div>                               
                                <div class="mb-3 mt-2">
                                    <div class="d-flex justify-content-between mb-1" style="font-size: 0.7rem;">
                                        <span>Điểm hiện có: <strong><%= userPoints %></strong></span>
                                        <% if (userPoints < 1000) { %>
                                            <span class="text-muted">Cần thêm <strong><%= (nextTargetPoints - userPoints) %></strong> điểm lên rank <%= nextRankName %></span>
                                        <% } else { %>
                                            <span class="text-danger fw-bold"><i class="fa-solid fa-bolt"></i> Đạt Hạng Cao Nhất</span>
                                        <% } %>
                                    </div>
                                    <div class="progress" style="height: 6px; border-radius: 4px;">
                                        <div class="progress-bar <%= userPoints >= 1000 ? "bg-danger" : (userPoints >= 500 ? "bg-warning" : "bg-success") %> progress-bar-striped progress-bar-animated" 
                                             role="progressbar" 
                                             style="width: <%= progressPercent %>%;"></div>
                                    </div>
                                </div>
                                <div class="p-2 mb-3 bg-white rounded border border-light-subtle" style="font-size: 0.72rem; border-radius: 0.5rem !important;">
                                    <div class="d-flex justify-content-between <%= userPoints < 500 ? "fw-bold text-dark" : "text-muted" %>">
                                        <span>• Hạng Bạc (Dưới 500đ):</span> <span>Giảm 0%</span>
                                    </div>
                                    <div class="d-flex justify-content-between <%= (userPoints >= 500 && userPoints < 1000) ? "fw-bold text-warning" : "text-muted" %>">
                                        <span>• Hạng Vàng (500đ - 999đ):</span> <span>Giảm 2%</span>
                                    </div>
                                    <div class="d-flex justify-content-between <%= userPoints >= 1000 ? "fw-bold text-danger" : "text-muted" %>">
                                        <span>• Hạng Bạch Kim (Trên 1000đ):</span> <span>Giảm 5%</span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-light-subtle">
                                    <span class="small text-secondary">Tổng tiền gốc:</span>
                                    <span class="text-secondary text-decoration-line-through small" id="originalPriceDisplay">0đ</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-1">
                                    <span class="small text-success fw-semibold">Được giảm (<%= discountPercent %>%):</span>
                                    <span class="text-success fw-bold small" id="discountDisplay">0đ</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-2 pt-2 border-top border-light-subtle">
                                    <span class="small fw-bold text-dark">Thành tiền thực tế:</span>
                                    <span class="fw-bold text-danger fs-5" id="finalPriceDisplay">0đ</span>
                                </div>
                            </div>                          
                            <input type="hidden" name="price" id="hiddenPrice" value="0">
                            <button type="submit" class="btn btn-success w-100 fw-bold py-2 shadow-sm radius-2 text-uppercase" id="submitBookingBtn" style="font-size: 0.85rem; letter-spacing: 0.5px;">
                                <i class="fa-solid fa-check me-2"></i>Xác Nhận Đặt Sân
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 radius-premium">
                    <div class="card-header bg-dark text-white fw-bold p-3 border-0" style="border-top-left-radius: 1rem; border-top-right-radius: 1rem;">
                        <i class="fa-solid fa-clock-history me-2"></i>Lịch Sử Đặt Sân Của Bạn
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 history-table">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3 text-secondary">Mã đơn</th>
                                        <th class="text-secondary">Tên Sân</th>
                                        <th class="text-secondary">Ngày Đặt</th>
                                        <th class="text-secondary">Khung Giờ</th>
                                        <th class="text-secondary">Chi Phí</th>
                                        <th class="text-secondary">Trạng Thái</th>
                                        <th class="text-center text-secondary">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<Booking> list = (List<Booking>) request.getAttribute("bookingList");
                                        if (list != null && !list.isEmpty()) {
                                            for (Booking b : list) {
                                    %>
                                    <tr>
                                        <td class="fw-bold ps-3">#<%= b.getBookingId() %></td>
                                        <td><span class="badge bg-secondary badge-field py-1 px-2 text-wrap" title="<%= b.getFieldName() %>" style="border-radius: 0.4rem; background-color: #6c757d !important;"><%= b.getFieldName() %></span></td>
                                        <td class="fw-semibold text-dark"><%= b.getBookingDate() %></td>
                                        <td><strong class="text-primary"><%= b.getTimeSlotText() %></strong></td>
                                        <td class="fw-bold text-danger"><%= String.format("%,.0f", b.getTotalPrice()) %>đ</td>
                                        <td>
                                            <% if("CONFIRMED".equals(b.getStatus())) { %>
                                                <span class="badge bg-success-subtle text-success border border-success-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;">Thành công</span>
                                            <% } else { %>
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;">Đã hủy</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <% if("CONFIRMED".equals(b.getStatus())) { %>
                                                <form action="<%= request.getContextPath() %>/booking?action=cancel" method="POST" class="d-inline" onsubmit="return confirm('Xác nhận hủy lịch đấu?');">
                                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger radius-2 fw-semibold" style="font-size: 0.75rem;">
                                                        <i class="fa-solid fa-trash"></i> Hủy 
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span class="text-muted small fw-medium">N/A</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } else { 
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center p-4 text-muted fw-medium">Bạn chưa có đơn đặt sân nào. Hãy đặt sân ngay bên trái!</td>
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
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
    <script>
        var fieldSelect = document.getElementById("fieldSelect");
        var dateInput = document.getElementById("dateInput");
        var slotSelect = document.getElementById("slotSelect");
        var bookingForm = document.getElementById("bookingForm");
        var discountPercent = parseInt("<%= discountPercent %>") || 0;
        function calculatePrice() {
            if (fieldSelect.selectedIndex === -1 || fieldSelect.value === "") {
                document.getElementById("originalPriceDisplay").textContent = "0đ";
                document.getElementById("discountDisplay").textContent = "0đ";
                document.getElementById("finalPriceDisplay").textContent = "0đ";
                document.getElementById("hiddenPrice").value = "0";
                return;
            }
            var selectedOption = fieldSelect.options[fieldSelect.selectedIndex];
            var originalPrice = parseFloat(selectedOption.getAttribute("data-price")) || 0;
            var discountAmount = originalPrice * (discountPercent / 100);
            var finalPrice = originalPrice - discountAmount;
            document.getElementById("originalPriceDisplay").textContent = originalPrice.toLocaleString() + "đ";
            document.getElementById("discountDisplay").textContent = discountAmount.toLocaleString() + "đ";
            document.getElementById("finalPriceDisplay").textContent = finalPrice.toLocaleString() + "đ";
            document.getElementById("hiddenPrice").value = finalPrice;
        }
        
        function executeRealtimeValidation() {
            var dateValue = dateInput.value;
            var slotValue = slotSelect.value;
            if (!dateValue || !slotValue) return;
            var apiUrl = "<%= request.getContextPath() %>/api/check-fields?date=" + dateValue + "&slotId=" + slotValue;
            fetch(apiUrl)
                .then(response => response.json())
                .then(resultData => {
                    var bookedFieldIds = resultData.bookedFieldIds || [];
                    for (var i = 0; i < fieldSelect.options.length; i++) {
                        var option = fieldSelect.options[i];
                        var fieldId = parseInt(option.value);
                        if (!fieldId) continue; 
                        var originalText = option.getAttribute("data-original-text") || option.text;
                        if (!option.getAttribute("data-original-text")) {
                            option.setAttribute("data-original-text", originalText);
                        }
                        var originalStatus = option.getAttribute("data-status") || "AVAILABLE";
                        if ("MAINTENANCE" === originalStatus) {
                            option.text = originalText + " 🛠️ (Sân đang bảo trì)";
                            option.disabled = true;
                            option.style.color = "#b58105";
                            option.style.fontWeight = "bold";
                            option.style.backgroundColor = "#fff3cd";
                        } else if (bookedFieldIds.includes(fieldId)) {
                            option.text = originalText + " ❌ (Đã có người đặt)";
                            option.disabled = true;
                            option.style.color = "#dc3545";
                            option.style.fontWeight = "bold";
                            option.style.backgroundColor = "#f8d7da";
                        } else {
                            option.text = originalText;
                            option.disabled = false;
                            option.style.color = "";
                            option.style.fontWeight = "";
                            option.style.backgroundColor = "";
                        }
                    }

                    if (fieldSelect.selectedOptions[0] && fieldSelect.selectedOptions[0].disabled) {
                        fieldSelect.value = "";
                        calculatePrice();
                    }
                })
                .catch(error => console.error("[AJAX ERROR] Lỗi phân hệ quét ca bận: ", error));
        }
        document.addEventListener("DOMContentLoaded", function() {
            calculatePrice(); 
            // Lịch
            flatpickr("#dateInput", {
                locale: "vn",
                dateFormat: "Y-m-d",
                altInput: true,
                altFormat: "d/m/Y",
                minDate: new Date(),        // Khóa các ngày quá khứ thời gian thực
                defaultDate: "today",       // Tự động chọn ngày hôm nay khi load trang
                onChange: function(selectedDates, dateStr, instance) {
                    executeRealtimeValidation();
                }
            });
            setTimeout(executeRealtimeValidation, 300);
            fieldSelect.addEventListener("change", calculatePrice);
            slotSelect.addEventListener("change", executeRealtimeValidation);
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>