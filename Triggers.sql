USE UABS;
-- Inserting Databroker or buisness accounts and verifications into correct tables when 
-- a buisness account or databroker account made
DELIMITER //
CREATE TRIGGER after_Buisness_or_Databroker
AFTER INSERT ON generic_account
FOR EACH ROW
BEGIN
IF new.Account_Type = 'B' THEN
INSERT INTO Buisness_profile(Account_id) values (new.Account_id);
INSERT INTO Verification(account_id, created_at, decision_status) values (new.Account_id, NOW(), 'in review');
Insert into Reviews values((select Ver_id from Verification inner join Buisness_Profile using(Account_id)
where Buisness_profile.Account_id = new.Account_id),
(Select Account_Id from Generic_Account where Account_Type = 'A' order by RAND() Limit 1));
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
IF new.appt_status = 'canceled' and old.cancel_window_min>(TIMESTAMPDIFF(MINUTE, NOW(), old.startTime)) THEN
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
IF (Select decision_status from Verification inner join Buisness_Profile using(Account_id)
inner join service using(Account_id) where service_id = new.service_id) not like 'approved' or
(Select service_status from service where service_id = new.service_id) not like 'active'
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Either service is inactive or buisness is not verified.';
END IF;
END;
//
DELIMITER ;


