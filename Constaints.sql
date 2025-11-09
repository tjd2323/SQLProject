USE UABS;

-- Generic_Account: emails must be unique
ALTER TABLE Generic_Account
  ADD CONSTRAINT uq_generic_account_email UNIQUE (email);

-- Service: valid price/status/durations
ALTER TABLE Service
  ADD CONSTRAINT chk_service_price    CHECK (price >= 0),
  ADD CONSTRAINT chk_service_status   CHECK (service_status IN ('active','inactive'));
  
-- Appointment: valid status + time window
ALTER TABLE Appointment
  ADD CONSTRAINT chk_appt_status CHECK (appt_status IN ('scheduled','completed','canceled','no-show')),
  ADD CONSTRAINT chk_appt_time   CHECK (startTime < endTime);

-- Availability block: start < end
ALTER TABLE Availability_block
  ADD CONSTRAINT chk_availability_time CHECK (start_time < end_time);

-- Verification: decision_time must not precede created_at
ALTER TABLE Verification
  ADD CONSTRAINT chk_verification_times CHECK (decision_time IS NULL OR decision_time >= created_at);
