<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Field, java.util.List" %>
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
        .bg-light-success { background-color: #e8f5e9; }
        .bg-light-danger { background-color: #ffebee; }
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
                <i class="fa-brands fa-battle-net"></i> THIẾT LẬP SÂN ĐẤU
            </a>
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
                    <a href="<%= request.getContextPath() %>/admin?action=dashboard" class="list-group-item list-group-item-action"><i class="fa-solid fa-chart-pie me-2"></i>Tổng doanh thu</a>
                    <a href="<%= request.getContextPath() %>/admin/fields" class="list-group-item list-group-item-action active shadow-sm"><i class="fa-solid fa-table-tennis-paddle-ball me-2"></i>Sân đấu</a>
                    <a href="<%= request.getContextPath() %>/admin-booking" class="list-group-item list-group-item-action"><i class="fa-solid fa-list-check me-2"></i>Quản lý đơn ca</a>
                    <a href="<%= request.getContextPath() %>/admin/users" class="list-group-item list-group-item-action"><i class="fa-solid fa-users me-2"></i>Khách hàng</a>
                </div>
            </div>
            <div class="col-lg-10">                
                <% String msg = request.getParameter("msg"); %>
                <% if(msg != null) { %>
                    <div class="alert alert-success alert-dismissible fade show p-3 mb-3 small radius-premium border-0 shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i>
                        <% if("add_success".equals(msg)) { %> Khai báo và thêm mới sân thể thao vào hệ thống thành công! <% } %>
                        <% if("delete_success".equals(msg)) { %> Xóa dữ liệu sân đấu khỏi hệ thống thành công! <% } %>
                        <% if("update_success".equals(msg)) { %> Cập nhật trạng thái vận hành của sân đấu thành công! <% } %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if("foreign_key_constraint".equals(request.getParameter("error")) || "foreign_key_fail".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger alert-dismissible fade show p-3 mb-3 small radius-premium border-0 shadow-sm" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Không thể xóa!</strong> Sân đấu này hiện đang gắn liền với lịch sử đơn đặt ca của khách hàng trong CSDL.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if(request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show p-3 mb-3 small radius-premium border-0 shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-xmark me-2"></i>Thao tác thất bại. Vui lòng kiểm tra lại dữ liệu đầu vào!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark mb-0"><i class="fa-solid fa-layer-group text-success me-2"></i>Danh Sách Sân Đấu Toàn Hệ Thống</h5>
                    <button class="btn btn-success btn-sm fw-bold shadow-sm py-2 px-3 radius-2" data-bs-toggle="modal" data-bs-target="#addFieldModal">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Sân Mới
                    </button>
                </div>

                <div class="card shadow-sm border-0 radius-premium overflow-hidden">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" style="font-size: 0.88rem;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3 text-secondary py-2.5">ID</th>
                                        <th class="text-secondary py-2.5">Tên Sân Đấu</th>
                                        <th class="text-secondary py-2.5">Bộ Môn</th>
                                        <th class="text-secondary py-2.5">Giá Thuê</th>
                                        <th class="text-secondary py-2.5">Trạng Thái</th>
                                        <th class="text-secondary py-2.5">Mô Tả Chi</th>
                                        <th class="text-center text-secondary py-2.5">Điều Chỉnh</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        List<Field> adminFields = (List<Field>) request.getAttribute("adminFieldList");
                                        if (adminFields != null && !adminFields.isEmpty()) {
                                            for (Field f : adminFields) {
                                                
                                                String categoryName = f.getCategoryName();
                                                String badgeColor = "bg-success-subtle text-success border-success-subtle";
                                                if (categoryName != null && categoryName.contains("Pickleball")) {
                                                    badgeColor = "bg-primary-subtle text-primary border-primary-subtle";
                                                } else if (categoryName != null && categoryName.contains("Bóng Đá")) {
                                                    badgeColor = "bg-warning text-dark border-warning shadow-sm";
                                                }
                                    %>
                                    <tr>
                                        <td class="fw-bold ps-3 py-2.5">#<%= f.getFieldId() %></td>
                                        <td><strong class="text-dark"><%= f.getFieldName() %></strong></td>
                                        <td>
                                            <span class="badge border px-2 py-1.5 radius-2 <%= badgeColor %>" style="font-size: 0.72rem; font-weight: 600;">
                                                <%= categoryName != null ? categoryName : (f.getCategoryId() == 1 ? "Cầu Lông" : "Pickleball") %>
                                            </span>
                                        </td>
                                        <td class="text-danger fw-bold"><%= String.format("%,.0f", f.getPricePerSlot()) %>đ</td>
                                        <td>
                                            <% if("AVAILABLE".equalsIgnoreCase(f.getStatus())) { %>
                                                <span class="badge bg-success-subtle text-success border border-success-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-circle-check me-1"></i>Hoạt động</span>
                                            <% } else { %>
                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle py-1 px-2 fw-bold" style="border-radius: 0.4rem;"><i class="fa-solid fa-screwdriver-wrench me-1"></i>Bảo trì</span>
                                            <% } %>
                                        </td>
                                        <td class="text-muted small"><%= f.getDescription() != null ? f.getDescription() : "Không có mô tả." %></td>                                       
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center align-items-center gap-2">
                                                <form action="<%= request.getContextPath() %>/admin/fields?action=updateStatus" method="POST" class="m-0">
                                                    <input type="hidden" name="fieldId" value="<%= f.getFieldId() %>">
                                                    <% if("AVAILABLE".equalsIgnoreCase(f.getStatus())) { %>
                                                        <input type="hidden" name="status" value="MAINTENANCE">
                                                        <button type="submit" class="btn btn-outline-warning btn-sm py-1 px-2 radius-2 fw-semibold" style="font-size: 0.75rem; white-space: nowrap;" title="Chuyển sang bảo trì">
                                                            <i class="fa-solid fa-screwdriver-wrench me-1"></i>Bảo trì
                                                        </button>
                                                    <% } else { %>
                                                        <input type="hidden" name="status" value="AVAILABLE">
                                                        <button type="submit" class="btn btn-outline-success btn-sm py-1 px-2 radius-2 fw-semibold" style="font-size: 0.75rem; white-space: nowrap;" title="Mở khóa hoạt động">
                                                            <i class="fa-solid fa-circle-check me-1"></i>Mở lại
                                                        </button>
                                                    <% } %>
                                                </form>
                                                <form action="<%= request.getContextPath() %>/admin/fields?action=delete" method="POST" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa hoàn toàn sân thể thao này khỏi hệ thống không?');">
                                                    <input type="hidden" name="fieldId" value="<%= f.getFieldId() %>">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm py-1 px-2 radius-2 fw-semibold" style="font-size: 0.75rem; white-space: nowrap;" title="Xóa sân đấu">
                                                        <i class="fa-solid fa-trash-can me-1"></i>Xóa
                                                    </button>
                                                </form>
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
                                            Hệ thống chưa ghi nhận sân thể thao nào. Vui lòng thêm mới!
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
    <div class="modal fade" id="addFieldModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content radius-premium border-0 shadow">
                <form action="<%= request.getContextPath() %>/admin/fields?action=add" method="POST">
                    <div class="modal-header bg-dark text-white border-0 p-3" style="border-top-left-radius: 1rem; border-top-right-radius: 1rem;">
                        <h5 class="modal-title fs-6 fw-bold"><i class="fa-solid fa-square-plus text-success me-2"></i>Triển Khai Sân Mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small">TÊN SÂN THỂ THAO</label>
                            <input type="text" class="form-control radius-2 border-light-subtle" name="fieldName" required placeholder="Ví dụ: Sân Cầu Lông Số 3" style="font-size: 0.85rem;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small">BỘ MÔN</label>
                            <select class="form-select radius-2 border-light-subtle" name="categoryId" style="font-size: 0.85rem; font-weight: 500;">
                                <option value="1">🏸 Bộ môn Cầu Lông</option>
                                <option value="2">☄️ Bộ môn Pickleball</option>
                                <option value="3">⚽ Bộ môn Bóng Đá</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small">GIÁ THUÊ (VNĐ)</label>
                            <input type="number" class="form-control radius-2 border-light-subtle" name="pricePerSlot" required placeholder="80000" style="font-size: 0.85rem;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small">TRẠNG THÁI VẬN HÀNH BAN ĐẦU</label>
                            <select class="form-select radius-2 border-light-subtle" name="status" style="font-size: 0.85rem; font-weight: 500;">
                                <option value="AVAILABLE">Sẵn sàng hoạt động</option>
                                <option value="MAINTENANCE">Tạm ngưng bảo trì</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small">MÔ TẢ CHI TIẾT</label>
                            <textarea class="form-control radius-2 border-light-subtle" name="description" rows="2" placeholder="Vị trí thảm PVC, hệ thống đèn chiếu..." style="font-size: 0.85rem;"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-secondary radius-2 small fw-semibold" data-bs-dismiss="modal" style="font-size: 0.8rem;">Đóng</button>
                        <button type="submit" class="btn btn-success fw-bold radius-2 text-uppercase px-3" style="font-size: 0.8rem; letter-spacing: 0.3px;">Xác Nhận Lưu Sân</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>