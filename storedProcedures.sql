-- stored procedure for getting all appointments in given time frame for a buisness and insert report in table
-- still need to insert report
USE UABS;

DELIMITER //
-- call to insert account
CREATE PROCEDURE InsertAccount(IN accountType2 char(1), IN fullName2 char(50), IN email2 char(50), IN phone2 char(30), IN pass2 char(30), In address2 char(100), In city2 char(50), in country2 char(50), in descript2 varchar(1500))
BEGIN
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone, pass)   values (accountType2, fullName2, address2, city2, country2, email2, phone2, pass2);
    IF accountType2 = 'B' THEN
		update Buisness_profile
		set Buisnesss_description = descript2
		where (Select email from Generic_Account inner join buisness_profile using (Account_id)) = email2;
	ElseIf accountType = 'D' THEN
		update databroker_Profile
		set purpose = descript2
		where (Select email from Generic_Account inner join databroker_profile using (Account_id)) = email2;
    END IF;
END //

-- call to verify login
CREATE PROCEDURE verifyLogin(IN email2 char(50), IN pass2 char(30), IN accountType2 char(1), out verif2 int)
BEGIN
	DECLARE verif2 int DEFAULT 0;
    If EXISTS(SELECT email, pass, Account_type from generic_Account where (email like email2 and pass like pass2 and account_type like accountType2)) THEN
		set verif2 = 1;
	END IF;
END //
-- set of functions for user dashboard load
-- call to get user info
CREATE PROCEDURE displayUserInfo(IN email2 char(50))
BEGIN
	SELECT full_name, phone, country, email, city from generic_account where email like email2;
END //
-- call to get all services
CREATE PROCEDURE displayServicesUser()
BEGIN
 SELECT generic_account.full_name as buisness_name, service.full_name as service_name, price, duration_min, service_status
    from service inner join Buisness_profile using(account_id) inner join generic_account using(account_id);
END //
-- call to get all appointments for user with email
CREATE PROCEDURE displayAppointmentsUser(IN email2 char(50))
BEGIN
	WITH t1 as (SELECT service.account_id as myaccount_id, startTime, service.full_name as service_name, appt_status from appointment inner join generic_account using(account_id) inner join service using(service_id) where email like email2)
    SELECT startTime, generic_account.full_name as buisness_name, service_name, appt_status
    from t1 inner join buisness_profile on(t1.myaccount_id = buisness_profile.account_id) inner join generic_account on(buisness_profile.account_id = generic_account.account_id);
END //
-- call to get all user messages
CREATE PROCEDURE displayMessages(IN email2 char(50))
BEGIN
	WITH t1 as (SELECT email, generic_account.full_name as sender, generic_account.account_id as account_id from generic_account)
    SELECT send_at, sender, generic_account.full_name as receiver, subjectName
    from message inner join generic_account on(message.receiver = generic_account.account_id) inner join t1 on(t1.account_id = sender)
    where t1.email like email2 or generic_account.email like email2;
