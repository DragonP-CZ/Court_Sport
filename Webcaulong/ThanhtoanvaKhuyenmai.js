document.addEventListener("DOMContentLoaded", function () {
  if (
    localStorage.getItem("userRole") !== "member" &&
    localStorage.getItem("userRole") !== "admin"
  ) {
    alert("Vui lòng đăng nhập để xem thông tin này!");
    window.location.href = "Nguoidung.html";
    return;
  }

  //TÍNH ĐIỂM
  let userPoints = parseFloat(localStorage.getItem("userPoints") || 0);
  let lastActive = localStorage.getItem("lastActiveDate");

  if (lastActive) {
    let lastDate = new Date(lastActive);
    let now = new Date();
    let diffDays = Math.ceil(Math.abs(now - lastDate) / (1000 * 60 * 60 * 24));

    if (diffDays > 30) {
      userPoints = 0;
      localStorage.setItem("userPoints", 0);
      alert(
        "Điểm tích lũy của bạn đã bị reset về 0 do không có giao dịch trong 30 ngày qua.",
      );
    }
  }

  //PHÂN HẠNG
  function updateTierDisplay(points) {
    const badge = document.getElementById("user-tier-badge");
    document.getElementById("user-total-points").innerText = points.toFixed(1);

    if (points >= 500) {
      badge.innerText = "Kim Cương";
      badge.style.borderColor = "#00ffff";
      badge.style.color = "#00ffff";
    } else if (points >= 300) {
      badge.innerText = "Vàng";
      badge.style.borderColor = "#ffd700";
      badge.style.color = "#ffd700";
    } else if (points >= 100) {
      badge.innerText = "Bạc";
      badge.style.borderColor = "#c0c0c0";
      badge.style.color = "#c0c0c0";
    } else if (points >= 50) {
      badge.innerText = "Đồng";
      badge.style.borderColor = "#cd7f32";
      badge.style.color = "#cd7f32";
    } else if (points >= 30) {
      badge.innerText = "Sắt";
      badge.style.borderColor = "#a19d94";
      badge.style.color = "#a19d94";
    } else {
      badge.innerText = "Thành viên mới";
      badge.style.borderColor = "#fff";
      badge.style.color = "#fff";
    }
  }

  updateTierDisplay(userPoints);

  //ĐỔI ĐIỂM LẤY KHUYẾN MÃI
  const exchangeBtns = document.querySelectorAll(".btn-exchange");
  exchangeBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      let cost = parseFloat(this.getAttribute("data-cost"));
      let code = this.getAttribute("data-code");

      if (userPoints < cost) {
        alert(
          `Bạn không đủ điểm! Cần ${cost} PT nhưng bạn chỉ có ${userPoints.toFixed(1)} PT.`,
        );
        return;
      }

      if (confirm(`Đổi ${cost} điểm để nhận mã ưu đãi [${code}]?`)) {
        userPoints -= cost;
        localStorage.setItem("userPoints", userPoints);
        updateTierDisplay(userPoints);

        let myCodes = JSON.parse(
          localStorage.getItem("myDiscountCodes") || "[]",
        );
        myCodes.push(code);
        localStorage.setItem("myDiscountCodes", JSON.stringify(myCodes));

        let history = JSON.parse(
          localStorage.getItem("transactionHistory") || "[]",
        );
        history.unshift({
          id: "EXC" + Math.floor(Math.random() * 10000),
          branch: `Đổi mã: ${code}`,
          hours: "0",
          points: `-${cost}`,
          amount: 0,
          status: "Hoàn tất",
        });
        localStorage.setItem("transactionHistory", JSON.stringify(history));

        alert(`Đổi thành công! Bạn có thể xem mã trong Kho Voucher bên dưới.`);

        renderHistory();
        renderMyCodes();
      }
    });
  });

  //BẢNG LỊCH SỬ
  function renderHistory() {
    const tbody = document.getElementById("history-table-body");
    let history = JSON.parse(
      localStorage.getItem("transactionHistory") || "[]",
    );

    tbody.innerHTML = "";
    if (history.length === 0) {
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Bạn chưa có giao dịch nào.</td></tr>`;
      return;
    }

    history.forEach((tx, index) => {
      let pointColor = tx.points.toString().startsWith("-")
        ? "#ff003c"
        : "var(--neon-volt)";
      tbody.innerHTML += `
        <tr>
          <td>${index + 1}</td>
          <td>${tx.id} <br><small style="color: var(--text-muted)">${tx.branch}</small></td>
          <td>${tx.hours}</td>
          <td style="color: ${pointColor}; font-weight: bold;">${tx.points}</td>
          <td>${tx.amount.toLocaleString()} đ</td>
          <td><span style="color: #00ff00;">${tx.status}</span></td>
        </tr>
      `;
    });
  }

  //HIỂN THỊ KHO VOUCHER
  function renderMyCodes() {
    const container = document.getElementById("my-codes-container");
    if (!container) return;

    let myCodes = JSON.parse(localStorage.getItem("myDiscountCodes") || "[]");
    container.innerHTML = "";

    if (myCodes.length === 0) {
      container.innerHTML = `<p style="color: var(--text-muted); font-style: italic; grid-column: 1 / -1;">Bạn chưa sở hữu mã giảm giá nào. Hãy tích điểm và đổi ngay nhé!</p>`;
      return;
    }

    myCodes.forEach((code) => {
      let desc = "Mã ưu đãi đặc biệt";
      if (code === "GIAM20K") desc = "Giảm 20.000đ hóa đơn";
      if (code === "GIAM50K") desc = "Giảm 50.000đ (Đơn > 200k)";
      if (code === "NUOCMIENPHI") desc = "Nhận 1 chai nước tại quầy";

      container.innerHTML += `
        <div class="my-code-card">
          <h4>${code}</h4>
          <p>${desc}</p>
          <button class="copy-btn" data-code="${code}">
            <i class="fa-regular fa-copy"></i> Sao chép mã
          </button>
        </div>
      `;
    });

    document.querySelectorAll(".copy-btn").forEach((btn) => {
      btn.addEventListener("click", function () {
        let codeToCopy = this.getAttribute("data-code");
        navigator.clipboard.writeText(codeToCopy);

        let originalHTML = this.innerHTML;
        this.innerHTML = `<i class="fa-solid fa-check"></i> Đã chép`;
        this.style.background = "var(--neon-volt)";
        this.style.color = "#000";

        setTimeout(() => {
          this.innerHTML = originalHTML;
          this.style.background = "transparent";
          this.style.color = "var(--text-main)";
        }, 2000);
      });
    });
  }

  renderHistory();
  renderMyCodes();
});
