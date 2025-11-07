USE UABS;

-- user view : users and their appointments with service info
CREATE OR REPLACE VIEW v_user_portal AS
SELECT
  u.Account_id        AS user_id,
  u.full_name         AS user_name,
  u.email             AS user_email,
  ap.appt_id,
  ap.appt_status,
  ap.startTime,
  ap.endTime,
  s.service_id,
  s.full_Name         AS service_name,
  s.price             AS service_price,
  s.Account_id        AS business_id
FROM Generic_Account u
LEFT JOIN Appointment ap
  ON ap.account_id = u.Account_id
LEFT JOIN Service s
  ON s.service_id = ap.service_id
WHERE u.Account_type = 'C';   


-- 2) business view: businesses, their services, and any appointments
CREATE OR REPLACE VIEW v_business_portal AS
SELECT
  b.Account_id             AS business_id,
  gb.full_name             AS business_name,
  s.service_id,
  s.full_Name              AS service_name,
  s.category,
  s.price,
  ap.appt_id,
  ap.appt_status,
  ap.startTime,
  ap.endTime,
  ap.account_id            AS user_id
FROM Buisness_Profile b
JOIN Generic_Account gb
  ON gb.Account_id = b.Account_id
LEFT JOIN Service s
  ON s.Account_id = b.Account_id
LEFT JOIN Appointment ap
  ON ap.service_id = s.service_id;


-- 3) data broker view: brokers with status/purpose and contact info
CREATE OR REPLACE VIEW v_databroker_portal AS
SELECT
  db.Account_id         AS broker_id,
  g.full_name           AS broker_name,
  g.email               AS broker_email,
  db.Access_status,
  db.Purpose
FROM DataBroker_Profile db
JOIN Generic_Account g
  ON g.Account_id = db.Account_id
WHERE g.Account_type = 'D';   
