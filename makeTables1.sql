DROP TABLE IF EXISTS enrolled;
DROP TABLE IF EXISTS teaches;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS truck;
DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS ownerd;
DROP TABLE IF EXISTS vehicle;

create table Student
(snum int check (snum > 0),
 sname char(30) Not null,
 major char(30),
 level char(30),
 age int check (age>0),
 primary key (snum));
 
 Create table Class
 (cname char(30),
  sectionId int check (sectionId>0),
  meets_at time,
  room char(30),
  Primary key (cname, sectionId));
  
  CREATE TABLE Faculty
  (fid int check (fid>0),
   fname char(30) not null,
   deptid int check (deptid>0),
   primary key (fid));
   
   create table Enrolled
   (snum int,
    cname char(30),
    primary key (snum, cname),
    foreign key (snum) references student(snum) on delete cascade on update cascade,
    foreign key (cname) references class(cname) on delete cascade on update cascade);
  
  Create table Teaches
  (fid int,
   cname char(30),
   sectionId int,
   primary key (fid, cname, sectionId),
   foreign key (fid) references Faculty(fid) on delete cascade on update cascade,
   foreign key (cname, sectionId) references class(cname, sectionId) on delete cascade on update cascade);
   
  Insert into student Values (1, 'Bob', 'Science', 'freshman', 20);
  Insert into student Values (2, 'Jerry', 'Math', 'freshman', 20);
  Insert into student Values (3, 'Alyssa', 'Computer Science', 'sophmore', 21);
  Insert into student Values (5, 'Tyler', 'Science', 'freshman', 22);
  Insert into student Values (6, 'Jordan', 'Science', 'junior', 22);
  Insert into student Values (7, 'Ana', 'Math', 'junior', 25);
  Insert into student Values (8, 'Hasan Khondker', 'Computer Science', 'junior', 25);
  Insert into student Values (9, 'Milton', 'Physics', 'sophmore', 28);
  Insert into student Values (10, 'Lukas', 'Physics', 'senior', 30);
  Insert into student Values (11, 'Kara', 'Chemistry', 'freshman', 20);
  
  INSERT INTO class VALUES ('Database Systems', 1, '14:30:00', 'R128');
  INSERT INTO class VALUES ('Database Systems', 2, '16:00:00', 'R128');
  INSERT INTO class VALUES ('Database Systems', 3, '18:30:00', 'R202');
  INSERT INTO class VALUES ('Operating System Design', 1, '14:30:00', 'R128');
  INSERT INTO class VALUES ('Operating System Design', 2, '10:30:00', 'R203');
  INSERT INTO class VALUES ('Concurrent Programming', 1, '14:30:00', 'R201');
  INSERT INTO class VALUES ('Database Admin', 1, '9:30:00', 'R202');
  INSERT INTO class VALUES ('Database Admin', 2, '10:00:00', 'R201');
  INSERT INTO class VALUES ('Research Methods', 1, '10:30:00', 'R128');
  INSERT INTO class VALUES ('Research Methods', 2, '14:30:00', 'R202');
  
  INSERT INTO Faculty VALUES (1, 'Ivana Hush', 1);
  INSERT INTO Faculty VALUES (2, 'James Brooks', 1);
  INSERT INTO Faculty VALUES (4, 'James Brookly', 2);
  INSERT INTO Faculty VALUES (6, 'Kara Franze', 3);
  INSERT INTO Faculty VALUES (7, 'Jared Franze', 3);
  INSERT INTO Faculty VALUES (13, 'Vincent Grimm', 3);
  INSERT INTO Faculty VALUES (9, 'Tyler Dean', 4);
  INSERT INTO Faculty VALUES (10, 'Steve Grimm', 4);
  INSERT INTO Faculty VALUES (11, 'Babe Ruth', 4);
  INSERT INTO Faculty VALUES (12, 'Lukas James', 3);
  
  INSERT INTO Enrolled VALUES (1, 'Database Systems');
  INSERT INTO Enrolled VALUES (1, 'Operating System Design');
  INSERT INTO Enrolled VALUES (2, 'Database Systems');
  INSERT INTO Enrolled VALUES (3, 'Operating System Design');
  INSERT INTO Enrolled VALUES (5, 'Database Systems');
  INSERT INTO Enrolled VALUES (5, 'Operating System Design');
  INSERT INTO Enrolled VALUES (8, 'Database Systems');
  INSERT INTO Enrolled VALUES (8, 'Research Methods');
  INSERT INTO Enrolled VALUES (5, 'Concurrent Programming');
  INSERT INTO Enrolled VALUES (5, 'Database Admin');

  INSERT INTO Teaches VALUES (1, 'Database Systems', 1);
  INSERT INTO Teaches VALUES (1, 'Operating System Design', 2);
  INSERT INTO Teaches VALUES (6, 'Research Methods', 1);
  INSERT INTO Teaches Values (2, 'Research Methods', 2);
  INSERT INTO Teaches Values (2, 'Database Admin', 2);
  INSERT INTO Teaches VALUES (6, 'Database Admin', 1);
  INSERT INTO Teaches VALUES (4, 'Database Systems', 2);
  INSERT INTO Teaches VALUES (7, 'Concurrent Programming', 1);
  INSERT INTO Teaches VALUES (13, 'Database Systems', 3);
  INSERT INTO Teaches VALUES (1, 'Database Systems', 2);
  
  
