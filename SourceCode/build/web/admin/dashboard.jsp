<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COURT SPORT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Lexend', sans-serif; background-color: #f4f6f9 !important; margin: 0; padding: 0; }
        .radius-premium { border-radius: 1rem !important; }
        .radius-2 { border-radius: 0.75rem !important; }
        .bg-light-success { background-color: #e8f5e9; }
        .bg-light-danger { background-color: #ffebee; }
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
            <a class="navbar-brand fw-bold text-success fs-5" href="<%= request.getContextPath() %>/admin?action=dashboard"><i class="fa-brands fa-battle-net"></i> PHÂN TÍCH DOANH THU</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="d-flex align-items-center text-white ms-auto">
                    <% 
                        User adminUser = (User) session.getAttribute("currentUser");
                        if (adminUser != null) {
                    %>
                        <span class="me-3 small"><i class="fa-solid fa-user-shield text-success me-1"></i> Mode: <strong><%= adminUser.getFullName() %></strong></span>
                        <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-outline-danger btn-sm radius-2">
                            <i class="fa-solid fa-right-from-bracket"></i>
                        </a>
                    <% } else { %>
                        <script>window.location.href='<%= request.getContextPath() %>/login.jsp?error=PlsLogin';</script>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
    <div class="container-fluid px-4 my-4">
        <div class="row g-4"> 
            <div class="col-lg-2 mb-2 admin-sidebar">
                <div class="list-group shadow-sm p-2 bg-white radius-premium border-0">
                    <a href="<%= request.getContextPath() %>/admin?action=dashboard" class="list-group-item list-group-item-action active shadow-sm"><i class="fa-solid fa-chart-pie me-2"></i>Tổng doanh thu</a>
                    <a href="<%= request.getContextPath() %>/admin/fields" class="list-group-item list-group-item-action"><i class="fa-solid fa-table-tennis-paddle-ball me-2"></i>Sân đấu</a>
                    <a href="<%= request.getContextPath() %>/admin-booking" class="list-group-item list-group-item-action"><i class="fa-solid fa-list-check me-2"></i>Quản lý đơn ca</a>
                    <a href="<%= request.getContextPath() %>/admin/users" class="list-group-item list-group-item-action"><i class="fa-solid fa-users me-2"></i>Khách hàng</a>
                </div>
            </div>
            <div class="col-lg-10">                
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-4">
                        <div class="card shadow-sm border-0 bg-white p-3 radius-premium d-flex flex-row align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary fw-semibold mb-1" style="font-size: 0.8rem;">SỐ LƯỢT ĐẶT THÀNH CÔNG</h6>
                                <h3 class="mb-0 fw-bold text-dark"><%= request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : 0 %> Ca</h3>
                            </div>
                            <div class="bg-light-success p-3 rounded-circle text-success"><i class="fa-solid fa-calendar-check fa-xl"></i></div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-4">
                        <div class="card shadow-sm border-0 bg-white p-3 radius-premium d-flex flex-row align-items-center justify-content-between">
                            <div>
                                <h6 class="text-secondary fw-semibold mb-1" style="font-size: 0.8rem;">DOANH THU</h6>
                                <h3 class="mb-0 fw-bold text-danger">
                                    <% 
                                        Double revenue = (Double) request.getAttribute("totalRevenue");
                                        out.print(String.format("%,.0f", revenue != null ? revenue : 0.0));
                                    %>đ
                                </h3>
                            </div>
                            <div class="bg-light-danger p-3 rounded-circle text-danger"><i class="fa-solid fa-money-bill-wave fa-xl"></i></div>
                        </div>
                    </div>
                </div>
                <div class="card shadow-sm border-0 radius-premium mb-4 bg-white p-4">
                    <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-chart-line text-success me-2"></i>BIỂU ĐỒ DOANH THU</h6>
                    <div style="position: relative; height: 220px; width: 100%">
                        <canvas id="revenueLineChart"></canvas>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0 radius-premium bg-white overflow-hidden">
                            <div class="card-header bg-dark text-white fw-bold p-3 border-0" style="font-size: 0.85rem;">
                                <i class="fa-solid fa-trophy text-warning me-2"></i>TOP 5 SÂN CÓ HIỆU SUẤT ĐẶT CAO NHẤT
                            </div>
                            <div class="card-body p-0">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.85rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3 text-secondary py-2">Tên Sân Thể Thao</th>
                                            <th class="text-center text-secondary py-2">Số Lượt Đặt Đấu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            List<Map<String, Object>> topFields = (List<Map<String, Object>>) request.getAttribute("topFieldsList");
                                            if (topFields != null && !topFields.isEmpty()) {
                                                for (Map<String, Object> map : topFields) {
                                                    String fName = (String) map.get("fieldName");
                                                    String iconClass = "fa-table-tennis-paddle-ball text-success";
                                                    if (fName != null && fName.contains("Pickleball")) {
                                                        iconClass = "fa-circle-dot text-primary";
                                                    } else if (fName != null && fName.contains("Bóng Đá")) {
                                                        iconClass = "fa-regular fa-futbol text-info";
                                                    }
                                        %>
                                        <tr>
                                            <td class="ps-3 fw-semibold text-dark py-2.5">
                                                <i class="fa-solid <%= iconClass %> me-2"></i><%= fName %>
                                            </td>
                                            <td class="text-center fw-bold text-primary py-2.5"><%= map.get("totalOrders") %> lượt</td>
                                        </tr>
                                        <% 
                                                }
                                            } else { 
                                        %>
                                        <tr><td colspan="2" class="text-center text-muted p-3">Chưa có dữ liệu vận hành hoặc dữ liệu trống.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0 radius-premium bg-white overflow-hidden">
                            <div class="card-header bg-dark text-white fw-bold p-3 border-0" style="font-size: 0.85rem;">
                                <i class="fa-solid fa-crown text-warning me-2"></i>TOP 5 KHÁCH HÀNG VIP
                            </div>
                            <div class="card-body p-0">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.85rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-3 text-secondary py-2">Khách VIP</th>
                                            <th class="text-secondary py-2">Số Điện Thoại</th>
                                            <th class="text-end pe-3 text-secondary py-2">Tổng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            List<Map<String, Object>> topCustomers = (List<Map<String, Object>>) request.getAttribute("topCustomersList");
                                            if (topCustomers != null && !topCustomers.isEmpty()) {
                                                for (Map<String, Object> map : topCustomers) {
                                        %>
                                        <tr>
                                            <td class="ps-3 fw-bold text-dark py-2.5"><i class="fa-solid fa-user text-warning me-2"></i><%= map.get("fullName") %></td>
                                            <td class="text-muted py-2.5"><%= map.get("phone") %></td>
                                            <td class="text-end pe-3 fw-bold text-danger py-2.5"><%= String.format("%,.0f", map.get("totalSpent")) %>đ</td>
                                        </tr>
                                        <% 
                                                }
                                            } else { 
                                        %>
                                        <tr><td colspan="3" class="text-center text-muted p-3">Chưa có dữ liệu chi tiêu hội viên.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        var canvasElement = document.getElementById('revenueLineChart');
        if (!canvasElement) return;       
        var ctx = canvasElement.getContext('2d');
        var labelsArray = [];
        var dataArray = [];       
        <% 
            Map<String, Double> chartData = (Map<String, Double>) request.getAttribute("chartData");
            if (chartData != null && !chartData.isEmpty()) {
                for (Map.Entry<String, Double> entry : chartData.entrySet()) {
        %>
                    labelsArray.push("<%= entry.getKey() %>");
                    dataArray.push(<%= entry.getValue() %>);
        <% 
                }
            } else {
        %>
                labelsArray = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ Nhật"];
                dataArray = [0, 0, 0, 0, 0, 0, 0];
        <% } %>
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labelsArray,
                datasets: [{
                    label: 'Doanh thu thực tế (VNĐ)',
                    data: dataArray,
                    borderColor: '#198754', 
                    backgroundColor: 'rgba(25, 135, 84, 0.05)',
                    borderWidth: 2.5,
                    tension: 0.25, 
                    fill: true,
                    pointBackgroundColor: '#dc3545',
                    pointRadius: 3.5,
                    pointHoverRadius: 5.5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return value.toLocaleString() + 'đ'; }
                        }
                    }
                }
            }
        });
    });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>