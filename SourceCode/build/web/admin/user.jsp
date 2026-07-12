<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, java.util.List" %>
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
                <i class="fa-brands fa-battle-net"></i> TÀI KHOẢN KHÁCH HÀNG
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
                    <a href="<%= request.getContextPath() %>/admin-booking" class="list-group-item list-group-item-action"><i class="fa-solid fa-list-check me-2"></i>Quản lý đơn ca</a>
                    <a href="<%= request.getContextPath() %>/admin/users" class="list-group-item list-group-item-action active shadow-sm"><i class="fa-solid fa-users me-2"></i>Khách hàng</a>
                </div>
            </div>
            <div class="col-lg-10">               
                <% if(request.getParameter("msg") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show p-3 mb-3 small radius-premium border-0 shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i> Thay đổi trạng thái khóa/mở khóa tài khoản người dùng thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <div class="card shadow-sm border-0 radius-premium overflow-hidden">
                    <div class="card-header bg-dark text-white fw-bold p-3 border-0" style="font-size: 0.9rem;">
                        <i class="fa-solid fa-users me-2"></i>Danh Sách Tài Khoản Khách Hàng Toàn Hệ Thống
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" style="font-size: 0.88rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3 text-secondary py-2.5">ID</th>
                                        <th class="text-secondary py-2.5">Họ Và Tên</th>
                                        <th class="text-secondary py-2.5">Email</th>
                                        <th class="text-secondary py-2.5">Số Điện Thoại</th>
                                        <th class="text-secondary py-2.5">Điểm Tích Lũy</th>
                                        <th class="text-secondary py-2.5">Trạng Thái</th>
                                        <th class="text-center text-secondary py-2.5">Thao Tác Quản Trị</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<User> userList = (List<User>) request.getAttribute("adminUserList");
                                        if (userList != null && !userList.isEmpty()) {
                                            for (User u : userList) {
                                    %>
                                    <tr>
                                        <td class="fw-bold ps-3 py-2.5">#<%= u.getUserId() %></td>
                                        <td><strong class="text-dark"><%= u.getFullName() %></strong></td>
                                        <td class="text-secondary"><%= u.getEmail() %></td>
                                        <td class="text-secondary fw-medium"><%= u.getPhone() != null ? u.getPhone() : "N/A" %></td>
                                        <td><span class="badge bg-info-subtle text-info border border-info-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;"><%= u.getRewardPoints() %> điểm</span></td>
                                        <td>
                                            <% if("ACTIVE".equals(u.getStatus())) { %>
                                                <span class="badge bg-success-subtle text-success border border-success-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-circle-check me-1"></i>Đang hoạt động</span>
                                            <% } else { %>
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-user-slash me-1"></i>Bị khóa</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <form action="<%= request.getContextPath() %>/admin/users" method="POST" style="display:inline;" onsubmit="return confirm('Xác nhận thay đổi quyền truy cập của người dùng này?');">
                                                <input type="hidden" name="action" value="toggleStatus">
                                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                <input type="hidden" name="status" value="<%= u.getStatus() %>">
                                                
                                                <% if("ACTIVE".equals(u.getStatus())) { %>
                                                    <button type="submit" class="btn btn-outline-danger btn-sm py-1 px-2 radius-2 fw-semibold" style="font-size: 0.75rem;"><i class="fa-solid fa-lock me-1"></i>Khóa tài khoản</button>
                                                <% } else { %>
                                                    <button type="submit" class="btn btn-outline-success btn-sm py-1 px-2 radius-2 fw-semibold" style="font-size: 0.75rem;"><i class="fa-solid fa-lock-open me-1"></i>Mở khóa</button>
                                                <% } %>
                                            </form>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } else { 
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center p-5 text-muted fw-medium">
                                            <i class="fa-solid fa-user-xmark fs-3 mb-2 text-secondary d-block"></i>
                                            Hệ thống chưa ghi nhận tài khoản người dùng phổ thông nào!
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>