document.addEventListener("DOMContentLoaded", function () {
  //CHỨC NĂNG ĐẢO MÀU GIAO DIỆN (SÁNG/TỐI)
  const themeToggle = document.getElementById("theme-toggle");
  if (themeToggle) {
    if (localStorage.getItem("theme") === "light") {
      document.body.classList.add("light-theme");
      themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
    }
    themeToggle.addEventListener("click", () => {
      document.body.classList.toggle("light-theme");
      const isLight = document.body.classList.contains("light-theme");
      localStorage.setItem("theme", isLight ? "light" : "dark");
      themeToggle.innerHTML = isLight
        ? '<i class="fa-solid fa-sun"></i>'
        : '<i class="fa-solid fa-moon"></i>';
    });
  }

  //QUẢN LÝ TRẠNG THÁI KHÁCH / THÀNH VIÊN
  function checkUserRole() {
    let currentRole = localStorage.getItem("userRole") || "guest";
    let currentName = localStorage.getItem("userName") || "Khách";
    let currentAvatar =
      localStorage.getItem("userAvatar") ||
      "https://maubanhkem.com/wp-content/uploads/2025/08/anh-con-bo-ngoi-may-tinh-10.jpg";

    const memberOnlyLinks = document.querySelectorAll(".member-only");
    const guestOnlyLinks = document.querySelectorAll(".guest-only");

    const defaultAvatarIcon = document.getElementById("default-avatar-icon");
    const userAvatarSidebar = document.getElementById("user-avatar-sidebar");
    const userNameSidebar = document.getElementById("user-name-sidebar");
    const userAvatarNav = document.getElementById("user-avatar-nav");
    const userNameNav = document.getElementById("user-name-nav");

    if (currentRole === "member" || currentRole === "admin") {
      guestOnlyLinks.forEach((el) => (el.style.display = "none"));
      memberOnlyLinks.forEach((el) => (el.style.display = "block"));
      document.getElementById("btn-member-nav").style.display = "flex";

      if (defaultAvatarIcon) defaultAvatarIcon.style.display = "none";
      if (userAvatarSidebar) {
        userAvatarSidebar.style.display = "block";
        userAvatarSidebar.src = currentAvatar;
      }
      if (userAvatarNav) {
        userAvatarNav.src = currentAvatar;
      }
      if (userNameSidebar) userNameSidebar.innerText = currentName;
      if (userNameNav) userNameNav.innerText = currentName;
    } else {
      memberOnlyLinks.forEach((el) => (el.style.display = "none"));
      guestOnlyLinks.forEach((el) => (el.style.display = "block"));
      document.getElementById("btn-login").style.display = "block";

      if (defaultAvatarIcon) defaultAvatarIcon.style.display = "block";
      if (userAvatarSidebar) userAvatarSidebar.style.display = "none";
      if (userNameSidebar) userNameSidebar.innerText = "Khách";
    }
  }

  checkUserRole();

  const btnLogout = document.getElementById("sidebar-logout");
  if (btnLogout) {
    btnLogout.addEventListener("click", function (e) {
      e.preventDefault();
      localStorage.clear();
      alert("Bạn đã đăng xuất.");
      window.location.reload();
    });
  }

  //TƯƠNG TÁC GIAO DIỆN CƠ BẢN
  const brandTrigger = document.getElementById("brand-trigger");
  if (brandTrigger) {
    brandTrigger.addEventListener("click", function () {
      window.location.href = "Nguoidung.html";
    });
  }

  const langBtn = document.getElementById("lang-btn");
  let isVietnamese = true;
  if (langBtn) {
    langBtn.addEventListener("click", function () {
      isVietnamese = !isVietnamese;
      langBtn.innerText = isVietnamese ? "Tiếng Việt" : "English";
      document.querySelectorAll(".i18n").forEach((el) => {
        el.innerText = isVietnamese
          ? el.getAttribute("data-vi")
          : el.getAttribute("data-en");
      });
      document.querySelectorAll(".i18n-input").forEach((el) => {
        el.placeholder = isVietnamese
          ? el.getAttribute("data-vi")
          : el.getAttribute("data-en");
      });
    });
  }

  const sidebar = document.getElementById("sidebar-menu");
  const btnMenu = document.getElementById("btn-menu");
  const closeSidebar = document.getElementById("close-sidebar");
  if (btnMenu && closeSidebar) {
    btnMenu.addEventListener("click", () => sidebar.classList.add("open"));
    closeSidebar.addEventListener("click", () =>
      sidebar.classList.remove("open"),
    );
  }

  const btnSearch = document.getElementById("btn-search");
  if (btnSearch) {
    btnSearch.addEventListener("click", function () {
      const query = document.getElementById("search-input").value;
      if (query.trim() !== "") alert("Đang tìm kiếm thông tin: " + query);
      else alert("Vui lòng nhập nội dung tìm kiếm!");
    });
  }

  const btnClbd = document.getElementById("btn-clbd");
  const btnHoTro = document.getElementById("btn-hotro");
  if (btnHoTro) {
    btnHoTro.addEventListener("click", () => {
      window.location.href = "Caidatchung.html";
    });
  }
  const btnDatSan = document.getElementById("btn-datsan");
  if (btnDatSan) {
    btnDatSan.addEventListener("click", () => {
      document
        .getElementById("grid-section")
        .scrollIntoView({ behavior: "smooth" });
    });
  }

  //XỬ LÝ MODAL ĐĂNG NHẬP / HỒ SƠ
  const loginModal = document.getElementById("login-modal");
  const closeLoginModal = document.getElementById("close-login-modal");
  const btnLoginNav = document.getElementById("btn-login");
  const sidebarLogin = document.getElementById("sidebar-login");

  if (btnLoginNav) {
    btnLoginNav.addEventListener("click", () => {
      loginModal.style.display = "flex";
    });
  }

  if (sidebarLogin) {
    sidebarLogin.addEventListener("click", (e) => {
      e.preventDefault();
      const sidebar = document.getElementById("sidebar-menu");
      if (sidebar) sidebar.classList.remove("open");
      loginModal.style.display = "flex";
    });
  }

  if (closeLoginModal) {
    closeLoginModal.addEventListener("click", () => {
      loginModal.style.display = "none";
    });
  }

  document
    .getElementById("submit-login-btn")
    ?.addEventListener("click", function (e) {
      e.preventDefault();
      const uName = document.getElementById("login-username")?.value.trim();
      const pass = document.getElementById("login-password")?.value.trim();

      if (!uName || !pass) {
        return alert("Vui lòng nhập đầy đủ SĐT/Gmail và Mật khẩu!");
      }

      const isAdmin = uName === "2305" && pass === "Admin";
      if (isAdmin) {
        localStorage.setItem("userRole", "admin");
        localStorage.setItem("userName", "Admin");
        alert("Đăng nhập thành công! Xin chào Admin.");
        window.location.href = "Admin.html";
      } else {
        localStorage.setItem("userRole", "member");
        localStorage.setItem("userName", uName);
        alert(`Đăng nhập thành công! Xin chào ${uName}.`);
        localStorage.removeItem("hasDismissedPopup");
        window.location.reload();
      }
    });

  document.getElementById("btn-forgot-pw")?.addEventListener("click", (e) => {
    e.preventDefault();
    alert("Cửa sổ Quên mật khẩu sẽ được bổ sung sau!");
  });

  document
    .getElementById("btn-show-register")
    ?.addEventListener("click", (e) => {
      e.preventDefault();
      alert("Cửa sổ Đăng ký tài khoản mới sẽ được bổ sung sau!");
    });

  //BẢNG LƯỚI ĐẶT SÂN
  const timeTable = document.getElementById("time-table");
  const dateSelector = document.getElementById("date-selector");
  const times = [];
  for (let h = 4; h <= 23; h++) {
    let hourStr = h.toString().padStart(2, "0");
    times.push(`${hourStr}:00`);
    if (h !== 23) times.push(`${hourStr}:30`);
  }

  function formatDateToVN(dateString) {
    if (!dateString) return "Chưa chọn ngày";
    const parts = dateString.split("-");
    if (parts.length === 3) return `${parts[2]}/${parts[1]}/${parts[0]}`;
    return dateString;
  }

  function renderTimeGrid(selectedDateStr) {
    if (!timeTable) return;
    let displayDate = formatDateToVN(selectedDateStr);

    let theadHTML = `<thead><tr><th class="sticky-col" id="grid-date-display">${displayDate}</th>`;
    times.forEach((t) => {
      theadHTML += `<th>${t}</th>`;
    });
    theadHTML += `</tr></thead>`;

    let tbodyHTML = `<tbody>`;
    for (let i = 1; i <= 5; i++) {
      tbodyHTML += `<tr><td class="sticky-col">Sân ${i}</td>`;
      let cellStatuses = new Array(times.length).fill("cell-white");

      if (i === 3) {
        let maintainIndices = [16, 17, 18, 19];
        maintainIndices.forEach((idx) => (cellStatuses[idx] = "cell-black"));
      }

      let j = 0;
      while (j < times.length - 1) {
        if (cellStatuses[j] !== "cell-white") {
          j++;
          continue;
        }
        if (Math.random() < 0.15) {
          let duration = Math.random() < 0.6 ? 2 : 3;
          let canBook = true;
          for (let k = 0; k < duration; k++) {
            if (j + k >= times.length || cellStatuses[j + k] !== "cell-white") {
              canBook = false;
              break;
            }
          }
          if (canBook) {
            for (let k = 0; k < duration; k++)
              cellStatuses[j + k] = "cell-blue";
            j += duration;
            continue;
          }
        }
        j++;
      }

      for (let k = 0; k < times.length; k++) {
        tbodyHTML += `<td class="${cellStatuses[k]}" data-san="${i}" data-time="${times[k]}"></td>`;
      }
      tbodyHTML += `</tr>`;
    }
    tbodyHTML += `</tbody>`;
    timeTable.innerHTML = theadHTML + tbodyHTML;

    attachCellClickEvents();
  }

  function attachCellClickEvents() {
    const cells = document.querySelectorAll(
      ".time-table tbody td:not(.sticky-col)",
    );
    cells.forEach((cell) => {
      cell.addEventListener("click", function () {
        if (
          this.classList.contains("cell-black") ||
          this.classList.contains("cell-blue")
        )
          return;
        if (this.classList.contains("cell-white")) {
          this.classList.replace("cell-white", "cell-red");
        } else {
          this.classList.replace("cell-red", "cell-white");
        }
      });
    });
  }

  if (dateSelector) {
    const today = new Date().toISOString().split("T")[0];
    dateSelector.value = today;
    renderTimeGrid(today);

    dateSelector.addEventListener("change", function () {
      renderTimeGrid(this.value);
    });
  }

  //CHỌN SÂN VÀ CHI NHÁNH
  const sportSelector = document.getElementById("sport-selector");
  if (sportSelector) {
    sportSelector.addEventListener("change", function () {
      if (this.value === "bongda") alert("Đã load danh sách Sân Bóng Đá");
      else if (this.value === "caulong")
        alert("Đã load danh sách Sân Cầu Lông");
    });
  }

  //QUẢN LÝ QUẬN, CHI NHÁNH VÀ ĐỊNH VỊ GPS
  const districtSelector = document.getElementById("district-selector");
  const branchSelector = document.getElementById("branch-selector");
  const displayBranchName = document.getElementById("display-branch-name");
  const branchIntro = document.getElementById("branch-intro");
  const btnLocation = document.getElementById("btn-location");

  //tọa độ giả lập (Latitude, Longitude) tính khoảng cách
  const locationData = {
    Q7: {
      name: "Quận 7",
      branches: {
        CN1: {
          name: "Chi nhánh 1",
          intro:
            "Sân Q7 CN1 trang bị mặt cỏ nhân tạo FIFA Quality Pro, đèn LED chuẩn.",
          lat: 10.733,
          lng: 106.716,
        },
        CN2: {
          name: "Chi nhánh 2",
          intro: "Sân Q7 CN2 rộng rãi, có bãi đậu xe hơi và khu căn tin VIP.",
          lat: 10.74,
          lng: 106.72,
        },
        CN3: {
          name: "Chi nhánh 3",
          intro: "Sân Q7 CN3 giá cả học sinh sinh viên, hoạt động 24/7.",
          lat: 10.725,
          lng: 106.71,
        },
      },
    },
    Q5: {
      name: "Quận 5",
      branches: {
        CN1: {
          name: "Chi nhánh 1",
          intro: "Sân Quận 5 CN1 nằm ở trung tâm, không gian thoáng mát.",
          lat: 10.754,
          lng: 106.666,
        },
        CN2: {
          name: "Chi nhánh 2",
          intro:
            "Sân Quận 5 CN2 mới khai trương, thảm êm ái chống chấn thương.",
          lat: 10.76,
          lng: 106.67,
        },
      },
    },
    Q1: {
      name: "Quận 1",
      branches: {
        CN1: {
          name: "Chi nhánh 1",
          intro: "Sân VIP Q1 CN1, mặt thảm đạt chuẩn quốc tế.",
          lat: 10.776,
          lng: 106.7,
        },
        CN2: {
          name: "Chi nhánh 2",
          intro:
            "Sân Q1 CN2 view bao quát thành phố, hệ thống làm mát hiện đại.",
          lat: 10.78,
          lng: 106.705,
        },
        CN3: {
          name: "Chi nhánh 3",
          intro: "Sân Q1 CN3 chuyên tổ chức các giải phong trào quy mô lớn.",
          lat: 10.772,
          lng: 106.695,
        },
        CN4: {
          name: "Chi nhánh 4",
          intro: "Sân Q1 CN4 tiện lợi, gần các tuyến đường lớn.",
          lat: 10.785,
          lng: 106.69,
        },
      },
    },
    Q11: {
      name: "Quận 11",
      branches: {
        CN1: {
          name: "Chi nhánh 1",
          intro:
            "Sân Quận 11 gần nhà thi đấu Phú Thọ, có cho thuê giày và vợt.",
          lat: 10.762,
          lng: 106.643,
        },
      },
    },
  };

  // Hàm cập nhật danh sách Chi Nhánh dựa trên Quận được chọn
  function loadBranches(districtId) {
    branchSelector.innerHTML = "";
    const branches = locationData[districtId].branches;
    for (let branchKey in branches) {
      let option = document.createElement("option");
      option.value = branchKey;
      option.text = branches[branchKey].name;
      branchSelector.appendChild(option);
    }
    branchSelector.dispatchEvent(new Event("change"));
  }

  if (districtSelector && branchSelector) {
    districtSelector.addEventListener("change", function () {
      loadBranches(this.value);
    });

    // Khi đổi Chi nhánh cập nhật tên hiển thị và dòng giới thiệu
    branchSelector.addEventListener("change", function () {
      let currentDistrictName = locationData[districtSelector.value].name;
      let branchInfo =
        locationData[districtSelector.value].branches[this.value];

      if (displayBranchName) {
        displayBranchName.innerText = `CN: ${currentDistrictName} - ${branchInfo.name}`;
      }
      if (branchIntro) {
        branchIntro.innerHTML = `<strong>Giới thiệu sân:</strong> ${branchInfo.intro}`;
      }
    });

    loadBranches(districtSelector.value);
  }

  //THUẬT TOÁN ĐỊNH VỊ VÀ TÌM SÂN GẦN NHẤT
  // Công thức Haversine tính khoảng cách đường chim bay giữa 2 tọa độ
  function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  if (btnLocation) {
    btnLocation.addEventListener("click", function () {
      if (!navigator.geolocation) {
        return alert("Trình duyệt của bạn không hỗ trợ định vị GPS!");
      }

      btnLocation.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';

      navigator.geolocation.getCurrentPosition(
        function (position) {
          const userLat = position.coords.latitude;
          const userLng = position.coords.longitude;

          let shortestDistance = Infinity;
          let nearestDistrict = "";
          let nearestBranch = "";

          for (let dKey in locationData) {
            for (let bKey in locationData[dKey].branches) {
              let branch = locationData[dKey].branches[bKey];
              let distance = calculateDistance(
                userLat,
                userLng,
                branch.lat,
                branch.lng,
              );

              if (distance < shortestDistance) {
                shortestDistance = distance;
                nearestDistrict = dKey;
                nearestBranch = bKey;
              }
            }
          }

          btnLocation.innerHTML =
            '<i class="fa-solid fa-location-crosshairs"></i>';

          // Cập nhật giao diện với sân gần nhất
          districtSelector.value = nearestDistrict;
          loadBranches(nearestDistrict);
          branchSelector.value = nearestBranch;
          branchSelector.dispatchEvent(new Event("change"));

          let finalName =
            locationData[nearestDistrict].name +
            " - " +
            locationData[nearestDistrict].branches[nearestBranch].name;
          alert(
            `Đã truy cập vị trí!\nSân gần bạn nhất (Cách ${shortestDistance.toFixed(1)} km):\n🏟️ ${finalName}`,
          );
        },
        function (error) {
          btnLocation.innerHTML =
            '<i class="fa-solid fa-location-crosshairs"></i>';
          alert(
            "Không thể lấy được vị trí của bạn. Vui lòng cấp quyền định vị cho trình duyệt!",
          );
        },
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 },
      );
    });
  }

  //NHẬP GIỜ BẰNG BÀN PHÍM VÀ THANH TOÁN
  const quickCourt = document.getElementById("quick-court");
  const quickStart = document.getElementById("quick-start");
  const quickEnd = document.getElementById("quick-end");
  const btnQuickAdd = document.getElementById("btn-quick-add");
  const btnQuickRemove = document.getElementById("btn-quick-remove");
  const quickMsg = document.getElementById("quick-msg");

  function processQuickSelect(isAdding) {
    let court = quickCourt.value;
    let start = quickStart.value;
    let end = quickEnd.value;

    if (!start || !end) {
      alert("Vui lòng nhập đầy đủ giờ bắt đầu và giờ kết thúc!");
      return;
    }
    if (start >= end) {
      alert("Lỗi: Giờ kết thúc phải lớn hơn giờ bắt đầu!");
      return;
    }

    let slots = [];
    let curr = new Date(`1970-01-01T${start}:00`);
    let endTime = new Date(`1970-01-01T${end}:00`);

    while (curr < endTime) {
      let h = curr.getHours().toString().padStart(2, "0");
      let m = curr.getMinutes().toString().padStart(2, "0");
      slots.push(`${h}:${m}`);
      curr.setMinutes(curr.getMinutes() + 30);
    }

    // QUY TẮC RÀNG BUỘC: Kiểm tra xem các ô đó có bị trùng lặp (Đã đặt / Bảo trì) không?
    let cellsToModify = [];
    for (let time of slots) {
      let cell = document.querySelector(
        `td[data-san="${court}"][data-time="${time}"]`,
      );
      if (!cell) {
        alert(`Lỗi: Không tìm thấy khung giờ ${time} trong hệ thống!`);
        return;
      }
      if (
        isAdding &&
        (cell.classList.contains("cell-blue") ||
          cell.classList.contains("cell-black"))
      ) {
        alert(
          `KHÔNG THỂ CHỌN: Khung giờ ${time} ở Sân ${court} đã được người khác đặt hoặc đang bảo trì!`,
        );
        return;
      }
      cellsToModify.push(cell);
    }

    // Nếu qua được vòng kiểm tra, tiến hành tô màu (hoặc xóa màu)
    cellsToModify.forEach((cell) => {
      if (isAdding) {
        if (cell.classList.contains("cell-white"))
          cell.classList.replace("cell-white", "cell-red");
      } else {
        if (cell.classList.contains("cell-red"))
          cell.classList.replace("cell-red", "cell-white");
      }
    });

    // Thông báo trạng thái nhỏ
    quickMsg.innerText = isAdding ? "✓ Đã chọn!" : "✓ Đã xóa!";
    quickMsg.style.color = isAdding ? "#00ff00" : "#ff003c";
    setTimeout(() => (quickMsg.innerText = ""), 3000);
  }

  if (btnQuickAdd)
    btnQuickAdd.addEventListener("click", () => processQuickSelect(true));
  if (btnQuickRemove)
    btnQuickRemove.addEventListener("click", () => processQuickSelect(false));

  [quickStart, quickEnd].forEach((input) => {
    if (input)
      input.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          processQuickSelect(true);
        }
      });
  });

  const modalCheckout = document.getElementById("checkout-modal");
  const btnCheckout = document.getElementById("btn-checkout");
  const closeCheckout = document.getElementById("close-checkout");
  const confirmPay = document.getElementById("confirm-pay");

  const btnApplyDiscount = document.getElementById("btn-apply-discount");
  let currentFinalTotal = 0;
  let currentHours = 0;
  let currentBranch = "";

  if (btnCheckout) {
    btnCheckout.addEventListener("click", function () {
      let sportVal = document.getElementById("sport-selector").value;
      if (sportVal === "") {
        return alert(
          "Vui lòng CHỌN MÔN THỂ THAO (Cầu lông/Bóng đá) ở thanh điều khiển trên cùng trước khi thanh toán!",
        );
      }

      let dateVal = document.getElementById("date-selector").value;
      if (!dateVal) {
        return alert("Vui lòng CHỌN NGÀY THÁNG trước khi thanh toán!");
      }

      let selectedCells = document.querySelectorAll(".cell-red");
      if (selectedCells.length === 0)
        return alert("Vui lòng chọn ít nhất 1 khung giờ trên bảng!");

      let currentRole = localStorage.getItem("userRole");
      if (currentRole !== "member" && currentRole !== "admin") {
        let wantToLogin = confirm(
          "Đăng nhập để tích điểm và nhận ưu đãi giảm giá.\nNhấn 'OK' để Đăng nhập, 'Cancel' để tiếp tục như Khách.",
        );
        if (wantToLogin) {
          document.getElementById("login-modal").style.display = "flex";
          return;
        }
      }
      let uniqueCourts = new Set();
      selectedCells.forEach((cell) => {
        uniqueCourts.add("Sân " + cell.getAttribute("data-san"));
      });

      // Lấy thông tin chi tiết Quận và Chi Nhánh để in ra Bill
      let districtSelect = document.getElementById("district-selector");
      let districtText =
        districtSelect.options[districtSelect.selectedIndex].text;

      let branchSelect = document.getElementById("branch-selector");
      let branchText = branchSelect.options[branchSelect.selectedIndex].text;

      let fullBranchLocation = `${districtText} (${branchText})`;

      currentBranch =
        fullBranchLocation + " - " + Array.from(uniqueCourts).join(", ");

      let sportText = sportVal === "bongda" ? "Bóng đá" : "Cầu lông";

      let totalMinutes = selectedCells.length * 30;
      currentHours = totalMinutes / 60;
      currentFinalTotal = selectedCells.length * 25000;

      // IN RA GIAO DIỆN XÁC NHẬN
      document.getElementById("checkout-sport").innerText = sportText;
      document.getElementById("checkout-branch").innerText = fullBranchLocation;

      let dateParts = dateVal.split("-");
      document.getElementById("checkout-date").innerText =
        `${dateParts[2]}/${dateParts[1]}/${dateParts[0]}`;

      document.getElementById("checkout-courts").innerText =
        Array.from(uniqueCourts).join(", ");
      document.getElementById("checkout-time").innerText =
        totalMinutes + " phút (" + currentHours + " giờ)";
      document.getElementById("checkout-total").innerText =
        currentFinalTotal.toLocaleString();

      document.getElementById("discount-code-input").value = "";
      document.getElementById("discount-message").style.display = "none";

      if (modalCheckout) modalCheckout.style.display = "flex";
    });
  }

  // Nút Áp dụng Mã
  if (btnApplyDiscount) {
    btnApplyDiscount.addEventListener("click", function () {
      let code = document
        .getElementById("discount-code-input")
        .value.trim()
        .toUpperCase();
      let myCodes = JSON.parse(localStorage.getItem("myDiscountCodes") || "[]");
      let msgBox = document.getElementById("discount-message");

      if (myCodes.includes(code)) {
        let discountAmount = 0;
        if (code === "GIAM20K") discountAmount = 20000;
        else if (code === "GIAM50K") discountAmount = 50000;

        currentFinalTotal = Math.max(0, currentFinalTotal - discountAmount);
        document.getElementById("checkout-total").innerText =
          currentFinalTotal.toLocaleString();

        msgBox.innerText = `Áp dụng thành công! Đã giảm ${discountAmount.toLocaleString()}đ`;
        msgBox.style.color = "#00ff00";
        msgBox.style.display = "block";

        myCodes = myCodes.filter((c) => c !== code);
        localStorage.setItem("myDiscountCodes", JSON.stringify(myCodes));
      } else {
        msgBox.innerText = "Mã không hợp lệ hoặc bạn không sở hữu mã này!";
        msgBox.style.color = "#ff003c";
        msgBox.style.display = "block";
      }
    });
  }

  if (closeCheckout)
    closeCheckout.addEventListener(
      "click",
      () => (modalCheckout.style.display = "none"),
    );

  // XÁC NHẬN THANH TOÁN VÀ LƯU DỮ LIỆU ĐẶT SÂN
  // HÀM HỖ TRỢ: LẤY MẢNG CÁC KHUNG GIỜ (Mỗi ô 30 phút)
  function getSlotsFromTime(startStr, durationHours) {
    let slots = [];
    let [h, m] = startStr.split(":").map(Number);
    let totalMins = h * 60 + m;
    let slotsCount = durationHours * 2;
    for (let i = 0; i < slotsCount; i++) {
      let curH = Math.floor(totalMins / 60)
        .toString()
        .padStart(2, "0");
      let curM = (totalMins % 60).toString().padStart(2, "0");
      slots.push(`${curH}:${curM}`);
      totalMins += 30;
    }
    return slots;
  }

  // XÁC NHẬN THANH TOÁN VÀ LƯU DỮ LIỆU ĐẶT SÂN
  if (confirmPay) {
    confirmPay.addEventListener("click", function () {
      if (
        localStorage.getItem("userRole") === "member" ||
        localStorage.getItem("userRole") === "admin"
      ) {
        let earnedPoints = parseFloat(currentHours.toFixed(1));
        let userPoints = parseFloat(localStorage.getItem("userPoints") || 0);
        localStorage.setItem("userPoints", userPoints + earnedPoints);
        localStorage.setItem("lastActiveDate", new Date().toISOString());

        let txId = "HD" + Math.floor(Math.random() * 100000);

        let history = JSON.parse(
          localStorage.getItem("transactionHistory") || "[]",
        );
        history.unshift({
          id: txId,
          branch: currentBranch,
          hours: currentHours + " Giờ",
          points: "+" + earnedPoints,
          amount: currentFinalTotal,
          status: "Thành công",
        });
        localStorage.setItem("transactionHistory", JSON.stringify(history));

        let myBookings = JSON.parse(localStorage.getItem("myBookings") || "[]");

        let selectedCells = document.querySelectorAll(".cell-red");
        let startTime = selectedCells[0].getAttribute("data-time");
        let dateVal = document.getElementById("date-selector").value;
        let dateParts = dateVal.split("-");
        let formattedDate = `${dateParts[2]}/${dateParts[1]}/${dateParts[0]}`;
        let courtsArr = [];
        selectedCells.forEach((cell) => {
          let sanSo = cell.getAttribute("data-san");
          if (!courtsArr.includes(sanSo)) courtsArr.push(sanSo);
        });

        myBookings.unshift({
          id: txId,
          branch: currentBranch,
          courts: courtsArr,
          date: formattedDate,
          startTime: startTime,
          duration: currentHours,
          amount: currentFinalTotal,
          isEdited: false,
          status: "Thành công",
        });
        localStorage.setItem("myBookings", JSON.stringify(myBookings));
      }

      alert(
        "Thanh toán thành công! Vui lòng đến đúng thời gian đặt để không bỏ lỡ nhiệp đấu của mình nhé.",
      );
      if (modalCheckout) modalCheckout.style.display = "none";

      document
        .querySelectorAll(".cell-red")
        .forEach((cell) => cell.classList.replace("cell-red", "cell-blue"));
      renderMyBookings();
    });
  }

  //QUẢN LÝ SÂN ĐÃ ĐẶT (XEM, SỬA GIỜ, HOÀN TIỀN)
  const myBookingsBody = document.getElementById("my-bookings-body");
  const editTimeModal = document.getElementById("edit-time-modal");
  const btnCloseEditTime = document.getElementById("btn-close-edit-time");
  const btnConfirmEditTime = document.getElementById("btn-confirm-edit-time");

  const navManageBooking = document.getElementById("nav-manage-booking");
  if (navManageBooking) {
    navManageBooking.addEventListener("click", function (e) {
      e.preventDefault();
      document.getElementById("sidebar-menu").classList.remove("open");
      document
        .getElementById("manage-booking-section")
        .scrollIntoView({ behavior: "smooth" });
    });
  }

  window.renderMyBookings = function () {
    if (!myBookingsBody) return;
    let myBookings = JSON.parse(localStorage.getItem("myBookings") || "[]");
    myBookingsBody.innerHTML = "";

    if (myBookings.length === 0) {
      myBookingsBody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding: 20px; color: var(--text-muted);">Bạn chưa có đơn đặt sân nào.</td></tr>`;
      return;
    }

    myBookings.forEach((bk, index) => {
      let isCancelled = bk.status.includes("Đã hủy");
      let trColor = isCancelled ? "opacity: 0.5;" : "";

      let btnEditHTML =
        !isCancelled && !bk.isEdited
          ? `<button class="btn-outline-neon small btn-edit-booking" data-index="${index}" style="margin-bottom: 5px; width: 100%;">Dời Giờ</button>`
          : `<button class="btn-outline-neon small" disabled style="margin-bottom: 5px; width: 100%; border-color: gray; color: gray;">Hết quyền Dời</button>`;

      let btnRefundHTML = !isCancelled
        ? `<button class="btn-outline-neon small btn-refund-booking" data-index="${index}" style="width: 100%; color: #ff003c; border-color: #ff003c;">Hủy (Hoàn 50%)</button>`
        : ``;

      myBookingsBody.innerHTML += `
        <tr style="${trColor}">
          <td><strong style="color: var(--neon-volt);">${bk.id}</strong></td>
          <td>${bk.branch}</td>
          <td>Ngày: ${bk.date}<br>Giờ bắt đầu: <b style="font-size:16px;">${bk.startTime}</b></td>
          <td>${bk.duration} Giờ</td>
          <td>${bk.amount.toLocaleString()} đ</td>
          <td style="color: ${isCancelled ? "#ff003c" : "#00ff00"}; font-weight: bold;">${bk.status}</td>
          <td style="min-width: 120px;">
            ${btnEditHTML}
            ${btnRefundHTML}
          </td>
        </tr>
      `;
    });

    attachBookingEvents();
  };

  function attachBookingEvents() {
    document.querySelectorAll(".btn-edit-booking").forEach((btn) => {
      btn.addEventListener("click", function () {
        let index = this.getAttribute("data-index");
        let myBookings = JSON.parse(localStorage.getItem("myBookings") || "[]");
        let bk = myBookings[index];

        document.getElementById("edit-booking-index").value = index;
        document.getElementById("edit-duration-display").innerText =
          bk.duration;
        document.getElementById("new-start-time").value = "";
        // Xử lý hiển thị bảng chọn sân nếu đơn hàng 2 sân trở lên
        const courtGroup = document.getElementById(
          "edit-court-selection-group",
        );
        const courtSelector = document.getElementById("edit-court-selector");

        if (courtGroup && courtSelector) {
          if (bk.courts && bk.courts.length >= 2) {
            courtGroup.style.display = "block";
            courtSelector.innerHTML = "";

            bk.courts.forEach((courtNum) => {
              let option = document.createElement("option");
              option.value = courtNum;
              option.text = `Sân số ${courtNum}`;
              courtSelector.appendChild(option);
            });
          } else {
            courtGroup.style.display = "none";
            courtSelector.innerHTML = "";
          }
        }

        editTimeModal.style.display = "flex";
      });
    });

    //HỦY VÀ HOÀN TIỀN
    document.querySelectorAll(".btn-refund-booking").forEach((btn) => {
      btn.addEventListener("click", function () {
        let index = this.getAttribute("data-index");
        let myBookings = JSON.parse(localStorage.getItem("myBookings") || "[]");
        let bk = myBookings[index];

        if (
          confirm(
            `CẢNH BÁO: Bạn có chắc muốn HỦY đơn ${bk.id}?\nBạn sẽ được hoàn 50% số tiền thanh toán dưới dạng Mã Giảm Giá.`,
          )
        ) {
          let refundAmount = bk.amount * 0.5;
          let newVoucherCode = "HOAN" + Math.floor(Math.random() * 10000);

          bk.status = "Đã hủy (Hoàn tiền)";
          localStorage.setItem("myBookings", JSON.stringify(myBookings));

          let myCodes = JSON.parse(
            localStorage.getItem("myDiscountCodes") || "[]",
          );
          myCodes.push(newVoucherCode);
          localStorage.setItem("myDiscountCodes", JSON.stringify(myCodes));

          let history = JSON.parse(
            localStorage.getItem("transactionHistory") || "[]",
          );
          history.unshift({
            id: "RF" + Math.floor(Math.random() * 100000),
            branch: "Hoàn 50% đơn " + bk.id,
            hours: "0",
            points: "+0",
            amount: refundAmount,
            status: `Đã cấp mã: ${newVoucherCode}`,
          });
          localStorage.setItem("transactionHistory", JSON.stringify(history));

          let courtsToClear =
            bk.courts ||
            (bk.branch.match(/Sân (\d+)/g) || []).map((s) =>
              s.replace("Sân ", ""),
            );
          let oldSlots = getSlotsFromTime(bk.startTime, bk.duration);

          courtsToClear.forEach((c) => {
            oldSlots.forEach((t) => {
              let td = document.querySelector(
                `td[data-san="${c}"][data-time="${t}"]`,
              );
              if (td && td.classList.contains("cell-blue")) {
                td.classList.replace("cell-blue", "cell-white");
              }
            });
          });

          alert(
            `ĐÃ HỦY ĐƠN VÀ HOÀN TIỀN THÀNH CÔNG!\nSố tiền hoàn: ${refundAmount.toLocaleString()}đ\nMã giảm giá của bạn là: [ ${newVoucherCode} ]\nVui lòng kiểm tra Kho Voucher ở trang Khuyến Mãi.`,
          );
          renderMyBookings();
        }
      });
    });
  }

  if (btnCloseEditTime)
    btnCloseEditTime.addEventListener(
      "click",
      () => (editTimeModal.style.display = "none"),
    );

  // THAY THẾ LUỒNG LOGIC KHI ẤN NÚT
  if (btnConfirmEditTime) {
    btnConfirmEditTime.addEventListener("click", function () {
      let index = document.getElementById("edit-booking-index").value;
      let newStart = document.getElementById("new-start-time").value;

      if (!newStart) return alert("Vui lòng chọn giờ bắt đầu mới!");

      let myBookings = JSON.parse(localStorage.getItem("myBookings") || "[]");
      let bk = myBookings[index];

      let courtsToMove = [];
      let isSingleCourtFromMultiple = false;
      let movedCourt = "";

      // PHÂN NHÁNH: KIỂM TRA KHÁCH DỜI 1 SÂN
      if (bk.courts && bk.courts.length >= 2) {
        movedCourt = document.getElementById("edit-court-selector").value;
        courtsToMove = [movedCourt];
        isSingleCourtFromMultiple = true;
      } else {
        courtsToMove =
          bk.courts ||
          (bk.branch.match(/Sân (\d+)/g) || []).map((s) =>
            s.replace("Sân ", ""),
          );
      }

      let oldSlots = getSlotsFromTime(bk.startTime, bk.duration);
      let newSlots = getSlotsFromTime(newStart, bk.duration);

      let canMove = true;
      courtsToMove.forEach((c) => {
        newSlots.forEach((t) => {
          let td = document.querySelector(
            `td[data-san="${c}"][data-time="${t}"]`,
          );
          if (!td) canMove = false;
          else if (td.classList.contains("cell-black")) canMove = false;
          else if (td.classList.contains("cell-blue") && !oldSlots.includes(t))
            canMove = false;
        });
      });

      if (!canMove) {
        return alert(
          "Giờ mới đã bị trùng với lịch đặt của người khác, giờ bảo trì hoặc vượt quá giờ đóng cửa!\nVui lòng chọn giờ khác.",
        );
      }

      courtsToMove.forEach((c) => {
        oldSlots.forEach((t) => {
          let td = document.querySelector(
            `td[data-san="${c}"][data-time="${t}"]`,
          );
          if (td && td.classList.contains("cell-blue"))
            td.classList.replace("cell-blue", "cell-white");
        });
        newSlots.forEach((t) => {
          let td = document.querySelector(
            `td[data-san="${c}"][data-time="${t}"]`,
          );
          if (td && td.classList.contains("cell-white"))
            td.classList.replace("cell-white", "cell-blue");
        });
      });

      if (isSingleCourtFromMultiple) {
        let totalCourtsOriginal = bk.courts.length;
        let singleAmount = bk.amount / totalCourtsOriginal;

        //Loại bỏ sân đã dời ra khỏi đơn gốc, giảm tiền đơn gốc
        bk.courts = bk.courts.filter((c) => c !== movedCourt);
        bk.amount = bk.amount - singleAmount;
        let branchBase = bk.branch.split(" - Sân ")[0];
        bk.branch = branchBase + " - Sân " + bk.courts.join(", Sân ");

        let txIdNew = bk.id + "-1";
        let newBooking = {
          id: txIdNew,
          branch: branchBase + " - Sân " + movedCourt,
          courts: [movedCourt],
          date: bk.date,
          startTime: newStart,
          duration: bk.duration,
          amount: singleAmount,
          isEdited: true,
          status: "Thành công",
        };

        myBookings.unshift(newBooking);

        // Lưu vào Lịch sử giao dịch
        let history = JSON.parse(
          localStorage.getItem("transactionHistory") || "[]",
        );
        history.unshift({
          id: txIdNew,
          branch:
            branchBase + " - Sân " + movedCourt + " (Tách từ " + bk.id + ")",
          hours: bk.duration + " Giờ",
          points: "+0",
          amount: singleAmount,
          status: "Thành công",
        });
        localStorage.setItem("transactionHistory", JSON.stringify(history));
      } else {
        bk.startTime = newStart;
        bk.isEdited = true;
      }

      localStorage.setItem("myBookings", JSON.stringify(myBookings));

      alert(
        `ĐÃ DỜI GIỜ THÀNH CÔNG!\nLịch mới cho Sân số ${courtsToMove.join(", ")} là từ: ${newStart}`,
      );
      editTimeModal.style.display = "none";
      renderMyBookings();
    });
  }

  renderMyBookings();
  const btnRules = document.getElementById("btn-rules");
  const rulesModal = document.getElementById("rules-modal");
  const closeRulesModal = document.getElementById("close-rules-modal");

  if (btnRules) {
    btnRules.addEventListener("click", () => {
      rulesModal.style.display = "flex";
    });
  }

  document.querySelectorAll("a").forEach((link) => {
    if (link.innerText.includes("Quy Định Về Sân")) {
      link.addEventListener("click", (e) => {
        e.preventDefault();
        rulesModal.style.display = "flex";
        const sidebar = document.getElementById("sidebar-menu");
        if (sidebar) sidebar.classList.remove("open");
      });
    }
  });

  if (closeRulesModal) {
    closeRulesModal.addEventListener("click", () => {
      rulesModal.style.display = "none";
    });
  }

  window.addEventListener("click", (e) => {
    if (e.target === rulesModal) {
      rulesModal.style.display = "none";
    }
  });
  // HIỆU ỨNG CUỘN NAV VÀ CHATBOT
  const navbarUnified = document.getElementById("navbar");
  if (navbarUnified) {
    window.addEventListener("scroll", function () {
      navbarUnified.classList.toggle("scrolled", window.scrollY > 20);
    });
  }

  const chatToggle = document.getElementById("chat-toggle");
  const chatClose = document.getElementById("chat-close");
  const chatWindow = document.getElementById("chat-window");
  const sendBtn = document.getElementById("send-btn");
  const userInput = document.getElementById("user-input");
  const chatMessages = document.getElementById("chat-messages");

  if (chatToggle && chatWindow) {
    chatToggle.addEventListener(
      "click",
      () => (chatWindow.style.display = "flex"),
    );
    chatClose.addEventListener(
      "click",
      () => (chatWindow.style.display = "none"),
    );

    sendBtn.addEventListener("click", sendMessage);
    userInput.addEventListener("keypress", (e) => {
      if (e.key === "Enter") sendMessage();
    });

    function sendMessage() {
      let msg = userInput.value.trim();
      if (!msg) return;

      chatMessages.innerHTML += `<div class="user-msg">${msg}</div>`;
      userInput.value = "";

      setTimeout(() => {
        chatMessages.innerHTML += `<div class="bot-msg">Cảm ơn bạn! Để thay đổi giờ đặt, bạn vui lòng kéo xuống phần "Quản Lý Sân Của Bạn" nhé!</div>`;
        chatMessages.scrollTop = chatMessages.scrollHeight;
      }, 500);
    }
  }
  // HỆ THỐNG TÌM KIẾM & ĐIỀU HƯỚNG THÔNG MINH
  const searchInput = document.getElementById("global-search-input");
  const searchBtn = document.getElementById("global-search-btn");

  function executeSearch() {
    if (!searchInput) return;
    let query = searchInput.value.toLowerCase().trim();
    if (!query) return;

    const removeAccents = (str) => {
      return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    };
    let normalizedQuery = removeAccents(query);

    if (
      normalizedQuery.includes("dat san") ||
      normalizedQuery.includes("thue san")
    ) {
      window.location.href = "Datsan.html";
    } else if (normalizedQuery.includes("bong da")) {
      window.location.href =
        "Thongtinchung.html?section=danhsachsan&mon=bongda";
    } else if (normalizedQuery.includes("cau long")) {
      window.location.href =
        "Thongtinchung.html?section=danhsachsan&mon=caulong";
    } else if (
      normalizedQuery.includes("khuyen mai") ||
      normalizedQuery.includes("lich su") ||
      normalizedQuery.includes("tich diem") ||
      normalizedQuery.includes("voucher")
    ) {
      window.location.href = "ThanhtoanvaKhuyenmai.html";
    } else if (
      normalizedQuery.includes("cuoc thi") ||
      normalizedQuery.includes("giai dau")
    ) {
      window.location.href = "Thongtinchung.html?section=cuocthi";
    } else if (
      normalizedQuery.includes("doi tac") ||
      normalizedQuery.includes("lien he")
    ) {
      window.location.href = "Thongtinchung.html?section=doitac";
    } else if (
      normalizedQuery.includes("quy dinh") ||
      normalizedQuery.includes("noi quy")
    ) {
      let rulesBtn = document.getElementById("btn-rules");
      if (rulesBtn) rulesBtn.click();
      else window.location.href = "Datsan.html";
    } else {
      alert(
        `Không tìm thấy kết quả cho: "${searchInput.value}"\n💡 Gợi ý từ khóa: Đặt sân, Bóng đá, Cầu lông, Khuyến mãi, Cuộc thi, Đối tác...`,
      );
    }
  }

  if (searchBtn) {
    searchBtn.addEventListener("click", executeSearch);
  }

  if (searchInput) {
    searchInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter") {
        e.preventDefault();
        executeSearch();
      }
    });
  }
});