END //
-- call to create booking
CREATE PROCEDURE createBooking(IN email2 char(50), IN Buisness char(50), IN serviceN char(200), IN mystartTime timestamp, in mynote varchar(3000))
BEGIN

	DECLARE myId int default 0;
    DECLARE myservice_id int default 0;
    DECLARE myCancel int default 0;
    DECLARE myendTime timestamp;
    set myID = (SELECT account_id from generic_Account where email like email2);
    set myservice_id = (SELECT service_id from service inner join buisness_profile using(account_id) inner join generic_account using(account_id)
    where Buisness like generic_account.full_name and serviceN like service.Full_Name);
    set myCancel = (SELECT buffer_min from service where service_id = myservice_id);
    set myendTime = DATE_ADD(mystartTime, INTERVAL (SELECT duration_min from service where service_id = myservice_id) MINUTE);
	insert into appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window) values (myId, myservice_id, mynote, 'scheduled', false, mystartTime, myendTime, myCancel);
    end //
	
    -- call to reschedule booking
    CREATE PROCEDURE rescheduleBooking(IN email2 char(50), IN Buisness char(50), IN serviceN char(200), IN curstartTime timestamp, IN wantstartTime timestamp)
	BEGIN
	DECLARE myId int default 0;
    DECLARE myservice_id int default 0;
    DECLARE myCancel int default 0;
    DECLARE myendTime timestamp;
    
    set myID = (SELECT account_id from generic_Account where email like email2);
    set myservice_id = (SELECT service_id from service inner join buisness_profile using(account_id) inner join generic_account using(account_id)
    where Buisness like generic_account.full_name and serviceN like service.Full_Name);
    set myCancel = (SELECT cancel_window_min from appointment where account_id = myID and myservice_id = service_id and startTime = curstartTime);
	if myCancel<(TIMESTAMPDIFF(MINUTE, NOW(), curstartTime)) then
		update appointment
		set startTime = wantStartTime, endTime = DATE_ADD(wantstartTime, INTERVAL (SELECT duration_min from service where service_id = myservice_id) MINUTE)
		where account_id = myID and myservice_id = service_id and startTime = curstartTime;
	else
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Select a time when the buisness is open';
	end if;
    end //
    -- call to cancel booking
    CREATE PROCEDURE CancelBookingRequest(IN email2 char(50), IN Buisness char(50), IN serviceN char(200), IN curstartTime timestamp)
    BEGIN
    DECLARE myId int default 0;
    DECLARE myservice_id int default 0;
    DECLARE myCancel int default 0;
    
    set myID = (SELECT account_id from generic_Account where email like email2);
    set myservice_id = (SELECT service_id from service inner join buisness_profile using(account_id) inner join generic_account using(account_id)
    where Buisness like generic_account.full_name and serviceN like service.Full_Name);
    set myCancel = (SELECT cancel_window_min from appointment where account_id = myID and myservice_id = service_id and startTime = curstartTime);
    if myCancel<(TIMESTAMPDIFF(MINUTE, NOW(), curstartTime)) then
    insert into message(sender, receiver, body, send_at) values (myID, (select account_id from service inner join buisness_profile using(account_id)), 'Requesting cancelation of appointment', now());
    insert into appointment_has_message values((select max(message_id) from message), (SELECT appt_id from appointment where account_id = myID and myservice_id = service_id and startTime = curstartTime));
    else
    		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Too late to cancel appointemnt.';
	end if;
    end//

-- call to get appointments in scheduled time frame (buisness report)
CREATE PROCEDURE GetAppointmentsBuisness(IN email2 varchar(50), IN startTime timestamp, IN endTime timestamp, out val int)
BEGIN
	DECLARE Buisness_Id int default 0;
	DECLARE val int default 0;
    -- Validate input
    set Buisness_Id = (SELECT account_id from generic_Account where email like email2);
    IF Buisness_Id not in (select Account_id from Buisness_profile) OR endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid buisness or start and end time';
    END IF;
	
    -- Get appointments scheduled in timeframe
--    SELECT *
--    FROM Appointment inner join Service using(service_id)
--    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime
--    ORDER BY Appointment.startTime ASC;
    set val = 
	(SELECT count(appt_id)
    FROM Appointment inner join Service using(service_id)
    WHERE Buisness_Id = service.account_id and Appointment.startTime > startTime and Appointment.startTime < endTime);
    
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values
    (Buisness_Id, CONCAT('Total number of appointments in time frame: ', val), now(), startTime, endTime); 
END //

-- stored procedure to get total number of appointments in a given area (country, city) in a given timeframe across all buisnesses
-- need to modify to work on a service type and services
CREATE PROCEDURE GetAppointments(IN myCat char(200), IN country char(50), IN city char(50), IN startTime timestamp, IN endTime timestamp, out numappt int, out numCompleted int, out numCanceled int, out numNoShow int)
BEGIN
    -- Validate input
    IF endTime <= startTime THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'End time needs to be after start time';
	ELSEIF country IS NULL OR TRIM(country) = '' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Country is required';
	ELSEIF myCat IS NULL OR TRIM(myCat) = '' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'category is required';
    END IF;
	if city IS NULL OR TRIM(city) = '' THEN
    SELECT count(appt_id) into numAppt
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status not like 'scheduled';
	SELECT count(appt_id) into numCompleted
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'completed';
	SELECT count(appt_id) into numCanceled
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'canceled';
	SELECT count(appt_id) into numNoShow
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'no-show';
    else
	-- Get number of appointments scheduled in timeframe and location
    SELECT count(appt_id) into numAppt
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status not like 'scheduled';
	SELECT count(appt_id) into numCompleted
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'completed';
    SELECT count(appt_id) into numCanceled
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'canceled';
    SELECT count(appt_id) into numNoShow
    FROM Appointment inner join Service using(service_id) inner join Buisness_Profile on (service.account_id = Buisness_Profile.Account_id) inner join Generic_Account on (buisness_profile.account_id = Generic_account.account_id)
    WHERE Generic_Account.country like country and Generic_Account.city like city and Appointment.startTime > startTime and Appointment.startTime < endTime and category like myCat and appt_status like 'no-show';
    
    end if;
