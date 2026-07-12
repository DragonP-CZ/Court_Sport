<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COURT SPORTS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <style>
        .radius-2 { border-radius: 0.5rem; }
        .form-check { cursor: pointer; transition: all 0.2s ease-in-out; }
        .form-check:hover { background-color: #f8f9fa; border-color: #198754 !important; }
    </style>
</head>
<body class="bg-light">
    <div class="container my-5" style="max-width: 600px;">
        <div class="card shadow border-0 radius-2">
            <div class="card-header bg-dark text-white fw-bold text-center py-3">
                <h5 class="mb-0"><i class="fa-solid fa-credit-card me-2 text-success"></i>CỔNG THANH TOÁN</h5>
            </div>
            <div class="card-body p-4">
                <div class="alert alert-success p-2 small mb-4 radius-2 d-flex align-items-center">
                    <i class="fa-solid fa-shield-halved me-2 fs-5 text-success"></i> 
                    <span>Đơn đặt sân của bạn đã được giữ chỗ tạm thời. Vui lòng hoàn tất thanh toán để ghi nhận lịch đấu vào hệ thống.</span>
                </div>               
                <h6 class="fw-bold mb-3 text-secondary text-uppercase small"><i class="fa-solid fa-receipt me-1"></i> Tóm tắt đơn hàng</h6>
                <ul class="list-group mb-4 shadow-sm radius-2">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span class="text-muted">Ngày đặt:</span> 
                        <span class="fw-bold text-dark"><%= request.getAttribute("bDate") %></span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span class="text-muted">Khung giờ:</span> 
                        <span class="badge bg-primary px-3 py-2 fw-bold">Ca thứ <%= request.getAttribute("sId") %></span>
                    </li>
                    <%
                        String rawTotal = (String) request.getAttribute("total");
                        if (rawTotal != null) {
                            rawTotal = rawTotal.replaceAll("[^0-9.]", "");
                        } else {
                            rawTotal = "0";
                        }
                        double totalAmount = Double.parseDouble(rawTotal);
                    %>
                    <li class="list-group-item d-flex justify-content-between align-items-center bg-light">
                        <span class="text-danger fw-bold fs-6">Tổng tiền:</span> 
                        <strong class="text-danger fs-5"><%= String.format("%,.0f", totalAmount) %>đ</strong>
                    </li>
                </ul>
                <form action="<%= request.getContextPath() %>/booking" method="POST" id="paymentForm">
                    <input type="hidden" name="action" value="create">                   
                    <input type="hidden" name="fieldId" value="<%= request.getAttribute("fId") %>">
                    <input type="hidden" name="slotId" value="<%= request.getAttribute("sId") %>">
                    <input type="hidden" name="bookingDate" value="<%= request.getAttribute("bDate") %>">                   
                    <input type="hidden" name="isCheckoutConfirm" value="true">                   
                    <input type="hidden" name="price" id="sanitizedPrice" value="<%= rawTotal %>">
                    <h6 class="fw-bold mb-3 text-secondary text-uppercase small"><i class="fa-solid fa-wallet me-1"></i> Chọn phương thức thanh toán</h6>                   
                    <div class="form-check card p-3 mb-2 shadow-sm border radius-2">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="payCash" value="CASH" checked>
                            <label class="form-check-label fw-bold text-dark ms-2 w-100 style-label" for="payCash">
                                <i class="fa-solid fa-money-bill-1-wave me-2 text-success fs-5"></i>Thanh toán tiền mặt tại sân
                            </label>
                        </div>
                    </div>
                    <div class="form-check card p-3 mb-2 shadow-sm border radius-2">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="payQR" value="QR_CODE">
                            <label class="form-check-label fw-bold text-dark ms-2 w-100 style-label" for="payQR">
                                <i class="fa-solid fa-qrcode me-2 text-primary fs-5"></i>Quét mã QR 
                            </label>
                        </div>
                    </div>
                    <div class="form-check card p-3 mb-4 shadow-sm border radius-2">
                        <div class="d-flex align-items-center">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="payBank" value="BANK_TRANSFER">
                            <label class="form-check-label fw-bold text-dark ms-2 w-100 style-label" for="payBank">
                                <i class="fa-solid fa-building-columns me-2 text-warning fs-5"></i>Chuyển khoản Ngân hàng (Ví điện tử)
                            </label>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold py-3 shadow radius-2 text-uppercase fs-6">
                        <i class="fa-solid fa-circle-check me-2"></i>HOÀN TẤT THANH TOÁN
                    </button>
                    <a href="<%= request.getContextPath() %>/booking?action=list" class="btn btn-link w-100 text-secondary text-decoration-none mt-2 text-center small"><i class="fa-solid fa-arrow-left me-1"></i> Hủy giao diện thanh toán</a>
                </form>
            </div>
        </div>
    </div>
    <script>
        document.getElementById("paymentForm").addEventListener("submit", function(e) {
            var priceInput = document.getElementById("sanitizedPrice");
            var cleanValue = priceInput.value.replace(/[^0-9.]/g, '');
            priceInput.value = cleanValue;
        });
    </script>
</body>
</html>