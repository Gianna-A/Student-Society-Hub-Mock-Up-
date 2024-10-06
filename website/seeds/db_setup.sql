DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table
 
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......

-- This is the hobby table definition and engages_in (associative entity) definition

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby (
    Hobby_No INT UNSIGNED NOT NULL,
    CHECK (1 <= Hobby_No <= 10),
    Hobby_Name   VARCHAR(255) NOT NULL,
    PRIMARY KEY (Hobby_No));

INSERT INTO Hobby VALUES
(1, 'Reading'),
(2, 'Hiking'),
(3, 'Chess'),
(4, 'Taichi'),
(5, 'Ballroom dancing'),
(6, 'Football'),
(7, 'Tennis'),
(8, 'Rugby'),
(9, 'Climbing'),
(10, 'Rowing');

DROP TABLE IF EXISTS Engages_In;

CREATE TABLE Engages_In (
    URN INT UNSIGNED NOT NULL,
    Hobby_No INT UNSIGNED NOT NULL,
    CHECK (1 <= Hobby_No <= 10),
    PRIMARY KEY (URN, Hobby_No),
    FOREIGN KEY (URN) REFERENCES Student(URN) ON DELETE CASCADE,
    FOREIGN KEY (Hobby_No) REFERENCES Hobby(Hobby_No) ON DELETE RESTRICT
);

INSERT INTO Engages_In VALUES
(612345, 1),
(612346, 2),
(612346, 5),
(612347, 3),
(612347, 2),
(612348, 4),
(612349, 5),
(612349, 6),
(612350, 7),
(612350, 1),
(612350, 8),
(612350, 5),
(612351, 8),
(612352, 9),
(612352, 4),
(612352, 6),
(612353, 10),
(612353, 3);
/*I have taken out student 612354 as they do not have hobbies
to solidify the many optional to many optional relationship between student and hobby*/

-- This is the Society table definition and joins table (associative entity) here

DROP TABLE IF EXISTS Society;

CREATE TABLE Society (
    Soc_ID INT UNSIGNED NOT NULL,
    Soc_Name VARCHAR(255) NOT NULL,
    Soc_Email  VARCHAR(255),
    Soc_Meeting_Time VARCHAR(5),
    Soc_Meeting_Day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    PRIMARY KEY (Soc_ID));

INSERT INTO Society VALUES
(01, 'Anime and Manga Society', 'ussu.anime@surrey.ac.uk', '18:00', 'Wednesday'),
(02, 'Theatre Society', 'ussu.theatresoc@surrey.ac.uk', '18:00', 'Wednesday'),
(03, 'Video Gaming Society', 'ussu.svgs@surrey.ac.uk', '18:00', 'Thursday'),
(04, 'Baseball & Softball', 'ussu.baseball@surrey.ac.uk', '18:45', 'Tuesday'),
(05, 'Baking Society', 'ussu.baking@surrey.ac.uk', '19:00', 'Thursday'),
(06, 'CompSoc Society', 'ussu.computing@surrey.ac.uk', '18:00', 'Thursday');


DROP TABLE IF EXISTS Joins;

CREATE TABLE Joins (
    URN INT UNSIGNED NOT NULL,
    Soc_ID INT UNSIGNED NOT NULL,
    CHECK (1 <= Soc_ID <= 6),
    PRIMARY KEY (URN, Soc_ID),
    FOREIGN KEY (URN) REFERENCES Student(URN) ON DELETE CASCADE,
    FOREIGN KEY (Soc_ID) REFERENCES Society(Soc_ID) ON DELETE RESTRICT
);

INSERT INTO Joins VALUES
(612345, 01),
(612345, 02),
(612346, 02),
(612345, 03),
(612347, 03),
(612347, 05),
(612347, 01),
(612347, 02),
(612348, 04),
(612349, 05),
(612349, 04),
(612349, 06),
(612350, 06),
(612350, 03),
(612350, 05),
(612351, 01),
(612351, 06),
(612351, 04),
(612353, 02),
(612353, 06),
(612354, 03);

/*student 612352 will not have any societies to further show the 
many optional to many optional relationship between student and society*/

-- The event table definition

DROP TABLE IF EXISTS Event;

CREATE TABLE Event (
    Event_ID INT UNSIGNED NOT NULL,
    Soc_ID INT UNSIGNED NOT NULL,
    Event_Name 	VARCHAR(255),
    Event_Date 	DATE,
    PRIMARY KEY (Event_ID),
    FOREIGN KEY (Soc_ID) REFERENCES Society (Soc_ID) ON DELETE CASCADE);

