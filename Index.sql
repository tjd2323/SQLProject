-- speeds up “show upcoming appointments” queries

USE UABS;
CREATE INDEX idx_appt_account_start
  ON Appointment (account_id, startTime);
