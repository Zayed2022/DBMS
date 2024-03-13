CREATE TABLE SALESMAN( 
SID NUMBER (4) PRIMARY KEY, 
NAME VARCHAR(20), 
CITY VARCHAR(20), 
COMMISSION VARCHAR(20) 
); 

CREATE TABLE CUSTOMER( 
CID NUMBER(4) PRIMARY KEY, 
CNAME VARCHAR(20), 
CITY VARCHAR(20), 
GRADE NUMBER(3), 
SALESMAN_ID REFERENCES SALESMAN (SID) ON DELETE CASCADE); 

CREATE TABLE ORDER1 ( 
ORD_NO NUMBER (5) PRIMARY KEY, 
PURCHASE_AMT NUMBER(10, 2), 
ORD_DATE DATE, 
CUSTOMER_ID REFERENCES CUSTOMER (CID) ON DELETE CASCADE, 
SALESMAN_ID REFERENCES SALESMAN (SID) ON DELETE CASCADE); 

--1. Count the customers with grades above Bangalore’saverage 
SELECT GRADE, COUNT (DISTINCT CID) FROM 
CUSTOMER 
GROUP BY GRADE 
HAVING GRADE > (SELECT AVG(GRADE) 
FROM CUSTOMER 
WHERE CITY='Bangalore'); 

--2. Find the name and numbers of all salesmen who had more than one customer. 
SELECT sid,name 
  FROM salesman 
  WHERE sid IN (SELECT salesman_id 
                          FROM customer 
                          GROUP BY salesman_id 
                          HAVING COUNT(*) > 1);               
 
--3. List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation.) 
SELECT SALESMAN.SID, NAME, CNAME, COMMISSION FROM 
SALESMAN, CUSTOMER 
WHERE SALESMAN.CITY = CUSTOMER.CITY 
UNION 
SELECT SID, NAME, 'NO MATCH', COMMISSION 
FROM SALESMAN 
WHERE NOT CITY IN 
(SELECT CITY 
FROM CUSTOMER) 
ORDER BY 1 ASC; 
 
 
--4. Create a view that finds the salesman who has the customer with the highest order of a day. 
CREATE VIEW ELITSALESMAN AS 
SELECT B.ORD_DATE, A.SID, A.NAME FROM 
SALESMAN A, ORDER1 B 
WHERE A.SID = B.SALESMAN_ID 
AND B.PURCHASE_AMT=(SELECT MAX (PURCHASE_AMT) 
FROM ORDER1 C 
WHERE C.ORD_DATE = B.ORD_DATE); 
 
select * from ELITSALESMAN; 
--5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted. 
DELETE FROM SALESMAN WHERE SID=1000; 
SELECT * FROM SALESMAN;  
