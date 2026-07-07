document.addEventListener("DOMContentLoaded", function () {
  //KIỂM TRA QUYỀN TRUY CẬP (BẢO MẬT VÀ PHÂN QUYỀN UI)
  let currentRole = localStorage.getItem("userRole");
  let currentName = localStorage.getItem("userName");

  if (currentRole !== "admin" && currentRole !== "manager") {
    alert("Cảnh báo: Bạn không có quyền truy cập trang quản trị!");
    window.location.href = "Nguoidung.html";
    return;
  }

  document.getElementById("display-admin-name").innerText =
    currentName || "Người dùng";

  if (currentRole === "manager") {
    document.getElementById("display-admin-role").innerText =
      "Quản lý Chi nhánh";

    const adminOnlyElements = document.querySelectorAll(".admin-only");
    adminOnlyElements.forEach((el) => {
      el.style.display = "none";
    });
  } else if (currentRole === "admin") {
    document.getElementById("display-admin-role").innerText =
      "Quản trị viên cấp cao";
  }

  //CHỨC NĂNG ĐĂNG XUẤT
  const btnLogout = document.getElementById("btn-logout");
  if (btnLogout) {
    btnLogout.addEventListener("click", function () {
      if (confirm("Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?")) {
        localStorage.clear();
        window.location.href = "Nguoidung.html";
      }
    });
  }

  // 3. XỬ LÝ CHUYỂN TAB
  const navItems = document.querySelectorAll(".nav-item");
  const contentSections = document.querySelectorAll(".content-section");
  const pageTitle = document.getElementById("page-title");

  navItems.forEach((item) => {
    item.addEventListener("click", function (e) {
      e.preventDefault();

      navItems.forEach((nav) => nav.classList.remove("active"));
      this.classList.add("active");

      pageTitle.innerText = this.innerText;

      const targetId = this.getAttribute("data-target");

      contentSections.forEach((section) => {
        section.style.display = "none";
        section.classList.remove("active");
      });

      const targetSection = document.getElementById(targetId);
      if (targetSection) {
        targetSection.style.display = "block";
        targetSection.classList.add("active"); //viết CSS animaton
      }
    });
  });
  //CRUD QUẢN LÝ SÂN BÃI
  const btnAddCourt = document.getElementById("btn-add-court");
  const courtModal = document.getElementById("court-modal");
  const btnCloseCourtModal = document.getElementById("btn-close-court-modal");
  const courtForm = document.getElementById("court-form");
  const modalTitle = document.getElementById("court-modal-title");
  const courtsTableBody = document.getElementById("courts-table-body");

  let courtsData = JSON.parse(localStorage.getItem("courtsData"));
  if (!courtsData) {
    courtsData = [
      {
        uuid: "1",
        courtId: "Sân 1",
        district: "Quận 7",
        branch: "Cơ sở chính",
        type: "Bóng đá",
        price: 250000,
        holidayPrice: 300000,
        discount: 10,
        status: "Hoạt động",
      },
      {
        uuid: "2",
        courtId: "Sân 3",
        district: "Quận 5",
        branch: "Cơ sở 1",
        type: "Cầu lông",
        price: 150000,
        holidayPrice: 180000,
        discount: 0,
        status: "Bảo trì",
      },
    ];
    localStorage.setItem("courtsData", JSON.stringify(courtsData));
  }

  function renderCourtsTable() {
    if (!courtsTableBody) return;
    courtsTableBody.innerHTML = "";

    courtsData.forEach((court) => {
      const badgeClass =
        court.status === "Hoạt động"
          ? "badge-success"
          : court.status === "Bảo trì"
            ? "badge-warning"
            : "badge-danger";
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td><strong>${court.courtId}</strong></td>
        <td>${court.branch} <br><small style="color: var(--neon-volt)">(${court.district})</small></td>
        <td>${court.type}</td>
        <td>${parseInt(court.price).toLocaleString()} đ</td>
        <td>${parseInt(court.holidayPrice).toLocaleString()} đ</td>
        <td>${court.discount}%</td>
        <td><span class="badge ${badgeClass}">${court.status}</span></td>
        <td>
          <button class="btn-text neon-text btn-edit-court" data-uuid="${court.uuid}" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></button>
          <button class="btn-text btn-delete-court" data-uuid="${court.uuid}" style="color: #ff003c; margin-left: 10px;" title="Xóa"><i class="fa-solid fa-trash"></i></button>
        </td>
      `;
      courtsTableBody.appendChild(tr);
    });
  }

  renderCourtsTable();

  //MỞ FORM THÊM SÂN
  if (btnAddCourt) {
    btnAddCourt.addEventListener("click", () => {
      modalTitle.innerText = "Thêm Sân Mới";
      if (courtForm) courtForm.reset();
      document.getElementById("edit-court-uuid").value = ""; // Xóa trắng ID ẩn
      courtModal.style.display = "flex";
    });
  }

  if (btnCloseCourtModal) {
    btnCloseCourtModal.addEventListener(
      "click",
      () => (courtModal.style.display = "none"),
    );
  }

  //XỬ LÝ SỰ KIỆN SỬA VÀ XÓA
  if (courtsTableBody) {
    courtsTableBody.addEventListener("click", (e) => {
      const editBtn = e.target.closest(".btn-edit-court");
      const delBtn = e.target.closest(".btn-delete-court");

      if (editBtn) {
        const uuid = editBtn.getAttribute("data-uuid");
        const court = courtsData.find((c) => c.uuid === uuid);

        if (court) {
          modalTitle.innerText = "Chỉnh Sửa Sân Bãi";
          document.getElementById("edit-court-uuid").value = court.uuid;
          document.getElementById("court-id").value = court.courtId;
          document.getElementById("court-district").value = court.district;
          document.getElementById("court-branch").value = court.branch;
          document.getElementById("court-type").value = court.type;
          document.getElementById("court-price").value = court.price;
          document.getElementById("court-holiday-price").value =
            court.holidayPrice;
          document.getElementById("court-discount").value = court.discount;
          document.getElementById("court-status").value = court.status;

          courtModal.style.display = "flex";
        }
      } else if (delBtn) {
        const uuid = delBtn.getAttribute("data-uuid");
        const courtIndex = courtsData.findIndex((c) => c.uuid === uuid);

        if (courtIndex !== -1) {
          if (
            confirm(
              `Bạn có chắc chắn muốn xóa "${courtsData[courtIndex].courtId}" thuộc "${courtsData[courtIndex].branch}" không?`,
            )
          ) {
            courtsData.splice(courtIndex, 1);
            localStorage.setItem("courtsData", JSON.stringify(courtsData));
            renderCourtsTable();
          }
        }
      }
    });
  }

  //LƯU DỮ LIỆU
  if (courtForm) {
    courtForm.addEventListener("submit", (e) => {
      e.preventDefault();

      const uuid = document.getElementById("edit-court-uuid").value;
      const courtId = document.getElementById("court-id").value.trim();
      const district = document.getElementById("court-district").value;
      const branch = document.getElementById("court-branch").value.trim();
      const type = document.getElementById("court-type").value;
      const price = document.getElementById("court-price").value;
      const holidayPrice = document.getElementById("court-holiday-price").value;
      const discount = document.getElementById("court-discount").value || 0;
      const status = document.getElementById("court-status").value;
      const isDuplicate = courtsData.some(
        (c) =>
          c.courtId.toLowerCase() === courtId.toLowerCase() &&
          c.branch.toLowerCase() === branch.toLowerCase() &&
          c.district === district &&
          c.type === type &&
          c.uuid !== uuid,
      );

      if (isDuplicate) {
        alert(
          `LỖI: Cơ sở "${branch} (${district})" ĐÃ TỒN TẠI "${courtId}" dành cho môn ${type}!\nVui lòng nhập mã sân khác.`,
        );
        return;
      }

      if (uuid) {
        const index = courtsData.findIndex((c) => c.uuid === uuid);
        if (index !== -1) {
          courtsData[index] = {
            uuid,
            courtId,
            district,
            branch,
            type,
            price,
            holidayPrice,
            discount,
            status,
          };
          alert("Cập nhật dữ liệu thành công!");
        }
      } else {
        const newUuid = Date.now().toString();
        courtsData.push({
          uuid: newUuid,
          courtId,
          district,
          branch,
          type,
          price,
          holidayPrice,
          discount,
          status,
        });
        alert("Thêm sân mới thành công!");
      }

      localStorage.setItem("courtsData", JSON.stringify(courtsData));
      renderCourtsTable();
      courtModal.style.display = "none";
    });
  }
});
