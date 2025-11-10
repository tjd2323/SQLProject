USE UABS;
-- Inserting Databroker or buisness accounts and verifications into correct tables when a buisness account or databroker account made
DELIMITER //
CREATE TRIGGER after_Buisness_or_Databroker
AFTER INSERT ON generic_account
FOR EACH ROW
BEGIN
IF new.Account_Type = 'B' THEN
INSERT INTO Buisness_profile(Account_id) values (new.Account_id);
INSERT INTO Verification(account_id, created_at, decision_status) values (new.Account_id, NOW(), 'in review');
Insert into Reviews values((Select Account_Id from Account where Account_Type = 'A' order by RAND() Limit 1), (select Verification_id from Verification inner join BuisnessProfile using(Account_id) where Account_id = new.Account_id));
ElseIf new.Account_Type = 'D' THEN
INSERT into databroker_profile(Account_id, Access_status) values(new.Account_id, false);
END IF;
END;
//
DELIMITER ;

-- Attempt to cancel an appointment, do not allow if current time is after canel_window_min minutes before the start of the appointment
DELIMITER //
CREATE TRIGGER attemptCancelation
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
IF new.appt_status = 'cancled' and old.cancel_window_min<(SELECT TIMESTAMPDIFF(MINUTE, NOW(), old.startTime)) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Past cancelation window.';
END IF;
END;
//
DELIMITER ;

-- Making sure appointment made is with verified buisness and active service from that buisness
DELIMITER //
CREATE TRIGGER ValidBuisness
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
IF (Select decision_status from Verification inner join BuisnessProfile using(Account_id)
inner join service using(Account_id) inner join appointment using(service_id) where appt_id = new.appt_id) not like 'approved' and
(Select service_status from service inner join appointment using(service_id) where appt_id = new.appt_id) not like 'active' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Either service is inactive or buisness is not verified.';
END IF;
END;
//
DELIMITER ;