create table Ownerd
(oid int check (oid > 0),
 oname char(30),
 street char(30),
 city char(30),
 primary key (oid));
 
 Create table vehicle
 (vid int check (vid>0),
  LicensePlateNumber char(7),
  Primary key (vid));
  
  CREATE TABLE owns
  (oid int,
   vid int,
   purchaseDate date,
   primary key (oid, vid),
   foreign key (oid) references ownerd(oid) on delete cascade on update cascade,
   foreign key (vid) references vehicle(vid) on delete cascade on update cascade);
   
create table truck
   (vid int,
    TModel char(30),
    TMake char(30),
    TYear int,
    primary key(vid),
    foreign key (vid) references vehicle(vid) on delete cascade on update cascade);
    
 create table car
   (vid int,
    Cstyle char(30),
    CModel char(30),
    CMake char(30) check (CMake in ('Apple', 'Tesla', 'Maserati', 'Hummer')),
    CYear int,
    primary key(vid),
    foreign key (vid) references vehicle(vid) on delete cascade on update cascade);
  

CREATE INDEX idx_contacts_email ON Vehicle(licensePlateNumber);
delimiter //
CREATE TRIGGER deletesOwn
AFTER DELETE
ON ownerd
FOR EACH ROW
BEGIN
    DELETE FROM Vehicle where VID in 
    (Select Vehicle.VID as tVID from Vehicle inner join Owns using(VID)
    where Owns.OID = old.OID);
    DELETE FROM Owns where Owns.OID = old.OID;
END;
//
delimiter ;  

delimiter //
CREATE TRIGGER deletesOwn
AFTER UPDATE OR DELETE
ON Vehicle
FOR EACH ROW
BEGIN
    DELETE FROM Vehicle where VID in 
    (Select Vehicle.VID as tVID from Vehicle inner join Owns using(VID)
    where Owns.OID = old.OID);
    DELETE FROM Owns where Owns.OID = old.OID;
END;
//
delimiter ;  
INSERT INTO Ownerd values (1, 'Tyler', 'Center Street', 'Deer Park');
INSERT INTO Ownerd values (2, 'Emily', 'main street', 'Houston');
INSERT INTO Ownerd values (3, 'Kara', 'Guadelupe Street', 'Austin');
INSERT INTO Ownerd values (4, 'Chance', 'Spencer street', 'Lufkin');
INSERT INTO Ownerd values (5, 'Ana', 'Fairmont', 'Deer Park');
INSERT INTO Ownerd values (6, 'Tia', 'Center Street', 'Deer Park');
INSERT INTO Ownerd values (7, 'Casey', '21st street', 'Austin');
INSERT INTO Ownerd values (8, 'Lori', '4th street', 'Dallas');
INSERT INTO Ownerd values (9, 'Milton', '6th street', 'Dallas');
INSERT INTO Ownerd values (10, 'Lukas', 'main street', 'Dallas');

