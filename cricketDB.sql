create table team(  
tid int primary key, 
tname varchar(20), 
coach varchar(20), 
captain_pid int, 
city varchar(20)); 

create table player(  
pid int primary key, 
pname varchar(2), 
age int, 
tid int references team(tid)); 

create table stadium( 
sid int primary key,  
sname varchar(20), 
pincode number(8), 
city varchar(20), 
area varchar(20)); 

create table match( 
mid int primary key, 
mdate date, 
time varchar(6), 
sid int references stadium(sid), 
team1_id int references team(tid), 
team2_id int references team(tid), 
winning_team_id int references team(tid), 
man_of_match int references player(pid),  
pid int references player(pid)); 

--1.Display the yougest player (in terms of age) Name,Team name,age in which he belongs of the the tournament. 
SELECT pname,tname,age 
FROM player p,team t 
WHERE p.tid=t.tid and age=(SELECT min(age) FROM player); 

--2.List the details of the stadium where the maximum number of matches were played. 
SELECT * FROM stadium WHERE sid in 
(SELECT sid from match  
GROUP BY sid HAVING count(sid)=(SELECT max(count(sid)) FROM match GROUP BY sid)); 

--3.List the details of the player who is not a captain but got the man_of_match award atleast in two matches. 
SELECT * FROM player WHERE pid NOT IN 
(SELECT captain_pid from team) AND pid IN 
(SELECT man_of_match FROM match  
GROUP BY man_of_match HAVING count(man_of_match)>=2); 

--4.Display the teams details who won the maximum matches. 
SELECT * FROM team WHERE tid IN 
(SELECT winning_team_id FROM match 
GROUP BY winning_team_id HAVING count(winning_team_id)= 
(SELECT max(count(winning_team_id)) FROM match 
GROUP BY winning_team_id)); 

--5.Display the team name where all its won matches played in the same stadium. 
SELECT m.winning_team_id,t.tname,m.sid 
from match m,team t,stadium s 
where m.winning_team_id=t.tid and m.sid=s.sid 
group by (m.winning_team_id,t.tname,m.sid)  
having count(m.sid)>1; 
