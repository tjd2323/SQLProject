-- stored procedure for getting all appointments in given time frame for a buisness and insert report in table
-- still need to insert report
USE UABS;
DELIMITER //
CREATE PROCEDURE GetAppointmentsBuisness(IN Buisness_Id INT, IN startTime timestamp, IN endTime timestamp)
BEGIN
	DECLARE val int default 0;
    -- Validate input
    IF Buisness_Id not in (select Account_id from Buisness_profile) OR endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid buisness or start and end time';
    END IF;
	
    -- Get appointments scheduled in timeframe
    SELECT *
    FROM Appointment inner join Service using(service_id)
    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime
    ORDER BY Appointment.startTime ASC;
    set val = 
	(SELECT count(appt_id)
    FROM Appointment inner join Service using(service_id)
    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime);
    
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values
    (Buisness_Id, CONCAT('Total number of appointments in time frame: ', val), now(), startTime, endTime); 
END //
DELIMITER ;  -- Restore default delimiter
-- stored procedure to get total number of appointments in a given area (country, city) in a given timeframe across all buisnesses
DELIMITER //
CREATE PROCEDURE GetAppointments(IN country char(50), IN city char(50), IN startTime timestamp, IN endTime timestamp, OUT numAppt INT)
BEGIN
    -- Validate input
    IF endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'End time needs to be after start time';
    END IF;

    -- Get number of appointments scheduled in timeframe and location
    SELECT count(appt_id) into numAppt
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime;
END //

DELIMITER ;  -- Restore default delimiter

-- get total revenue for a buisness in a given time period
DELIMITER //
CREATE PROCEDURE GetRevenue(IN Buisness_Id INT, IN startTime timestamp, IN endTime timestamp, OUT mysum Double)
BEGIN
DECLARE sum Double DEFAULT 0;
DECLARE val Double DEFAULT 0;
DECLARE finished bool default false;
DECLARE myCursor CURSOR for
select price from Appointment inner join Service using(service_id)
 inner join Buisness_profile on(buisness_profile.account_id = service.account_id)
WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished= TRUE;
    -- Validate input
    IF Buisness_Id not in (select Account_id from Buisness_profile) OR endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid buisness or start and end time';
    END IF;

   Open myCursor;
   read_loop: LOOP
   FETCH NEXT FROM mycursor into val;
   IF finished THEN
   LEAVE read_loop;
   END IF;
   set sum = sum + val;
   END LOOP;
   close mycursor;
   set mysum = sum;
   end //
   DELIMITER ;