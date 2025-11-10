-- stored procedure for getting all appointments in given time frame for a buisness and insert report in table
DELIMITER //
CREATE PROCEDURE GetAppointmentsBuisness(IN Buisness_Id INT, IN startTime timestamp, IN endTime timestamp)
BEGIN
    -- Validate input
    IF BuisnessId not in (select Account_id from Buisness_profile) OR endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid buisness or start and end time';
    END IF;

    -- Get appointments scheduled in timeframe
    SELECT *
    FROM Appointments inner join Service using(service_id)
    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime
    ORDER BY Appointment.startTime ASC;
    
    -- create buisness_report
    insert into Buisness_report(account_id, metric_summary, generated_at, period_start, period_end) values (Buisness_Id, 'Num appointments in time frame: ' +
    cast( (SELECT count(appt_id)
    FROM Appointments inner join Service using(service_id)
    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime)
    as char(10)), NOW(), startTime, endTime);
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
    FROM Appointments inner join Service using(service_id) inner join BuisnessProfile on (service.account_id = BuisnessProfile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime;
END //

DELIMITER ;  -- Restore default delimiter