INSERT INTO Event VALUES
(301, 01, 'Karaoke Night', '2024-1-12'),
(302, 01, 'Bar Crawl', '2023-9-20'),
(303, 01, 'MCM Comicon London', '2024-05-24'),
(304, 02, 'Puppetry Session', '2023-11-1'),
(305, 02, 'Bar Crawl', '2023-09-30'),
(306, 02, 'Attempts on Her Life', '2023-10-3'),
(307, 03, 'Just Dance Tournament', '2023-12-1'),
(308, 03, 'League of Legends Tournament', '2023-11-19'),
(309, 05, 'Christmas Biscuit Decorating Night', '2023-12-9'),
(310, 05, 'Savoury Week', '2023-11-16'),
(311, 05, 'Bake Your Degree', '2023-11-7'),
(312, 06, 'Stem Night', '2023-11-18'),
(313, 06, 'Movie Night', '2023-10-26');

/*there are no events for baseball and softball to show the 
1 mandatory to many optional relationship between
society and event*/

-- This Committee_Member table definition 

DROP TABLE IF EXISTS Committee_Member;

CREATE TABLE Committee_Member (
    Committee_name VARCHAR(255) NOT NULL,
    Soc_ID INT UNSIGNED NOT NULL,
    Committee_Position VARCHAR(255) NOT NULL,
    PRIMARY KEY (Committee_name),
    FOREIGN KEY (Soc_ID) REFERENCES Society (Soc_ID) ON DELETE CASCADE);

INSERT INTO Committee_Member VALUES
('Holly Morrow', 01, 'President'),
('Abir Hussain', 01, 'Vice President'),
('Liam O’Driscoll', 01, 'Treasurer'),
('Shu Sadiq', 01, 'Social Media Secretary'),
('Luca Shawcross', 01, 'Events Secretary'),
('Tom Good', 02, 'President'),
('Katie Fraiser', 02, 'Vice President'),
('Freya Burgess', 02, 'Treasurer'),
('Rose Foster', 03, 'President'),
('Will Donaldson', 03, 'Vice President'),
('Saad Mazhar', 03, 'Treasurer'),
('Prithihan Yogarajah', 03, 'Esports Coordinator'),
('Angel Chatzaroulas', 03, 'Technical Coordinator'),
('Charlotte Roberts', 04, 'President'),
('Emilie Moucheron', 04, 'Vice President'),
('Harrison Pagett', 04, 'Treasurer'),
('Izzy', 05, 'President'),
('Maeve', 05, 'Vice Presdient'),
('Mitch', 05, 'Treasurer'),
('Alex Godwin', 06, 'Vice President'),
('Mia Tran', 06, 'President'),
('Rup Singh', 06, 'Treasurer');

/*the multivalued attribute table*/

DROP TABLE IF EXISTS Committee_Email;

CREATE TABLE Committee_Email (
    Committee_name VARCHAR(255) NOT NULL,
    committee_email VARCHAR(255) NOT NULL,
    PRIMARY KEY (Committee_name, committee_email),
    FOREIGN KEY (Committee_name) REFERENCES Committee_Member (Committee_name) ON DELETE CASCADE);

INSERT INTO Committee_Email VALUES
('Holly Morrow', 'hm00985@surrey.ac.uk'),
('Holly Morrow', 'hmorrow@gmail.com'),
('Abir Hussain', 'ah00623@surrey.ac.uk'),
('Liam O’Driscoll', 'lo00227@surrey.ac.uk'),
('Shu Sadiq', 'ss00119@surrey.ac.uk'),
('Luca Shawcross', 'ls00383@surrey.ac.uk'),
('Luca Shawcross', 'lshawcross@gmail.com'),
('Tom Good', 'tg00375@surrey.ac.uk'),
('Katie Fraiser', 'kf00998@surrey.ac.uk'),
('Freya Burgess', 'fb00397@surrey.ac.uk'),
('Rose Foster', 'rf00274@surrey.ac.uk'),
('Will Donaldson', 'wd00235@surrey.ac.uk'),
('Saad Mazhar', 'sm02510@surrey.ac.uk'),
('Prithihan Yogarajah', 'py00156@surrey.ac.uk'),
('Prithihan Yogarajah', 'pyogarajah@gmail.com'),
('Angel Chatzaroulas', 'e.chatzaroulas@surrey.ac.uk'),
('Charlotte Roberts', 'cr00234@surrey.ac.uk'),
('Charlotte Roberts', 'croberts@gmail.com'),
('Emilie Moucheron', 'em00238@surrey.ac.uk'),
('Harrison Pagett', 'hp00445@surrey.ac.uk'),
('Harrison Pagett', 'hpagett@gmail.com'),
('Izzy', 'im00273@surrey.ac.uk'),
('Maeve', 'ma00274@surrey.ac.uk'),
('Maeve', 'amaeve@gmail.com'),
('Mitch', 'mk00893@surrey.ac.uk'),
('Alex Godwin', 'ag00883@surrey.ac.uk'),
('Alex Godwin', 'agodwin@gmail.com'),
('Mia Tran', 'mt00278@surrey.ac.uk'),
('Rup Singh', 'rs00327@surrey.ac.uk'),
('Rup Singh', 'rsingh@gmail.com');


