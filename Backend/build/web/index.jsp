<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Booking, model.Field, java.util.List" %>
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
        .field-card { 
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); 
            overflow: hidden;
            border: none !important;
            border-radius: 1rem !important;
        }
        .field-card:hover:not(.card-maintenance) { 
            transform: translateY(-6px); 
            box-shadow: 0 12px 24px rgba(0,0,0,0.1) !important;
        }
        .card-img-wrapper {
            overflow: hidden;
            border-top-left-radius: 1rem !important;
            border-top-right-radius: 1rem !important;
            position: relative;
        }
        .card-img-wrapper img {
            transition: transform 0.5s ease;
        }
        .field-card:hover:not(.card-maintenance) .card-img-wrapper img {
            transform: scale(1.06);
        }       
        .card-maintenance {
            opacity: 0.75;
            background-color: #f8f9fa !important;
        }
        .img-maintenance {
            filter: grayscale(100%);
        }
        .hero-section {
            background: transparent !important;
            color: #212529 !important;
            padding: 30px 0 10px 0 !important;
        }
        .hero-section h2 {
            font-size: 2.1rem !important;
            font-weight: 700 !important;
            color: #1a1d20 !important;
            margin-bottom: 4px !important;
        }
        .hero-section p.text-muted-hero {
            color: #6c757d !important;
            font-size: 0.95rem !important;
            font-weight: 500;
            margin-bottom: 8px !important;
        }
        .header-filter-select {
            font-weight: 500; 
            font-size: 0.85rem; 
            border-radius: 0.5rem;
            min-width: 210px;
        }
        .social-container-card {
            background-color: #eaedf0 !important;
            border: 1px solid #dee2e6 !important;
            border-radius: 1rem !important;
        }
        .social-btn-item {
            background-color: #ffffff !important;
            color: #495057 !important;
            border: 1px solid #e2e8f0 !important;
            font-weight: 600;
            border-radius: 0.75rem !important;
            transition: all 0.2s ease;
        }
        .social-btn-item:hover {
            background-color: #212529 !important;
            color: #ffffff !important;
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-success fs-5 me-3" href="<%= request.getContextPath() %>/"><i class="fa-brands fa-battle-net"></i> COURT SPORT</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>           
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mb-2 mb-lg-0 align-items-lg-center">
                    <li class="nav-item"><a class="nav-link active fw-semibold small me-2" href="<%= request.getContextPath() %>/home">Trang Chủ</a></li>
                    <li class="nav-item"><a class="nav-link fw-semibold text-white-50 small me-3" href="<%= request.getContextPath() %>/booking?action=list">Đặt Lịch</a></li>
                    
                    <li class="nav-item mt-2 mt-lg-0 ms-lg-3">
                        <form action="<%= request.getContextPath() %>/home" method="GET" class="d-flex align-items-center gap-2">
                            <%
                                String currentCat = request.getParameter("categoryId");
                                if (currentCat == null) { currentCat = "0"; }
                            %>
                            <select class="form-select border-secondary bg-dark text-white header-filter-select py-1.5 shadow-sm" name="categoryId">
                                <option value="0" <%= "0".equals(currentCat) ? "selected" : "" %>>🔎Thể Thao Yêu Thích</option>
                                <option value="1" <%= "1".equals(currentCat) ? "selected" : "" %>>🏸Cầu Lông</option>
                                <option value="2" <%= "2".equals(currentCat) ? "selected" : "" %>>☄️Pickleball</option>
                                <option value="3" <%= "3".equals(currentCat) ? "selected" : "" %>>⚽Bóng Đá</option>
                            </select>
                            <button type="submit" class="btn btn-success btn-sm fw-bold py-1.5 px-3 shadow-sm text-uppercase text-nowrap" style="font-size: 0.8rem; border-radius: 0.5rem; letter-spacing: 0.3px;">
                                <i class="fa-solid fa-magnifying-glass me-1"></i>Tìm Kiếm
                            </button>
                        </form>
                    </li>
                </ul>               
                <div class="d-flex align-items-center mt-3 mt-lg-0 ms-auto">
                    <% 
                        User uSession = (User) session.getAttribute("currentUser");
                        if (uSession != null) {
                            int pts = uSession.getRewardPoints();
                            String miniBadge = "bg-secondary";
                            String miniRank = "Silver";
                            if(pts >= 1000) { miniBadge = "bg-danger"; miniRank = "Platinum VIP"; }
                            else if(pts >= 500) { miniBadge = "bg-warning text-dark"; miniRank = "Gold"; }
                    %>
                        <span class="text-white me-2 small" style="font-size: 0.8rem;"><i class="fa-solid fa-user text-success me-1"></i><%= uSession.getFullName() %></span>
                        <span class="badge <%= miniBadge %> fw-bold me-3 p-1.5" style="font-size:0.65rem; border-radius: 0.5rem;"><%= miniRank %></span>
                        
                        <% if (uSession.getRoleId() == 1) { %>
                            <a href="<%= request.getContextPath() %>/admin" class="btn btn-success btn-sm me-2 fw-semibold px-2" style="font-size: 0.75rem; border-radius: 0.5rem;"><i class="fa-solid fa-user-shield me-1"></i>Quản trị</a>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-outline-danger btn-sm" style="border-radius: 0.5rem;"><i class="fa-solid fa-right-from-bracket"></i></a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-success btn-sm me-2 fw-bold px-3" style="border-radius: 0.5rem; font-size: 0.8rem;">Đăng nhập</a>
                        <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-success btn-sm fw-bold px-3" style="border-radius: 0.5rem; font-size: 0.8rem;">Đăng ký</a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
    <header class="hero-section text-center">
        <div class="container px-3">
            <h2>Đặt Sân Tốc Hành - Trải Nghiệm Đỉnh Cao</h2>
            <p class="text-muted-hero">Hệ thống phức hợp thể thao tiêu chuẩn: Cầu Lông, Pickleball & Sân Bóng Đá.</p>
        </div>
    </header>
    <main class="container my-2" id="danh-sach">
        <div class="row g-3">
            <div class="col-12">
                <div class="row g-3">
                    <% 
                        List<Field> fields = (List<Field>) request.getAttribute("availableFields");
                        if (fields != null && !fields.isEmpty()) {
                            for (Field f : fields) {
                                
                                String categoryName = "Cầu Lông";
                                String badgeStyle = "bg-success-subtle text-success border-success-subtle";
                                String cardImg = "https://tse2.mm.bing.net/th/id/OIP.iLMCf-erGI4V0Q8YRfzPYAHaHa?w=2000&h=2000&rs=1&pid=ImgDetMain&o=7&rm=3"; 
                                
                                if (f.getCategoryId() == 2) {
                                    categoryName = "Pickleball";
                                    badgeStyle = "bg-primary-subtle text-primary border-primary-subtle";
                                    cardImg = "https://i.pinimg.com/originals/6b/04/2e/6b042e417f0a2dd4b02ee9d7c93a502e.jpg";
                                } else if (f.getCategoryId() == 3) {
                                    categoryName = "Bóng Đá";
                                    badgeStyle = "bg-warning text-dark border-warning shadow-sm";
                                    cardImg = "https://tse1.mm.bing.net/th/id/OIP.vNzUToMyWbEalwg8F_slNAHaGv?rs=1&pid=ImgDetMain&o=7&rm=3";
                                }
                                boolean isMaint = "MAINTENANCE".equalsIgnoreCase(f.getStatus());
                    %>
                    <div class="col-lg-3 col-md-4 col-sm-6 col-12">
                        <div class="card h-100 shadow-sm border-0 field-card <%= isMaint ? "card-maintenance" : "bg-white" %>">
                            <div class="card-img-wrapper">
                                <img src="<%= cardImg %>" class="card-img-top <%= isMaint ? "img-maintenance" : "" %>" alt="Field Image" style="height: 140px; object-fit: cover;">
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <span class="badge mb-1.5 align-self-start border py-1 px-2 <%= badgeStyle %>" style="font-size: 0.65rem; font-weight: 600; border-radius: 0.5rem;">
                                    <%= categoryName %>
                                </span>
                                <h6 class="card-title fw-bold text-dark mb-1" style="font-size: 0.85rem;"><%= f.getFieldName() %></h6>
                                <p class="card-text text-muted small flex-grow-1 lh-sm mb-2" style="font-size: 0.72rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <%= f.getDescription() != null ? f.getDescription() : "Sân tiêu chuẩn thi đấu chất lượng cao." %>
                                </p>
                                
                                <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top border-light-subtle">
                                    <span class="text-danger fw-bold" style="font-size: 0.9rem;"><%= String.format("%,.0f", f.getPricePerSlot()) %>đ<small class="text-muted fw-normal ms-0.5" style="font-size: 0.65rem;">/ca</small></span>
                                    
                                    <% if (isMaint) { %>
                                        <button class="btn btn-secondary btn-sm fw-bold px-2 py-1 shadow-sm opacity-100" style="font-size: 0.68rem; border-radius: 0.5rem;" disabled>
                                            <i class="fa-solid fa-screwdriver-wrench me-1"></i>Bảo trì
                                        </button>
                                    <% } else { %>
                                        <a href="<%= request.getContextPath() %>/booking?action=list" class="btn btn-success btn-sm fw-bold px-2 py-1 shadow-sm" style="font-size: 0.68rem; border-radius: 0.5rem;">
                                            <i class="fa-solid fa-calendar-check me-1"></i>Đặt Lịch Ngay
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                            }
                        } else { 
                    %>
                    <div class="col-12 text-center py-5 text-muted bg-white shadow-sm radius-premium">
                        <i class="fa-solid fa-folder-open display-6 mb-2 text-secondary" style="font-size: 2rem;"></i>
                        <p class="fw-semibold small">Không tìm thấy sân thể thao nào phù hợp!</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>
    <footer class="pt-4 pb-2 border-top border-light-subtle w-100" style="background-color: #f8f9fa; color: #6c757d;">
        <div class="container">
            <div class="row g-3 mb-3">
                <div class="col-lg-6 col-md-12 text-start">
                    <p class="mb-1 small fw-semibold text-secondary" style="font-size: 0.75rem;">Chi nhánh: 737 Nguyễn Trãi, Tân Liêu</p>
                    <p class="mb-2 mt-1" style="font-size: 0.8rem;">
                        <span class="fw-bold text-dark">Hotline(Anh Long):</span> <strong class="text-primary ms-1">0909000001</strong>
                        <br> 
                        <span class="fw-bold text-dark">Mail:</span> <span class="text-primary fw-semibold ms-1">hotro@courtsport.com</span>
                    </p>
                </div>
                <div class="col-lg-6 col-md-12">
                    <div class="card social-container-card p-2.5 text-center shadow-sm">
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.8rem;">Mạng xã hội</h6>
                        <div class="row g-2">
                            <div class="col-4"><a href="https://zalo.me" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-solid fa-comment-dots text-primary me-1"></i>Zalo</a></div>
                            <div class="col-4"><a href="https://messenger.com" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-brands fa-facebook-messenger text-danger me-1"></i>Chat</a></div>
                            <div class="col-4"><a href="https://facebook.com" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-brands fa-facebook text-primary me-1"></i>FB</a></div>
                            <div class="col-4"><a href="https://instagram.com" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-brands fa-instagram text-info me-1"></i>Insta</a></div>
                            <div class="col-4"><a href="https://threads.net" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-solid fa-at text-dark me-1"></i>Thread</a></div>
                            <div class="col-4"><a href="https://telegram.org" target="_blank" class="btn social-btn-item btn-sm w-100 py-1 radius-2 shadow-sm" style="font-size: 0.7rem;"><i class="fa-brands fa-telegram text-info me-1"></i>Tele</a></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row pt-2 mt-2 border-top border-light-subtle text-center">
                <div class="col-12">
                    <p class="mb-0 text-muted" style="font-size: 0.7rem; font-weight: 500;">© 2026 Court Sport. Sản phẩm của nhóm 4AN1PM.</p>
                </div>
            </div>
        </div>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>