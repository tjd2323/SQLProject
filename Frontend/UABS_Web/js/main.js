// Main JavaScript for UABS front-end

document.addEventListener("DOMContentLoaded", () => {
  console.log("UABS front-end loaded.");

  const accountTypeSelect = document.getElementById("account_type");
  const businessFields = document.getElementById("businessFields");
  const dataBrokerFields = document.getElementById("dataBrokerFields");

  const businessNameInput = document.getElementById("business_name"); // may not exist; safe-guarded
  const businessDescInput = document.getElementById("business_description");
  const purposeInput = document.getElementById("purpose");

  // ============================================================
  // ACCOUNT TYPE HANDLING (Registration + Login screens)
  // ============================================================
  if (accountTypeSelect) {
    const handleAccountTypeChange = () => {
      const value = accountTypeSelect.value;

      // Default: hide conditional sections and remove "required"
      if (businessFields) businessFields.classList.add("hidden");
      if (dataBrokerFields) dataBrokerFields.classList.add("hidden");

      if (businessNameInput) businessNameInput.required = false;
      if (businessDescInput) businessDescInput.required = false;
      if (purposeInput) purposeInput.required = false;

      // Show fields only for registration (where those sections exist)
      if (value === "B" && businessFields) {
        businessFields.classList.remove("hidden");
        if (businessNameInput) businessNameInput.required = true;
        if (businessDescInput) businessDescInput.required = true;
      } else if (value === "D" && dataBrokerFields) {
        dataBrokerFields.classList.remove("hidden");
        if (purposeInput) purposeInput.required = true;
      }
    };

    // Pre-select type from URL parameter (for links like login.html?type=B)
    const params = new URLSearchParams(window.location.search);
    const urlType = params.get("type");
    if (urlType) {
      accountTypeSelect.value = urlType;
    }

    handleAccountTypeChange();
    accountTypeSelect.addEventListener("change", handleAccountTypeChange);
  }

  // ============================================================
  // USER DASHBOARD – BROWSE SERVICES + BOOK APPOINTMENT
  // ============================================================

  // ---------- Browse Services search on User Dashboard ----------
  const serviceSearchInput = document.getElementById("serviceSearch");
  const servicesTable = document.getElementById("servicesTable");

  if (serviceSearchInput && servicesTable) {
    const rows = servicesTable.querySelectorAll("tbody tr");

    serviceSearchInput.addEventListener("input", () => {
      const query = serviceSearchInput.value.toLowerCase().trim();

      rows.forEach((row) => {
        const text = row.textContent.toLowerCase();
        row.style.display = !query || text.includes(query) ? "" : "none";
      });
    });
  }

  // ---------- User: Create Appointment (Book) ----------
  const createAppointmentPanel = document.getElementById(
    "createAppointmentPanel"
  );
  const createAppointmentForm = document.getElementById(
    "createAppointmentForm"
  );
  const bookServiceIdInput = document.getElementById("book_service_id");
  const bookServiceSummary = document.getElementById("book_service_summary");
  const cancelCreateAppointmentBtn = document.getElementById(
    "cancelCreateAppointment"
  );

  const openCreateAppointment = (row) => {
    if (!row || !createAppointmentPanel || !createAppointmentForm) return;

    // Reset first so we do NOT wipe out the service id after setting it
    createAppointmentForm.reset(); // clear date/time/note

    const serviceId = row.getAttribute("data-service-id") || "";
    const cells = row.children;
    // Columns: 0 = Business, 1 = Service, 2 = Price, 3 = Duration
    const business = cells[0].textContent.trim();
    const service = cells[1].textContent.trim();
    const price = cells[2].textContent.trim();
    const duration = cells[3].textContent.trim();

    const summary = `${service} at ${business} – ${price}, ${duration} minutes`;

    if (bookServiceIdInput) bookServiceIdInput.value = serviceId;
    if (bookServiceSummary) bookServiceSummary.textContent = summary;

    createAppointmentPanel.classList.remove("hidden");
    createAppointmentPanel.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  };

  const closeCreateAppointment = () => {
    if (!createAppointmentPanel || !createAppointmentForm) return;
    createAppointmentPanel.classList.add("hidden");
    createAppointmentForm.reset();
    if (bookServiceSummary) bookServiceSummary.textContent = "";
  };

  // When user clicks "Book" in Browse Services
  if (servicesTable && createAppointmentPanel && createAppointmentForm) {
    servicesTable.addEventListener("click", (event) => {
      const target = event.target;
      if (target.classList.contains("btn-book")) {
        const row = target.closest("tr");
        openCreateAppointment(row);
      }
    });
  }

  // NOTE: Right now we keep this as a demo (alert). When backend is ready,
  // we can remove preventDefault() and let the form submit to a servlet.
  if (createAppointmentForm) {
    createAppointmentForm.addEventListener("submit", (event) => {
      event.preventDefault();

      const date = document.getElementById("book_date").value;
      const time = document.getElementById("book_time").value;

      if (!date || !time) {
        alert("Please choose both date and time.");
        return;
      }

      alert("Appointment booking request submitted (demo).");
      closeCreateAppointment();
    });
  }

  if (cancelCreateAppointmentBtn) {
    cancelCreateAppointmentBtn.addEventListener(
      "click",
      closeCreateAppointment
    );
  }

  // ============================================================
  // BUSINESS DASHBOARD – SERVICES + AVAILABILITY
  // ============================================================

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
  const svcCategoryInput = document.getElementById("svc_category");

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
      if (svcCategoryInput) svcCategoryInput.value = "";
      const statusSelect = document.getElementById("svc_status");
      if (statusSelect) statusSelect.value = "Active";
    } else if (mode === "edit" && row) {
      serviceFormTitle.textContent = "Edit Service";
      const cells = row.children;
      // Table columns: 0 = name, 1 = category, 2 = price, 3 = duration, 4 = status
      document.getElementById("svc_name").value = cells[0].textContent.trim();
      if (svcCategoryInput) {
        svcCategoryInput.value = cells[1].textContent.trim();
      }
      document.getElementById("svc_price").value = cells[2].textContent
        .replace("$", "")
        .trim();
      document.getElementById("svc_duration").value =
        cells[3].textContent.trim();
      const statusSelect = document.getElementById("svc_status");
      if (statusSelect) {
        statusSelect.value = cells[4].textContent.trim() || "Active";
      }
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
      const category = svcCategoryInput ? svcCategoryInput.value.trim() : "";
      const price = document.getElementById("svc_price").value.trim();
      const duration = document.getElementById("svc_duration").value.trim();
      const statusSelect = document.getElementById("svc_status");
      const status = statusSelect ? statusSelect.value : "Active";

      if (!name || !category || !price || !duration || !status) {
        alert("Please fill in all required fields (including category).");
        return;
      }

      const formattedPrice = `$${price}`;

      if (serviceFormMode === "add" && businessServicesTable) {
        const tbody = businessServicesTable.querySelector("tbody");
        const newRow = document.createElement("tr");
        newRow.innerHTML = `
          <td>${name}</td>
          <td>${category}</td>
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
        cells[1].textContent = category;
        cells[2].textContent = formattedPrice;
        cells[3].textContent = duration;
        cells[4].textContent = status;
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
      } else if (
        availabilityFormMode === "edit" &&
        currentAvailabilityRow
      ) {
        const cells = currentAvailabilityRow.children;
        cells[0].textContent = day;
        cells[1].textContent = start;
        cells[2].textContent = end;
      }

      closeAvailabilityForm();
    });
  }

  // ============================================================
  // DATA BROKER – REPORT FILTERS
  // ============================================================
  const reportsTable = document.getElementById("businessReportsTable");
  const btnApplyReportFilters = document.getElementById(
    "btnApplyReportFilters"
  );
  const btnClearReportFilters = document.getElementById(
    "btnClearReportFilters"
  );

  const filterBusinessInput = document.getElementById("filter_business"); // Category
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

    const firstCol = cells[0].textContent.toLowerCase(); // Category
    const city = cells[1].textContent.toLowerCase();
    const country = cells[2].textContent.toLowerCase();
    const periodText = cells[3].textContent.trim();
    const totalApptsText = cells[4].textContent.trim();

    const qFirst = (filterBusinessInput?.value || "").toLowerCase().trim();
    const qCity = (filterCityInput?.value || "").toLowerCase().trim();
    const qCountry = (filterCountryInput?.value || "").toLowerCase().trim();
    const qMinAppts = filterMinApptsInput?.value
      ? parseInt(filterMinApptsInput.value, 10)
      : null;
    const qStart = filterStartInput?.value || null;
    const qEnd = filterEndInput?.value || null;

    // Text filters
    if (qFirst && !firstCol.includes(qFirst)) return false;
    if (qCity && !city.includes(qCity)) return false;
    if (qCountry && !country.includes(qCountry)) return false;

    // Min appointments
    const totalAppts = parseInt(totalApptsText, 10) || 0;
    if (qMinAppts !== null && totalAppts < qMinAppts) return false;

    // Date range vs "Report Period"
    if (qStart || qEnd) {
      const { start, end } = parsePeriod(periodText);
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

  // ============================================================
  // USER – RESCHEDULE APPOINTMENT (demo UI)
  // ============================================================
  const appointmentsTable = document.getElementById("appointmentsTable");
  const rescheduleFormPanel = document.getElementById("rescheduleFormPanel");
  const rescheduleForm = document.getElementById("rescheduleForm");
  const reschedApptIdInput = document.getElementById("resched_appt_id");
  const reschedApptSummary = document.getElementById("resched_appt_summary");
  const cancelRescheduleFormBtn = document.getElementById(
    "cancelRescheduleForm"
  );

  const openRescheduleForm = (row) => {
    if (!row || !rescheduleFormPanel) return;

    const apptId = row.getAttribute("data-appt-id") || "";
    const cells = row.children;

    const summaryText =
      `${cells[0].textContent.trim()} at ${cells[1].textContent.trim()} – ` +
      `${cells[2].textContent.trim()} (${cells[3].textContent.trim()})`;

    if (reschedApptIdInput) reschedApptIdInput.value = apptId;
    if (reschedApptSummary) reschedApptSummary.textContent = summaryText;

    rescheduleFormPanel.classList.remove("hidden");
    rescheduleFormPanel.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const closeRescheduleForm = () => {
    if (!rescheduleFormPanel || !rescheduleForm) return;
    rescheduleFormPanel.classList.add("hidden");
    rescheduleForm.reset();
    if (reschedApptSummary) reschedApptSummary.textContent = "";
  };

  if (appointmentsTable) {
    appointmentsTable.addEventListener("click", (event) => {
      const target = event.target;

      // open reschedule form
      if (target.classList.contains("btn-reschedule")) {
        const row = target.closest("tr");
        openRescheduleForm(row);
      }

      // simple cancel action demo
      if (target.classList.contains("btn-cancel-appt")) {
        const row = target.closest("tr");
        const serviceName = row
          ? row.children[3].textContent.trim()
          : "appointment";
        if (confirm(`Send cancel request for this ${serviceName}? (demo)`)) {
          alert("Cancel request sent to business (demo only).");
        }
      }
    });
  }

  if (rescheduleForm) {
    rescheduleForm.addEventListener("submit", (event) => {
      event.preventDefault();
      const date = document.getElementById("resched_date").value;
      const time = document.getElementById("resched_time").value;

      if (!date || !time) {
        alert("Please choose both date and time.");
        return;
      }

      alert("Reschedule request submitted (demo).");
      closeRescheduleForm();
    });
  }

  if (cancelRescheduleFormBtn) {
    cancelRescheduleFormBtn.addEventListener("click", closeRescheduleForm);
  }

  // ============================================================
  // MESSAGES – SEND + VIEW DETAILS (User/Business/DataBroker/Admin)
  // ============================================================
  const messageForm = document.getElementById("messageForm");
  const messagesTable = document.getElementById("messagesTable");
  const detailPanel = document.getElementById("messageDetailPanel");

  // Send message (front-end demo only)
  if (messageForm && messagesTable) {
    messageForm.addEventListener("submit", (event) => {
      event.preventDefault();

      const to = document.getElementById("msg_recipient").value.trim();
      const subject = document.getElementById("msg_subject").value.trim();
      const body = document.getElementById("msg_body").value.trim();

      if (!to || !subject || !body) {
        alert("Please fill in all message fields.");
        return;
      }

      const tbody = messagesTable.querySelector("tbody");
      const now = new Date().toISOString().slice(0, 10); // yyyy-mm-dd

      const safeBody = body.replace(/"/g, "&quot;");

      const newRow = document.createElement("tr");
      newRow.innerHTML = `
        <td>${now}</td>
        <td>Me</td>
        <td>${to}</td>
        <td>
          <button type="button"
                  class="link-button msg-subject"
                  data-body="${safeBody}">
            ${subject}
          </button>
        </td>
      `;
      tbody.appendChild(newRow);

      alert("Message sent (demo only).");
      messageForm.reset();
    });
  }

  // Click subject -> show detail panel
  if (messagesTable && detailPanel) {
    const detailSubject = document.getElementById("detailSubject");
    const detailFrom = document.getElementById("detailFrom");
    const detailTo = document.getElementById("detailTo");
    const detailDate = document.getElementById("detailDate");
    const detailBody = document.getElementById("detailBody");

    messagesTable.addEventListener("click", (event) => {
      const btn = event.target.closest(".msg-subject");
      if (!btn) return;

      const row = btn.closest("tr");
      const cells = row.children;

      const date = cells[0].textContent.trim();
      const from = cells[1].textContent.trim();
      const to = cells[2].textContent.trim();
      const subject = btn.textContent.trim();
      const body = btn.dataset.body || "(No message body in demo)";

      detailSubject.textContent = subject;
      detailFrom.textContent = from;
      detailTo.textContent = to;
      detailDate.textContent = date;
      detailBody.textContent = body;

      detailPanel.classList.remove("hidden");
      detailPanel.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  }
});
