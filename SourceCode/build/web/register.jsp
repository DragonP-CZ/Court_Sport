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
        body { font-family: 'Lexend', sans-serif; background-color: #f4f6f9 !important; margin: 0; padding: 0; }
        .radius-premium { border-radius: 1rem !important; }
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
<body class="bg-light d-flex align-items-center" style="min-height: 100vh; padding: 20px 0;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                
                <% String error = request.getParameter("error"); %>
                <% if("RegisterFail".equals(error)) { %>
                    <div class="alert alert-danger alert-dismissible fade show radius-premium shadow-sm small" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> Đăng ký thất bại! Email hoặc Số điện thoại đã tồn tại trên hệ thống.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <div class="card shadow-sm border-0 radius-premium bg-white">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <h3 class="fw-bold text-success mb-1"><i class="fa-brands fa-battle-net"></i> COURT SPORT</h3>
                            <p class="text-muted small">Tạo tài khoản thành viên để tích điểm thưởng Rank</p>
                        </div>                       
                        <form action="<%= request.getContextPath() %>/auth?action=register" method="POST" onsubmit="return validateRegisterForm()">                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">HỌ VÀ TÊN</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-id-card text-muted small"></i></span>
                                    <input type="text" class="form-control border-light-subtle py-2" name="fullName" required placeholder="Nguyễn Văn A" style="font-size: 0.85rem;">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">SỐ ĐIỆN THOẠI</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-phone text-muted small"></i></span>
                                    <input type="text" class="form-control border-light-subtle py-2" name="phone" id="phoneInput" required placeholder="0988xxxxxx" style="font-size: 0.85rem;">
                                </div>
                                <div class="form-text text-danger fw-semibold mt-1" id="phoneError" style="font-size: 0.7rem; min-height: 15px;"></div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">EMAIL</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-envelope text-muted small"></i></span>
                                    <input type="email" class="form-control border-light-subtle py-2" name="email" required placeholder="nguyenvana@gmail.com" style="font-size: 0.85rem;">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-secondary">MẬT KHẨU</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-lock text-muted small"></i></span>
                                    <input type="password" class="form-control border-light-subtle py-2" name="password" id="passwordInput" required placeholder="Tối thiểu 6 ký tự" style="font-size: 0.85rem;">
                                </div>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-secondary">XÁC NHẬN MẬT KHẨU</label>
                                <div class="input-group shadow-sm" style="border-radius: 0.5rem; overflow: hidden;">
                                    <span class="input-group-text bg-white border-light-subtle"><i class="fa-solid fa-key text-muted small"></i></span>
                                    <input type="password" class="form-control border-light-subtle py-2" id="confirmPasswordInput" required placeholder="******" style="font-size: 0.85rem;">
                                </div>
                                <div class="form-text text-danger fw-semibold mt-1" id="passwordError" style="font-size: 0.7rem; min-height: 15px;"></div>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold py-2 mb-3 shadow-sm text-uppercase" style="border-radius: 0.5rem; font-size: 0.85rem; letter-spacing: 0.5px;">
                                Đăng Ký Ngay
                            </button>
                        </form>                        
                        <div class="text-center border-top pt-3 mt-3 d-flex justify-content-between align-items-center" style="font-size: 0.75rem;">
                            <a href="<%= request.getContextPath() %>/home" class="text-secondary text-decoration-none fw-semibold">
                                <i class="fa-solid fa-arrow-left me-1"></i> Trang chủ
                            </a>
                            <span>Đã có tài khoản? <a href="<%= request.getContextPath() %>/login.jsp" class="text-success fw-bold text-decoration-none">Đăng nhập</a></span>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
    <script>
        function validateRegisterForm() {
            var phone = document.getElementById("phoneInput").value.trim();
            var password = document.getElementById("passwordInput").value;
            var confirmPassword = document.getElementById("confirmPasswordInput").value;           
            var phoneError = document.getElementById("phoneError");
            var passwordError = document.getElementById("passwordError");            
            phoneError.innerText = "";
            passwordError.innerText = "";
            var phoneRegex = /^(03|05|07|08|09)+([0-9]{8})$/;
            if (!phoneRegex.test(phone)) {
                phoneError.innerText = "Số điện thoại không đúng định dạng Việt Nam (10 chữ số).";
                document.getElementById("phoneInput").focus();
                return false;
            }
            if (password.length < 6) {
                passwordError.innerText = "Mật khẩu phải có độ dài tối thiểu từ 6 ký tự.";
                document.getElementById("passwordInput").focus();
                return false;
            }
            if (password !== confirmPassword) {
                passwordError.innerText = "Mật khẩu xác nhận không khớp! Vui lòng kiểm tra lại.";
                document.getElementById("confirmPasswordInput").focus();
                return false;
            }           
            return true;
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>