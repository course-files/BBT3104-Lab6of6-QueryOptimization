-- DATABASE: company
-- DROP DATABASE IF EXISTS company;
CREATE DATABASE company WITH
OWNER = postgres
TEMPLATE = template0
ENCODING = 'UTF8'
LC_COLLATE = 'en_GB.utf8'
LC_CTYPE = 'en_GB.utf8'
CONNECTION LIMIT = 10;

-- SCHEMA: company_schema
-- DROP SCHEMA IF EXISTS company_schema;
CREATE SCHEMA company_schema
    AUTHORIZATION postgres;
COMMENT ON SCHEMA company_schema
    IS 'Company schema as used in Elmasri and Navathe (2016)';
GRANT USAGE ON SCHEMA company_schema TO postgres;
GRANT ALL ON SCHEMA company_schema TO postgres;


-- 


CREATE TABLE company_schema.department (
    dname character varying(25),
    dnumber integer,
    mgr_ssn integer,
    mgr_start_date character varying(25)
);


ALTER TABLE company_schema.department OWNER TO postgres;


CREATE TABLE company_schema.dependent (
    essn integer,
    dependent_name character varying(25),
    sex character varying(25),
    bdate character varying(25),
    relationship character varying(25)
);


ALTER TABLE company_schema.dependent OWNER TO postgres;


CREATE TABLE company_schema.dept_locations (
    dnumber integer,
    dlocation character varying(25)
);


ALTER TABLE company_schema.dept_locations OWNER TO postgres;


CREATE TABLE company_schema.employee (
    fname character varying(25),
    minit character varying(25),
    lname character varying(25),
    ssn integer,
    bdate character varying(25),
    address character varying(25),
    sex character varying(25),
    salary integer,
    super_ssn integer,
    dnumber integer
);


ALTER TABLE company_schema.employee OWNER TO postgres;


CREATE TABLE company_schema.project (
    pname character varying(25),
    pnumber integer,
    plocation character varying(25),
    dnum integer
);


ALTER TABLE company_schema.project OWNER TO postgres;


CREATE TABLE company_schema.works_on (
    ssn integer,
    pnumber integer,
    hours integer
);


ALTER TABLE company_schema.works_on OWNER TO postgres;


INSERT INTO company_schema.department VALUES ('Research', 5, 333445555, '1988-05-22');
INSERT INTO company_schema.department VALUES ('Administration', 4, 987654321, '1995-01-01');
INSERT INTO company_schema.department VALUES ('Headquarters', 1, 888665555, '1981-06-19');



INSERT INTO company_schema.dependent VALUES (333445555, 'Alice', 'F', '1986-04-05', 'Daughter');
INSERT INTO company_schema.dependent VALUES (333445555, 'Theodore', 'M', '1983-10-25', 'Son');
INSERT INTO company_schema.dependent VALUES (333445555, 'Joy', 'F', '1958-05-03', 'Spouse');
INSERT INTO company_schema.dependent VALUES (987654321, 'Abner', 'M', '1942-02-28', 'Spouse');
INSERT INTO company_schema.dependent VALUES (123456789, 'Michael', 'M', '1988-01-04', 'Son');
INSERT INTO company_schema.dependent VALUES (123456789, 'Alice', 'F', '1988-12-30', 'Daughter');
INSERT INTO company_schema.dependent VALUES (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');



INSERT INTO company_schema.dept_locations VALUES (1, 'Houston');
INSERT INTO company_schema.dept_locations VALUES (4, 'Stafford');
INSERT INTO company_schema.dept_locations VALUES (5, 'Bellaire');
INSERT INTO company_schema.dept_locations VALUES (5, 'Sugarland');
INSERT INTO company_schema.dept_locations VALUES (5, 'Houston');



INSERT INTO company_schema.employee VALUES ('John', 'B', 'Smith', 123456789, '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, 333445555, 5);
INSERT INTO company_schema.employee VALUES ('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, 688665555, 5);
INSERT INTO company_schema.employee VALUES ('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321 Castle Spring, TX', 'F', 25000, 987654321, 4);
INSERT INTO company_schema.employee VALUES ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, 888665555, 4);
INSERT INTO company_schema.employee VALUES ('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, 333445555, 5);
INSERT INTO company_schema.employee VALUES ('Joyce', 'A', 'English', 453543453, '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, 333445555, 5);
INSERT INTO company_schema.employee VALUES ('Ahmed', 'V', 'Jabbar', 987987987, '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, 987654321, 4);
INSERT INTO company_schema.employee VALUES ('James', 'E', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1);


INSERT INTO company_schema.project VALUES ('ProductX', 1, 'Bellaire', 5);
INSERT INTO company_schema.project VALUES ('ProductY', 2, 'Sugarland', 5);
INSERT INTO company_schema.project VALUES ('ProductZ', 3, 'Houston', 5);
INSERT INTO company_schema.project VALUES ('Computerization', 10, 'Stafford', 4);
INSERT INTO company_schema.project VALUES ('Reorganization', 20, 'Houston', 1);
INSERT INTO company_schema.project VALUES ('Newbenefits', 30, 'Stafford', 4);


INSERT INTO company_schema.works_on VALUES (123456789, 1, 33);
INSERT INTO company_schema.works_on VALUES (123456789, 2, 8);
INSERT INTO company_schema.works_on VALUES (666884444, 3, 40);
INSERT INTO company_schema.works_on VALUES (453543453, 1, 20);
INSERT INTO company_schema.works_on VALUES (453543453, 2, 20);
INSERT INTO company_schema.works_on VALUES (333445555, 2, 10);
INSERT INTO company_schema.works_on VALUES (333445555, 3, 10);
INSERT INTO company_schema.works_on VALUES (333445555, 10, 10);
INSERT INTO company_schema.works_on VALUES (333445555, 20, 10);
INSERT INTO company_schema.works_on VALUES (999887777, 30, 30);
INSERT INTO company_schema.works_on VALUES (999887777, 10, 10);
INSERT INTO company_schema.works_on VALUES (987987987, 10, 35);
INSERT INTO company_schema.works_on VALUES (987987987, 30, 5);
INSERT INTO company_schema.works_on VALUES (987654321, 30, 20);
INSERT INTO company_schema.works_on VALUES (987654321, 20, 15);
INSERT INTO company_schema.works_on VALUES (888665555, 20, NULL);