END //

-- get total revenue for a buisness in a given time period

CREATE PROCEDURE GetRevenue(IN email2 char(50), IN startTime timestamp, IN endTime timestamp, OUT mysum Double)
BEGIN
DECLARE sum Double DEFAULT 0;
DECLARE val Double DEFAULT 0;
DECLARE finished bool default false;
DECLARE Buisness_Id int default (SELECT account_id from generic_Account where email like email2);
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

   -- send message to a different user
   CREATE PROCEDURE sendMessages(IN email2 char(50), IN email3 char(50), IN mybody varchar(10000), IN sub varchar(100))
   BEGIN
   if EXISTS(select email from generic_account where email = email3) Then
   insert into message(sender, receiver, body, send_at, subjectName) values((select account_id from generic_account where email2 like email), (select accout_id from generic_account where email3 like email), mybody, now(), sub);
   else
           SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Account with that email does not exist.';
	end if;
   END//
   -- group of procedures for buisness dashboard
   -- display buisness info
   CREATE PROCEDURE displayBuisnessInfo(IN email2 char(50))
BEGIN
	SELECT full_name, email, address, city, country, Buisness_description from generic_account inner join buisness_profile using(account_id) where email like email2;
END //
	-- display current buisness services
	CREATE PROCEDURE displayServices(IN email2 char(50))
BEGIN
	SELECT service.full_name as serviceName, category, price, duration_min, service_status from service inner join Buinsness_Profile using(account_id) inner join generic_account using(account_id)
    where email like email2;
END //
	-- display current appoitnments for buisness
	Create procedure displayAppointments(IN email2 char(50))
BEGIN
	WITH t1 as (SELECT generic_account.full_name as myName, service.account_id as myaccount_id, startTime, service.full_name as service_name, appt_status from appointment inner join generic_account using(account_id) inner join service using(service_id))
    SELECT startTime, t1.myName as Customer_name, service_name, appt_status
    from t1 inner join buisness_profile on(t1.myaccount_id = buisness_profile.account_id) inner join generic_account on(buisness_profile.account_id = generic_account.account_id)
    where generic_account.email like email2;
END //
-- get buisness avail;ability
create procedure displayAvailability(IN email2 char(50))
BEGIN
	SELECT recurrence_rule, start_time, end_time from availability_block inner join Buisness_profile using(account_id) inner join generic_account using(account_id)
    where email like email2;
END //
-- to add a service
create procedure addService(IN email2 char(50), IN Service_name char(200), IN myCat char(200), IN myPrice double, in dur int, in stat char(30), in descript varchar(10000))
BEGIN
	if dur<=0 or price<=0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Either price or duration is less than or equal to 0.';
	else
		insert into service(account_id, category, full_name, duration_min, buffer_min, service_status, price, service_description) 
        values ((Select account_id from generic_account where email like email2), myCat, Service_name, dur, 60, stat, myPrice, descript); 
    end if;
