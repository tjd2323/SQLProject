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
   phone char(30) not null,
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
    period_end timestamp,
    primary key(report_id),
    foreign key(account_id) references Buisness_profile(account_id) on delete cascade on update cascade);
    
    insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Tyler Dean', '4210 Rotal Manor Drive', 'Houston', 'USA', 'someEmail@yahoo.com', '123-456-7890');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Simone Ascher', '7115 Boondoggle Drive', 'Houston', 'USA', 'aSimon56@gmail.com', '713-895-8172');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Franklin Roosevelt', '5532 Vista Drive', 'Houston', 'USA', 'dFrankRoss@outlook.com', '832-581-7319');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Kat Anchovy', '6200 Glenn Dale St', 'Houston', 'USA', 'fishyCat@gmail.com', '231-559-7134');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Jack Black', '6220 AppleJack Circle', 'Houston', 'USA', 'thatOneGuy@sbcglobal.net', '264-252-9991');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Daniel Thorn', '7089 Woodvale St', 'Dallas', 'USA', 'DJThorn@gmail.com', '346-226-9801');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Dave Bean', '1566 Worm Drive', 'Dallas', 'USA', 'tjd@oul.com', '615-034-6821');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Ellie Dryer', '1615 Melon Str', 'Dallas', 'USA', 'lintel@live.com', '832-555-1561');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Max Williams', '9137 Strawberry Ln', 'Houston', 'USA', 'MaxWillie@gmail.com', '819-336-8134');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('C', 'Billy Nassar', '6355 Cherrydale Lane', 'Austin', 'USA', 'thebesCar@gmail.com', '115-879-3513');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Rodium Root', '1923 Pecan Street', 'London', 'UK', 'elementalRodie@yahoo.com', '+31 832-513-4931');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Julio Esparza', '7251 Canary Circle', 'Houston', 'USA', 'espJuly@gmail.com', '737-328-3568');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Mary Madenline', '6105 Hill Country St', 'Berlin', 'Germany', 'marMaddie@gmail.com', '+55 281-998-5351');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Allison Mcqown', '0351 Siren Drive', 'Houston', 'USA', 'Allie.m@icloud.com', '716-002-8732');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Nayley Torres', '7521 Holl Lane', 'Dallas', 'USA', 'ellieTorres@yahoo.com', '281-998-8187');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Daina Cruz', '2001 Aquifer Dr', 'Austin', 'USA', 'todiefor@gmail.com', '+90 135-649-8742');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Tulip Pan', '8372 Rose Hill Circle', 'Houston', 'USA', 'theNoodel@unemployed.com', '+84 336-814-9367');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Kate Delly', '6257 Morton Hill Dr', 'Houston', 'USA', 'ladyKaty@unemployed.com', '832-031-2418');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Isablla Ohera', '7732 Greenbriar Lane', 'San Antonio', 'USA', 'issaOhera@gmail.com', '891-367-4821');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('A', 'Sunny Saldivar', '7172 Cheezit Dr', 'San Antonio', 'USA', 'solSaldi@yahoo.com', '+886 865-123-4209');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Jack Daniels', '5333 Garland St', 'Houston', 'USA', 'whisky@JDaniels.com', '+44 098-765-4321');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Micro Wave co.', '8064 Telephone Road', 'Berlin', 'Germany', 'support@littleWave.com', '+33 420-678-6969');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Arrow Head inc.', '9500 Arizona St', 'Houston', 'USA', 'straightAhead@arrowHead.org', '1-800-27769');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Steel Supply mfg.', '1776 Hamilton Dr', 'Dallas', 'USA', 'flint@steelssupply.org', '1-800-7833548');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Allpoints LLC', '6767 Meme St', 'Dallas', 'USA', 'someBuisness@email.com', '717-23-4599');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Kitty Co.', '4200 Leaves Drive', 'Houton', 'USA', 'meow@kitty.co', '713-456-8732');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Fish & Chips', '6968 FeedMe ave', 'London', 'UK', 'crunch@fmp.org', '832-516-4324');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Lockheed Martin', '4210 Musician Lane', 'Houston', 'USA', 'biggerBuisness@aerospace.org', '281-889-7650');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Home Depot', '3344 abc Drive', 'Austin', 'USA', 'wood@homedepot.com', '647-998-1738');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Windex inc', '2020 MLK st', 'San Antonio', 'USA', 'getClean@windex.com', '713-667-0195');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Lowes', '7382 Finesse St', 'San Antonio', 'USA', 'moreWood@lowes.com', '281-835-7614');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Target', '5522 Blaze Dr', 'Austin', 'USA', 'superiorWalmart@weAreBetter.com', '713-449-7273');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('B', 'Walmart', '8733 Orchid Circle', 'Dallas', 'USA', 'NoYouAreNot@Lies.com', '281-283-2884');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Google', '7777 Electric Dr', 'Houston', 'USA', 'search@goo.gl', '441-987-6413');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Facebook', '3344 Aquifer Dr', 'Austin', 'USA', 'RussianSpies@watchingYou.org', '281-734-4513');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Yahoo', '7432 Murdle Dr', 'Houston', 'USA', 'yahoo@yahoo.com', '437-873-6981');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Insight Forge', '6733 Taco Dr', 'Dallas', 'USA', 'giveUsYourData@forge.com', '832-763-4512');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Data Catalyst', '4220 Goat St', 'Dallas', 'USA', 'catalyze@yourdata.com', '713-765-7519');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Analytics Sphere', '5514 Cheese Pizza Dr', 'Dallas', 'USA', 'cube@triangle.com', '832-734-9627');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Insight Next', '6251 Toshiba Dr', 'San Antonio', 'USA', 'blind@next.org', '346-923-1821');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Orcale', '4313 Chess St', 'Houston', 'USA', 'oracle@search.com', '832-223-2520');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Atom', '7667 Orchid Circle', 'Dallas', 'USA', 'Atom@yahoo.com', '713-235-2250');
	insert into Generic_Account(Account_type, full_name, address, city, country, email, phone)   values ('D', 'Swift Brokerage', '3244 Finale Dr', 'Austin', 'USA', 'swift@yahoo.com', '713-231-4229');
    
	insert into Buisness_profile values(21, 'Sells whisky and other drinks.');
    insert into Buisness_profile values(22, 'Sells Microwaves and other kitchen accessories.');
    insert into Buisness_profile values(23, 'Sells outdoor sports equipment.');
    insert into Buisness_profile values(24, 'Sells steel supplies.');
    insert into Buisness_profile values(25, 'Subcontracts to other space agencies.');
    insert into Buisness_profile values(26, 'Sells cat food and toys.');
    insert into Buisness_profile values(27, 'British pub themed resturant.');
    insert into Buisness_profile values(28, 'Works on federal space contracts.');
    insert into Buisness_profile values(29, 'Sells home improvement supplies.');
    insert into Buisness_profile values(30, 'Sells cleaning supplies.');
    insert into Buisness_profile values(31, 'Sells home imporvement supplies.');
    insert into Buisness_profile values(32, 'Supermarket for variety goods.');
    insert into Buisness_profile values(33, 'Supermarket for variety goods.');
    
    insert into databroker_profile values(34, True, 'Collects data related to tech industries.');
    insert into databroker_profile values(35, True, 'Collects data related to tech industries.');
    insert into databroker_profile values(36, True, 'Collects data from online queries.');
    insert into databroker_profile values(37, False, 'Collects data on hardware goods.');
    insert into databroker_profile values(38, True, 'Collects aggregate data on variety of goods.');
    insert into databroker_profile values(39, True, 'Collects aggregate data worldwide.');
    insert into databroker_profile values(40, True, 'Collects data for prediction making.');
    insert into databroker_profile values(41, True, 'Collects data for data banks.');
    insert into databroker_profile values(42, False, 'Collects data for a variety of goods.');
    insert into databroker_profile values(43, True, 'Collects financial product related data.');
    
    insert into message(sender, receiver, body, send_at) values(1, 22, 'What different brands are available?', '2023-09-15 10:30:00');
	insert into message(sender, receiver, body, send_at) values(22, 1, 'Models A, B, and C are available.', '2023-09-15 11:30:00');
    insert into message(sender, receiver, body, send_at) values(1, 22, 'What are the differences between model B and C?', '2023-09-15 13:00:00');
    insert into message(sender, receiver, body, send_at) values(28, 25, 'How many people do you currently have available for work?', '2023-10-15 10:30:00');
    insert into message(sender, receiver, body, send_at) values(18, 42, 'Please send in the activation payment to start collecting data.', '2022-09-15 10:30:00');
    insert into message(sender, receiver, body, send_at) values(19, 23, 'What is your current address? It appears the address of the company has moved recently.', '2024-03-03 10:30:00');
    insert into message(sender, receiver, body, send_at) values(3, 24, 'What different kinds of steel are available?', '2023-08-13 8:30:00');
    insert into message(sender, receiver, body, send_at) values(24, 3, 'We have both refined and crude steel available currently.', '2023-08-13 10:30:00');
    insert into message(sender, receiver, body, send_at) values(5, 25, 'Could I reschedule my appointment for a later date?', '2023-07-25 9:30:00');
    insert into message(sender, receiver, body, send_at) values(6, 26, 'When will the new cat toy be in?', '2023-06-15 14:30:00');
    insert into message(sender, receiver, body, send_at) values(26, 6, 'We are not expecting the new cat toy for about another month.', '2023-06-16 10:30:00');
    insert into message(sender, receiver, body, send_at) values(1, 27, 'Could I make a reservation at 6 PM?', '2023-09-20 8:30:00');
    insert into message(sender, receiver, body, send_at) values(27, 1, 'Sorry, we are first come first serve from 6 to 9.', '2023-09-15 16:30:00');
    insert into message(sender, receiver, body, send_at) values(1, 29, 'I am looking for some home renovation tools- what would you suggest I look at?', '2023-09-15 10:30:00');
    insert into message(sender, receiver, body, send_at) values(7, 21, 'When does the next shipment of drinks come in?', '2023-11-15 17:00:00');
    
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (21, 'Alcohol', 'Taste Testing', 60, 15, 'active', 30, 'Provides taste testing and advice on different kinds of whiskies. Great for party preperation.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (22, 'Appliances', 'Microwave selling and demonstrations', 30, 15, 'active', 20, 'Provides microwave purchasing advice on different microwave brands.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (24, 'Steel Produciton', 'Mass order negotiations for steel purchase', 120, 30, 'active', 500, 'Negotiation for mass steel purchases of different types and quantities to discuss details.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (27, 'Dine in food', 'Dining in at pub', 90, 15, 'active', 50, 'Resturant reservations at a fish and chips pub for larger parties.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (32, 'Eye Care', 'Eye Exams', 30, 30, 'active', 90, 'Provides eye exams.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (26, 'Pets', 'Cat Adoption', 120, 30, 'active', 300, 'Adopting a choosen cat and associated adoption paperwork and instructions.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (26, 'Pets', 'Cat Grooming', 90, 15, 'active', 70, 'Grooming for short hair cats.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (25, 'Employment Contracting', 'Subcontracting', 180, 30, 'inactive', 300, 'Negotiations for initial terms and conditions for subcontracts to other companies.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (31, 'Contruction', 'House renovation services', 90, 15, 'active', 150, 'Information and negotions on full price for different home improvement services.');
    insert into service(Account_id, category, full_Name, duration_min, buffer_min, service_status, price, service_description) values (33, 'Car Repair', 'Oil change', 45, 15, 'active', 75, 'Oil changing service (does not include oil price).');
    
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (1,  2, 'Purchasing a microwave for new hours',  'completed', false,  '2023-09-16 17:00:00', '2023-09-16 17:30:00', 60);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (3,  3, 'Negotiating steel product shipment',  'completed', false,  '2023-08-17 10:30:00', '2023-08-17 12:30:00', 600);
    insert into Appointment(account_id, service_id, notes, appt_status) values (6,  7, 'Purchasing a set of pet toys',  'canceled');
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (1,  4, 'Eating out at pub.',  'completed', false,  '2023-09-16 22:00:00', '2023-09-16 23:30:00', 30);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (5,  8, 'Hiring on new employees',  'completed', false,  '2023-07-25 9:30:00', '2023-07-25 12:30:00', 1200);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (2,  2, 'Wanting to get more information on different microwaves',  'completed', false,  '2023-10-16 12:00:00', '2023-10-16 12:30:00', 60);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (3,  5, 'Getting eye exam',  'no-show', true,  '2023-09-16 17:00:00', '2023-09-16 17:30:00', 60);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (6,  5, 'Getting eye exam',  'completed', false,  '2023-10-16 17:00:00', '2023-10-16 17:30:00', 60);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (10,  10, 'Getting oil change with synthetic oil',  'no-show', true,  '2023-06-16 12:00:00', '2023-06-16 12:45:00', 120);
    insert into Appointment(account_id, service_id, notes, appt_status, no_show, startTime, endTime, cancel_window_min) values (1,  7, 'Buying a cat',  'completed', false,  '2024-09-16 14:00:00', '2023-09-16 16:00:00', 1200);
    
    insert into Reminder values (1, 1, 'received', '2023-09-15 17:00:00', '2023-09-15 17:00:00');
    insert into Reminder values (2, 1, 'received', '2023-09-16 7:00:00', '2023-09-16 7:00:00');
    insert into Reminder values (3, 1, 'not received', '2023-09-16 16:00:00', '2023-09-16 16:00:00');
    insert into Reminder values (1, 2, 'received', '2023-08-16 10:30:00', '2023-08-16 10:45:00');
    insert into Reminder values (2, 2, 'received', '2023-08-17 9:30:00', '2023-08-17 9:30:00');
    insert into Reminder values (1, 4, 'received', '2023-09-16 21:00:00', '2023-09-16 21:00:00');
    insert into Reminder values (1, 6, 'received', '2023-10-15 12:00:00', '2023-10-15 12:00:00');
    insert into Reminder values (1, 8, 'received', '2023-09-15 17:00:00', '2023-09-15 17:00:00');
    insert into Reminder values (1, 10, 'received', '2023-10-16 15:00:00', '2023-10-16 15:15:00');
    insert into Reminder values (2, 10, 'received', '2024-09-16 13:00:00', '2024-09-16 13:00:00');
    
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (21, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (22, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (23, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (24, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (25, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (26, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (27, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (28, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (29, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (30, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (31, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (32, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    insert into Verification(account_id, created_at, decision_status, decision_time, reviewer_notes) values (33, '2020-09-15 17:00:00', 'approved',  '2023-09-16 17:00:00', '');
    
    insert into Reviews values (1, 21);
    insert into Reviews values (2, 22);
    insert into Reviews values (3, 23);
    insert into Reviews values (4, 24);
    insert into Reviews values (5, 25);
    insert into Reviews values (6, 26);
    insert into Reviews values (7, 27);
    insert into Reviews values (8, 28);
    insert into Reviews values (9, 29);
    insert into Reviews values (10, 30);
    insert into Reviews values (10, 31);
    insert into Reviews values (9, 32);
    insert into Reviews values (8, 33);
    
    insert into Appointment_has_message values(1, 1);
    insert into Appointment_has_message values(2, 1);
    insert into Appointment_has_message values(3, 1);
    insert into Appointment_has_message values(7, 3);
    insert into Appointment_has_message values(8, 3);
    insert into Appointment_has_message values(12, 4);
    insert into Appointment_has_message values(13, 4);
    insert into Appointment_has_message values(10, 3);
    insert into Appointment_has_message values(11, 3);
    insert into Appointment_has_message values(4, 5);
    
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (21, 'M-Su', '11:00:00', '23:59:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (22, 'M-F', '10:00:00', '22:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (23, 'M-TH', '11:00:00', '20:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (24, 'M-F', '11:00:00', '22:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (25, 'M-Su', '9:00:00', '17:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (26, 'M-Su', '9:00:00', '23:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (27, 'M-Su', '11:00:00', '17:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (28, 'M-F', '9:00:00', '17:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (29, 'M-Su', '10:00:00', '22:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (30, 'M-Sa', '10:00:00', '18:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (31, 'M-Su', '10:00:00', '22:00:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (32, 'M-Su', '8:00:00', '23:59:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (33, 'M-Su', '8:00:00', '23:59:00');
    insert into Availability_block(account_id, recurrence_rule, start_time, end_time) values (27, 'M-Su', '21:00:00', '23:59:00');
    
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (21, 'default report for Jack Daniels', '2023-09-15 17:00:00', '2023-08-15 17:00:00', '2023-09-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (22, 'default report for Micro Wave Co.', '2023-10-15 17:00:00', '2023-09-15 17:00:00', '2023-10-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (23, 'default report for Arrow Head Inc.', '2023-09-17 15:00:00', '2023-06-15 17:00:00', '2023-09-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (24, 'default report for Steel Supply mfg.', '2024-09-15 17:00:00', '2023-09-15 17:00:00', '2023-11-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (25, 'default report for AllPoints LLC.', '2024-06-15 5:00:00', '2022-09-15 17:00:00', '2023-09-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (26, 'default report for Kitty Co.', '2023-06-15 12:00:00', '2022-09-15 17:00:00', '2023-03-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (27, 'default report for Fish & Chips.', '2023-09-15 17:00:00', '2023-08-15 12:00:00', '2023-09-15 12:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (28, 'default report for Lockheed Martin.', '2023-09-15 17:00:00', '2023-08-15 17:00:00', '2023-09-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (29, 'default report for Home Depot.', '2023-09-15 17:00:00', '2023-08-15 17:00:00', '2023-09-15 17:00:00');
    insert into Buisness_Report(account_id, metric_summary, generated_at, period_start, period_end) values (30, 'default report for Windex.', '2023-09-15 20:00:00', '2023-06-15 17:00:00', '2023-09-15 17:00:00');
    
    