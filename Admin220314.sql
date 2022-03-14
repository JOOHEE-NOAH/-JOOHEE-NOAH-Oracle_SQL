--------------------------------------------
------- Tablespace  --------------
--------------------------------------------
--1. TableSpace 积己 : 靛扼捞宏 C俊 刚历 弃歹 积己饶 角青
CREATE TABLESPACE user1 Datafile 'C:\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 Datafile 'C:\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 Datafile 'C:\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 Datafile 'C:\tableSpace\user4.ora' SIZE 100M;

--2. usertest03 积己窍哥 TableSpace user1 Mapping

drop user usertest03;
CREATE USER usertest03 IDENTIFIED BY tiger
DEFAULT Tablespace user1;

grant dba to usertest03;


---------------------------------------------------
---  Backup 包府
---------------------------------------------------
--1. Directory 积己
create or replace directory mdBackup2 as 'C:\orabackup';


