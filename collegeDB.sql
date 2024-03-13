CREATE TABLE Student
( Usn		VARCHAR(20) PRIMARY KEY, 
  Sname		VARCHAR(20) NOT NULL,
  Address	VARCHAR(20), 
  Phone		NUMBER(10),
  Gender	VARCHAR(2)
);


CREATE TABLE Semsec
( Ssid	NUMBER(10) PRIMARY KEY, 
  Sem	NUMBER(10),
  Sec	VARCHAR(10)
);


 CREATE TABLE CLASS
(   Usn		VARCHAR(20) 	REFERENCES 	Student(Usn), 
    Ssid	NUMBER(10)	REFERENCES 	Semsec(Ssid),
	PRIMARY KEY(Usn,Ssid)
);


CREATE TABLE Subject
( Subcode	VARCHAR(20) PRIMARY KEY, 
  Sub_title	VARCHAR(20) NOT NULL, 
  Sem		NUMBER(10),
  Credits	NUMBER(10)
);

 CREATE TABLE IAmarks
(Usn	VARCHAR(20),
Subcode	VARCHAR(20) REFERENCES Subject(Subcode),
Ssid	NUMBER(10),
Test1	NUMBER(10),
Test2	NUMBER(10),
Test3	NUMBER(10),
Finalia	NUMBER(6,2), 
PRIMARY KEY(Usn,Subcode,Ssid),
FOREIGN KEY(Usn,Ssid) REFERENCES Class(Usn,Ssid)
);


-- 1.	List all the student details studying in fourth semester ‘C’ section.
SELECT s.usn,s.sname,s.address,s.phone
FROM Student s, Semsec n, Class c
WHERE n.sem=4 and n.sec='C' and s.usn=c.usn and c.ssid=n.ssid;



-- 2.	Compute the total number of male and female students in each semester and in each section.
SELECT c.ssid room_no, sec section, sem semester,
			SUM(CASE WHEN s.gender='M' THEN 1 ELSE 0 END) AS MALE,
			SUM(CASE WHEN s.gender='F' THEN 1 ELSE 0 END ) AS FEMALE
FROM Class c, Student s, Semsec m
WHERE s.usn=c.usn AND m.ssid=c.ssid GROUP BY c.ssid, sem, sec;



-- 3.	Create a view of Test1 marks of student USN ‘1BI15CS101’ in all subjects.
CREATE VIEW Test1_Marks AS
SELECT test1 FROM IAmarks WHERE usn='3br15cs005';

select * from Test1_Marks;



-- 4.	Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
UPDATE iamarks SET finalia= (GREATEST(test1+test2,test2+test3,test3+test1))/2; 

SELECT * FROM IAmarks;




-- 5.Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’ If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

SELECT i.usn,i.test1,i.test2,i.test3,i.finalia,
		(CASE WHEN i.finalia>=17 AND i.finalia<=20 THEN 'outstanding' 
		      WHEN i.finalia>=12 AND i.finalia<=17 THEN 'average' 
		      WHEN i.finalia>12 THEN 'weak'
		      ELSE 'invalid'
		END) AS grade
FROM IAmarks i, Class c, Semsec s
WHERE i.usn=c.usn AND c.ssid=s.ssid AND s.sem=8 and s.sec IN ('A','B','C');

