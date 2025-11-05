DROP TABLE IF EXISTS Buisness_Report;
DROP TABLE IF EXISTS Availability_Block;
DROP TABLE IF EXISTS Appointment_Has_Message;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Verification;
DROP TABLE IF EXISTS Reminder;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Service;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Buisness_Profile;
DROP TABLE IF EXISTS DataBroker_Profile;
DROP TABLE IF EXISTS Generic_Account;

  CREATE TABLE Generic_Account
  (Account_id int auto_increment,
   Account_type char(1) not null,
   full_name char(50) not null,
   address char(100) not null,
   city char(50) not null,
   country char(50) not null,
   email char(50) not null,
   phone char(15) not null,
   primary key (Account_id),
   constraint Account_Typing check (Account_type IN ('A', 'B', 'C', 'D')));
   
   CREATE TABLE Buisness_Profile
   (Account_id int,
    Buisness_desription varchar(1500),
   primary key (Account_id),
   foreign key (Account_id) references Generic_Account(Account_id) on delete cascade on update cascade);
   
   CREATE Table DataBroker_Profile
   (Account_id int,
    Access_status bool not null,
    Purpose varchar(1000),
    primary key(Account_id),
    foreign key(Account_id) references Generic_Account(Account_id) on delete cascade on update cascade);
   
   CREATE Table Message
   (message_id int auto_increment,
   sender int,
   receiver int,
   body varchar(10000),
   send_at timestamp,
   primary key(message_id),
   foreign key(sender) references Generic_Account(Account_id) on delete cascade on update cascade,
   foreign key(receiver) references Generic_Account(Account_id) on delete cascade on update cascade);
   
   CREATE Table Service
   (service_id int auto_increment,
   Account_id int,
   category char(200),
   full_Name char(200),
   duration_min int not null check (duration_min > 0),
   buffer_min int check (buffer_min > 0),
   service_status char(30),
   price double not null,
   service_description varchar(10000),
   primary key (service_id),
   foreign key(account_id) references Buisness_profile(account_id) on delete cascade on update cascade);
   
   Create table Appointment
   (appt_id int auto_increment,
   account_id int,
   service_id int,
   notes varchar(3000),
   appt_status char(100),
   no_show bool,
   startTime timestamp,
   endTime timestamp,
   cancel_window_min int check (cancel_window_min > 0),
   primary key (appt_id),
   foreign key(account_id) references generic_account(account_id) on delete cascade on update cascade,
   foreign key(service_id) references service(service_id) on delete cascade on update cascade);
   
   create table Reminder
   (reminder_num int check (reminder_num>0),
   appt_id int,
   delivery_status char(30) check (delivery_status in ('sent', 'waiting to send', 'received', 'not received')) default 'waiting to send',
   actual_send_time timestamp,
   planned_send_time timestamp,
   primary key(reminder_num, appt_id),
   foreign key(appt_id) references appointment(appt_id) on delete cascade on update cascade);
   
   create table Verification
   (ver_id int auto_increment,
   account_id int,
   created_at timestamp,
   decision_status char(30) check (decision_status in ('approved', 'denied', 'in review')) default 'in review',
   decision_time timestamp,
   reviewer_notes varchar(10000),
   primary key(ver_id),
   foreign key(account_id) references buisness_profile(account_id) on delete cascade on update cascade);
   
   create table Reviews
   (ver_id int,
   account_id int,
   primary key(ver_id, account_id),
   foreign key(ver_id) references verification(ver_id) on delete cascade on update cascade,
   foreign key(account_id) references generic_Account(account_id) on delete cascade on update cascade);
   
   create table Appointment_Has_Message
   (message_id int,
   appt_id int,
   primary key(message_id, appt_id),
   foreign key(message_id) references message(message_id) on delete cascade on update cascade,
   foreign key(appt_id) references appointment(appt_id) on delete cascade on update cascade);
   
   create table Availability_block
   (avail_id int auto_increment,
    account_id int,
    recurrence_rule varchar(300),
    start_time time not null,
    end_time time not null,
    primary key(avail_id),
    foreign key(account_id) references Buisness_profile(account_id) on delete cascade on update cascade);
    
    create table Buisness_Report
    (report_id int auto_increment,
    account_id int,
    metric_summary varchar(2000),
    generated_at timestamp,
    period_start timestamp,
    periood_end timestamp,
    primary key(report_id),
    foreign key(account_id) references Buisness_profile(account_id) on delete cascade on update cascade);
    