END //
-- to edit a service
create procedure editService(IN email2 char(50), IN oldService_name char(200), IN newService_name char(200), IN myCat char(200), IN myPrice double, in dur int, in stat char(30), in descript varchar(10000))
	Begin
    if dur<=0 or price<=0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Either price or duration is less than or equal to 0.';
	else
		update service
        set category = myCat,
        full_name = newServiceName,
        duration_min = dur,
        service_status = stat,
        price = myPrice,
        service_description = descript
        where service_id = (Select service_id from service inner join buisness_Profile using(account_id) inner join generic_account using(account_id) where email like email2 and oldService_name like service.full_Name);
    end if;
    END //
    
    -- to deactivate a service
    create procedure deactivate(IN email2 char(50), in service_name char(200))
    begin
    update service
    set service_status = 'inactive'
    where service_id = (Select service_id from service inner join buisness_Profile using(account_id) inner join generic_account using(account_id) where email like email2 and oldService_name like service.full_Name);
    end //
	-- to activate service
    create procedure activate(IN email2 char(50), in service_name char(200))
    begin
    update service
    set service_status = 'active'
    where service_id = (Select service_id from service inner join buisness_Profile using(account_id) inner join generic_account using(account_id) where email like email2 and oldService_name like service.full_Name);
    end //
   -- to mark an appointment complete
   create procedure markComplete(in custName char(50), in serviceName char(200), in apptTime timestamp)
   BEGIN
   if now() < apptTime Then
   		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Time for appointment has not passed yet';
	else
		update appointment
        set appt_status = 'completed'
        where appt_id = (select appt_id from appointment inner join generic_account using(account_id) inner join service using(service_id) where generic_account.full_name like custName and apptTime = startTime and service.full_name like serviceName);
        end if;
	end //
    -- to mark an appointment missed
   create procedure markMissed(in custName char(50), in serviceName char(200), in apptTime timestamp)
   BEGIN
   if now() < apptTime Then
   		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Time for appointment has not passed yet';
	else
		update appointment
        set appt_status = 'no-show',
        no_show = true
        where appt_id = (select appt_id from appointment inner join generic_account using(account_id) inner join service using(service_id) where generic_account.full_name like custName and apptTime = startTime and service.full_name like serviceName);
        end if;
	end //
        -- to mark an appointment missed
   create procedure markCanceled(IN email2 char(50), in custName char(50), in serviceName char(200), in apptTime timestamp)
   BEGIN
		insert into message(sender, receiver, body, send_at, subjectName) values ((select account_id from generic_account where email like email2),
        (select distinct account_id from appointment inner join generic_account using(account_id) inner join service using(service_id) where generic_account.full_name like custName and apptTime = startTime and service.full_name like serviceName),
        CONCAT('The appointment at ', (select full_name from generic_account where email like email2), ' for ', CAST(apptTime as char), ' has been canceled.'),
        now(), 'appointment cancelation');
        insert into appointment_has_message values ((select max(message_id) from message),  (select appt_id from appointment inner join generic_account using(account_id) inner join service using(service_id) where generic_account.full_name like custName and apptTime = startTime and service.full_name like serviceName));
		update appointment
        set appt_status = 'canceled'
        where appt_id = (select appt_id from appointment inner join generic_account using(account_id) inner join service using(service_id) where generic_account.full_name like custName and apptTime = startTime and service.full_name like serviceName);
        
	end //
   -- add availability block to a buisness
   create procedure addAvailability(in email2 char(50), in recur varchar(300), in startt time, in endt time)
   begin
   insert into availability_block(account_id, recurrence_rule, start_time, end_time) values
   ((select account_id from generic_account where email like email2), recur, startt, endt);
   end //
   -- delete an availability block for a buisness
   create procedure deleteAvailability(in email2 char(50), in recur varchar(300), in startt time, in endt time)
   begin
   delete from availability_block
   where account_id = (select account_id from generic_account where email like email2)
   and recur like recurrence_rule
   and startt = start_time
   and endt = end_time;
   end //
   -- edit availability block for a buisness
   create procedure changeAvailability(in email2 char(50), in oldrecur varchar(300), in newrecur varchar(300), in oldstartt time, in newstartt time, in oldendt time, in newendt time)
   begin
   update availability_block
   set recurrence_rule = newrecur,
   start_time = newstartt,
   end_time = newendt
   where
   account_id = (select account_id from generic_account where email like email2)
   and recur like recurrence_rule
   and startt = start_time
   and endt = edn_time;
   end //
   -- group of procedures for data broker page
   -- display data broker info
   create procedure displayBrokerInfo(in email2 char(50))
   begin
   SELECT full_name, phone, country, email, city, purpose, access_status from generic_account inner join databroker_profile using(account_id) where email like email2;
   end //
DELIMITER ;
