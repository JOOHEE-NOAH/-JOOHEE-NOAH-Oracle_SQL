--------------------------------------------
------- Tablespace  --------------
--------------------------------------------
--1. TableSpace 생성 : 드라이브 C에 먼저 폴더 생성후 실행
CREATE TABLESPACE user1 Datafile 'C:\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 Datafile 'C:\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 Datafile 'C:\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 Datafile 'C:\tableSpace\user4.ora' SIZE 100M;

--2. usertest03 생성하며 TableSpace user1 Mapping

drop user usertest03;
CREATE USER usertest03 IDENTIFIED BY tiger
DEFAULT Tablespace user1;

grant dba to usertest03;


---------------------------------------------------
---  Backup 관리
---------------------------------------------------
--1. Directory 생성
create or replace directory mdBackup2 as 'C:\orabackup';


--2. Backup test 계정
Drop User scott3;
CREATE USER scott3 IDENTIFIED BY tiger;
grant dba to scott3;