CREATE SCHEMA dreamhome
    AUTHORIZATION postgres;
COMMENT ON SCHEMA dreamhome
    IS 'Dream Home schema used in the lecture slides and lecture notes.';
GRANT USAGE ON SCHEMA dreamhome TO postgres;
GRANT ALL ON SCHEMA dreamhome TO postgres;

-- Dropping existing tables if they exist

DROP TABLE IF EXISTS Branch CASCADE;
DROP TABLE IF EXISTS Client CASCADE;
DROP TABLE IF EXISTS PrivateOwner CASCADE;
DROP TABLE IF EXISTS PropertyForRent CASCADE;
DROP TABLE IF EXISTS Registration CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Viewing CASCADE;

-- Creating Branch table
CREATE TABLE Branch (
  branchNo CHAR(4) PRIMARY KEY,
  street VARCHAR(25) NOT NULL,
  city VARCHAR(15) NOT NULL,
  postcode VARCHAR(8) NOT NULL
);

-- Inserting data into Branch
INSERT INTO Branch (branchNo, street, city, postcode) VALUES
  ('B002','56 Clover Dr','London','NW10 6EU'),
  ('B003','163 Main St','Glasgow','G11 9QX'),
  ('B004','32 Manse Rd','Bristol','BS99 1NZ'),
  ('B005','22 Deer Rd','London','SW1 4EH'),
  ('B007','16 Argyll St','Aberdeen','AB2 3SU');

-- Creating Client table
CREATE TABLE Client (
  clientNo VARCHAR(7) PRIMARY KEY,
  fName VARCHAR(15) NOT NULL,
  lName VARCHAR(15) NOT NULL,
  telNo VARCHAR(13) NOT NULL,
  prefType VARCHAR(10) NOT NULL,
  maxRent DECIMAL(5,1) NOT NULL
);

-- Inserting data into Client
INSERT INTO Client (clientNo, fName, lName, telNo, prefType, maxRent) VALUES
  ('CR56','Aline','Stewart','0141-848-1825','Flat',350.0),
  ('CR62','Mary','Tregar','01224-196720','Flat',600.0),
  ('CR74','Mike','Ritchie','01475-392178','House',750.0),
  ('CR76','John','Kay','0207-774-5632','Flat',425.0);

-- Creating PrivateOwner table
CREATE TABLE PrivateOwner (
  ownerNo VARCHAR(7) PRIMARY KEY,
  fName VARCHAR(15) NOT NULL,
  lName VARCHAR(15) NOT NULL,
  address VARCHAR(50) NOT NULL,
  telNo VARCHAR(13) NOT NULL
);

-- Inserting data into PrivateOwner
INSERT INTO PrivateOwner (ownerNo, fName, lName, address, telNo) VALUES
  ('CO40','Tina','Murphy','63 Well St, Glasgow G42','0141-943-1728'),
  ('CO46','Joe','Keogh','2 Fergus Dr, Aberdeen AB2 7SX','01224-861212'),
  ('CO87','Carol','Farrel','6 Achray St, Glasgow G32 9DX','0141-357-7419'),
  ('CO93','Tony','Shaw','12 Park Pl, Glasgow G4 0QR','0141-225-7025');

-- Creating Staff table
CREATE TABLE Staff (
  staffNo VARCHAR(5) PRIMARY KEY,
  fName VARCHAR(15) NOT NULL,
  lName VARCHAR(15) NOT NULL,
  position VARCHAR(10) NOT NULL,
  sex CHAR(4),
  DOB DATE,
  salary DECIMAL(9,2) NOT NULL,
  branchNo CHAR(4) NOT NULL REFERENCES Branch(branchNo)
);

-- Inserting data into Staff
INSERT INTO Staff (staffNo, fName, lName, position, sex, DOB, salary, branchNo) VALUES
  ('SA9','Mary','Howe','Assistant','F','1970-02-19',9000.00,'B007'),
  ('SG14','David','Ford','Supervisor','M','1958-11-24',18000.00,'B003'),
  ('SG37','Ann','Beech','Assistant','F','1960-10-11',12000.00,'B003'),
  ('SG5','Susan','Brand','Manager','F','1940-06-03',24000.00,'B003'),
  ('SL21','John','White','Manager','M','1945-10-01',30000.00,'B005'),
  ('SL41','Julie','Lee','Assistant','F','1965-06-13',9000.00,'B005');

-- Creating PropertyForRent table
CREATE TABLE PropertyForRent (
  propertyNo VARCHAR(8) PRIMARY KEY,
  street VARCHAR(25) NOT NULL,
  city VARCHAR(15) NOT NULL,
  postcode VARCHAR(8) NOT NULL,
  type VARCHAR(10) NOT NULL,
  rooms SMALLINT NOT NULL,
  rent DECIMAL(5,1) NOT NULL,
  ownerNo VARCHAR(7) NOT NULL REFERENCES PrivateOwner(ownerNo),
  staffNo VARCHAR(5) REFERENCES Staff(staffNo),
  branchNo CHAR(4) NOT NULL REFERENCES Branch(branchNo)
);

-- Inserting data into PropertyForRent
INSERT INTO PropertyForRent (propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo) VALUES
  ('PA14','16 Holhead','Aberdeen','AB7 5SU','House',6,650.0,'CO46','SA9','B007'),
  ('PG16','5 Novar Dr','Glasgow','G12 9AX','Flat',4,450.0,'CO93','SG14','B003'),
  ('PG21','18 Dale Rd','Glasgow','G12','House',5,600.0,'CO87','SG37','B003'),
  ('PG36','2 Manor Rd','Glasgow','G32 4QX','Flat',3,375.0,'CO93','SG37','B003'),
  ('PG4','6 Lawrence St','Glasgow','G11 9QX','Flat',3,350.0,'CO40',NULL,'B003'),
  ('PL94','6 Argyll St','London','NW2','Flat',4,400.0,'CO87','SL41','B005');

-- Creating Registration table
CREATE TABLE Registration (
  clientNo VARCHAR(7) NOT NULL REFERENCES Client(clientNo),
  branchNo CHAR(4) NOT NULL REFERENCES Branch(branchNo),
  staffNo VARCHAR(5) NOT NULL REFERENCES Staff(staffNo),
  dateJoined DATE NOT NULL,
  PRIMARY KEY (clientNo, branchNo)
);

-- Inserting data into Registration
INSERT INTO Registration (clientNo, branchNo, staffNo, dateJoined) VALUES
  ('CR56','B003','SG37','2000-04-11'),
  ('CR62','B007','SA9','2000-03-07'),
  ('CR74','B003','SG37','1999-11-16'),
  ('CR76','B005','SL41','2001-01-02');

-- Creating Viewing table
CREATE TABLE Viewing (
  clientNo VARCHAR(7) NOT NULL REFERENCES Client(clientNo),
  propertyNo VARCHAR(8) NOT NULL REFERENCES PropertyForRent(propertyNo),
  viewDate DATE NOT NULL,
  comment VARCHAR(50),
  PRIMARY KEY (propertyNo, clientNo)
);

-- Inserting data into Viewing
INSERT INTO Viewing (clientNo, propertyNo, viewDate, comment) VALUES
  ('CR56','PA14','2001-05-24','too small'),
  ('CR62','PA14','2001-05-14','no dining room'),
  ('CR56','PG36','2001-04-28',NULL),
  ('CR56','PG4','2001-05-26',NULL),
  ('CR76','PG4','2001-04-20','too remote');
