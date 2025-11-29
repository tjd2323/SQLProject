 -- log table trigger for generic_Account
USE UABS;
DELIMITER //
CREATE TRIGGER audit_Account_delete AFTER DELETE ON generic_Account
FOR EACH ROW
BEGIN
insert into generic_account_log(account_id, account_type, full_name, address, city, country, email, phone, operation, odate)  values 
(old.account_id, old.account_type, 
old.full_name, old.address, old.city, old.country, old.email, old.phone, 'Delete', NOW());
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER audit_Account_update AFTER Update ON generic_Account
FOR EACH ROW
BEGIN
insert into generic_account_log(account_id, account_type, full_name, address, city, country, email, phone, operation, odate) values 
(old.account_id, old.account_type, old.full_name, 
old.address, old.city, old.country, old.email, old.phone, 'Update', NOW());
END;
//
DELIMITER ;
-- log table trigger for Appointment
DELIMITER //
CREATE TRIGGER audit_Appointment_delete AFTER DELETE ON Appointment
FOR EACH ROW
BEGIN
insert into Appointment_log(appt_id, service_id, account_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min, operation, odate) values 
(old.appt_id, old.service_id, old.account_id, old.notes, old.appt_status, old.no_show, old.startTime, old.endTime, old.cancel_window_min, 'Delete', NOW());
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER audit_Appointment_update AFTER UPDATE ON Appointment
FOR EACH ROW
BEGIN
insert into Appointment_log(appt_id, service_id, account_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min, operation, odate) 
values (old.appt_id, old.service_id, old.account_id, old.notes, old.appt_status, old.no_show, old.startTime, old.endTime, old.cancel_window_min, 'Update', NOW());
END;
//
DELIMITER ;
-- log table trigger for service
DELIMITER //
CREATE TRIGGER audit_Service_delete AFTER DELETE ON service
FOR EACH ROW
BEGIN
insert into service_log(service_id, account_id, category, full_name, duration_min, buffer_min, service_status, price, service_description, operation, odate) values 
(old.service_id, old.account_id, old.category, old.full_name, old.duration_min, old.buffer_min, old.service_status, old.price, old.service_description, 'Delete', NOW());
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER audit_Service_update AFTER Update ON service
FOR EACH ROW
BEGIN
insert into service_log(service_id, account_id, category, full_name, duration_min, buffer_min, service_status, price, service_description, operation, odate)
values (old.service_id, old.account_id, old.category, old.full_name, old.duration_min, old.buffer_min, old.service_status, old.price, old.service_description, 'Update', NOW());
END;
//
DELIMITER ;
