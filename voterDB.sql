create table constituency(
   cons_id number(20) primary key,
   csname varchar(20),
   csstate varchar(20),
   no_of_voters number(10)
);

create table party(
   pid number(20) primary key,
   pname varchar(20),
   psymbol varchar(10)
);

create table candidates(
   cand_id number(12) primary key,
   phone_no number(10),
   age number(2),
   state varchar(20),
   name varchar(20),
   pid int references party(pid)
);

create table contest(
   cons_id number(20) references constituency(cons_id),
   cand_id number(12) references candidates(cand_id),
   primary key(cons_id,cand_id)
);

create table voter(
   vid number(20) primary key,
   vname varchar(20),
   vage number(5),
   vaddr varchar(20),
   cons_id number(20) references constituency(cons_id),
   cand_id number(12) references candidates(cand_id)
);

--1. List the details of the candidates who are contesting from more than one constituency which are 
--belongs to different states. 
select c.cand_id,cd.name,count(c.cons_id) from contest c,candidates cd where 
c.cand_id=cd.cand_id group by(cd.name,c.cand_id) having count(c.cons_id)>1; 

--2. Display the state name having maximum number of constituencies. 
select * from (select csstate,count(cons_id) from constituency group by csstate order by 
count(cons_id) desc) resultset where rownum=1; 

--3. Create a stored procedure to insert the tuple into the voter table by checking the voter age. If 
--voter s age is at least 18 years old, then insert the tuple into the voter else display the  Not 
--an eligible voter msg .
create   procedure agechecking ( id in number,age in number) 
as 
BEGIN 
if age>18 then 
insert into voter(vid,vage) values (id,age); 
else 
dbms_output.put_line('age should be high'); 
end if; 
end agechecking; 
/
  
set serveroutput on; 
exec agechecking (25,21);

--4.Display the constituency name, state and number of voters in each state in descending order using rank() function .
SELECT csname, csstate, no_of_voters, 
RANK () OVER (partition BY csstate order by no_of_voters desc) AS Rank_No FROM constituency; 

--5. Create a TRIGGER to UPDATE the count of  Number_of_voters  of the respective 
--constituency in  CONSTITUENCY  table, AFTER inserting a tuple into the  VOTERS  
--table.
create  trigger count 
after insert on voter 
for each row 
begin 
update constituency 
set no_of_voters = no_of_voters + 1 
where cons_id=:new.cons_id; 
end count; 
/
  
insert into voter values(399,'nagesh',30,'mandya',111,199); 
select * from constituency; 
