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
  const popup = document.getElementById("welcome-popup");
  const closePopupBtn = document.getElementById("close-popup");

  function handlePopupDisplay() {
    if (!localStorage.getItem("hasDismissedPopup")) {
      if (popup) popup.style.display = "flex";
    } else {
      if (popup) popup.style.display = "none";
    }
  }

  handlePopupDisplay();

  if (closePopupBtn) {
    closePopupBtn.addEventListener("click", function () {
      if (popup) popup.style.display = "none";
      localStorage.setItem("hasDismissedPopup", "true");
    });
  }

  const brandTrigger = document.getElementById("brand-trigger");
  if (brandTrigger) {
    brandTrigger.addEventListener("click", function () {
      window.location.reload();
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
  const btnDatSan = document.getElementById("btn-datsan");
  const btnHoTro = document.getElementById("btn-hotro");

  if (btnClbd)
    btnClbd.addEventListener("click", () =>
      document
        .getElementById("clbd-section")
        .scrollIntoView({ behavior: "smooth" }),
    );
  if (btnHoTro) {
    btnHoTro.addEventListener("click", () => {
      window.location.href = "Caidatchung.html";
    });
  }
  if (btnDatSan) {
    btnDatSan.addEventListener("click", () => {
      window.location.href = "Datsan.html";
    });
  }
  const btnBookNow = document.getElementById("btn-book-now");
  if (btnBookNow) {
    btnBookNow.addEventListener("click", function () {
      window.location.href = "Datsan.html";
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

  //SLIDER HÌNH ẢNH
  const slides = document.querySelectorAll(".slide");
  let currentSlide = 0;
  function showSlide(index) {
    slides.forEach((slide) => slide.classList.remove("active"));
    if (slides[index]) slides[index].classList.add("active");
  }
  function nextSlide() {
    if (slides.length === 0) return;
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
  }
  function prevSlide() {
    if (slides.length === 0) return;
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
  }
  const btnNext = document.getElementById("btn-next");
  const btnPrev = document.getElementById("btn-prev");
  if (btnNext) btnNext.addEventListener("click", nextSlide);
  if (btnPrev) btnPrev.addEventListener("click", prevSlide);
  setInterval(nextSlide, 5000);

  //HIỆU ỨNG CUỘN

  const navbarUnified = document.getElementById("navbar");
  if (navbarUnified) {
    window.addEventListener("scroll", function () {
      if (window.scrollY > 20) {
        navbarUnified.classList.add("scrolled");
      } else {
        navbarUnified.classList.remove("scrolled");
      }
    });
  }
  const scrollToTopBtn = document.getElementById("scroll-to-top");
  if (scrollToTopBtn) {
    scrollToTopBtn.addEventListener("click", function (e) {
      e.preventDefault();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }
  document.addEventListener("DOMContentLoaded", function () {
    const chatToggle = document.getElementById("chat-toggle");
    const chatClose = document.getElementById("chat-close");
    const chatWindow = document.getElementById("chat-window");
    const sendBtn = document.getElementById("send-btn");
    const userInput = document.getElementById("user-input");
    const chatMessages = document.getElementById("chat-messages");

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

      // Gọi chatbot(Backend)
      fetch("ChatbotServlet?query=" + encodeURIComponent(msg))
        .then((res) => res.text())
        .then((answer) => {
          chatMessages.innerHTML += `<div class="bot-msg">${answer}</div>`;
          chatMessages.scrollTop = chatMessages.scrollHeight;
        });
    }
  });
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
