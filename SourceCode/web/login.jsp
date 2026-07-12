<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        body { 
            font-family: 'Lexend', sans-serif; 
            background-color: #f4f6f9 !important; 
        }      
        .radius-premium { 
            border-radius: 1rem !important; 
        }     
        .form-control:focus {
            border-color: #198754 !important;
            box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25) !important;
        }
        .input-group-text {
            border-right: none !important;
        }
        .form-control {
            border-left: none !important;
        }
    </style>
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">              
                <% 
                    String error = request.getParameter("error"); 
                    if(error == null) {
                        error = request.getParameter("auth_error");
                    }
                %>
                <% if("InvalidCredentials".equals(error) || "failed".equals(error)) { %>
                    <div class="alert alert-danger alert-dismissible fade show radius-premium shadow-sm small" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> Sai email hoặc mật khẩu! Vui lòng kiểm tra lại.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if("PlsLogin".equals(error)) { %>
                    <div class="alert alert-warning alert-dismissible fade show radius-premium shadow-sm small" role="alert">
                        <i class="fa-solid fa-circle-info me-2"></i> Vui lòng đăng nhập tài khoản để sử dụng chức năng đặt lịch ca.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if("RegisterSuccess".equals(error)) { %>
                    <div class="alert alert-success alert-dismissible fade show radius-premium shadow-sm small" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i> Đăng ký thành công! Hãy đăng nhập ngay.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if("AccessDenied".equals(error) || "AdminAccessRequired".equals(error)) { %>
                    <div class="alert alert-danger alert-dismissible fade show radius-premium shadow-sm small" role="alert">
                        <i class="fa-solid fa-shield-halved me-2"></i> <strong>Từ chối truy cập!</strong> Vùng quản trị chỉ dành riêng cho tài khoản Chủ Sân (Admin).
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <div class="card shadow-sm border-0 radius-premium bg-white">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <h3 class="fw-bold text-success mb-1"><i class="fa-brands fa-battle-net"></i> COURT SPORT</h3>
                            <p class="text-muted small">Đăng nhập tài khoản đặt sân dễ dàng</p>
                        </div>                        
                        <form action="<%= request.getContextPath() %>/auth?action=login" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">EMAIL</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-envelope text-muted small"></i></span>
                                    <input type="email" class="form-control border-light-subtle py-2 small" name="email" required placeholder="name@example.com" style="font-size: 0.85rem;">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-secondary">MẬT KHẨU</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-lock text-muted small"></i></span>
                                    <input type="password" class="form-control border-light-subtle py-2 small" name="password" required placeholder="******" style="font-size: 0.85rem;">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold py-2 mb-3 shadow-sm text-uppercase" style="border-radius: 0.5rem; font-size: 0.85rem; letter-spacing: 0.5px;">
                                Đăng Nhập
                            </button>
                        </form>                        
                        <div class="text-center border-top pt-3 mt-3 d-flex justify-content-between align-items-center" style="font-size: 0.75rem;">
                            <a href="<%= request.getContextPath() %>/home" class="text-secondary text-decoration-none fw-semibold">
                                <i class="fa-solid fa-arrow-left me-1"></i> Trang chủ
                            </a>
                            <span>Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register.jsp" class="text-success fw-bold text-decoration-none">Đăng ký</a></span>
                        </div>
                    </div>
                </div>               
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>