INSERT INTO Vehicle values (1, 'abc1234');
INSERT INTO Vehicle values (2, 'def2345');
INSERT INTO Vehicle values (3, 'wat6942');
INSERT INTO Vehicle values (4, 'yes4201');
INSERT INTO Vehicle values (5, 'not0928');
INSERT INTO Vehicle values (6, 'llw6687');
INSERT INTO Vehicle values (7, 'fhl4227');
INSERT INTO Vehicle values (8, 'pww6790');
INSERT INTO Vehicle values (9, 'jdw6069');
INSERT INTO Vehicle values (10, 'qqr1235');

INSERT INTO Vehicle values (11, 'qqq1234');
INSERT INTO Vehicle values (12, 'www2345');
INSERT INTO Vehicle values (13, 'eee6942');
INSERT INTO Vehicle values (14, 'rrr4201');
INSERT INTO Vehicle values (15, 'ttt0928');
INSERT INTO Vehicle values (16, 'yyy6687');
INSERT INTO Vehicle values (17, 'uuu4227');
INSERT INTO Vehicle values (18, 'iii6790');
INSERT INTO Vehicle values (19, 'ooo6069');
INSERT INTO Vehicle values (20, 'ppp1235');

INSERT INTO Owns values (1, 1, '2017-08-26');
INSERT INTO Owns values (1, 3, '2017-06-16');
INSERT INTO Owns values (1, 5, '2012-08-26');
INSERT INTO Owns values (2, 7, '2017-08-26');
INSERT INTO Owns values (2, 9, '2019-01-25');
INSERT INTO Owns values (3, 11, '2020-10-08');
INSERT INTO Owns values (1, 13, '2010-09-05');
INSERT INTO Owns values (1, 15, '2015-08-04');
INSERT INTO Owns values (4, 17, '2013-03-23');
INSERT INTO Owns values (4, 19, '2015-02-26');

INSERT INTO car values (1, 'SE', 'Camry', 'Apple', 2020);
INSERT INTO car values (2, 'LE', 'Camry', 'Apple', 2019);
INSERT INTO car values (3, 'SE', 'Sedan', 'Apple', 2020);
INSERT INTO car values (4, 'LE', 'Sedan', 'Tesla', 2021);
INSERT INTO car values (5, 'XSE', 'Sedan', 'Tesla', 2022);
INSERT INTO car values (6, 'SE', 'SUV', 'Maserati', 2021);
INSERT INTO car values (7, 'XLE', 'SUV', 'Maserati', 2019);
INSERT INTO car values (8, 'LE', 'convertable', 'Maserati', 2018);
INSERT INTO car values (9, 'XSE', 'MUV', 'Maserati', 2020);
INSERT INTO car values (10, 'SE', 'MUV', 'Hummer', 2018);

INSERT into truck values (11, 'Apple', 'Box truck', 2018);
INSERT into truck values (12, 'Apple', 'Box truck', 2018);
INSERT into truck values (13, 'Toyota', 'Cybertruck', 2019);
INSERT into truck values (14, 'Toyota', 'Pickup', 2019);
INSERT into truck values (15, 'Tesla', 'Cybertruck', 2019);
INSERT into truck values (16, 'Tesla', 'Cybertruck', 2020);
INSERT into truck values (17, 'Tesla', 'Box Truck', 2021);
INSERT into truck values (18, 'Hummer', 'Light Truck', 2021);
INSERT into truck values (19, 'Hummer', 'Light Truck', 2023);
INSERT into truck values (20, 'Hummer', 'Cybertruck', 2024);

