// Main JavaScript for UABS front-end

document.addEventListener("DOMContentLoaded", () => {
  console.log("UABS front-end loaded.");

  const accountTypeSelect = document.getElementById("account_type");
  const businessFields = document.getElementById("businessFields");
  const dataBrokerFields = document.getElementById("dataBrokerFields");

  const businessNameInput = document.getElementById("business_name");
  const businessDescInput = document.getElementById("business_description");
  const purposeInput = document.getElementById("purpose");

  // ---------- Account type handling (registration + login) ----------
  if (accountTypeSelect) {
    const handleAccountTypeChange = () => {
      const value = accountTypeSelect.value;

      // Default: hide conditional sections and remove "required"
      if (businessFields) businessFields.classList.add("hidden");
      if (dataBrokerFields) dataBrokerFields.classList.add("hidden");

      if (businessNameInput) businessNameInput.required = false;
      if (businessDescInput) businessDescInput.required = false;
      if (purposeInput) purposeInput.required = false;

      // Show fields only for registration page (where those sections exist)
      if (value === "B" && businessFields) {
        businessFields.classList.remove("hidden");
        if (businessNameInput) businessNameInput.required = true;
        if (businessDescInput) businessDescInput.required = true;
      } else if (value === "D" && dataBrokerFields) {
        dataBrokerFields.classList.remove("hidden");
        if (purposeInput) purposeInput.required = true;
      }
    };

    // Pre-select type from URL parameter (for login links like login.html?type=B)
    const params = new URLSearchParams(window.location.search);
    const urlType = params.get("type");
    if (urlType) {
      accountTypeSelect.value = urlType;
    }

    handleAccountTypeChange();
    accountTypeSelect.addEventListener("change", handleAccountTypeChange);
  }

  // Helper to decide which dashboard to go to
  const redirectToDashboard = (type, message) => {
    let targetPage = "index.html";

    switch (type) {
      case "C":
        targetPage = "user_dashboard.html";
        break;
      case "B":
        targetPage = "business_dashboard.html";
        break;
      case "D":
        targetPage = "databroker_dashboard.html";
        break;
      case "A":
        targetPage = "admin_dashboard.html";
        break;
    }

    if (!type) {
      alert("Please select an account type.");
      return;
    }

    alert(message);
    window.location.href = targetPage;
  };

  // ---------- Registration form demo submit ----------
  const registrationForm = document.getElementById("registrationForm");
  if (registrationForm && accountTypeSelect) {
    registrationForm.addEventListener("submit", (event) => {
      event.preventDefault(); // demo only
      const type = accountTypeSelect.value;
      redirectToDashboard(
        type,
        "Registration successful! Redirecting you to your dashboard (demo)."
      );
    });
  }

  // ---------- Login form demo submit ----------
  const loginForm = document.getElementById("loginForm");
  if (loginForm && accountTypeSelect) {
    loginForm.addEventListener("submit", (event) => {
      event.preventDefault(); // demo only
      const type = accountTypeSelect.value;
      redirectToDashboard(
        type,
        "Login successful! Redirecting you to your dashboard (demo)."
      );
    });
  }

  // ---------- Browse Services search on User Dashboard ----------
  const serviceSearchInput = document.getElementById("serviceSearch");
  const servicesTable = document.getElementById("servicesTable");

  if (serviceSearchInput && servicesTable) {
    const rows = servicesTable.querySelectorAll("tbody tr");

    serviceSearchInput.addEventListener("input", () => {
      const query = serviceSearchInput.value.toLowerCase().trim();

      rows.forEach((row) => {
        const text = row.textContent.toLowerCase();
        if (!query || text.includes(query)) {
          row.style.display = "";
        } else {
          row.style.display = "none";
        }
      });
    });
  }
  // ---------- Search + Add/Edit Service on Business Dashboard ----------

  const businessServiceSearchInput = document.getElementById(
    "businessServiceSearch"
  );
  const businessServicesTable = document.getElementById(
    "businessServicesTable"
  );
  const btnAddService = document.getElementById("btnAddService");
  const serviceFormPanel = document.getElementById("serviceFormPanel");
  const serviceForm = document.getElementById("serviceForm");
  const cancelServiceFormBtn = document.getElementById("cancelServiceForm");
  const serviceFormTitle = document.getElementById("serviceFormTitle");

  let serviceFormMode = null; // "add" or "edit"
  let currentServiceRow = null; // row being edited (if any)

  // Live search on services table
  if (businessServiceSearchInput && businessServicesTable) {
    businessServiceSearchInput.addEventListener("input", () => {
      const query = businessServiceSearchInput.value.toLowerCase().trim();
      const rows = businessServicesTable.querySelectorAll("tbody tr");

      rows.forEach((row) => {
        const text = row.textContent.toLowerCase();
        row.style.display = !query || text.includes(query) ? "" : "none";
      });
    });
  }

  const openServiceForm = (mode, row) => {
    serviceFormMode = mode;
    currentServiceRow = row || null;

    if (mode === "add") {
      serviceFormTitle.textContent = "Add New Service";
      serviceForm.reset();
      document.getElementById("svc_status").value = "Active";
    } else if (mode === "edit" && row) {
      serviceFormTitle.textContent = "Edit Service";
      // Read values from the row
      const cells = row.children;
      document.getElementById("svc_name").value = cells[0].textContent.trim();
      document.getElementById("svc_price").value = cells[1].textContent
        .replace("$", "")
        .trim();
      document.getElementById("svc_duration").value =
        cells[2].textContent.trim();
      document.getElementById("svc_status").value =
        cells[3].textContent.trim() || "Active";
      // Description is not shown in table in this demo, so leave as-is
    }

    serviceFormPanel.classList.remove("hidden");
    serviceFormPanel.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const closeServiceForm = () => {
    serviceFormPanel.classList.add("hidden");
    serviceForm.reset();
    serviceFormMode = null;
    currentServiceRow = null;
  };

  if (btnAddService && serviceFormPanel && serviceForm) {
    btnAddService.addEventListener("click", () => openServiceForm("add", null));
  }

  if (cancelServiceFormBtn) {
    cancelServiceFormBtn.addEventListener("click", closeServiceForm);
  }

  // Use event delegation for Edit buttons (works for newly added rows too)
  if (businessServicesTable) {
    businessServicesTable.addEventListener("click", (event) => {
      const target = event.target;
      if (target.classList.contains("btn-edit-service")) {
        const row = target.closest("tr");
        openServiceForm("edit", row);
      }
    });
  }

  if (serviceForm) {
    serviceForm.addEventListener("submit", (event) => {
      event.preventDefault();

      const name = document.getElementById("svc_name").value.trim();
      const price = document.getElementById("svc_price").value.trim();
      const duration = document.getElementById("svc_duration").value.trim();
      const status = document.getElementById("svc_status").value;

      if (!name || !price || !duration || !status) {
        alert("Please fill in all required fields.");
        return;
      }

      const formattedPrice = `$${price}`;

      if (serviceFormMode === "add" && businessServicesTable) {
        const tbody = businessServicesTable.querySelector("tbody");
        const newRow = document.createElement("tr");
        newRow.innerHTML = `
                    <td>${name}</td>
                    <td>${formattedPrice}</td>
                    <td>${duration}</td>
                    <td>${status}</td>
                    <td>
                        <button class="btn btn-small btn-outline btn-edit-service">Edit</button>
                        <button class="btn btn-small">${
                          status === "Active" ? "Deactivate" : "Activate"
                        }</button>
                    </td>
                `;
        tbody.appendChild(newRow);
      } else if (serviceFormMode === "edit" && currentServiceRow) {
        const cells = currentServiceRow.children;
        cells[0].textContent = name;
        cells[1].textContent = formattedPrice;
        cells[2].textContent = duration;
        cells[3].textContent = status;
      }

      closeServiceForm();
    });
  }
  // ---------- Availability / Schedule Add/Edit/Delete on Business Dashboard ----------

  const availabilityTable = document.getElementById("availabilityTable");
  const btnAddAvailability = document.getElementById("btnAddAvailability");
  const availabilityFormPanel = document.getElementById(
    "availabilityFormPanel"
  );
  const availabilityForm = document.getElementById("availabilityForm");
  const availabilityFormTitle = document.getElementById(
    "availabilityFormTitle"
  );
  const cancelAvailabilityFormBtn = document.getElementById(
    "cancelAvailabilityForm"
  );

  let availabilityFormMode = null; // "add" or "edit"
  let currentAvailabilityRow = null; // row being edited (if any)

  const openAvailabilityForm = (mode, row) => {
    availabilityFormMode = mode;
    currentAvailabilityRow = row || null;

    if (mode === "add") {
      availabilityFormTitle.textContent = "Add Availability Block";
      availabilityForm.reset();
      const daySelect = document.getElementById("avail_day");
      if (daySelect) daySelect.value = "Monday";
    } else if (mode === "edit" && row) {
      availabilityFormTitle.textContent = "Edit Availability Block";
      const cells = row.children;
      document.getElementById("avail_day").value = cells[0].textContent.trim();
      document.getElementById("avail_start").value =
        cells[1].textContent.trim();
      document.getElementById("avail_end").value = cells[2].textContent.trim();
    }

    availabilityFormPanel.classList.remove("hidden");
    availabilityFormPanel.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  };

  const closeAvailabilityForm = () => {
    availabilityFormPanel.classList.add("hidden");
    availabilityForm.reset();
    availabilityFormMode = null;
    currentAvailabilityRow = null;
  };

  if (btnAddAvailability && availabilityFormPanel && availabilityForm) {
    btnAddAvailability.addEventListener("click", () =>
      openAvailabilityForm("add", null)
    );
  }

  if (cancelAvailabilityFormBtn) {
    cancelAvailabilityFormBtn.addEventListener("click", closeAvailabilityForm);
  }

  if (availabilityTable) {
    availabilityTable.addEventListener("click", (event) => {
      const target = event.target;

      if (target.classList.contains("btn-edit-availability")) {
        const row = target.closest("tr");
        openAvailabilityForm("edit", row);
      } else if (target.classList.contains("btn-delete-availability")) {
        const row = target.closest("tr");
        if (confirm("Delete this availability block?")) {
          row.remove();
        }
      }
    });
  }

  if (availabilityForm) {
    availabilityForm.addEventListener("submit", (event) => {
      event.preventDefault();

      const day = document.getElementById("avail_day").value;
      const start = document.getElementById("avail_start").value;
      const end = document.getElementById("avail_end").value;

      if (!day || !start || !end) {
        alert("Please fill in all required fields.");
        return;
      }

      if (availabilityFormMode === "add" && availabilityTable) {
        const tbody = availabilityTable.querySelector("tbody");
        const newRow = document.createElement("tr");
        newRow.innerHTML = `
          <td>${day}</td>
          <td>${start}</td>
          <td>${end}</td>
          <td>
            <button class="btn btn-small btn-outline btn-edit-availability">Edit</button>
            <button class="btn btn-small btn-delete-availability">Delete</button>
          </td>
        `;
        tbody.appendChild(newRow);
      } else if (availabilityFormMode === "edit" && currentAvailabilityRow) {
        const cells = currentAvailabilityRow.children;
        cells[0].textContent = day;
        cells[1].textContent = start;
        cells[2].textContent = end;
      }

      closeAvailabilityForm();
    });
  }

  // ---------- Data Broker: Business Reports filters ----------

  const reportsTable = document.getElementById("businessReportsTable");
  const btnApplyReportFilters = document.getElementById(
    "btnApplyReportFilters"
  );
  const btnClearReportFilters = document.getElementById(
    "btnClearReportFilters"
  );

  const filterBusinessInput = document.getElementById("filter_business");
  const filterCityInput = document.getElementById("filter_city");
  const filterCountryInput = document.getElementById("filter_country");
  const filterStartInput = document.getElementById("filter_start_date");
  const filterEndInput = document.getElementById("filter_end_date");
  const filterMinApptsInput = document.getElementById(
    "filter_min_appointments"
  );

  const parsePeriod = (periodText) => {
    // Example: "2025-01-01 to 2025-03-31"
    if (!periodText.includes("to")) return { start: null, end: null };
    const parts = periodText.split("to").map((p) => p.trim());
    return {
      start: parts[0] || null,
      end: parts[1] || null,
    };
  };

  const rowMatchesReportFilters = (row) => {
    const cells = row.children;

    const business = cells[0].textContent.toLowerCase();
    const city = cells[1].textContent.toLowerCase();
    const country = cells[2].textContent.toLowerCase();
    const periodText = cells[3].textContent.trim();
    const totalApptsText = cells[4].textContent.trim();

    const qBusiness = (filterBusinessInput?.value || "").toLowerCase().trim();
    const qCity = (filterCityInput?.value || "").toLowerCase().trim();
    const qCountry = (filterCountryInput?.value || "").toLowerCase().trim();
    const qMinAppts = filterMinApptsInput?.value
      ? parseInt(filterMinApptsInput.value, 10)
      : null;
    const qStart = filterStartInput?.value || null;
    const qEnd = filterEndInput?.value || null;

    // Text filters
    if (qBusiness && !business.includes(qBusiness)) return false;
    if (qCity && !city.includes(qCity)) return false;
    if (qCountry && !country.includes(qCountry)) return false;

    // Min appointments
    const totalAppts = parseInt(totalApptsText, 10) || 0;
    if (qMinAppts !== null && totalAppts < qMinAppts) return false;

    // Date range vs "Report Period"
    if (qStart || qEnd) {
      const { start, end } = parsePeriod(periodText);
      // Simple checks using ISO date strings
      if (qStart && (!start || start < qStart)) return false;
      if (qEnd && (!end || end > qEnd)) return false;
    }

    return true;
  };

  const applyReportFilters = () => {
    if (!reportsTable) return;
    const rows = reportsTable.querySelectorAll("tbody tr");
    rows.forEach((row) => {
      row.style.display = rowMatchesReportFilters(row) ? "" : "none";
    });
  };

  const clearReportFilters = () => {
    if (filterBusinessInput) filterBusinessInput.value = "";
    if (filterCityInput) filterCityInput.value = "";
    if (filterCountryInput) filterCountryInput.value = "";
    if (filterStartInput) filterStartInput.value = "";
    if (filterEndInput) filterEndInput.value = "";
    if (filterMinApptsInput) filterMinApptsInput.value = "";

    if (!reportsTable) return;
    const rows = reportsTable.querySelectorAll("tbody tr");
    rows.forEach((row) => {
      row.style.display = "";
    });
  };

  if (btnApplyReportFilters) {
    btnApplyReportFilters.addEventListener("click", applyReportFilters);
  }

  if (btnClearReportFilters) {
    btnClearReportFilters.addEventListener("click", clearReportFilters);
  }
});
